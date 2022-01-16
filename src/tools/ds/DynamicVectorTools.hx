package tools.ds;

import haxe.ds.Vector;
import tools.debug.Precondition;

using tools.ds.VectorTools;

@:structInit class DynamicVectorTools {
	static final DEFAULT_CAP = 64;
	static final MAX_SIZE = 1048576;

	static var idx:Int;

	public static inline function size(?_size:Int) {
		final sizeIsNull = _size == null;
		final sizeGteZero = _size >= 0;
		final sizeGtMaxSize = _size > MAX_SIZE;
		final sizeInRange = sizeGteZero && !sizeGtMaxSize;

		#if debug
		if (_size != null)
			Precondition.requires(sizeInRange, '"_size" must be greater than or equal to zero and less than or equal to $MAX_SIZE');
		#end

		return sizeIsNull ? MAX_SIZE : (sizeGtMaxSize ? MAX_SIZE : _size);
	}

	public static inline function caps(_maxCap:Int) {
		final maxCapGteZero = _maxCap >= 0;
		final maxCapLteMaxSize = _maxCap <= MAX_SIZE;
		final maxCapGtDefault = _maxCap > DEFAULT_CAP;

		#if debug
		Precondition.requires(maxCapGteZero, '"_maxCap" must be greater than or equal to zero');
		Precondition.requires(maxCapLteMaxSize, '"_maxCap" must be less than or equal to $MAX_SIZE');
		#end

		if (maxCapGteZero) {
			_maxCap = maxCapLteMaxSize ? _maxCap : MAX_SIZE;
			var cArr = new Array<Int>();
			idx = 0;
			cArr[idx] = maxCapGtDefault ? DEFAULT_CAP : _maxCap;
			if (maxCapGtDefault) {
				var doAdd = true;
				do {
					var n = cArr[idx] * 2;
					idx++;
					var add = n < _maxCap;
					cArr[idx] = add ? n : _maxCap;
					doAdd = add;
				} while (doAdd);
			}
			final len = cArr.length;
			var c = new Vector<Int>(len);
			c.alloc(len);
			for (i in 0...len)
				c[i] = cArr[i];
			return c;
		} else
			return new Vector<Int>(0);
	}
}
