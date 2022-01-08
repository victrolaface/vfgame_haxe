#if debug
package tools.ecs.core;

import utest.Assert;
import utest.Test;
import tools.ecs.core.EntityManager;

@:structInit class EntityManagerTests extends Test {
	var sut:EntityManager;
	var stateIsInit(get, never):Bool;
	var canUpdateFromInit(get, never):Bool;

	public inline function new()
		super();

	inline function test_init_is_valid() {
		sut = new EntityManager(1); // lt min size
		if (sut.canUpdateFromInit)
			Assert.isTrue(stateIsInit);
		sut = new EntityManager(); // default size
		if (canUpdateFromInit)
			Assert.isTrue(stateIsInit);
		sut = new EntityManager(33); // lt default size
		if (canUpdateFromInit)
			Assert.isTrue(stateIsInit);
		sut = new EntityManager(65); // gt default size
		if (canUpdateFromInit)
			Assert.isTrue(stateIsInit);
		sut = new EntityManager(9999); // gt max size
		if (canUpdateFromInit)
			Assert.isTrue(stateIsInit);
	}

	inline function get_canUpdateFromInit()
		return sut.canUpdateFromInit;

	inline function get_stateIsInit()
		return sut.currentState == "Init";
}
#end
