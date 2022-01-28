/*package tools.ds;

	import utest.Assert;
	import utest.Test;
	import tools.ds.CartesianProductIterator;
	import tools.ds.DynamicVector;
	import haxe.ds.Vector;
	import haxe.Json;

	@:structInit class DynamicVectorTests extends Test {
	static final MAX_SIZE = 1048576;
	static final DEFAULT_CAP = 64;
	static final LT_ZERO=-1;
	static final IS_ZERO=0;
	static var sut:DynamicVector<Int>;
	static var valid:Bool = false;
	static var nVals(get, never):Vector<Int>;
	static var sizes(get, never):Vector<Int>;
	static var srcItems(get, never):Vector<Vector<Int>>;

	public inline function new()
		super();

	static inline function get_nVals() {
		var n = new Vector<Int>(9);
		n[0] = LT_ZERO;
		n[1] = IS_ZERO;
		n[2] = 1;
		n[3] = DEFAULT_CAP -1;
		n[4] = DEFAULT_CAP;
		n[5] = DEFAULT_CAP + 1;
		n[6] = MAX_SIZE-1;
		n[7] = MAX_SIZE;
		n[8] = MAX_SIZE +1;
		return n;
	}

	static inline function get_sizes()
		return nVals;

	static inline function get_srcItems() {
		final SIZES_LEN=sizes.length;
		var items = new Vector<Vector<Int>>(SIZES_LEN-1);//sizesLen);//-1);// - 1);
		var idx = 0;
		for (j in 0...SIZES_LEN) {
			var size = sizes[j];
			var i:Vector<Int>;
			if (size == LT_ZERO)//ltZero)
				continue;
			else if (size == IS_ZERO)//isZero)
				i = new Vector<Int>(IS_ZERO);
			else if (size == isNull) {
				i = new Vector<Null<Int>>(1);
				i[0] = null;
			} else {
				i = new Vector<Null<Int>>(size);
				var amt = 1;
				for (k in 0...size) {
					i[k] = amt;
					amt++;
				}
			}
			items[idx] = i;
			idx++;
		}
		return items;
	}

	public static inline function test_new_valid()
		Assert.isTrue(validateNew());

	public static inline function test_alloc_valid()
		Assert.isTrue(validateAlloc());

	static inline function validateNew() {
		valid = false;
		for (i in 0...sizes.length) {
			var size = sizes[i];
			sut = new DynamicVector(size);
			if (size == ltZero || size == isZero || size == isNull)
				valid = sut.length == 0;
			else if (size == ltDefaultCap)
				valid = sut.length == size;
			else
				valid = sut.length == defaultCap;
			if (valid)
				continue;
			else
				break;
		}
		return valid;
	}

	static inline function validateAlloc(){
		valid=false;
		var params =[
			sizes,
			nVals
		];
		for(v in new CartesianProductIterator(params)){
			
		}
		return valid;
	}
	/*class Test {
		static function main() {
			var sets = [
				["robert", "michael", "george"],
				["sucks", "kisses", "loves", "dies"],
				["once", "twice", "forever"],
				["and", "or", "but"],
				["fuck it", "it's okay", "life goes on"],
				["?", "!", ".", "‽"]
			];

			for (v in new CartesianProductIterator(sets)) {
				trace(v);
			}
		}
}*/
// }
// static var srcItems(get, never):Vector<Vector<Int>>>;
// static var vals(get,never):Vector<Null<Int>>;
// static var sizesArr:Array<Null<Int>> = [
//	isNull, ltZero, isZero, gtZero, ltDefaultCap, isDefaultCap, gtDefaultCap, ltMaxSize, isMaxSize, gtMaxSize
// ];
// static var size:Null<Int> = null;
// static var n:Null<Int> = null;
/*public inline function test_new_valid()
	Assert.isTrue(validateNew()); */
// static inline function get_srcItems() {
//	var s = new Vector<Vector<Int>>(sizes.length - 1);
//	return s;
// }
/*inline function validateNew() {
	valid = false;
	for (i in 0...sizes.length) {
		var size = sizes[i];
		var sut = size != null ? new DynamicVector<Int>(size) : new DynamicVector<Int>();
		var sutLen = sut.length;
		var lenIsDefaultCap = sutLen == defaultCap;
		if (size != null) {
			if (size >= 0) {
				if (size < defaultCap)
					valid = sutLen == size;
				else
					valid = lenIsDefaultCap;
			} else
				valid = sutLen == 0;
		} else
			valid = lenIsDefaultCap;
		if (valid)
			continue;
		else
			break;
	}
	return valid;
}*/
// return sizes;
/*static inline function get_sizes() {
	var s = new Vector<Null<Int>>(10)//sizesArr.length);
	for (i in 0...s.length)
		s[i] = sizesArr[i];
	return s;
}*/
/*static inline function get_srcItems() {

}*/
// return items;
//
// static inline function
// static inline function genSrcItems(?_n:Int) {
// var s = new Vector<Int>(sizes.length);
// if (_n != null && _n > 0) {
//	for (i in 0..._n)
//		s[i] = i;
// }
// return s;
// }
// public inline function test_alloc_valid<T>() {
// Assert.isTrue(validateAlloc());
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
// }
// inline function validateAlloc() {
/*
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
 */
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
// }
/*
	inline function validateInit<T>() {}
 */
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
