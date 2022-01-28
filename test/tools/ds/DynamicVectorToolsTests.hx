/*
	#if debug
	package tools.ds;

	import utest.Assert;
	import utest.Test;
	import tools.ds.DynamicVectorTools;

	@:structInit class DynamicVectorToolsTests extends Test {
	final maxSize = 1048576;
	final defaultCap = 64;

	public inline function new()
		super();

	public inline function test_size_valid() {
		Assert.isTrue(validateSize());
		
		/*Assert.isTrue(validateSize()); // size is null
		var size = -1;
		Assert.isTrue(validateSize(size)); // size lt zero
		size = 0;
		Assert.isTrue(validateSize(size)); // size is zero
		size = 1;
		Assert.isTrue(validateSize(size)); // size gt zero, lt max
		size = maxSize;
		Assert.isTrue(validateSize(size)); // size is max
		size = maxSize + 1;
		Assert.isTrue(validateSize(size)); // size gt max
 */
// }
/*

	public inline function test_caps_valid() {
		Assert.isTrue(validateCaps());
		var maxCap = -1;
		Assert.isTrue(validateCaps(maxCap)); // maxCap lt zero
		maxCap = 0;
		Assert.isTrue(validateCaps(maxCap)); // maxCap zero
		maxCap = 1;
		Assert.isTrue(validateCaps(maxCap)); // maxCap gt zero lt default
		maxCap = defaultCap - 1;
		Assert.isTrue(validateCaps(maxCap)); // maxCap gt zero lt default
		maxCap++;
		Assert.isTrue(validateCaps(maxCap)); // maxCap is default
		maxCap++;
		Assert.isTrue(validateCaps(maxCap)); // maxCap gt default
		maxCap = 999;
		Assert.isTrue(validateCaps(maxCap)); // maxCap lt maxSize
		maxCap = maxSize - 1;
		Assert.isTrue(validateCaps(maxCap)); // maxCap lt maxSize
		maxCap++;
		Assert.isTrue(validateCaps(maxCap)); // maxCap is maxSize
		maxCap++;
		Assert.isTrue(validateCaps(maxCap)); // maxCap gt maxSize
	}

	inline function validateSize(?_size:Int) {
		final sizeInit = _size;
		final sizeInitNotNull = sizeInit != null;
		var valid = false;
		var size = sizeInitNotNull ? DynamicVectorTools.size(sizeInit) : DynamicVectorTools.size();
		final sizeIsMax = size == maxSize;
		if (sizeInitNotNull) {
			if (sizeInit < 0)
				valid = size == 0;
			else {
				if (sizeInit > maxSize)
					valid = sizeIsMax;
				else
					valid = size == sizeInit;
			}
		} else
			valid = sizeIsMax;
		return valid;
	}

	inline function validateCaps(?_maxCap:Int) {
		final maxCapInit = _maxCap;
		final maxCapInitNotNull = _maxCap != null;
		var valid = false;
		var caps = maxCapInitNotNull ? DynamicVectorTools.caps(maxCapInit) : DynamicVectorTools.caps();
		final capsLen = caps.length;
		if (capsLen >= 1 && capsLen <= 15) {
			var cap = caps[0];
			if (capsLen == 1) {
				if (maxCapInit < 0)
					valid = cap == 0;
				else
					valid = cap == maxCapInit;
			} else {
				if (cap == defaultCap) {
					var amt = 1;
					for (i in 1...capsLen) {
						cap = caps[i];
						var capIsMaxSize = cap == maxSize;
						var last = i == capsLen - 1;
						if (last) { // on caps lastPos
							if (maxCapInitNotNull) {
								if (maxCapInit < maxSize)
									valid = cap == maxCapInit;
								else
									valid = capIsMaxSize;
							} else
								valid = capIsMaxSize;
						} else // on caps defaultPos
							valid = cap == caps[i - 1] * 2;
						if (valid) {
							amt++;
							if (last) {
								valid = amt == capsLen;
								break;
							} else
								continue;
						} else
							break;
					}
				}
			}
		}
		return valid;
	}
	}
	#end
 */
