/*
package tools.ds;

import haxe.ds.Vector;

@:structInit class VectorTools {
	static public inline function alloc<T>(_vec:Vector<T>, _len:Int) {
		final vecLen = _vec.length;
		if (vecLen > 0 && _len > 0 && _len <= vecLen) {
			for (i in 0..._len)
				_vec[i] = null;
		}
		return _vec;
	}

	public static inline function init<T>(_vec:Vector<T>, _val:T, _first:Int = 0, _n:Int = 0) {
		final vecLen = _vec.length;
		if (vecLen > 0 && _first >= 0 && _n > 0 && _first < vecLen && _first + _n < vecLen) {
			for (i in _first..._first + _n + 1)
				_vec[i] = _val;
		}
		return _vec;
	}

	public static inline function trim<T>(_vec:Vector<T>, _len:Int) {
		final vecLen = _vec.length;
		if (vecLen > 0 && _len >= 0 && _len < _vec.length) {
			var vec = new Vector<T>(_len);
			if (_len > 0) {
				for (i in 0..._len)
					vec[i] = _vec[i];
			}
			return vec;
		} else
			return _vec;
	}

	public static function blit<T>(_src:Vector<T>, _srcPos:Int, _dst:Vector<T>, _dstPos:Int, _n:Int) {
		final srcLen = _src.length;
		final srcPosLtLen = _srcPos < srcLen;
		final dstLen = _dst.length;
		final dstPosLtLen = _dstPos < dstLen;

		if (srcPosLtLen && dstPosLtLen && _srcPos + _n < srcLen && _dstPos + _n < dstLen && _n > 0) {
			if (srcLen == dstLen) {
				var i:Int;
				var j:Int;
				if (_srcPos < _dstPos) {
					i = _srcPos + _n;
					j = _dstPos + _n;
					for (_ in 0..._n) {
						i--;
						j--;
						_src[j] = _src[i];
					}
				} else if (_srcPos > _dstPos) {
					i = _srcPos;
					j = _dstPos;
					for (_ in 0..._n) {
						_src[j] = _src[i];
						i++;
						j++;
					}
				}
			} else {
				final srcPosZero = _srcPos == 0;
				final dstPosZero = _dstPos == 0;
				if (srcPosZero && dstPosZero) {
					for (i in 0..._n)
						_dst[i] = _src[i];
				} else if (srcPosZero) {
					for (i in 0..._n)
						_dst[_dstPos + i] = _src[i];
				} else if (dstPosZero) {
					for (i in 0..._n)
						_dst[i] = _src[_srcPos + i];
				} else {
					for (i in 0..._n)
						_dst[_dstPos + i] = _src[_srcPos + i];
				}
			}
		}
		return _dst;
	}

	#if debug
	public static inline function toString<T>(_src:Vector<T>) {
		var str = '';
		if (_src.length > 0)
			str = _src.toArray().toString();
		return str;
	}
	#end
}
*/