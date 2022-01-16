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
}
