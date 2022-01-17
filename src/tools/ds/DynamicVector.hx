package tools.ds;

import haxe.ds.Vector;
import tools.ds.DynamicVectorTools;
import tools.debug.Precondition;

using tools.ds.VectorTools;

@:structInit class DynamicVector<T> {
	var size:Int = 0;
	var count:Int = 0;
	var capIdx:Int = 0;
	var state:State = None;
	var caps:Vector<Int>;
	var storage:Vector<T>;

	var cap(get, never):Int;
	var maxCap(get, never):Int;
	var hasNextCap(get, never):Bool;

	public var length(get, never):Int;
	public var toString(get, never):String;

	public inline function new(?_size:Int) {
		size = DynamicVectorTools.size(_size);
		caps = DynamicVectorTools.caps(maxCap);
		storage = new Vector<T>(cap);
		storage.alloc(cap);
		state = Alloc;
	}

	inline function get_maxCap()
		return size;

	inline function get_cap()
		return caps[capIdx];

	inline function get_length()
		return cap;

	inline function get_hasNextCap()
		return capIdx + 1 < caps.length;

	inline function hasCapGte(_len:Int) {
		var has = false;
		for (i in capIdx...caps.length) {
			if (caps[i] >= _len)
				has = true;
			else
				continue;
		}
		return has;
	}

	// ==========================================================================================

	inline function get_toString() {
		final c = caps.toArray().toString();
		final s = storage.toArray().toString();
		final r = 'capIdx: $capIdx \n caps: $c \n length: $cap \n storage: $s';
		return r;
	}

	// ==========================================================================================

	inline function capIdxGte(_len:Int) {
		var idxGteLen:Null<Int> = null;
		for (i in capIdx...caps.length) {
			if (caps[i] >= _len) {
				idxGteLen = i;
				break;
			} else
				continue;
		}
		return idxGteLen != null ? idxGteLen : null;
	}

	public inline function alloc(_len:Int) {
		final canAlloc = _len >= 0 && _len <= maxCap;
		final canAllocAtNewCap = hasCapGte(_len);
		#if debug
		Precondition.requires(canAlloc, '"_len" greater than or equal to zero and less than or equal to maximum capacity of $maxCap');
		#end

		if (canAlloc) {
			if (_len <= cap)
				storage.alloc(_len);
			else {
				if (canAllocAtNewCap) {
					final idxGteLen = capIdxGte(_len);
					capIdx = idxGteLen == null ? capIdx : idxGteLen;
					final capAtCapIdxIsGteLen = capIdx == idxGteLen;

					#if debug
					Precondition.requires(capAtCapIdxIsGteLen, '"_len" is less than or equal to capacity of $cap at index $capIdx');
					#end

					if (capAtCapIdxIsGteLen) {
						storage = new Vector<T>(cap);
						storage.alloc(_len);
					}
				}
			}
		}
	}

	public inline function init(_val:T, _first:Int = 0, _n:Int = 0) {
		final firstGteZero = _first >= 0;
		final toIdx = _first + _n;
		final maxCapGteToIdx = maxCap >= toIdx;
		final canInit = firstGteZero && maxCapGteToIdx;
		final canInitAtNewCap = hasCapGte(toIdx);

		#if debug
		final vOf = 'value of';
		final fVal = '"_first" $vOf $_first index in storage';
		final tE = 'than or equal to';
		Precondition.requires(firstGteZero, '$fVal greater $tE zero');
		Precondition.requires(maxCapGteToIdx, '"_n" $vOf $_n items starting at $fVal less $tE maximum capacity of $maxCap');
		#end

		if (canInit) {
			if (toIdx <= cap) {} else {
				if (canInitAtNewCap) {
					final idxGteToIdx = capIdxGte(toIdx);
					capIdx = idxGteToIdx == null ? capIdx : idxGteToIdx;
					final capAtCapIdxIsGteToIdx = capIdx == idxGteToIdx;

					#if debug
					Precondition.requires(capAtCapIdxIsGteToIdx,
						'capacity of value $cap greater $tE index of value $toIdx ending at $vOf "_n" $_n number of items, 
					starting at $fVal');
					#end

					if (capAtCapIdxIsGteToIdx) {
						var dst = new Vector<T>(cap);
						dst.alloc(cap);
						dst = storage.blit(0, dst, 0, storage.length);
						dst.init(_val, _first, _n);
						storage = dst;
					}
				}
			}
		}
	}

	public inline function add(_item:T) {}

	public inline function remove(_idx:Int) {}

	public inline function swap(_from:Int, _to:Int) {}

	public inline function get(_idx:Int) {}

	public inline function set(_idx:Int, _item:T) {}
}

enum State {
	None;
	Alloc;
	Init;
	Set;
	Error;
}
/*
	import haxe.ds.Vector;
	#if debug
	import tools.debug.Precondition;
	import haxe.Json;
	#end

	using tools.ds.VectorTools;
	using tools.ds.DynamicVectorTools;

	// using Std;
	#if debug
	typedef Report = {
	count:Int,
	size:Int,
	storage:String,
	maxCap:Int,
	caps:Array<Int>,
	capIdx:Int,
	state:String,
	cap:Int,
	hasNextCap:Bool,
	nextCap:Int
	}
	#end

	@:structInit class DynamicVector<T> {
	/*final DEFAULT_SIZE = 64;
	final MAX_SIZE = 1048576; */ /*
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
	var cap(get, never):Int;
	var hasNextCap(get, never):Bool;
	var nextCap(get, never):Int;
	var maxCapGtDefault(get, never):Bool;

	#if debug
	public var report(get, never):String;
	public var canInit(get, never):Bool;
	public var stateName(get, never):String;

	public var canAlloc(get, never):Bool;

	var capDirty:Bool;

	public inline function get_canAlloc()
		return verifyAlloc();

	public inline function get_canInit()
		return verifyAlloc();

	public inline function get_stateName()
		return state.getName();

	public inline function get_report() {
		var r:Report = {
			count: count,
			size: size,
			storage: storage.toArray().toString(),
			maxCap: maxCap,
			caps: caps.toArray(),
			capIdx: capIdx,
			state: Std.string(state),
			cap: cap,
			hasNextCap: hasNextCap,
			nextCap: nextCap
		};
		return Json.stringify(r);
	}
	#end



	inline function get_nextCap()
		return hasNextCap ? caps[capIdx + 1] : cap;

	public var length(get, never):Int;

	inline function get_length()
		return cap;

	inline function get_cap()
		return caps[capIdx];

	inline function get_maxCap()
		return caps[caps.length];



	inline function onDirty() {
		dirty = dirty ? !dirty : false;
		return dirty;
	}

	inline function get_maxCapGtDefault()
		return maxCap > DEFAULT_SIZE;



	#if debug
	inline function doSizeValid() {}

	inline function verifyAlloc() {}
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
				size = len;
				doAlloc();
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
		state = Init;
	}

	inline function verifyInit(_first:Int, _n:Int, _val:T)
		return true;

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

	public inline function init(_val:T, _first:Int = 0, _n:Int = 0) {
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
			len = _first > 0 ? _first : 0;
			len += _n;
			size = len;
			doAlloc();
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
				var s = new Vector<T>(cap); // Vector<T>;
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

 */
