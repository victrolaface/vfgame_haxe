package tools.ecs.core;

#if debug
using tools.debug.Precondition;
#end

import haxe.ds.Vector;

@:structInit class EntityManager {
	static final ID_MASK = 0xfffff;
	static final ID_BITS_AMOUNT = 20;
	static final VERSION_MASK = 0xfff << ID_BITS_AMOUNT;
	static final COUNT_MIN = 4;
	static final COUNT_MAX = 4096;
	static final CHUNK_MIN = 64;
	static final CAP_RANGE = [CHUNK_MIN, 128, 256, 512, 1024, 2048, COUNT_MAX];

	var dirty:Bool;
	var len:Int;
	var idx:Int;
	var pop:Int;
	var push:Int;
	var count:Int;
	var idxCap:Int;
	var maxCap:Int;
	var version:Int;
	var available:Int;
	var toDestroy:Int;
	var caps:Vector<Int>;
	var storage:Vector<Int>;
	var state = None;
	var next(get, set):Int;
	var cap(get, never):Int;
	var nextCap(get, never):Int;
	var atCap(get, never):Bool;
	var hasNextCap(get, never):Bool;
	var hasAvailable(get, never):Bool;

	#if debug
	var canChangeState(get, never):Bool;

	public var canInit(get, never):Bool;
	public var canUpdateFromInit(get, never):Bool;
	public var currentState(get, never):String;

	inline function get_currentState()
		return state.getName();

	inline function get_canInit()
		return state == None;

	inline function get_canChangeState() {
		switch (state) {
			case Init:
				return true;
			case _:
				return state == Update;
		}
	}

	public var report(get, never):String;

	inline function get_report() {
		var capsArr = caps.toArray();
		var r:Report = {
			count: count,
			available: available,
			storageLength: storage.length,
			next: next,
			idxCap: idxCap,
			cap: cap,
			maxCap: maxCap,
			hasNextCap: hasNextCap,
			atCap: atCap,
			hasAvailable: hasAvailable,
			nextCap: nextCap,
			caps: caps.toArray(),
			storage: storage.toArray(),
			capsLen: capsArr.length,
			lastCap: capsArr[capsArr.length - 1]
		};
		return haxe.Json.stringify(r);
	}

	public inline function get_canUpdateFromInit() {
		if (canChangeState) {
			switch (state) {
				case Init:
					dirty = false;
					len = storage.length;
					var last = len - 1;
					var isAvailable = count == available && last == available;
					var isCap = cap == count;
					var isCount = last == count;
					var isFirst:Bool;
					var isLast:Bool;
					dirty = !isAvailable || !isCap || !isCount || idxCap != 0;
					if (!dirty) {
						for (i in 0...len) {
							pop = storage[i];
							push = pop;
							var idx = parseIdx(push);
							var version = parseVersion(push);
							isFirst = i == 0;
							isLast = i == last;
							if (version == 1) {
								if (isFirst) {
									if (idx == count && next == push) {
										continue;
									} else {
										dirty = true;
										break;
									}
								}
								if (isLast) {
									if (idx == count && i == count) {
										continue;
									} else {
										dirty = true;
										break;
									}
								}
								if (!isFirst && i == idx) {
									continue;
								} else {
									dirty = true;
									break;
								}
							} else {
								dirty = true;
								break;
							}
						}
						if (!dirty) {
							idx = 0;
							pop = caps[idx];
							push = pop;
							len = caps.length;
							var isMaxCapAtMinLen = len == 1 && maxCap == push && cap == push;
							idx++;
							pop = caps[idx];
							push = pop;
							idx--;
							pop = caps[idx];
							var isMaxCapAtTwoLen = len == 2 && maxCap == push && cap == pop && hasNextCap && push > pop;
							idx = len - 1;
							pop = caps[idx];
							push = pop;
							idx = 0;
							pop = caps[idx];
							var isDefaultLen = len > 2 && maxCap == push && cap == pop && hasNextCap;
							if (isMaxCapAtMinLen || isMaxCapAtTwoLen || isDefaultLen) {
								if (isDefaultLen) {
									len = caps.length;
									for (i in 0...len) {
										idx = i + 1;
										if (idx < len) {
											pop = caps[idx];
											push = pop;
											idx = i;
											pop = caps[idx];
											if (push > pop)
												continue;
											else {
												dirty = true;
												break;
											}
										} else {
											idx = i;
											pop = caps[idx];
											push = pop;
											idx--;
											pop = caps[idx];
											dirty = push <= pop;
											break;
										}
									}
								} else
									dirty = (isMaxCapAtMinLen && isMaxCapAtTwoLen) || (!isMaxCapAtMinLen && !isMaxCapAtTwoLen);
							} else
								dirty = true;
						} else
							dirty = true;
					} else
						dirty = true;
					if (dirty) {
						state = Error;
						return onDirty();
					}
					return true;
				case _:
					return canChangeState;
			}
		}
		return false;
	}

	inline function isMaxCap(_cap:Int)
		return cap == _cap && maxCap == _cap;

	/*
		public var test(get, never):Bool;
		var t:Bool;
		inline function get_test()
			return t;
	 */
	#end
	public inline function new(?_size:Int) {
		#if debug
		Precondition.requires(canInit);
		#end
		var size = _size != null ? _size : CHUNK_MIN;
		size = size <= COUNT_MIN ? COUNT_MIN : size;
		size = size >= COUNT_MAX ? COUNT_MAX : size;
		maxCap = size;
		var tmp = new Array<Int>();
		idx = 0;
		final maxCapGtChunkMin = maxCap > CHUNK_MIN;
		tmp[idx] = maxCapGtChunkMin ? CHUNK_MIN : maxCap;
		pop = tmp[idx];
		push = pop;
		if (maxCapGtChunkMin && push == CHUNK_MIN) {
			len = CAP_RANGE.length + 1;
			for (i in 1...len) {
				var chunk = CAP_RANGE[i];
				if (maxCap <= chunk) {
					tmp[i] = maxCap < chunk ? maxCap : chunk;
					break;
				} else
					tmp[i] = chunk;
			}
		}
		caps = new Vector<Int>(tmp.length);
		for (i in 0...caps.length)
			caps[i] = tmp[i];
		idxCap = 0;
		storage = new Vector<Int>(cap + 1);
		available = 0;
		count = 0;
		storage[0] = -1;
		doChunk();
		state = Init;
	}

	inline function onDirty() {
		dirty = false;
		return dirty;
	}

	public inline function update() {
		switch (state) {
			case Init:
				#if debug
				Precondition.requires(canUpdateFromInit);
				#end
				state = Update;
			case Create:
				if (hasAvailable)
					recycle();
				else {
					if (atCap) {
						if (hasNextCap) {
							idxCap++;
							var s = new Vector<Int>(cap);
							for (i in 0...storage.length)
								s[i] = storage[i];
							storage = s;
							doChunk();
							recycle();
						} else
							dirty = true;
					} else
						doCreate();
				}
				state = dirty ? Create : Update;
				onDirty();
			case Destroy:
				doDestroy();
				state = Update;
			case _:
				state = canChangeState ? Update : Error;
		}
	}

	public inline function create() {
		state = Create;
	}

	public inline function destroy(_id:Int) {
		pop = _id;
		push = pop;
		idx = parseIdx(push);
		version = parseVersion(push);
		pop = id(idx, version);
		push = pop;
		pop = storage[idx];
		final valid = push == pop;
		toDestroy = valid ? push : null;
		state = valid ? Destroy : Update;
	}

	inline function parseVersion(_id)
		return ((_id & VERSION_MASK) >>> ID_BITS_AMOUNT);

	inline function parseIdx(_id:Int)
		return _id & ID_MASK;

	inline function recycle() {
		pop = next;
		push = pop;
		idx = parseIdx(push);
		for (i in 0...available) {
			pop = storage[idx];
			storage[idx] = push;
			push = pop;
			idx = parseIdx(push);
			if (i == available)
				next = push;
		}
		available--;
	}

	inline function doChunk() {
		final from = count + 1;
		len = storage.length;
		for (_ in from...len)
			doCreate();
		for (i in from...len) {
			idx = i;
			version = 0;
			pop = id(idx, version);
			push = pop;
			toDestroy = push;
			doDestroy();
		}
	}

	inline function doCreate() {
		idx = count + 1;
		version = 0;
		pop = id(idx, version);
		push = pop;
		storage[idx] = push;
		count++;
	}

	inline function doDestroy() {
		idx = parseIdx(toDestroy);
		version = parseVersion(toDestroy);
		version++;
		pop = id(idx, version);
		push = pop;
		storage[idx] = push;
		pop = storage[idx];
		push = pop;
		next = push;
		available++;
	}

	inline function id(_index:Int, _version:Int):Int
		return (((_version << ID_BITS_AMOUNT) & VERSION_MASK) | (_index & ID_MASK));

	inline function get_nextCap()
		return caps.length < (idxCap + 1) + 1 ? cap : caps[idxCap + 1];

	inline function get_hasNextCap()
		return nextCap > cap;

	inline function get_hasAvailable()
		return available > 0;

	inline function get_atCap()
		return count >= cap;

	inline function get_cap()
		return caps[idxCap];

	inline function get_next()
		return storage[0];

	inline function set_next(_id:Int)
		return storage[0] = _id;
}

private enum State {
	Error;
	None;
	Init;
	Update;
	Create;
	Destroy;
}

#if debug
typedef Report = {
	count:Int,
	available:Int,
	storageLength:Int,
	next:Int,
	idxCap:Int,
	cap:Int,
	maxCap:Int,
	hasNextCap:Bool,
	atCap:Bool,
	hasAvailable:Bool,
	nextCap:Int,
	lastCap:Int,
	caps:Array<Int>,
	storage:Array<Int>,
	capsLen:Int
}
#end
