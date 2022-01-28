#if debug
package tools.ecs.core;

import utest.Assert;
import utest.Test;
import tools.ecs.core.EntityManager;

class EntityManagerTests extends Test {
	static var mgr:EntityManager;

	public inline function new()
		super();

	public inline function testNewIsValid() {
		Assert.equals(4, newMgrLen(-1));
		Assert.equals(4, newMgrLen(0));
		Assert.equals(4, newMgrLen(1));
		Assert.equals(4, newMgrLen(3));
		Assert.equals(4, newMgrLen(4));
		Assert.equals(5, newMgrLen(5));
		Assert.equals(4095, newMgrLen(4095));
		Assert.equals(4096, newMgrLen(4096));
		Assert.equals(4096, newMgrLen(4097));
	}

	static inline function newMgrLen(_size:Int) {
		mgr = new EntityManager(_size);
		return mgr.length;
	}
}
#end
// Assert.isTrue(validateNew());
// public inline function test_update_is_valid()
//	Assert.isTrue(validateUpdate());
// public inline function test_create_is_valid()
//	Assert.isTrue(validateCreate());
/*static inline function validateNew() {
	valid = false;
	for (i in 0...sizesLen) {
		var size = SIZES[i];
		sut = new EntityManager(size);
		if (size == LT_ZERO || size == ZERO || size == GT_ZERO || size == LT_MIN)
			valid = sut.length == MIN;
		else if (size == MIN || size == GT_MIN || size == LT_MAX || size == MAX)
			valid = sut.length == size;
		else if (size == GT_MAX)
			valid = sut.length == MAX;
		if (valid)
			continue;
		else
			break;
	}
	return valid;
}*/
/*static inline function validOnCreateRaises(_sut:EntityManager) {
		var v = Assert.raises(() -> {
			_sut.create();
		});
		return v;
	}

	static inline function validOnUpdateRaises(_sut:EntityManager) {
		var v = Assert.raises(() -> {
			_sut.update();
		});
		return v;
	}

	static inline function validateUpdate() {
		valid = false;
		for (i in 0...sizesLen) {
			var size = SIZES[i];
			sut = new EntityManager(size);
			if (sut.canUpdate) {
				sut.update();
				valid = sut.canUpdate;
			} else
				valid = validOnUpdateRaises(sut);
			if (valid)
				continue;
			else
				break;
		}
		if (valid) {
			for (i in 0...sizesLen) {
				var size = SIZES[i];
				var doUpdate = true;
				var getNextCreateAmt = true;
				var hasNextCreateAmt = true;
				var amt = 0;
				var currAmt = 0;
				var createIdx = -1;
				sut = new EntityManager(size);
				while (doUpdate) {
					if (sut.canUpdate) {
						sut.update();
						valid = sut.canUpdate;
					} else
						valid = validOnUpdateRaises(sut);
					if (getNextCreateAmt) {
						createIdx++;
						amt = CREATE[createIdx];
						currAmt = amt;
					}
					hasNextCreateAmt = createIdx + 1 < createLen - 1;
					if (sut.canCreate) {
						sut.create();
						currAmt--;
						valid = sut.canCreate;
					} else
						valid = validOnCreateRaises(sut);
					var currAmtLteZero = currAmt <= 0;
					getNextCreateAmt = currAmtLteZero && hasNextCreateAmt;
					if ((currAmtLteZero && !hasNextCreateAmt) || !valid)
						doUpdate = false;
				}
				if (valid)
					continue;
				else
					break;
			}
		}
		return valid;

		// conditions
		//  X can update after init of (sizes)
		//	X can update after (create), after init of (sizes)
		// 	can update after (destroy), after init of (sizes)
		// 	can update after (create), after (destroy), after init of (sizes)
		// 	can update after (destroy), after (create), after init of (sizes)
		//	create[1,3,4,5,4095,4096,4097xcycles]
		//	destroy[[id :
		//		idx: 1,3,4,5,4095,4096,4097
		//		ver: 1,2,3 ]x1,3,4,5,4095,4096,4097xcycles]
	}

	static inline function validateCreate() {
		valid = true;
		for (i in 0...SIZES.length) {
			var size = SIZES[i];
			sut = new EntityManager(size);
		}
		return valid;
}*/
