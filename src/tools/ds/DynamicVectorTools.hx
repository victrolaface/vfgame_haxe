package tools.ds;

import haxe.ds.Vector;
import tools.debug.Precondition;

using tools.ds.VectorTools;

@:structInit class DynamicVectorTools {
	static final DEFAULT_CAP = 64;
	static final MAX_SIZE = 1048576;

	public static inline function size(?_size:Int) {
		if (_size != null) {
			if (_size < 0)
				_size = 0;
			else {
				if (_size > MAX_SIZE)
					_size = MAX_SIZE;
			}
		} else
			_size = MAX_SIZE;
		return _size;
	}

	public static inline function caps(?_maxCap:Int) {
		if (_maxCap != null) {
			if (_maxCap < 0) {
				_maxCap = 0;
			} else {
				if (_maxCap > MAX_SIZE)
					_maxCap = MAX_SIZE;
			}
		} else
			_maxCap = MAX_SIZE;
		var idx = 0;
		var capsArr = new Array<Int>();
		final maxCapGtDefault = _maxCap > DEFAULT_CAP;
		capsArr[idx] = maxCapGtDefault ? DEFAULT_CAP : _maxCap;
		if (maxCapGtDefault) {
			var doAdd = true;
			while (doAdd) {
				var cap = capsArr[idx] * 2;
				idx++;
				var add = cap < _maxCap;
				capsArr[idx] = add ? cap : _maxCap;
				doAdd = add;
			}
		}
		final capsLen = capsArr.length;
		var caps = new Vector<Int>(capsLen);
		for (i in 0...capsLen)
			caps[i] = capsArr[i];
		return caps;
	}
}
