package tools.ds;

class SignalArray<T> implements ISignal<T> {
	final listeners:Array<Listener<T>> = [];

	public var length(get, never):Int;

	public inline function new() {}

	public inline function on(_listener:Listener<T>)
		listeners.push(_listener);

	public inline function once(_listener:Listener<T>) {
		listeners.push(function wrapped(data:T) {
			listeners.remove(wrapped);
			_listener(data);
		});
	}

	public inline function off(?_listener:Listener<T>) {
		if (_listener != null)
			listeners.remove(_listener);
		else
			listeners.resize(0);
	}

	public inline function emit(_data:T)
		for (l in listeners)
			l(_data);

	inline function get_length()
		return listeners.length;
}
