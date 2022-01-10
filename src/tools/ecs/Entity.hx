package tools.ecs;

abstract Entity(Null<Int>) {
	public static final none = new Entity(-1);

	public var id(get, set):Int;

	public inline function new(_id:Int)
		this = _id;

	public inline function get_id()
		return this;

	public inline function set_id(_id)
		return this = _id;
}
