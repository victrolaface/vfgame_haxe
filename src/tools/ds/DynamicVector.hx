package tools.ds;

import haxe.ds.Vector;
#if debug
import tools.debug.Precondition;
#end

using tools.ds.VectorTools;

@:structInit class DynamicVector<T> {
	final DEFAULT_SIZE = 64;
	final MAX_SIZE = 524288;

	var dirty:Bool;
	var count:Int;
	var size:Int;
	var storage:Vector<T>;
	var maxCap:Int;
	var caps:Vector<Int>;
	var capIdx:Int;
	var idx:Int;
	var len:Int;
	var state:State = None;
	var className:String;
	var cap(get, never):Int;
	var hasNextCap(get, never):Bool;
	var nextCap(get, never):Int;

	inline function get_hasNextCap() {
		len = caps.length;
		idx = capIdx;
		idx++;
		return idx + 1 <= len;
	}

	inline function get_nextCap()
		return hasNextCap ? caps[capIdx + 1] : cap;

	public var length(get, never):Int;

	inline function get_length()
		return maxCap;

	inline function get_cap()
		return caps[capIdx];

	public inline function new(?_size:Int)
		doAlloc(_size);

	inline function onDirty()
		dirty = dirty ? !dirty : false;

	inline function doAlloc(?_size:Int) {
		maxCap = _size == null || _size <= 0 ? DEFAULT_SIZE : _size;
		maxCap = size;
		final capGtDefault = maxCap > DEFAULT_SIZE;
		var capsArr = new Array<Int>();
		idx = 0;
		capIdx = idx;
		capsArr[capIdx] = capGtDefault ? DEFAULT_SIZE : maxCap;
		if (capGtDefault) {
			var addCap = true;
			do {
				var nextCap = capsArr[idx] * 2;
				idx++;
				var add = nextCap < maxCap;
				capsArr[idx] = add ? nextCap : maxCap;
				addCap = add;
			} while (addCap);
		}
		len = capsArr.length;
		caps.alloc(len);
		for (i in 0...len)
			caps[i] = capsArr[i];
		len = cap;
		storage.alloc(len);
		#if debug
		final verifiedAlloc = verifyAlloc(_size);
		Precondition.requires(verifiedAlloc, 'allocation of Dynamic Vector verified.');
		state = verifiedAlloc ? Init : Error;
		#end
		state = Init;
	}

	#if debug
	inline function verifyAlloc(?_size:Int) {
		return true;
	}
	#end

	inline function doInit(_first:Int, _n:Int, _val:T) {
		final firstIsLteMaxCap = idxLteMaxCap(_first);
		#if debug
		Precondition.requires(firstIsLteMaxCap, "first index is less than or equal to maximum capacity.");
		#end
		if (firstIsLteMaxCap) {
			final lastIdx = _first + _n;
			if (lastIdx <= cap) {
				len = _n + 1;
				for (i in _first...len)
					storage[i] = _val;
			} else {
				doCapIdx(lastIdx);
				len = lastIdx;
				doAlloc(len);
				for (i in _first...len)
					storage[i] = _val;
			}
		} else
			dirty = true;
		#if debug
		Precondition.requires(!dirty, 'can initialize at index "_first" for "_n" number of positions.');
		#end
		state = dirty ? Error : Init;
		#if debug
		final verifiedInit = verifyInit(_first, _n, _val);
		Precondition.requires(verifiedInit, 'initialization of Dynamic Vector verified.');
		state = verifiedInit ? Init : Error;
		#end
	}

	inline function verifyInit(_first:Int, _n:Int, _val:T) {
		return true;
	}

	inline function doCapIdx(_idx:Int) {
		var idxLteCap = false;
		for (i in 0...caps.length) {
			idxLteCap = _idx <= caps[i];
			if (idxLteCap) {
				capIdx = i;
				break;
			}
		}
		#if debug
		Precondition.requires(idxLteCap, 'index where "_first" starts and ends at "_n" position is less than or equal to current capacity');
		#end
		if (idxLteCap)
			return;
		else
			state = Error;
	}

	public inline function init(?_vec:DynamicVector<T>, _val:T, _first:Int = 0, _n:Int = 0) {
		switch (state) {
			case None:
				onInit(true, _first, _n, _val);
			case Init:
				onInit(false, _first, _n, _val);
			case _:
				final isNone = state == None;
				final isInit = state == Init;
				final canInit = isNone || isInit;
				#if debug
				Precondition.requires(canInit, 'can initialize dynamic vector.');
				#end
				if (canInit) {
					if (isNone) {
						onInit(true, _first, _n, _val);
					}
					if (isInit)
						onInit(false, _first, _n, _val);
				} else
					dirty = true;
		}
		return dirty ? null : this;
	}

	inline function onInit(_isNone:Bool, _first:Int, _n:Int, _val:T) {
		if (_isNone) {
			doAlloc(_n);
			doInit(_first, _n, _val);
		} else
			doInit(_first, _n, _val);
	}

	public inline function get(_idx:Int) {
		final idxLteCap = idxLteCap(_idx);
		#if debug
		Precondition.requires(idxLteCap, '"_idx" is less than or equal to maximum capacity.');
		#end
		return idxLteCap ? storage[_idx] : null;
	}

	public inline function set(_idx:Int, _item:T) {
		final idxLteMaxCap = idxLteMaxCap(_idx);
		#if debug
		Precondition.requires(idxLteMaxCap, "index is less than or equal to maximum capacity.");
		#end
		final idxLteCap = idxLteCap(_idx);
		if (idxLteCap) {
			storage[_idx] = _item;
			state = Set;
		} else {
			if (idxLteMaxCap) {
				doCapIdx(_idx);
				var s:Vector<T>;
				s.alloc(cap);
				len = storage.length;
				for (i in 0...len)
					s[i] = storage[i];
				storage = s;
				set(_idx, _item);
			} else
				state = Error;
		}
	}

	inline function idxLteCap(_idx:Int)
		return _idx <= cap;

	inline function idxLteMaxCap(_idx:Int)
		return _idx <= maxCap;

	public inline function add(_item:T) {}

	public inline function remove(_idx:Int) {}

	public inline function swap(_from:Int, _to:Int) {}
}

enum State {
	None;
	Init;
	Set;
	Error;
}
