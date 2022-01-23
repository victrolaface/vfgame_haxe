package tools.math;

import haxe.ds.Vector;

using haxe.Int64;

@:structInit class Factorial {
	static var factors(get, never):Vector<Int64>;

	public static inline function factor(_val:Int)
		return _val <= 20 ? factors[_val] : null;

	static inline function get_factors() {
		var f:Int64;
		var fs = new Vector<Int64>(20);
		f = 1;
		fs[0] = f;
		for (i in 1...21) {
			f *= i;
			fs[i] = f;
		}
		return fs;
	}
}
