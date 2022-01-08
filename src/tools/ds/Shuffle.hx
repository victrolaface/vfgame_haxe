package tools.ds;

@:structInit class Shuffle {
	static var f:Void->Float = () -> Math.random();

	public static inline function setRandom(_float:Void->Float)
		f = _float;

	public static inline function frand()
		return f();
}
