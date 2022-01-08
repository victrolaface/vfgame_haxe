package tools.ds;

import haxe.ds.Vector;
#if debug
import tools.debug.Precondition;
#end

using Std;
using tools.ds.VectorTools;

@:structInit class DynamicVector<T> {
	final DEFAULT_SIZE = 64;

	var count:Int;
	var size:Int;
	var storage:Vector<T>;
	var type:String;
	var maxCap:Int;
	var caps:Vector<Int>;
	var idx:Int;
	var len:Int;

	public inline function new(?_size:Int) {
		size = _size == null || _size <= 0 ? DEFAULT_SIZE : _size;
		maxCap = size;
		idx = 0;
		if (maxCap > DEFAULT_SIZE) {
			var capsArr = new Array<Int>();
			capsArr[idx] = DEFAULT_SIZE;
			var addCap = true;
			do {
				var nextCap = capsArr[idx] * 2;
				idx++;
				var add = nextCap < maxCap;
				capsArr[idx] = add ? nextCap : maxCap;
				addCap = add;
			} while (addCap);
			len = capsArr.length;
			caps = VectorTools.alloc(len);
			for (i in 0...len)
				caps[i] = capsArr[i];
		} else {
			caps = VectorTools.alloc(1);
			caps[idx] = maxCap;
		}
		idx = 0;
		len = caps[idx];
		storage = VectorTools.alloc(len);
		count = 0;
	}

	public inline function add(_item:T) {
		#if debug
		// Precondition.requires(isType, 'can add item of type'); // _item.isOfType())
		#end
	}

	// static inline function equals<T>(_expected:T, _result:T) {
	//	if (_expected != _result)
	// }
}
/*
	class NativeArrayTools {
	public static inline function alloc<T>(len:Int):NativeArray<T> {
		#if flash10
		#if (generic && !no_inline)
		return new flash.Vector<T>(len, true);
		#else
		var a = new Array<T>();
		untyped a.length = len;
		return a;
		#end
		#elseif neko
		return untyped __dollar__amake(len);
		#elseif js
		#if (haxe_ver >= 4.000)
		return js.Syntax.construct(Array, len);
		#else
		return untyped __new__(Array, len);
		#end
		#elseif cs
		return cs.Lib.arrayAlloc(len);
		#elseif java
		return untyped Array.alloc(len);
		#elseif cpp
		cpp.NativeArray.create(len);
		return a;
		#elseif python
		return python.Syntax.code("[{0}]*{1}", null, len);
		#elseif eval
		return new eval.Vector<T>(len);
		#else
		var a = [];
		untyped a.length = len;
		return a;
		#end
	}

	#if !(assert == "extra")
	inline
	#end
	public static function get<T>(src:NativeArray<T>, index:Int):T {
		#if (assert == "extra")
		assert(index >= 0 && index < size(src), 'index $index out of range ${size(src)}');
		#end

		return #if (cpp && generic)
			cpp.NativeArray.unsafeGet(src, index);
		#elseif python
			python.internal.ArrayImpl.unsafeGet(src, index);
		#else
			src[index];
		#end
	}

	#if !(assert == "extra")
	inline
	#end
	public static function set<T>(dst:NativeArray<T>, index:Int, val:T) {
		#if (assert == "extra")
		assert(index >= 0 && index < size(dst), 'index $index out of range ${size(dst)}');
		#end

		#if (cpp && generic)
		cpp.NativeArray.unsafeSet(dst, index, val);
		#elseif python
		python.internal.ArrayImpl.unsafeSet(dst, index, val);
		#else
		dst[index] = val;
		#end
	}

	public static inline function size<T>(a:NativeArray<T>):Int {
		return #if neko
			untyped __dollar__asize(a);
		#elseif cs
			a.length;
		#elseif java
			a.length;
		#elseif python
			a.length;
		#elseif cpp
			a.length;
		#else
			a.length;
		#end
	}

	public static function toArray<T>(src:NativeArray<T>, first:Int, len:Int, dst:Array<T>):Array<T> {
		assert(first >= 0 && first < size(src), "first index out of range");
		assert(len >= 0 && first + len <= size(src), "len out of range");

		#if (cpp || python)
		if (first == 0 && len == size(src))
			return src.copy();
		#elseif eval
		if (first == 0 && len == size(src))
			return src.toArray();
		#end

		if (len == 0)
			return [];
		var out = ArrayTools.alloc(len);
		if (first == 0) {
			for (i in 0...len)
				out[i] = get(src, i);
		} else {
			for (i in first...first + len)
				out[i - first] = get(src, i);
		}
		return out;
	}

	public static inline function ofArray<T>(src:Array<T>):NativeArray<T> {
		#if (python || cs)
		return cast src.copy();
		#elseif flash10
		return #if (generic && !no_inline) flash.Vector.ofArray(src); #else src.copy(); #end
		#elseif js
		return src.slice(0, src.length);
		#else
		var out = alloc(src.length);
		for (i in 0...src.length)
			set(out, i, src[i]);
		return out;
		#end
	}

	#if (cs || java || neko || cpp)
	inline
	#end
	public static function blit<T>(src:NativeArray<T>, srcPos:Int, dst:NativeArray<T>, dstPos:Int, n:Int) {
		if (n > 0) {
			assert(srcPos < size(src), "srcPos out of range");
			assert(dstPos < size(dst), "dstPos out of range");
			assert(srcPos + n <= size(src) && dstPos + n <= size(dst), "n out of range");

			#if neko
			untyped __dollar__ablit(dst, dstPos, src, srcPos, n);
			#elseif cpp
			cpp.NativeArray.blit(dst, dstPos, src, srcPos, n);
			#else
			if (src == dst) {
				if (srcPos < dstPos) {
					var i = srcPos + n;
					var j = dstPos + n;
					for (k in 0...n) {
						i--;
						j--;
						set(src, j, get(src, i));
					}
				} else if (srcPos > dstPos) {
					var i = srcPos;
					var j = dstPos;
					for (k in 0...n) {
						set(src, j, get(src, i));
						i++;
						j++;
					}
				}
			} else {
				if (srcPos == 0 && dstPos == 0) {
					for (i in 0...n)
						dst[i] = src[i];
				} else if (srcPos == 0) {
					for (i in 0...n)
						dst[dstPos + i] = src[i];
				} else if (dstPos == 0) {
					for (i in 0...n)
						dst[i] = src[srcPos + i];
				} else {
					for (i in 0...n)
						dst[dstPos + i] = src[srcPos + i];
				}
			}
			#end
		}
	}

	inline public static function copy<T>(src:NativeArray<T>):NativeArray<T> {
		#if (neko || cpp)
		var len = size(src);
		var out = alloc(len);
		blit(src, 0, out, 0, len);
		return out;
		#elseif flash
		return src.slice(0);
		#elseif js
		return src.slice(0);
		#elseif python
		return src.copy();
		#else
		var len = size(src);
		var dst = alloc(len);
		for (i in 0...len)
			set(dst, i, get(src, i));
		return dst;
		#end
	}

	#if (flash || java)
	inline
	#end
	public static function zero<T>(dst:NativeArray<T>, first:Int = 0, n:Int = 0):NativeArray<T> {
		var min = first;
		var max = n <= 0 ? size(dst) : min + n;

		assert(min >= 0 && min < size(dst));
		assert(max <= size(dst));

		#if cpp
		cpp.NativeArray.zero(dst, min, max - min);
		#else
		var val:Int = 0;
		while (min < max)
			set(dst, min++, cast val);
		#end

		return dst;
	};

	public static function init<T>(a:NativeArray<T>, val:T, first:Int = 0, n:Int = 0):NativeArray<T> {
		var min = first;
		var max = n <= 0 ? size(a) : min + n;

		assert(min >= 0 && min < size(a));
		assert(max <= size(a));

		while (min < max)
			set(a, min++, val);
		return a;
	}

	public static function nullify<T>(a:NativeArray<T>, first:Int = 0, n:Int = 0):NativeArray<T> {
		var min = first;
		var max = n <= 0 ? size(a) : min + n;

		assert(min >= 0 && min < size(a));
		assert(max <= size(a));

		#if cpp
		cpp.NativeArray.zero(a, min, max - min);
		#else
		while (min < max)
			set(a, min++, cast null);
		#end

		return a;
	}

	public static function binarySearchCmp<T>(a:NativeArray<T>, val:T, min:Int, max:Int, cmp:T->T->Int):Int {
		assert(a != null);
		assert(cmp != null);
		assert(min >= 0 && min < size(a));
		assert(max < size(a));

		var l = min, m, h = max + 1;
		while (l < h) {
			m = l + ((h - l) >> 1);
			if (cmp(get(a, m), val) < 0)
				l = m + 1;
			else
				h = m;
		}

		if ((l <= max) && cmp(get(a, l), val) == 0)
			return l;
		else
			return ~l;
	}

	public static function binarySearchf(a:NativeArray<Float>, val:Float, min:Int, max:Int):Int {
		assert(a != null);
		assert(min >= 0 && min < size(a));
		assert(max < size(a));

		var l = min, m, h = max + 1;
		while (l < h) {
			m = l + ((h - l) >> 1);
			if (get(a, m) < val)
				l = m + 1;
			else
				h = m;
		}

		if ((l <= max) && (get(a, l) == val))
			return l;
		else
			return ~l;
	}

	public static function binarySearchi(a:NativeArray<Int>, val:Int, min:Int, max:Int):Int {
		assert(a != null);
		assert(min >= 0 && min < size(a));
		assert(max < size(a));

		var l = min, m, h = max + 1;
		while (l < h) {
			m = l + ((h - l) >> 1);
			if (get(a, m) < val)
				l = m + 1;
			else
				h = m;
		}

		if ((l <= max) && (get(a, l) == val))
			return l;
		else
			return ~l;
	}
	}
 */
