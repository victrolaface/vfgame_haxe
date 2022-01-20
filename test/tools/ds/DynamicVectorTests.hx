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
	}

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
		});
	}

	// 2 - public inline function test_init_valid() {}
}
