package tools.ds;

import haxe.ds.Vector;
import tools.ds.DynamicVectorTools;

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

	public inline function new(?_size:Int) {
		size = DynamicVectorTools.size(_size);
		caps = DynamicVectorTools.caps(maxCap);
		storage = new Vector<T>(cap);
		storage.alloc(cap);
		state = Alloc;
	}

	public inline function alloc(?_n:Int) {
		if (_n != null && _n >= 0) {
			final doAlloc = canAlloc(_n);
			if (doAlloc) {
				if (lteCap(_n))
					storage.alloc(_n);
				else if (hasCapGte(_n)) {
					final idxGteN = capIdxGte(_n);
					if (idxGteN != null && idxGteN > capIdx) {
						capIdx = idxGteN;
						storage = new Vector<T>(cap);
						storage.alloc(_n);
					}
				}
			}
			state = doAlloc && state != Alloc ? Alloc : state;
		}
	}

	public inline function canAlloc(?_n:Int)
		return _n != null && _n >= 0 ? (_n <= cap ? true : (hasCapGte(_n) ? true : false)) : false;

	inline function lteCap(_n:Int)
		return _n <= cap;

	inline function get_maxCap()
		return size;

	inline function get_cap()
		return caps[capIdx];

	inline function get_length()
		return cap;

	inline function get_hasNextCap()
		return capIdx + 1 < caps.length;

	inline function hasCapGte(_n:Int) {
		var has = false;
		for (i in capIdx...caps.length) {
			has = _n <= caps[i];
			if (has)
				break;
			else
				continue;
		}
		return has;
	}

	inline function capIdxGte(_n:Int) {
		var idx:Null<Int> = null;
		for (i in capIdx...caps.length) {
			if (_n <= caps[i]) {
				idx = i;
				break;
			} else
				continue;
		}
		return idx;
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
