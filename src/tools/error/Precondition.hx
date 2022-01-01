package tools.error;

import haxe.Exception;

@:structInit class Precondition {
	public static function requires(_condition:Bool)
		try {
			if (!_condition)
				throw new Exception('requires condition to be true.');
		} catch (e)
			throw e;
}
