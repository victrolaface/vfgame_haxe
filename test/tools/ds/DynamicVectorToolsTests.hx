#if debug
package tools.ds;

import utest.Assert;
import utest.Test;
import haxe.ds.Vector;
import tools.ds.DynamicVector;
import tools.ds.DynamicVectorTools;

using tools.ds.VectorTools;

@:structInit class DynamicVectorToolsTests extends Test {
	final maxSize = 1048576;
	final defaultCap = 64;
	var len:Int;

	public inline function new()
		super();

	public inline function test_size_valid() {
		var size = DynamicVectorTools.size();
		Assert.isTrue(size == maxSize);
		len = 0;
		size = DynamicVectorTools.size(len);
		Assert.isTrue(size == len);
		len = 33;
		size = DynamicVectorTools.size(len);
		Assert.isTrue(size == len);
		Assert.raises(() -> { // size lt zero
			size = DynamicVectorTools.size(-1);
		});
		Assert.raises(() -> { // size gt max
			size = DynamicVectorTools.size(1048577);
		});
	}

	public inline function test_caps_valid() {
		Assert.raises(() -> { // maxCap lt zero
			var c = DynamicVectorTools.caps(-1);
		});
		Assert.isTrue(validateCaps(0));
		Assert.isTrue(validateCaps(1));
		Assert.isTrue(validateCaps(defaultCap - 1));
		Assert.isTrue(validateCaps(defaultCap));
		Assert.isTrue(validateCaps(defaultCap + 1));
		Assert.isTrue(validateCaps(999));
		Assert.isTrue(validateCaps(maxSize - 1));
		Assert.isTrue(validateCaps(maxSize));
		Assert.raises(() -> { // maxCap gt max size
			var c = DynamicVectorTools.caps(maxSize + 1);
		});
	}

	inline function validateCaps(_len:Int) {
		var c = DynamicVectorTools.caps(_len);
		len = c.length;
		final max = c[len - 1];
		final lenIsOne = len == 1;
		final initCapIsMax = c[0] == max;
		var valid = false;
		if (max < defaultCap) {
			valid = lenIsOne && initCapIsMax;
		} else {
			if (max == defaultCap) {
				if (lenIsOne)
					valid = initCapIsMax;
			} else {
				for (i in 0...len) {
					if (i == 0)
						valid = c[i] == defaultCap;
					else {
						if (i + 1 == len)
							valid = c[i] == max;
						else
							valid = c[i] == c[i - 1] * 2;
					}
					if (valid)
						continue;
					else
						break;
				}
			}
		}
		return valid;
	}
}
#end
