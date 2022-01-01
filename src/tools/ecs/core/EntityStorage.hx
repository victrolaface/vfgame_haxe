package tools.ecs.core;

import haxe.ds.Vector;
import haxe.Json;

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
	var state:State;
	var len:Int;
	var idx:Int;
	var idxCap:Int;
	var push:Int;
	var pop:Int;
	var dirty:Bool;
	var version:Int;

	public var output(get, never):String;

	inline function get_output() {
		var out = {
			dirty: dirty,
			state: Std.string(state),
			storage: {},
			capacity: {}
		}

		var s = {
			length: storage.length,
			available: available,
			count: count,
			next: next,
			items: []
		}

		for (i in 0...s.length) {
			var e = storage[i];
			var item = {
				index: parseIdx(e),
				version: parseVersion(e),
				id: e
			};
			s.items.push(item);
		}

		out.storage = s;

		var c = {
			capsAmount: caps.length,
			caps_index: idxCap,
			currentCap: cap,
			nextCap: nextCap,
			caps: []
		}

		for (i in 0...c.capsAmount)
			c.caps.push(caps[i]);

		out.capacity = c;

		return haxe.Json.stringify(out);
	}

	var cap(get, never):Int;
	var nextCap(get, never):Int;
	var next(get, set):Int;

	public var isInitialized(get, never):Bool;
	public var created(get, never):Bool;
	public var destroyed(get, never):Bool;

	public inline function new(?_size:Int) {
		state = Init;
		final isMin = _size == null || _size <= SIZE_MIN;
		final isSize = _size <= DEFAULT_CHUNK_SIZE;
		final hasChunks = _size > DEFAULT_CHUNK_SIZE;
		dirty = isMin || isSize || hasChunks;

		if (dirty) {
			idx = 0;
			var tmp = new Array<Int>();
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
			} else {
				if (isMin)
					tmp[idx] = SIZE_MIN;
				if (isSize)
					tmp[idx] = _size;
			}
			len = tmp.length;
			caps = new Vector<Int>(len);
			for (i in 0...len)
				caps[i] = tmp[i];
			idxCap = 0;
			len = cap + 1;
			storage = new Vector<Int>(len);
			available = 0;
			count = 0;
			for (_ in 0...len)
				create();
			for (i in 0...len) {
				pop = id(i + 1, 0);
				push = pop;
				destroy(push);
			}
			state = Update;
		}
	}

	inline function onDirty()
		return dirty = !dirty;

	inline function get_nextCap() {
		len = caps.length;
		var n = caps[idxCap + 1];
		if (n > len || n == null)
			n = caps[idxCap];
		return n;
	}

	inline function get_cap()
		return caps[idxCap];

	public inline function create() {
		if (state == Init) {
			if (dirty) {
				idx = 0;
				storage[idx] = -1;
				onDirty();
			} else {
				idx++;
				if (count < cap) {
					pop = id(idx, 0);
					push = pop;
					storage[idx] = push;
					count++;
				}
			}
		}
	}

	public inline function destroy(_id:Int) {
		if (state == Init) {
			idx = parseIdx(_id);
			if (idx <= count) {
				version = parseVersion(_id);
				version++;
				pop = id(idx, version);
				push = pop;
				storage[idx] = push;
				pop = storage[idx];
				push = pop;
				next = push;
				available++;
			}
		}
	}

	inline function get_next()
		return storage[0];

	inline function set_next(_id:Int)
		return storage[0] = _id;

	inline function parseVersion(_id)
		return ((_id & VERSION_MASK) >>> ID_BITS_AMOUNT);

	inline function get_created()
		return state == Create;

	inline function get_destroyed()
		return state == Destroy;

	inline function get_isInitialized() {
		return false;
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
/*
	// [(-1),(1|0)]
	// [(1|1),(1|1),(2|0)]
	// ...
	// [(62|1),(1|1),(2|1)...(63|0)]
}*/
/*
	// [(1|1)]
	// [(2|1)]
	// ...
	// [(63|1)]
	// [(-1),(1|1)]
	// [(1|1),(1|1), (2|1)]
	// ...
	// [(62|1),(1|1),(2|1),...,(63|1)]
	// [(1|1),(1|1)
	// [(2|1),(1|1),(2|1)]
	// ...
	// [(63|1),(1|1),(2|1),...,(63|1)]
 */
/*if (state != Update)
		return false;
	else
		return true; */
/*
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
 */
