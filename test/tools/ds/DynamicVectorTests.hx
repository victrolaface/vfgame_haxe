package tools.ds;

import utest.Assert;
import utest.Test;
import tools.ds.DynamicVector;

@:structInit class DynamicVectorTests extends Test {
	final maxSize = 1048576;
	final defaultCap = 64;
	var sut:DynamicVector<Int>;

	public inline function new()
		super();

	public inline function test_new_valid() {
		Assert.isTrue(validateNew()); // size is null
		var size = 0;
		Assert.isTrue(validateNew(size)); // size is zero
		size = 1;
		Assert.isTrue(validateNew(size)); // size gte zero and size lt defaultCap
		size = defaultCap - 1;
		Assert.isTrue(validateNew(size)); // size gte zero and size lt defaultCap
		size = defaultCap;
		Assert.isTrue(validateNew(size)); // size is defaultCap
		size = defaultCap + 1;
		Assert.isTrue(validateNew(size)); // size is gt defaultCap and lt maxSize
		size = maxSize - 1;
		Assert.isTrue(validateNew(size)); // size is gt defaultCap and lt maxSize
		size = maxSize;
		Assert.isTrue(validateNew(size)); // size is maxSize
		size = maxSize + 1;
		Assert.isTrue(validateNew(size)); // size is gt maxSize
	}

	/*
		public inline function test_alloc_valid(){}
		public inline function test_init_valid(){}
	 */
	inline function validateNew<T>(?_size:Int) {
		final sizeNotNull = _size != null;
		var sut:DynamicVector<T>;
		var valid = false;
		if (sizeNotNull)
			sut = new DynamicVector<T>(_size);
		else
			sut = new DynamicVector<T>();
		final lenIsDefaultCap = sut.length == defaultCap;
		if (sizeNotNull) {
			if (_size >= 0) {
				if (_size < defaultCap)
					valid = sut.length == _size;
				else
					valid = lenIsDefaultCap;
			} else
				valid = sut.length == 0;
		} else
			valid = lenIsDefaultCap;
		if (valid)
			valid = sut.state == "Alloc";
		return valid;
	}
	/*
		inline function validateAlloc<T>() {}
		inline function validateInit<T>() {}
	 */
}
/*
	public inline function test_alloc_valid() {
	sut = new DynamicVector<Int>();
	sut.alloc(12);
	Assert.isTrue(sut.length == defaultCap);
	sut = new DynamicVector<Int>(defaultCap - 1);
	sut.alloc(1);
	Assert.isTrue(sut.length == defaultCap - 1);
	sut = new DynamicVector<Int>(defaultCap);
	sut.alloc(10);
	Assert.isTrue(sut.length == defaultCap);
	sut = new DynamicVector<Int>(defaultCap * 2 + 10);
	sut.alloc(2);
	Assert.isTrue(sut.length == defaultCap);
	sut.alloc(defaultCap + 1);
	Assert.isTrue(sut.length == defaultCap * 2);
	sut.alloc(defaultCap * 2 + 2);
	Assert.isTrue(sut.length == defaultCap * 2 + 10);
	Assert.raises(() -> {
		sut = new DynamicVector<Int>(0);
		sut.alloc(1); // alloc gt size
	});
	Assert.raises(() -> {
		sut = new DynamicVector<Int>(maxSize);
		sut.alloc(-1); // alloc lt zero
});*/
//	}
// 2 - public inline function test_init_valid() {}
