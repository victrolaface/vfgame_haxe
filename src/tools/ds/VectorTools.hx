package tools.ds;

import haxe.ds.Vector;
import tools.debug.Precondition;

@:structInit class VectorTools {
	static var len:Int;

	static public inline function alloc<T>(_vec:Vector<T>, _len:Int) {
		len = _vec.length;
		final canAlloc = _len >= 0;

		#if debug
		Precondition.requires(canAlloc, '"_len" is greater than or equal to zero');
		#end

		if (_len <= len) {
			for (i in 0..._len)
				_vec[i] = null;
		} else {
			for (i in 0...len)
				_vec[i] = null;
		}
		return canAlloc ? _vec : null;
	}

	public static inline function init<T>(_vec:Vector<T>, _val:T, _first:Int = 0, _n:Int = 0) {
		len = _vec.length;
		var min = _first;
		final max = _n <= 0 ? len : min + _n;
		final minGteZero = min >= 0;
		final minLtLen = min < len;
		final maxLteLen = max <= len;
		final canInit = minGteZero && minLtLen && maxLteLen;

		#if debug
		Precondition.requires(minGteZero, '"_first" greater than or equal to zero');
		Precondition.requires(minLtLen, '"_first" less than "_vec" length');
		Precondition.requires(maxLteLen, '"_max" less than or equal to "_vec" length');
		#end

		while (min < max)
			_vec[min++] = _val;
		return canInit ? _vec : null;
	}

	public static inline function trim<T>(_vec:Vector<T>, _len:Int) {
		#if debug
		Precondition.requires(_len >= 0, '"_len" greater than or equal to zero');
		#end

		len = _vec.length;
		if (len > _len) {
			var arr = _vec.toArray();
			arr = arr.slice(0, _len);
			len = arr.length;
			var vec = new Vector<T>(len);
			for (i in 0...len)
				vec[i] = arr[i];
			return vec;
		} else
			return _vec;
	}

	public static function blit<T>(_src:Vector<T>, _srcPos:Int, _dst:Vector<T>, _dstPos:Int, _n:Int) {
		final srcLen = _src.length;
		final srcPosLtLen = _srcPos < srcLen;
		final dstLen = _dst.length;
		final dstPosLtLen = _dstPos < dstLen;

		#if debug
		Precondition.requires(srcPosLtLen, '"_srcPos" at index $_srcPos less than length of $srcLen of vector "_src"');
		Precondition.requires(dstPosLtLen, '"_dstPos" at index $_dstPos less than length of $dstLen of vector "_dst"');
		#end

		var doBlit = srcPosLtLen && dstPosLtLen && _srcPos + _n < srcLen && _dstPos + _n < dstLen && _n > 0;
		var dstBlitted = new Vector<T>(dstLen);

		if (doBlit) {
			final srcPosLast = posAt(_srcPos, _n);
			final dstPosLast = posAt(_dstPos, _n);
			var srcTrimmed = new Vector<T>(_n);
			var idx = -1;
			for (i in _srcPos...srcPosLast + 1) {
				idx++;
				srcTrimmed[idx] = _src[i];
			}
			final srcTrimmedLen = srcTrimmed.length;
			final srcAmt = amt(_srcPos, srcPosLast);
			final dstAmt = amt(_dstPos, dstPosLast);
			if (isAmt(srcTrimmedLen, srcAmt, dstAmt, _n)) {
				for (i in 0...dstLen)
					dstBlitted[i] = _dst[i];
				idx = -1;
				for (i in _dstPos...dstPosLast + 1) {
					idx++;
					dstBlitted[i] = srcTrimmed[idx];
				}
				doBlit = isAmt(idx + 1, srcAmt, dstAmt, srcTrimmedLen, _n);
			}
		}
		return doBlit ? dstBlitted : _dst;
	}

	static inline function posAt(_initPos:Int, _n:Int)
		return _initPos + _n - 1;

	static inline function isAmt(_len:Int, _amt1:Int, _amt2:Int, _amt3:Int, ?_amt4:Int) {
		final notNull = _amt4 != null;
		final lenIsAmt = _len == _amt1 && _len == _amt2 && _len == _amt3;
		return notNull ? lenIsAmt && _len == _amt4 : lenIsAmt;
	}

	static inline function amt(_pos1:Int, _pos2:Int) {
		final len = _pos2 + 1;
		var a = 0;
		for (_ in _pos1...len)
			a++;
		return a;
	}

	#if debug
	public static inline function toString<T>(_src:Vector<T>) {
		final srcLen = _src.length;
		final canParse = srcLen >= 0;

		Precondition.requires(canParse, '"_src" length of $srcLen greater than or equal to zero');

		if (canParse)
			return _src.toArray().toString();
		else
			return null;
	}
	#end
}
/*


	public static inline function swap<T>(_vec:Vector<T>, _a:Int, _b:Int) {
		len = _vec.length;
		dirty = _vec == null || 0 > _a || _a >= len || 0 > _b || _b >= len;
		#if debug
		Precondition.requires(!dirty);
		#end
		if (dirty) {
			onDirty();
		} else {
			if (_a != _b) {
				var x = _vec[_a];
				_vec[_a] = _vec[_b];
				_vec[_b] = x;
			}
		}
	}

	public static inline function getFront<T>(_vec:Vector<T>, _idx:Int) {
		dirty = _vec == null || 0 > _idx || _idx >= _vec.length;
		#if debug
		Precondition.requires(!dirty);
		#end
		if (dirty) {
			onDirty();
			final nulled:Null<T> = null;
			return nulled;
		} else {
			swap(_vec, _idx, 0);
			return _vec[0];
		}
	}

	public static inline function iter<T>(_src:Vector<T>, _f:T->Void, _n:Int = 0) {
		if (_n == 0)
			_n = _src.length;
		for (i in 0..._n)
			_f(_src[i]);
	}

	public static inline function forEach<T>(_src:Vector<T>, _f:T->Int->T) {
		final n = _src.length;
		for (i in 0...n)
			_src[i] = _f(_src[i], i);
	}

	public static inline function binarySearchCmp<T>(_vec:Vector<T>, _x:T, _min:Int, _max:Int, _comparator:T->T->Int) {
		len = _vec.length;
		dirty = _vec == null || _comparator == null || _min < 0 || _min >= len || _max >= len;
		#if debug
		Precondition.requires(!dirty);
		#end
		if (dirty) {
			var intNull:Null<Int> = null;
			return intNull;
		} else {
			var l = _min;
			var m = _max + 1;
			var h = _max + 1;
			while (l < h) {
				m = l + ((h - l) >> 1);
				if (_comparator(_vec[m], _x) < 0)
					l = m + 1;
				else
					h = m;
			}
			return ((l <= _max) && _comparator(_vec[l], _x) == 0) ? l : ~l;
		}
	}

	public static inline function binarySearchf(_vec:Vector<Float>, _x:Float, _min:Int, _max:Int) {
		len = _vec.length;
		dirty = _vec == null || _min < 0 && _min >= len || _max >= len;
		#if debug
		Precondition.requires(!dirty);
		#end
		if (dirty) {
			final intNull:Null<Int> = null;
			return intNull;
		} else {
			var l = _min;
			var m = _max + 1;
			var h = _max + 1;
			while (l < h) {
				m = l + ((h - l) >> 1);
				if (_vec[m] < _x)
					l = m + 1;
				else
					h = m;
			}
			return ((l <= _max) && (_vec[l] == _x)) ? l : ~l;
		}
	}

	public static inline function shuffle<T>(_vec:Vector<T>, _rvals:Vector<Float> = null) {
		dirty = _vec == null;
		#if debug
		Precondition.requires(!dirty);
		#end
		if (dirty) {
			onDirty();
		} else {
			len = _vec.length;
			var s = len;
			if (_rvals == null) {
				while (--s > 1) {
					var i = Std.int(Shuffle.frand() * s);
					var t = _vec[s];
					_vec[s] = _vec[i];
					_vec[i] = t;
				}
			} else {
				dirty = _rvals.length < len;
				#if debug
				Precondition.requires(!dirty, "sufficient random values.");
				#end
				var j = 0;
				while (--s > 1) {
					var i = Std.int(_rvals[j++] * s);
					var t = _vec[s];
					_vec[s] = _vec[i];
					_vec[i] = t;
				}
			}
		}
	}

	public static inline function random<T>(_vec:Vector<T>) {
		len = _vec.length;
		return len < 2 ? _vec[0] : _vec[Std.int(Shuffle.frand() * len)];
	}

	public static inline function sortRange(_vec:Vector<Float>, _cmp:Float->Float->Int, _useInsertionSort:Bool, _first:Int, _n:Int) {
		len = _vec.length;
		if (len > 1) {
			final firstInRange = _first >= 0 && _first <= len - 1 && _first + _n <= len;
			final nInRange = _n >= 0 && _n <= len;
			#if debug
			Precondition.requires(firstInRange, "first in range.");
			Precondition.requires(nInRange, "n in range.");
			#end
			dirty = !firstInRange || !nInRange;
			if (dirty) {
				onDirty();
			} else {
				if (_useInsertionSort) {
					for (i in _first + 1..._first + _n) {
						var x = _vec[i];
						var j = i;
						while (j > _first) {
							var y = _vec[j - 1];
							if (_cmp(y, x) > 0) {
								_vec[j] = y;
								j--;
							} else
								break;
						}
						_vec[j] = x;
					}
				} else
					quickSort(_vec, _first, _n, _cmp);
			}
		}
	}

	static inline function quickSort(_vec:Vector<Float>, _first:Int, _n:Int, _cmp:Float->Float->Int) {
		var last = _first + _n - 1;
		var lo = _first;
		var hi = last;
		if (_n > 1) {
			var i0 = _first;
			var i1 = i0 + (_n >> 1);
			var i2 = i0 + _n - 1;
			var t0 = _vec[i0];
			var t1 = _vec[i1];
			var t2 = _vec[i2];
			var mid:Int;
			var t = _cmp(t0, t2);
			if (t < 0 && _cmp(t0, t1) < 0)
				mid = _cmp(t1, t2) < 0 ? i1 : i2;
			else {
				if (_cmp(t1, t0) < 0 && _cmp(t1, t2) < 0)
					mid = t < 0 ? i0 : i2;
				else
					mid = _cmp(t2, t0) < 0 ? i1 : i0;
			}
			var pivot = _vec[mid];
			_vec[mid] = _vec[_first];
			while (lo < hi) {
				while (_cmp(pivot, _vec[hi]) < 0 && lo < hi)
					hi--;
				if (hi != lo) {
					_vec[lo] = _vec[hi];
					lo++;
				}
				while (_cmp(pivot, _vec[lo]) > 0 && lo < hi)
					lo++;
				if (hi != lo) {
					_vec[hi] = _vec[lo];
					hi--;
				}
			}
			_vec[lo] = pivot;
			quickSort(_vec, _first, lo - _first, _cmp);
			quickSort(_vec, lo + 1, last - lo, _cmp);
		}
	}

	public static inline function quickPerm(_n:Int) {
		var r = [];
		var a = [];
		var p = [];
		var i:Int, j:Int, t:Int;
		i = 0;
		while (i < _n) {
			a[i] = i + 1;
			p[i] = 0;
			i++;
		}
		r.push(a.copy());
		i = 1;
		while (i < _n) {
			if (p[i] < i) {
				j = i % 2 * p[i];
				t = a[j];
				a[j] = a[i];
				a[i] = t;
				r.push(a.copy());
				p[i]++;
				i = 1;
			} else {
				p[i] = 0;
				i++;
			}
		}
		len = r.length;
		var r2 = new Vector(len);
		for (i in 0...len)
			r2[i] = r[i];
		return r2;
	}

	public static inline function equals<T>(_a:Vector<T>, _b:Vector<T>, _eq:(a:T, b:T) -> Bool) {
		len = _a.length;
		if (len != _b.length)
			return false;
		var i = 0;
		while (i < len) {
			if (!_eq(_a[i], _b[i]))
				return false;
			i++;
		}
		return true;
	}

	public static inline function split<T>(_vec:Vector<T>, _n:Int, _k:Int) {
		dirty = _n % _k != 0;
		#if debug
		Precondition.requires(!dirty, '"_n" is multiple of "_k".');
		#end
		if (dirty) {
			onDirty();
			return null;
		} else {
			var a = new Array<Array<T>>();
			var b:Array<T> = null;
			for (i in 0..._n) {
				if (i % _k == 0)
					a[Std.int(i / _k)] = b = [];
				b.push(_vec[i]);
			}
			len = a.length;
			var out = new Vector<Vector<T>>(len);
			for (x in 0...len) {
				var a2 = a[x];
				var b2 = new Vector(a2.length);
				for (y in 0...b2.length)
					b2[y] = a2[y];
				out[x] = b2;
			}
			return out;
		}
	}

	public static inline function pairwise<T>(_input:Vector<T>, _visit:Int->T->T->Void, _max:Int) {
		dirty = _max % 1 != 0;
		#if debug
		Precondition.requires(!dirty);
		#end
		if (dirty) {
			onDirty();
		} else {
			var i = 0;
			while (i < _max) {
				_visit(i, _input[i], _input[i + 1]);
				i += 2;
			}
		}
	}

	public static inline function bruteforce<T>(_input:Vector<T>, _visit:T->T->Void) {
		len = _input.length;
		var i = 0;
		var j = len;
		var k = len;
		var l = k - 1;
		var t:T;
		while (i < l) {
			t = _input[i];
			j = i + 1;
			while (j < k) {
				_visit(t, _input[j]);
				j++;
			}
			i++;
		}
	}

	static inline function onDirty()
		dirty = dirty ? !dirty : false;
	}
 */
