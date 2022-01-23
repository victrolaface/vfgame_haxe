package tools.ds;

import utest.Assert;
import utest.Test;
import tools.ds.DynamicVector;
import haxe.Json;

@:structInit class DynamicVectorTests extends Test {
	static final maxSize = 1048576;
	static final defaultCap = 64;
	static final isNull = null;
	static final ltZero = -1;
	static final isZero = 0;
	static final gtZero = 1;
	static final ltDefaultCap = defaultCap - 1;
	static final isDefaultCap = defaultCap;
	static final gtDefaultCap = defaultCap + 1;
	static final ltMaxSize = maxSize - 1;
	static final isMaxSize = maxSize;
	static final gtMaxSize = maxSize + 1;

	static var sut:DynamicVector<Int>;
	static var conditionalVals:Array<Null<Int>> = [
		isNull, ltZero, isZero, gtZero, ltDefaultCap, isDefaultCap, gtDefaultCap, ltMaxSize, isMaxSize, gtMaxSize
	];
	static var conditionalSrcItems:Array<Array<Null<Int>>> = [
		genSrcItems(isNull), genSrcItems(ltZero), genSrcItems(isZero), genSrcItems(gtZero), genSrcItems(ltDefaultCap), genSrcItems(isDefaultCap),
		genSrcItems(gtDefaultCap), genSrcItems(ltMaxSize), genSrcItems(isMaxSize), genSrcItems(gtMaxSize)];
	static var valid:Bool = false;

	// static var size:Null<Int> = null;
	// static var n:Null<Int> = null;

	public inline function new()
		super();

	public inline function test_new_valid() {
		valid = false;

		Assert.isTrue(validateNew()); // size is null or empty
		// var size:Null<Int> = null;
		/*Assert.isTrue(validateNew(size)); // size is null;
			size = -1;
			Assert.isTrue(validateNew(size)); // size is lt zero
			size = 0;
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
			Assert.isTrue(validateNew(size)); // size is gt maxSize */
	}

	public inline function test_alloc_valid<T>() {
		/*
			Assert.isTrue(validateAlloc()); // size and n is null or empty
			// var srcItems:Array<Int> = null;
			// var size:Null<Int> = null;
			// var n:Null<Int> = null;

			Assert.isTrue(validateAlloc(srcItems, size, n)); // srcItems is null, size is (null defaults to) maxSize, n is null
			n = -1;
			Assert.isTrue(validateAlloc(srcItems, size, n)); // srcItems is null, size is maxSize, n is lt zero
			n = 0;
			Assert.isTrue(validateAlloc(srcItems, size, n)); // srcItems is null, size is maxSize, n is zero
			n = 1;
			Assert.isTrue(validateAlloc(srcItems, size, n)); // srcItems is null, size is maxSize, n gte zero lt defaultCap
			n = defaultCap;
			Assert.isTrue(validateAlloc(srcItems, size, n)); // srcItems is null, size is maxSize, n is defaultCap
			n = defaultCap + 1;
			Assert.isTrue(validateAlloc(srcItems, size, n)); // srcItems is null, size is maxSize, n is gt defaultCap
			n = maxSize - 1;
			Assert.isTrue(validateAlloc(srcItems, size, n)); // srcItems is null, size is maxSize, n is lt maxSize
			n = maxSize;
			Assert.isTrue(validateAlloc(srcItems, size, n)); // srcItems is null, size and n is maxSize
			n = maxSize + 1;
			Assert.isTrue(validateAlloc(srcItems, size, n)); // srcItems is null, size is maxSize, n is gt maxSize
			size = -1;
			n = null;
			Assert.isTrue(validateAlloc(srcItems, size, n)); // srcItems is null, size is lt zero, n is null
			n = -1;
			Assert.isTrue(validateAlloc(srcItems, size, n)); // srcItems is null, size is lt zero, n is lt zero
			n = 0;
			Assert.isTrue(validateAlloc(srcItems, size, n)); // srcItems is null, size is lt zero, n is zero
			n = 1;
			Assert.isTrue(validateAlloc(srcItems, size, n)); // srcItems is null, size is lt zero, n is gt zero
			n = defaultCap - 1;
			Assert.isTrue(validateAlloc(srcItems, size, n)); // srcItems is null, size is lt zero, n is lt defaultCap
			n = defaultCap;
			Assert.isTrue(validateAlloc(srcItems, size, n)); // srcItems is null, size is lt zero, n is defaultCap
			n = defaultCap + 1;
			Assert.isTrue(validateAlloc(srcItems, size, n)); // srcItems is null, size is lt zero, n is gt defaultCap
			n = maxSize - 1;
			Assert.isTrue(validateAlloc(srcItems, size, n)); // srcItems is null, size is lt zero, n is lt maxSize
			n = maxSize;
			Assert.isTrue(validateAlloc(srcItems, size, n)); // srcItems is null, size is lt zero, n is maxSize
			n = maxSize + 1;
			Assert.isTrue(validateAlloc(srcItems, size, n)); // srcItems is null, size is lt zero, n is gt maxSize
			size = 0;
			n = null;
			Assert.isTrue(validateAlloc(srcItems, size, n)); // srcItems is null, size is zero, n is null
			n = -1;
			Assert.isTrue(validateAlloc(srcItems, size, n)); // srcItems is null, size is zero,, n is lt zero
			n = 0;
			Assert.isTrue(validateAlloc(srcItems, size, n)); // srcItems is null, size is zero, n is zero
			n = 1;
			Assert.isTrue(validateAlloc(srcItems, size, n)); // srcItems is null, size is zero, n is gt zero
			n = defaultCap - 1;
			Assert.isTrue(validateAlloc(srcItems, size, n)); // srcItems is null, size is zero, n is lt defaultCap
			n = defaultCap;
			Assert.isTrue(validateAlloc(srcItems, size, n)); // srcItems is null, size is zero, n is defaultCap
			n = defaultCap + 1;
			Assert.isTrue(validateAlloc(srcItems, size, n)); // srcItems is null, size is zero, n is gt defaultCap
			n = maxSize - 1;
			Assert.isTrue(validateAlloc(srcItems, size, n)); // srcItems is null, size is zero, n is lt maxSize
			n = maxSize;
			Assert.isTrue(validateAlloc(srcItems, size, n)); // srcItems is null, size is zero, n is maxSize
			n = maxSize + 1;
			Assert.isTrue(validateAlloc(srcItems, size, n)); // srcItems is null, size is zero, n is gt maxSize

			//
			size = 1;
			n = null;
			Assert.isTrue(validateAlloc(srcItems, size, n)); // srcItems is null, size is zero, n is null
			n = -1;
			Assert.isTrue(validateAlloc(srcItems, size, n)); // srcItems is null, size is gt zero, n is lt zero
			n = 0;
			Assert.isTrue(validateAlloc(srcItems, size, n)); // srcItems is null, size is gt zero, n is zero
			n = 1;
			Assert.isTrue(validateAlloc(srcItems, size, n)); // srcItems is null, size is gt zero, n is gt zero
			n = defaultCap - 1;
			Assert.isTrue(validateAlloc(srcItems, size, n)); // srcItems is null, size is gt zero, n is lt defaultCap
			n = defaultCap;
			Assert.isTrue(validateAlloc(srcItems, size, n)); // srcItems is null, size is gt zero, n is defaultCap
			n = defaultCap + 1;
			Assert.isTrue(validateAlloc(srcItems, size, n)); // srcItems is null, size is gt zero, n is gt defaultCap
			n = maxSize - 1;
			Assert.isTrue(validateAlloc(srcItems, size, n)); // srcItems is null, size is gt zero, n is lt maxSize
			n = maxSize;
			Assert.isTrue(validateAlloc(srcItems, size, n)); // srcItems is null, size is gt zero, n is maxSize
			n = maxSize + 1;
			Assert.isTrue(validateAlloc(srcItems, size, n)); // srcItems is null, size is gt zero, n is gt maxSize

			//
			size = defaultCap - 1;
			n = null;
			Assert.isTrue(validateAlloc(srcItems, size, n)); // srcItems is null, size is lt defaultCap, n is null
			n = -1;
			Assert.isTrue(validateAlloc(srcItems, size, n)); // srcItems is null, size is lt defaultCap, n is lt zero
			n = 0;
			Assert.isTrue(validateAlloc(srcItems, size, n)); // srcItems is null, size is lt defaultCap, n is zero
			n = 1;
			Assert.isTrue(validateAlloc(srcItems, size, n)); // srcItems is null, size is lt defaultCap, n is gt zero
			n = defaultCap - 1;
			Assert.isTrue(validateAlloc(srcItems, size, n)); // srcItems is null, size is lt defaultCap, n is lt defaultCap
			n = defaultCap;
			Assert.isTrue(validateAlloc(srcItems, size, n)); // srcItems is null, size is lt defaultCap, n is defaultCap
			n = defaultCap + 1;
			Assert.isTrue(validateAlloc(srcItems, size, n)); // srcItems is null, size is lt defaultCap, n is gt defaultCap
			n = maxSize - 1;
			Assert.isTrue(validateAlloc(srcItems, size, n)); // srcItems is null, size is lt defaultCap, n is lt maxSize
			n = maxSize;
			Assert.isTrue(validateAlloc(srcItems, size, n)); // srcItems is null, size is lt defaultCap, n is maxSize
			n = maxSize + 1;
			Assert.isTrue(validateAlloc(srcItems, size, n)); // srcItems is null, size is lt defaultCap, n is gt maxSize

			//
			size = defaultCap;
			n = null;
			Assert.isTrue(validateAlloc(srcItems, size, n)); // srcItems is null, size is defaultCap, n is null
			n = -1;
			Assert.isTrue(validateAlloc(srcItems, size, n)); // srcItems is null, size is defaultCap, n is lt zero
			n = 0;
			Assert.isTrue(validateAlloc(srcItems, size, n)); // srcItems is null, size is defaultCap, n is zero
			n = 1;
			Assert.isTrue(validateAlloc(srcItems, size, n)); // srcItems is null, size is defaultCap, n is gt zero
			n = defaultCap - 1;
			Assert.isTrue(validateAlloc(srcItems, size, n)); // srcItems is null, size is defaultCap, n is lt defaultCap
			n = defaultCap;
			Assert.isTrue(validateAlloc(srcItems, size, n)); // srcItems is null, size is defaultCap, n is defaultCap
			n = defaultCap + 1;
			Assert.isTrue(validateAlloc(srcItems, size, n)); // srcItems is null, size is defaultCap, n is gt defaultCap
			n = maxSize - 1;
			Assert.isTrue(validateAlloc(srcItems, size, n)); // srcItems is null, size is defaultCap, n is lt maxSize
			n = maxSize;
			Assert.isTrue(validateAlloc(srcItems, size, n)); // srcItems is null, size is defaultCap, n is maxSize
			n = maxSize + 1;
			Assert.isTrue(validateAlloc(srcItems, size, n)); // srcItems is null, size is defaultCap, n is gt maxSize

			//
			size = defaultCap + 1;
			n = null;
			Assert.isTrue(validateAlloc(srcItems, size, n)); // srcItems is null, size is gt defaultCap, n is null
			n = -1;
			Assert.isTrue(validateAlloc(srcItems, size, n)); // srcItems is null, size is gt defaultCap, n is lt zero
			n = 0;
			Assert.isTrue(validateAlloc(srcItems, size, n)); // srcItems is null, size is gt defaultCap, n is zero
			n = 1;
			Assert.isTrue(validateAlloc(srcItems, size, n)); // srcItems is null, size is gt defaultCap, n is gt zero
			n = defaultCap - 1;
			Assert.isTrue(validateAlloc(srcItems, size, n)); // srcItems is null, size is gt defaultCap, n is lt defaultCap
			n = defaultCap;
			Assert.isTrue(validateAlloc(srcItems, size, n)); // srcItems is null, size is gt defaultCap, n is gt defaultCap
			n = defaultCap + 1;
			Assert.isTrue(validateAlloc(srcItems, size, n)); // srcItems is null, size is gt defaultCap, n is defaultCap
			n = maxSize - 1;
			Assert.isTrue(validateAlloc(srcItems, size, n)); // srcItems is null, size is gt defaultCap, n is lt maxSize
			n = maxSize;
			Assert.isTrue(validateAlloc(srcItems, size, n)); // srcItems is null, size is gt defaultCap, n is maxSize
			n = maxSize + 1;
			Assert.isTrue(validateAlloc(srcItems, size, n)); // srcItems is null, size is gt defaultCap, n is gt maxSize

			//
			size = maxSize - 1; // size is lt maxSize,
			n = null;
			Assert.isTrue(validateAlloc(srcItems, size, n)); // srcItems is null, size is lt maxSize, n is null
			n = -1;
			Assert.isTrue(validateAlloc(srcItems, size, n)); // srcItems is null, size is lt maxSize, n is lt zero
			n = 0;
			Assert.isTrue(validateAlloc(srcItems, size, n)); // srcItems is null, size is lt maxSize, n is zero
			n = 1;
			Assert.isTrue(validateAlloc(srcItems, size, n)); // srcItems is null, size is lt maxSize, n is gt zero
			n = defaultCap - 1;
			Assert.isTrue(validateAlloc(srcItems, size, n)); // srcItems is null, size is lt maxSize, n is lt defaultCap
			n = defaultCap;
			Assert.isTrue(validateAlloc(srcItems, size, n)); // srcItems is null, size is lt maxSize, n is defaultCap
			n = defaultCap + 1;
			Assert.isTrue(validateAlloc(srcItems, size, n)); // srcItems is null, size is lt maxSize, n is gt defaultCap
			n = maxSize - 1;
			Assert.isTrue(validateAlloc(srcItems, size, n)); // srcItems is null, size is lt maxSize, n is lt maxSize
			n = maxSize;
			Assert.isTrue(validateAlloc(srcItems, size, n)); // srcItems is null, size is lt maxSize, n is maxSize
			n = maxSize + 1;
			Assert.isTrue(validateAlloc(srcItems, size, n)); // srcItems is null, size is lt maxSize, n is gt maxSize

			//
			size = maxSize;
			n = null;
			Assert.isTrue(validateAlloc(srcItems, size, n)); // srcItems is null, size is maxSize, n is null
			n = -1;
			Assert.isTrue(validateAlloc(srcItems, size, n)); // srcItems is null, size is maxSize, n is lt zero
			n = 0;
			Assert.isTrue(validateAlloc(srcItems, size, n)); // srcItems is null, size is maxSize, n is zero
			n = 1;
			Assert.isTrue(validateAlloc(srcItems, size, n)); // srcItems is null, size is maxSize, n is gt zero
			n = defaultCap - 1;
			Assert.isTrue(validateAlloc(srcItems, size, n)); // srcItems is null, size is maxSize, n is lt defaultCap
			n = defaultCap;
			Assert.isTrue(validateAlloc(srcItems, size, n)); // srcItems is null, size is maxSize, n is defaultCap
			n = defaultCap + 1;
			Assert.isTrue(validateAlloc(srcItems, size, n)); // srcItems is null, size is maxSize, n is gt defaultCap
			n = maxSize - 1;
			Assert.isTrue(validateAlloc(srcItems, size, n)); // srcItems is null, size is maxSize, n is lt maxSize
			n = maxSize;
			Assert.isTrue(validateAlloc(srcItems, size, n)); // srcItems is null, size is maxSize, n is maxSize
			n = maxSize + 1;
			Assert.isTrue(validateAlloc(srcItems, size, n)); // srcItems is null, size is maxSize, n is gt maxSize

			//
			size = maxSize + 1;
			n = null;
			Assert.isTrue(validateAlloc(srcItems, size, n)); // srcItems is null, size is gt maxSize, n is null
			n = -1;
			Assert.isTrue(validateAlloc(srcItems, size, n)); // srcItems is null, size is gt maxSize, n is lt zero
			n = 0;
			Assert.isTrue(validateAlloc(srcItems, size, n)); // srcItems is null, size is gt maxSize, n is zero
			n = 1;
			Assert.isTrue(validateAlloc(srcItems, size, n)); // srcItems is null, size is gt maxSize, n is gt zero
			n = defaultCap - 1;
			Assert.isTrue(validateAlloc(srcItems, size, n)); // srcItems is null, size is gt maxSize, n is lt defaultCap
			n = defaultCap;
			Assert.isTrue(validateAlloc(srcItems, size, n)); // srcItems is null, size is gt maxSize, n is defaultCap
			n = defaultCap + 1;
			Assert.isTrue(validateAlloc(srcItems, size, n)); // srcItems is null, size is gt maxSize, n is gt defaultCap
			n = maxSize - 1;
			Assert.isTrue(validateAlloc(srcItems, size, n)); // srcItems is null, size is gt maxSize, n is lt maxSize
			n = maxSize;
			Assert.isTrue(validateAlloc(srcItems, size, n)); // srcItems is null, size is gt maxSize, n is maxSize
			n = maxSize + 1;
			Assert.isTrue(validateAlloc(srcItems, size, n)); // srcItems is null, size is gt maxSize, n is gt maxSize
		 */
	}

	static inline function genSrcItems(?_n:Int) {
		var s = new Array<Int>();
		if (_n != null && _n > 0) {
			for (i in 0..._n)
				s[i] = i;
		}
		return s;
	}

	// public inline function test_alloc_valid() {
	// Assert.isTrue(validateAlloc());
	// }

	/*
		public inline function test_init_valid(){}
	 */
	inline function validateNew(?_size:Int) {
		final sizeNotNull = _size != null;
		sut = sizeNotNull ? new DynamicVector<Int>(_size) : new DynamicVector<Int>();
		var valid = false;
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
		return valid;
	}

	inline function initConditional() {
		var vals = new Array<Null<Int>>();
		for (i in 0...conditionalVals.length)
			vals[i] = conditionalVals[i];
		return vals;
	}

	inline function initConditionalSrcItems() {
		var srcItems = new Array<Array<Null<Int>>>();
		for (i in 0...conditionalSrcItems.length)
			srcItems[i] = conditionalSrcItems[i];
		return srcItems;
	}

	inline function validateAlloc(?_srcItems:Array<Int>, ?_size:Int, ?_n:Int) {
		var valid = false;
		var sizesConditional = initConditional();
		var nConditional = initConditional();
		var srcItemsConditional = initConditionalSrcItems();

		var n:Null<Int>;
		var size:Null<Int>;

		for (i in 0...nConditional.length) {
			var n = nConditional[i];
			for (j in 0...sizesConditional.length) {
				var size = sizesConditional[j];		
			}
		}



		for (i in 0...sizesConditional.length) {}

		// :Array<Null<Int>>;
		/*var valid = false;
			var validNoSrc = false;
			sut = _size != null ? new DynamicVector<Int>(_size) : new DynamicVector<Int>();
			final sutInitLen = sut.length;
			final canAlloc = sut.canAlloc(_n);
			sut.alloc(_n);
			final lenIsInit = sut.length == sutInitLen;
			if (canAlloc) {
				if (_n <= sutInitLen)
					validNoSrc = lenIsInit;
				else if (_n > sutInitLen)
					validNoSrc = sut.length > sutInitLen;
			} else
				validNoSrc = lenIsInit;
			if (_srcItems == null)
				valid = validNoSrc;
			else {}
			return valid; */
	}
	/*
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
