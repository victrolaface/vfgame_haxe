package tools.ds;

import utest.Assert;
import utest.Test;
import haxe.ds.Vector;
import tools.ds.DynamicVector;
import tools.ds.DynamicVectorTools;

@:structInit class DynamicVectorTests extends Test {
	final maxSize = 1048576;
	final defaultCap = 64;
	var sut:DynamicVector<Int>;

	public inline function new()
		super();

	public inline function test_new_valid() {
		sut = new DynamicVector();
		Assert.isTrue(sut.length == defaultCap);
		sut = new DynamicVector(0);
		Assert.isTrue(sut.length == 0);
		sut = new DynamicVector(1);
		Assert.isTrue(sut.length == 1);
		sut = new DynamicVector(defaultCap - 1);
		Assert.isTrue(sut.length == defaultCap - 1);
		sut = new DynamicVector(defaultCap);
		Assert.isTrue(sut.length == defaultCap);
		sut = new DynamicVector(defaultCap + 1);
		Assert.isTrue(sut.length == defaultCap);
		sut = new DynamicVector(maxSize - 1);
		Assert.isTrue(sut.length == defaultCap);
		sut = new DynamicVector(maxSize);
		Assert.isTrue(sut.length == defaultCap);
		Assert.raises(() -> {
			sut = new DynamicVector<Int>(-1);
		});
		Assert.raises(() -> {
			sut = new DynamicVector<Int>(maxSize + 1);
		});
	}
	/*public inline function test_alloc_valid(){

	}*/
}
