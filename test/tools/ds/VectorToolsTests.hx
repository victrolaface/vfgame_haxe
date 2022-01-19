package tools.ds;

import utest.Assert;
import utest.Test;
import haxe.ds.Vector;

using tools.ds.VectorTools;

@:structInit class VectorToolsTests extends Test {
	public inline function new()
		super();

	public inline function test_alloc_valid() {
		var srcItems = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
		var n = 10;
		Assert.isTrue(validateAlloc(srcItems, n)); // n is vecLen
		n = 5;
		Assert.isTrue(validateAlloc(srcItems, n)); // n lt vecLen
		n = 20;
		Assert.isTrue(validateAlloc(srcItems, n)); // n gt vecLen
		n = -1;
		Assert.isTrue(validateAlloc(srcItems, n)); // n lt zero
		n = 0;
		Assert.isTrue(validateAlloc(srcItems, n)); // n is zero
		srcItems = [];
		n = 1;
		Assert.isTrue(validateAlloc(srcItems, n)); // vec len is zero
	}

	inline function validateAlloc<T>(_srcItems:Array<T>, _n:Int) {
		var valid = false;
		final vecLen = _srcItems.length;
		var vecInit = new Vector<T>(vecLen);
		for (i in 0...vecLen)
			vecInit[i] = _srcItems[i];
		var vec = vecInit;
		vec.alloc(_n);
		if (_n > 0 && _n <= vecLen) {
			for (i in 0..._n) {
				valid = vec[i] == null;
				if (valid)
					continue;
				else
					break;
			}
			if (valid) {
				if (_n != vecLen) {
					for (i in _n - 1...vecLen - _n) {
						valid = vec[i] == vecInit[i];
						if (valid)
							continue;
						else
							break;
					}
				}
			}
		} else
			valid = vec == vecInit;
		return valid;
	}

	public inline function test_init_valid() {
		var srcItems = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
		var val = 0;
		var first = 0;
		var n = 10;
		Assert.isTrue(validateInit(srcItems, val, first, n));
		srcItems = [];
		Assert.isTrue(validateInit(srcItems, val, first, n)); // vecLen is zero
		srcItems = [1, 2, 3];
		first = -1;
		n = 1;
		Assert.isTrue(validateInit(srcItems, val, first, n)); // first is lt zero
		first = 0;
		n = 0;
		Assert.isTrue(validateInit(srcItems, val, first, n)); // n is lte zero
		first = 3;
		n = 1;
		Assert.isTrue(validateInit(srcItems, val, first, n)); // first gt lastPos (vecLen - 1)
		first = 0;
		n = 4;
		Assert.isTrue(validateInit(srcItems, val, first, n)); // lastPos (first + n) gt vec lastPos (vecLen - 1)
		srcItems = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
		first = 0;
		n = 5;
		Assert.isTrue(validateInit(srcItems, val, first, n)); // n lt vec lastPos (vecLen - 1)
		first = 4;
		Assert.isTrue(validateInit(srcItems, val, first, n)); // first gt zero
		first = 2;
		n = 6;
		Assert.isTrue(validateInit(srcItems, val, first, n)); // n lt vecLen, first gt zero, lastPos lt vec lastPos (vecLen - 1)
	}

	inline function validateInit<T>(_srcItems:Array<T>, _val:T, _first:Int, _n:Int) {
		final vecLen = _srcItems.length;
		final last = _first + _n;
		var valid = false;
		var doValid = true;
		var vecInit = new Vector<T>(vecLen);
		for (i in 0...vecLen)
			vecInit[i] = _srcItems[i];
		var vec = vecInit;
		vec.init(_val, _first, _n);
		while (doValid) {
			if (vecLen > 0 && _first >= 0 && _n > 0 && _first < vecLen && last < vecLen) {
				for (i in _first...last + 1) {
					valid = vec[i] == _val;
					if (valid)
						continue;
					else
						doValid = false;
				}
				if (_first > 0) {
					for (i in 0..._first) {
						valid = vec[i] == vecInit[i];
						if (valid)
							continue;
						else
							doValid = false;
					}
				}
				if (last < vecLen - 1) {
					for (i in last + 1...vecLen) {
						valid = vec[i] == vecInit[i];
						if (valid)
							continue;
						else
							doValid = false;
					}
				}
			} else
				valid = vec == vecInit;
			doValid = false;
		}
		return valid;
	}

	public inline function test_trim_valid() {
		var srcItems = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
		var n = 9;
		var v = intVector(srcItems);
		Assert.isTrue(validateTrim(v, n));
		n = -1;
		Assert.isTrue(validateTrim(v, n)); // trim len lt zero
		n = 20;
		Assert.isTrue(validateTrim(v, n)); // trim len gt vec len
		n = 10;
		Assert.isTrue(validateTrim(v, n)); // trim len is vec len
	}

	inline function validateTrim<T>(_vec:Vector<T>, _n:Int) {
		final vecInit = _vec;
		var valid = true;
		_vec = _vec.trim(_n);
		if (_n >= 0 && _n < vecInit.length) {
			final vecLen = _vec.length;
			if (_n > 0) {
				var idx = -1;
				for (i in 0...vecLen) {
					idx++;
					valid = _vec[i] == vecInit[idx];
					if (valid)
						continue;
					else
						break;
				}
				valid = valid ? _n == idx + 1 : false;
			} else
				valid = vecLen == 0;
		} else
			valid = _vec == vecInit;
		return valid;
	}

	public inline function test_blit_valid() {
		var n = 10;
		var srcItems = [10, 11, 22, 33, 44, 55, 66, 77, 88, 99];
		var dstItems = [12, 13, 14, 25, 36, 47, 58, 69, 82, 93];
		var src = intVector(srcItems);
		var dst = intVector(dstItems);
		var srcPos = 0;
		var dstPos = 0;
		Assert.isTrue(validateBlit(src, dst, srcPos, dstPos, n));
		n = 10;
		srcItems = [21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31];
		dstItems = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20];
		src = intVector(srcItems);
		dst = intVector(dstItems);
		srcPos = 0;
		dstPos = 10;
		Assert.isTrue(validateBlit(src, dst, srcPos, dstPos, n));
		n = 6;
		srcItems = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20];
		dstItems = [21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31];
		src = intVector(srcItems);
		dst = intVector(dstItems);
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
		srcItems = [1, 2, 3];
		dstItems = [4, 5, 6];
		n = 0;
		srcPos = 0;
		dstPos = 0;
		src = intVector(srcItems);
		dst = intVector(dstItems);
		var dstBlitted = src.blit(srcPos, dst, dstPos, n); // dst,srcPos,dstPos,n); //0, dst, 0, 0);
		Assert.isTrue(dstBlitted == dst); // n is 0
		n = -1;
		dstBlitted = src.blit(srcPos, dst, dstPos, n);
		Assert.isTrue(dstBlitted == dst); // n is lte 0
		srcPos = 2;
		dstPos = 0;
		n = 3;
		dstBlitted = src.blit(srcPos, dst, dstPos, n);
		Assert.isTrue(dstBlitted == dst); // srcPos + n (srcAmt) > srcLen
		srcPos = 0;
		dstPos = 2;
		dstBlitted = src.blit(srcPos, dst, dstPos, n);
		Assert.isTrue(dstBlitted == dst); // dstPos + n (dstAmt) > dstLen
		Assert.raises(() -> { // srcPos gt srcLen, dstPos gt dstLen, n lte 0, srcPos + n (srcAmt) > srcLen, dstPos + n (dstAmt) > dstLen
			src = new Vector<Int>(10);
			dst = new Vector<Int>(10);
			dst = src.blit(100, dst, 100, -1);
		});
	}

	inline function validateBlit<T>(_src:Vector<T>, _dst:Vector<T>, _srcPos:Int, _dstPos:Int, _n:Int) {
		final dstLen = _dst.length;
		var valid = _srcPos < _src.length && _dstPos < dstLen;
		if (valid) {
			var doValid = true;
			while (doValid) {
				final dstInit = _dst;
				final dst = _src.blit(_srcPos, _dst, _dstPos, _n);
				final lenAtDstPosLast = _dstPos + _n;
				if (_n > 0) {
					if (_dstPos > 0) {
						final lenAtDstPos = _dstPos + 1;
						for (i in 0...lenAtDstPos) {
							valid = dst[i] == dstInit[i];
							if (valid)
								continue;
							else
								doValid = false;
						}
					}
					var src = new Vector<T>(_n);
					var idx = -1;
					for (i in _srcPos..._srcPos + _n) {
						idx++;
						src[idx] = _src[i];
					}
					idx = -1;
					var amt = 0;
					for (i in _dstPos...lenAtDstPosLast) {
						idx++;
						amt++;
						valid = dst[i] == src[idx];
						if (valid)
							continue;
						else
							doValid = false;
					}
					valid = amt == _n;
					if (valid && lenAtDstPosLast < dstLen) {
						for (i in lenAtDstPosLast...dstLen) {
							valid = dst[i] == dstInit[i];
							if (valid)
								continue;
							else
								doValid = false;
						}
					} else
						doValid = false;
				} else {
					valid = dst.length == dstLen && dst.length == dstInit.length;
					if (valid) {
						for (i in 0...dstLen) {
							valid = dst[i] == dstInit[i];
							if (valid)
								continue;
							else
								doValid = false;
						}
					}
				}
				doValid = false;
			}
			return valid;
		} else
			return false;
	}

	static inline function intVector(_intArr:Array<Int>) {
		final intArrLen = _intArr.length;
		var v = new Vector<Int>(intArrLen);
		for (i in 0...intArrLen)
			v[i] = _intArr[i];
		return v;
	}
}
