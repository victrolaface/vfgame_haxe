package tools.ecs.core;

import haxe.ds.Vector;

@:structInit class EntityStorage {
	static final ID_MASK = 0xfffff;
	static final ID_BITS_AMOUNT = 20;
	static final VERSION_MASK = 0xfff << ID_BITS_AMOUNT;
	static final SIZE_MIN = 4;
	static final SIZE_MAX = 4000;
	static final DEFAULT_CHUNK_SIZE = 64;

	var storage:Vector<Int>;
	var available:Int;
	var count:Int;
	var caps:Vector<Int>;
	var capIdx:Int;
	var state:State;
	var len:Int;
	var idx:Int;
	var push:Int;
	var pop:Int;
	var dirty:Bool;
	var version:Int;

	var cap(get, never):Int;
	var capsAmount(get, never):Int;
	var nextCap(get, never):Int;
	var atCap(get, never):Bool;
	var next(get, set):Int;

	public var isInitialized(get, never):Bool;
	public var created(get, never):Bool;
	public var destroyed(get, never):Bool;

	public inline function new(?_size:Int) {
		final isNull = _size == null;
		state = Init;
		dirty = isNull || (_size >= SIZE_MIN && _size <= SIZE_MAX);
		if (dirty) {
			idx = 0;
			if (isNull)
				_size = SIZE_MIN;
			final isMin = _size == SIZE_MIN;
			final isMax = _size == SIZE_MAX;
			final isSize = _size < DEFAULT_CHUNK_SIZE;
			final hasChunks = _size > DEFAULT_CHUNK_SIZE;
			dirty = isMin || isMax || isSize || hasChunks;
			if (dirty) {
				var tmp = new Array<Int>();
				if (isMin)
					tmp[idx] = SIZE_MIN;
				if (isMax)
					tmp[idx] = SIZE_MAX;
				if (isSize)
					tmp[idx] = _size;
				if (hasChunks) {
					var c1 = DEFAULT_CHUNK_SIZE;
					var c2 = c1 * 2;
					tmp[idx] = c1;
					var addDefaultChunks = _size > c1 + c2;
					if (addDefaultChunks) {
						do {
							c1 = tmp[idx];
							c2 = c1 * 2;
							if (_size > c1 + c2) {
								idx++;
								tmp[idx] = c2;
							} else
								addDefaultChunks = false;
						} while (addDefaultChunks);
					}
					c1 = tmp[idx];
					c2 = _size - c1;
					final addSmChunk = c2 > 0 && c2 < DEFAULT_CHUNK_SIZE;
					if (addSmChunk) {
						idx++;
						tmp[idx] = c2;
					}
				}
				len = tmp.length + 1;
				caps = new Vector<Int>(len);
				idx = 0;
				caps[idx] = tmp.length;
				idx++;
				len = tmp.length;
				for (i in 0...len) {
					caps[idx] = tmp[i];
					idx++;
				}
				idx = 0;
				idx++;
				capIdx = idx;
				available = 0;
				count = 0;
				create();
				destroy(pop);
				len = cap;
				for (_ in 0...len) {
					create();
					destroy(pop);
				}
				onDirty();
				if (dirty) {
					state = Update;
					onDirty();
				}
			}
		}
	}

	inline function onDirty()
		return dirty = !dirty;

	inline function get_capsAmount()
		return caps[0];

	inline function get_nextCap() {
		final n = caps[capIdx + 1];
		return n <= capsAmount ? n : null;
	}

	inline function get_cap()
		return caps[capIdx];

	inline function get_atCap()
		return count == cap && available == 0;

	public inline function create() {
		if (state == Init) {
			if (dirty) {
				idx = 0;
				storage[idx] = -1;
				idx++;
				pop = id(1, 0);
				push = pop;
				storage[idx] = push;
				pop = storage[idx];
				onDirty();
			} else {
				idx = count;
				storage[idx] = id(idx, 0);
				pop = storage[idx];
				// [(-1),(1|0)]
				// [(1|1),(1|1),(2|0)]
				// ...
				// [(62|1),(1|1),(2|1)...(63|0)]
			}
			count++;
		}
	}

	public inline function destroy(_id:Int) {
		if (state == Init) {
			pop = _id;
			idx = parseIdx(pop);
			version = parseVersion(pop);
			version++;
			pop = id(idx, version);
			// [(1|1)]
			// [(2|1)]
			// ...
			// [(63|1)]
			push = pop;
			storage[idx] = push;
			// [(-1),(1|1)]
			// [(1|1),(1|1), (2|1)]
			// ...
			// [(62|1),(1|1),(2|1),...,(63|1)]
			pop = push;
			next = pop;
			// [(1|1),(1|1)
			// [(2|1),(1|1),(2|1)]
			// ...
			// [(63|1),(1|1),(2|1),...,(63|1)]
			available++;
		}
	}

	inline function get_next()
		return storage[0];

	inline function set_next(_id:Int)
		return storage[0] = _id;

	inline function parseVersion(_id)
		return ((_id & VERSION_MASK) >>> ID_BITS_AMOUNT);

	public inline function get_created()
		return state == Create;

	public inline function get_destroyed()
		return state == Destroy;

	inline function get_isInitialized() {
		if (state != Update) {
			return false;
		} else {
			onDirty();
			idx = 0;
			len = cap;
			var i:Int;
			var c = idx;
			var a = idx;
			do {
				pop = storage[idx];
				i = parseIdx(pop);
				version = parseVersion(pop);
				var isVersion = version == 1;
				if (idx == 0)
					dirty = i != len - 1 && !isVersion;
				else
					dirty = i != idx && !isVersion;
				if (dirty)
					break;
				c = idx + 1;
				a = idx + 1;
				idx++;
			} while (idx < len);
			if (!dirty)
				dirty = c != count && a != available && state != Update;
			return dirty;
		}
	}

	inline function parseIdx(_id:Int)
		return _id & ID_MASK;

	inline function id(_index:Int, _version:Int):Int
		return (((_version << ID_BITS_AMOUNT) & VERSION_MASK) | (_index & ID_MASK));
}

private enum State {
	Init;
	Update;
	Create;
	Destroy;
}
