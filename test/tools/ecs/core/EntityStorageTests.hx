package tools.ecs.core;

import utest.Assert;
import tools.ecs.core.EntityStorage;
import utest.ITest;

class EntityStorageTests implements ITest {
	var sut:EntityStorage;

	public function new()
		sut = new EntityStorage();

	inline function test_initialized_default_is_valid() {
		sut = new EntityStorage();
		Assert.isTrue(sut.isInitialized);
	}
}
