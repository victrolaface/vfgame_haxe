#if debug
package tools.debug;

import haxe.Exception;

using StringTools;

@:structInit class Precondition {
	static final CONDITION = "#condition";
	static final MESSAGE = '$CONDITION is false';

	public static function requires(_isCondition:Bool, ?_condition:String) {
		try {
			if (_isCondition) {
				return true;
			} else {
				throw new Exception(error(_condition == null, _condition));
				return false;
			}
		} catch (e) {
			throw new Exception(e.message);
		}
	}

	static inline function error(_isNull:Bool, ?_condition:String)
		return _isNull ? MESSAGE.replace(CONDITION, 'Condition') : MESSAGE.replace(CONDITION, _condition);
}
#end
