// import tools.ecs.core.EntityManagerTests;
// import tools.ds.DynamicVectorTests;
// import tools.ds.DynamicVectorTests.DynamicVectorToolsTests;
import tools.ds.VectorToolsTests;
import tools.ds.DynamicVectorToolsTests;
import tools.ds.DynamicVectorTests;
import utest.UTest;

class Tests {
	static function main()
		UTest.run([new DynamicVectorTests(), new DynamicVectorToolsTests(), new VectorToolsTests()]);
}
