package tools.ds;

import utest.Assert;
import utest.Test;
import haxe.ds.Vector;

using tools.ds.VectorTools;

@:structInit class VectorToolsTests extends Test {
	var n:Int;
	var len:Int;
	var idx:Int;

	public inline function new()
		super();

	public inline function test_alloc_valid() {
		len = 10;
		var v = new Vector<Int>(len);
		var val = 0;
		n = 2;
		for (i in 0...len)
			v[i] = val;
		v.alloc(n);
		Assert.isTrue(validateIter(v, null, 0, n) && validateIter(v, val, n, len - n));
		len = 1;
		v = new Vector<Int>(len);
		n = 9999;
		v.alloc(n);
		val = null;
		Assert.isTrue(validateIter(v, val, 0, len));
		Assert.raises(() -> { // _first/min lt zero
			v = new Vector(1);
			v.alloc(-1);
		});
	}

	public inline function test_init_valid() {
		len = 10;
		var v = new Vector<Int>(len);
		var val = 0;
		n = 2;
		v.init(val, 0, n);
		Assert.isTrue(validateIter(v, val, 0, n) && validateIter(v, null, n, len - n));
		Assert.raises(() -> { // _first/min lt zero
			var v = new Vector<Int>(1);
			v.init(1, -1, 2);
		});
		Assert.raises(() -> { // _first/min gte vector length
			var v = new Vector<Int>(1);
			v.init(1, 2, 1);
		});
		Assert.raises(() -> { // _max gt vector length
			var v = new Vector<Int>(1);
			v.init(1, 0, 99);
		});
	}

	function validateIter<T>(_vec:Vector<T>, _val:T, _first:Int, _n:Int) {
		var valid = true;
		for (i in _first..._n) {
			if (_vec[i] == _val)
				continue;
			else {
				valid = false;
				break;
			}
		}
		return valid;
	}

	public inline function test_trim_valid() {
		var v = new Vector<Int>(10);
		for (i in 0...v.length)
			v[i] = i;
		v = v.trim(9);
		var isVal = false;
		for (i in 0...v.length) {
			isVal = v[i] == i;
			if (isVal)
				continue;
			else
				break;
		}
		Assert.isTrue(isVal && v.length == 9);
		Assert.raises(() -> {
			v = v.trim(-1); // trim len < 0
		});
		v = new Vector<Int>(1);
		v = v.trim(8); // trim len < vec len
		Assert.isTrue(v.length == 1);
	}

	public inline function test_blit_valid() {
		var n = 10;
		var src = initRandom(n);
		var dst = initRandom(n);
		var srcPos = 0;
		var dstPos = 0;
		Assert.isTrue(validateBlit(src, dst, srcPos, dstPos, n));
		n = 10;
		src = initRandom(10);
		dst = initRandom(20);
		srcPos = 0;
		dstPos = 10;
		Assert.isTrue(validateBlit(src, dst, srcPos, dstPos, n));
		n = 6;
		src = initRandom(20);
		dst = initRandom(10);
		srcPos = 4;
		dstPos = 2;
		Assert.isTrue(validateBlit(src, dst, srcPos, dstPos, n));
		Assert.raises(() -> { // srcPos gt srcLen
			src = new Vector<Int>(1);
			dst = new Vector<Int>(1);
			dst = src.blit(2, dst, 0, 1);
		});
		Assert.raises(() -> { // dstPos gt dstLen
			src = new Vector<Int>(1);
			dst = new Vector<Int>(1);
			dst = src.blit(0, dst, 2, 1);
		});
		Assert.raises(() -> { // n is 0
			src = new Vector<Int>(1);
			dst = new Vector<Int>(1);
			dst = src.blit(0, dst, 0, 0);
		});
		Assert.raises(() -> { // n lte 0
			src = new Vector<Int>(1);
			dst = new Vector<Int>(1);
			dst = src.blit(0, dst, 0, -1);
		});
		Assert.raises(() -> { // srcPos + n (srcAmt) > srcLen
			src = new Vector<Int>(10);
			dst = new Vector<Int>(10);
			dst = src.blit(9, dst, 0, 2);
		});
		Assert.raises(() -> { // dstPos + n (dstAmt) > dstLen
			src = new Vector<Int>(10);
			dst = new Vector<Int>(10);
			dst = src.blit(0, dst, 9, 2);
		});
		Assert.raises(() -> { // srcPos gt srcLen, dstPos gt dstLen, n lte 0, srcPos + n (srcAmt) > srcLen, dstPos + n (dstAmt) > dstLen
			src = new Vector<Int>(10);
			dst = new Vector<Int>(10);
			dst = src.blit(100, dst, 100, -1);
		});
	}

	inline function validateBlit<T>(_src:Vector<T>, _dst:Vector<T>, _srcPos:Int, _dstPos:Int, _n:Int) {
		final nGtZero = _n > 0;
		final srcLen = _src.length;
		final srcPosLtLen = _srcPos < srcLen;
		final srcPosLast = _srcPos + _n - 1;
		final srcPosLastLtLen = srcPosLast < srcLen;
		final srcAmt = blitAmt(_srcPos, srcPosLast);
		final srcAmtIsN = srcAmt == _n;
		final dstLen = _dst.length;
		final dstPosLtLen = _dstPos < dstLen;
		final dstPosLast = _dstPos + _n - 1;
		final dstPosLastLtLen = dstPosLast < dstLen;
		final dstAmt = blitAmt(_dstPos, dstPosLast);
		final dstAmtIsN = dstAmt == _n;
		final canValidate = srcPosLtLen && srcPosLastLtLen && srcAmtIsN && dstPosLtLen && dstPosLastLtLen && dstAmtIsN;

		var valid = canValidate;

		if (canValidate) {
			final dstInit = _dst;
			final dst = _src.blit(_srcPos, _dst, _dstPos, _n);
			var amt:Int;
			if (nGtZero) {
				if (_dstPos > 0) {
					len = _dstPos + 1;
					for (i in 0...len) {
						valid = dst[i] == dstInit[i];
						if (valid)
							continue;
						else
							break;
					}
				}
				if (valid) {
					var src = new Vector<T>(_n);
					var idx = -1;
					len = srcPosLast + 1;
					for (i in _srcPos...len) {
						idx++;
						src[idx] = _src[i];
					}
					len = dstPosLast + 1;
					idx = -1;
					amt = 0;
					for (i in _dstPos...len) {
						idx++;
						amt++;
						valid = dst[i] == src[idx];
						if (valid)
							continue;
						else
							break;
					}
					if (valid)
						valid = amt == _n;
				}
				if (valid) {
					if (dstPosLast + 1 < dstLen) {
						final dstPosAfterLast = dstPosLast + 1;
						for (i in dstPosAfterLast...dstLen) {
							valid = dst[i] == dstInit[i];
							if (valid)
								continue;
							else
								break;
						}
					}
				}
			} else {
				if (dst.length == dstLen && dst.length == dstInit.length) {
					for (i in 0...dstLen) {
						valid = dst[i] == dstInit[i];
						if (valid)
							continue;
						else
							break;
					}
				} else
					valid = false;
			}
			return valid;
		} else
			return false;
	}

	static inline function initRandom(_len:Int) {
		var v = new Vector<Int>(_len);
		for (i in 0...v.length)
			v[i] = Math.round(Math.random() * 1000);
		return v;
	}

	static inline function blitAmt(_pos1:Int, _pos2:Int) {
		final len = _pos2 + 1;
		var a = 0;
		for (_ in _pos1...len)
			a++;
		return a;
	}
}
