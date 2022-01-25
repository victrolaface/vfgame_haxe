package tools.ds;

typedef ListenerData<T> = (data:T) -> Void;

@:callable
abstract Listener<T>(ListenerData<T>) from ListenerData<T> {
	@:from static inline function fromNoArguments(_f:() -> Void):Listener<NoData> {
		return (data:NoData) -> _f();
	}
}
