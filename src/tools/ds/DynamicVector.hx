package tools.ds;

import haxe.ds.Vector;
import tools.ds.DynamicVectorTools;

using tools.ds.VectorTools;

@:structInit class DynamicVector<T> {
	var size:Int = 0;
	var count:Int = 0;
	var capIdx:Int = 0;
	var mState:State = None;
	var caps:Vector<Int>;
	var storage:Vector<T>;

	var cap(get, never):Int;
	var maxCap(get, never):Int;
	var hasNextCap(get, never):Bool;

	public var length(get, never):Int;
	#if debug
	public var toString(get, never):String;
	public var state(get, never):String;
	#end

	public inline function new(?_size:Int) {
		size = DynamicVectorTools.size(_size);
		caps = DynamicVectorTools.caps(maxCap);
		storage = new Vector<T>(cap);
		storage.alloc(cap);
		mState = Alloc;

		#if debug
		final capsLen = caps.length;
		final first = caps[0];
		final capIsFirst = cap == first;
		final hasCap = capsLen == 1 && size == first && !hasNextCap;
		final hasCaps = size == caps[capsLen - 1] && hasNextCap;
		mState = capIsFirst && (hasCap || hasCaps) ? Alloc : Error;
		#end
	}

	inline function get_maxCap()
		return size;

	inline function get_cap()
		return caps[capIdx];

	inline function get_length()
		return cap;

	inline function get_hasNextCap()
		return capIdx + 1 < caps.length;

	/*inline function hasCapGte(_len:Int) {
		var has = false;
		for (i in capIdx...caps.length) {
			if (caps[i] >= _len)
				has = true;
			else
				continue;
		}
		return has;
	}*/
	/*inline function capIdxGte(_len:Int) {
		var idxGteLen:Null<Int> = null;
		for (i in capIdx...caps.length) {
			if (caps[i] >= _len) {
				idxGteLen = i;
				break;
			} else
				continue;
		}
		return idxGteLen != null ? idxGteLen : null;
	}*/
	public inline function alloc(?_len:Int) {
		/*
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
				mState = Alloc;
			}
		 */
	}

	public inline function init(_val:T, _first:Int = 0, _n:Int = 0) {
		/*final firstGteZero = _first >= 0;
			final toIdx = _first + _n;
			final maxCapGteToIdx = maxCap >= toIdx;
			final canInit = firstGteZero && maxCapGteToIdx;
			final canInitAtCap = hasCapGte(toIdx);

			#if debug
			final vOf = 'value of';
			final fVal = '"_first" $vOf $_first index in storage';
			final tE = 'than or equal to';
			Precondition.requires(firstGteZero, '$fVal greater $tE zero');
			Precondition.requires(maxCapGteToIdx, '"_n" $vOf $_n items starting at $fVal less $tE maximum capacity of $maxCap');
			#end

			if (canInit) {
				if (toIdx <= cap) {
					// do
				} else {
					if (canInitAtCap) {
						final capIdxGteTo = capIdxGte(toIdx);
						capIdx = capIdxGteTo == null ? capIdx : capIdxGteTo;
						final hasCapGteTo = capIdx == capIdxGteTo;

						#if debug
						Precondition.requires(hasCapGteTo, 'capacity of value $cap greater $tE index of value $toIdx ending at $vOf "_n" $_n number of items, 
						starting at $fVal');
						#end

						if (hasCapGteTo) {
							var dst = new Vector<T>(cap);
							dst.alloc(cap);
							dst = storage.blit(0, dst, 0, storage.length);
							dst.init(_val, _first, _n);
							storage = dst;
						}
					}
				}
				mState = Init;
		}*/
	}

	public inline function add(_item:T) {}

	public inline function remove(_idx:Int) {}

	public inline function swap(_from:Int, _to:Int) {}

	public inline function get(_idx:Int) {}

	public inline function set(_idx:Int, _val:T) {}

	#if debug
	public inline function get_toString() {
		final c = caps.toArray().toString();
		final s = storage.toArray().toString();
		final r = 'capIdx: $capIdx \n caps: $c \n length: $cap \n storage: $s';
		return r;
	}

	public inline function get_state()
		return mState.getName();
	#end
}

enum State {
	None;
	Alloc;
	Init;
	Set;
	Error;
}
/*
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
 */
