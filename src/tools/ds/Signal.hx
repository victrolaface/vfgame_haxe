package tools.ds;

import haxe.extern.EitherType;
import tools.debug.Log;

@:structInit class Signal extends BaseSignal<() -> Void> {
	static final signalErr = 'use signal ';
	static inline function err(_n:Int) {
		#if debug
		Log.error('$signalErr $_n');
		#end
	}
	override inline function emitCallback(_callback:() -> Void)
		_callback();
	override inline function emitCallback1(_callback:(Dynamic) -> Void)
		err(1);
	override inline function emitCallback2(callback:(Dynamic, Dynamic) -> Void)
		err(2);
	override inline function emitCallback3(callback:(Dynamic, Dynamic, Dynamic) -> Void)
		err(3);
	public inline function new(?_emitOnAdd:Bool = false)
		super(_emitOnAdd);
	public inline function emit() {
		sortPriority();
		emitCallbacks();
	}
}

@:structInit class BaseSignal<Callback> {
	#if js
	@:noCompletion private static function __init__() {
		untyped Object.defineProperties(BaseSignal.prototype, {
			"listeners": {
				get: untyped __js__("function () { return this.get_listeners (); }"),
				set: untyped __js__("function (v) { return this.set_listeners (v); }")
			},
			"hasListeners": {
				get: untyped __js__("function () { return this.get_hasListeners (); }"),
				set: untyped __js__("function (v) { return this.set_hasListeners (v); }")
			},
		});
	}
	#end
	var current:SignalCallbackData;
	var callbacks:Array<SignalCallbackData> = [];
	var toEmit:Array<SignalCallbackData> = [];
	var doSort:Bool = false;
	public var listeners(get, null):Int;
	public var hasListeners(get, null):Bool;
	public var doEmitOnAdd:Bool = false;
	inline function sortPriority() {
		if (doSort) {
			callbacks.sort(sortCallbacks);
			doSort = false;
		}
	}
	inline function emitCallbacks() {
		var i:Int = 0;
		while (i < callbacks.length) {
			var callbackData = callbacks[i];
			if (callbackData.repeat < 0 || callbackData.callCount <= callbackData.repeat)
				toEmit.push(callbackData);
			else
				callbackData.remove = true;
			callbackData.callCount++;
			i++;
		}
		var j:Int = callbacks.length - 1;
		while (j >= 0) {
			var callbackData = callbacks[j];
			if (callbackData.remove == true)
				callbacks.splice(j, 1);
			j--;
		}
		for (l in 0...toEmit.length) {
			if (toEmit[l] != null)
				toEmit[l].method(toEmit[l].callback);
		}
		toEmit = [];
	}
	function emitCallback(callback:() -> Void)
		throw "implement in override";
	function emitCallback1(callback:(Dynamic) -> Void)
		throw "implement in override";
	function emitCallback2(callback:(Dynamic, Dynamic) -> Void)
		throw "implement in override";
	function emitCallback3(callback:(Dynamic, Dynamic, Dynamic) -> Void)
		throw "implement in override";
	inline function sortCallbacks(s1:SignalCallbackData, s2:SignalCallbackData):Int {
		if (s1.priority > s2.priority)
			return -1;
		else if (s1.priority < s2.priority)
			return 1;
		else
			return 0;
	}
	inline function get_listeners()
		return callbacks.length;
	inline function get_hasListeners()
		return listeners > 0;
	inline function getNumParams(callback:Callback) {
		var n = 0;
		#if (!static)
		var len:Null<Int> = Reflect.getProperty(callback, 'length');
		if (len != null)
			n = len;
		#end
		return n;
	}
	public inline function new(?_emitOnAdd:Bool = false)
		doEmitOnAdd = _emitOnAdd;
	public inline function add(callback:Callback, ?fireOnce:Bool = false, ?priority:Int = 0, ?_emitOnAdd:Null<Bool> = null) {
		var params:Int = getNumParams(callback);
		var repeat:Int = -1;
		if (fireOnce == true)
			repeat = 0;
		current = {
			params: params,
			callback: callback,
			callCount: 0,
			repeat: repeat,
			priority: priority,
			remove: false
		}
		if (params == 0)
			current.method = emitCallback;
		else if (params == 1)
			current.method = emitCallback1;
		else if (params == 2)
			current.method = emitCallback2;
		else if (params == 3)
			current.method = emitCallback3;
		callbacks.push(current);
		if (priority != 0)
			doSort = true;
		if (_emitOnAdd == true || doEmitOnAdd)
			current.method(callback);
		return this;
	}
	public inline function priority(value:Int) {
		if (current != null) {
			current.priority = value;
			doSort = true;
		}
		return this;
	}
	public inline function repeat(value:Int = -1) {
		if (current != null)
			current.repeat = value;
		return this;
	}
	public inline function emitOnAdd() {
		if (current != null) {
			current.callCount++;
			current.method(current.callback);
		}
	}
	public inline function remove(callback:EitherType<Bool, Callback> = false) {
		if (callback == true)
			callbacks = [];
		else {
			var j:Int = 0;
			while (j < callbacks.length) {
				if (callbacks[j].callback == callback)
					callbacks.splice(j, 1);
				else
					j++;
			}
		}
	}
}
typedef SignalCallbackData = {
	callback:Dynamic,
	callCount:Int,
	params:Int,
	repeat:Int,
	priority:Int,
	remove:Bool,
	?method:(Dynamic) -> Void
}
typedef Signal0 = Signal
/*
if (fireOnce != false || priority != 0 || _emitOnAdd != null) {
    var warningMessage:String = 
    "\nWARNING: fireOnce, priority and fireOnAdd params will be removed from 'Signals' in a future release\n
    Instead use daisy chain methods, eg: obj.add(callback).repeat(5).priority(1000).fireOnAdd();";
    #if js
    untyped __js__('console.warn(warningMessage)');
    #else
    trace(warningMessage);
    #end
}*/