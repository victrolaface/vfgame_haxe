import tools.ecs.core.EntityStorageTests;
import utest.UTest;

class TestAll {
	static function main()
		UTest.run([new EntityStorageTests()]);
}
