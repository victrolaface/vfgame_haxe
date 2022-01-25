package tools.ds;

interface ISignal<T> {
	var length(get, never):Int;
	function on(_listener:Listener<T>):Void;
	function once(_listener:Listener<T>):Void;
	function off(?_listener:Listener<T>):Void;
	function emit(_data:T):Void;
}
