package tools.ecs.core;

import tools.ecs.core.EntityStorage as Storage;

@:structInit class EntityManager {
	var to:Int;
	var storage:Storage;
	var state:State;

	public inline function new(?_size:Int)
		storage = _size == null ? new Storage() : new Storage(_size);

	public inline function update()
		doUpdate();

	public inline function create()
		state = Create;

	public inline function destroy(_id:Int) {
		to = _id;
		state = Destroy;
	}

	inline function doUpdate() {
		switch (state) {
			case Create:
				{
					storage.create();
				};
			case Destroy:
				{};
			case _:
				state = Update;
		}
	}

	inline function init(?_size:Int) {}
}

private enum State {
	Update;
	Create;
	Destroy;
}
