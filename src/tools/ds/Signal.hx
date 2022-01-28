package tools.ds;

class Signal<T> implements ISignal<T> {
	var listeners:Array<Listener<T>> = [];

	public final changeSignal:ISignal<NoData> = new SignalArray<NoData>();

	public var length(get, never):Int;

	public inline function new() {}

	public inline function on(_listener:Listener<T>) {
		listeners.push(_listener);
		changeSignal.emit(new NoData());
	}

	public inline function once(_listener:Listener<T>) {
		listeners.push(function wrapped(data:T) {
			listeners.remove(wrapped);
			changeSignal.emit(new NoData());
			_listener(data);
		});
		changeSignal.emit(new NoData());
	}

	public inline function off(?_listener:Listener<T>) {
		if (_listener != null)
			listeners.remove(_listener);
		else
			listeners.resize(0);
		changeSignal.emit(new NoData());
	}

	public inline function emit(_data:T) {
		for (l in listeners)
			l(_data);
	}

	inline function get_length()
		return listeners.length;
}
