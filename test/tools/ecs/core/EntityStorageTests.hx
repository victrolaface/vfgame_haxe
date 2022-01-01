package tools.ecs.core;

import utest.Assert;
import tools.ecs.core.EntityStorage;
import utest.ITest;

class EntityStorageTests implements ITest {
	var sut:EntityStorage;

	public function new()
		sut = new EntityStorage();

	function test_default_init_is_valid() {
		sut = new EntityStorage();
		Assert.isTrue(sut.isInitialized, sut.output);
	}
}
