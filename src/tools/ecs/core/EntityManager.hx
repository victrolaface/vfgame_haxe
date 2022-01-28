package tools.ecs.core;

#if debug
import tools.debug.Precondition;
#end

@:structInit class EntityManager {
	static final ID_MASK = 0xfffff;
	static final ID_BITS_AMOUNT = 20;
	static final VERSION_MASK = 0xfff << ID_BITS_AMOUNT;
	static final COUNT_MIN = 4;
	static final COUNT_MAX = 4096;

	var count:Int = 0;
	var cap:Int = 0;
	var available:Int = 0;
	var toDestroy:Int = 0;
	var storage:Array<Int> = [];
	var state = None;
	var next(get, set):Int;
	var atCap(get, never):Bool;
	var hasAvailable(get, never):Bool;

	public var length(get, never):Int;
	public var canUpdate(get, never):Bool;
	public var canCreate(get, never):Bool;

	inline function get_canUpdate() {
		final CAN_UPDATE = state == Init || state == Update;
		/*#if debug
			Precondition.requires(CAN_UPDATE, '"CAN_UPDATE" of value $CAN_UPDATE is true');
			#end */
		return CAN_UPDATE;
	}

	inline function get_canCreate() {
		final CAN_CREATE = hasAvailable || !atCap;
		/*#if debug
			Precondition.requires(CAN_CREATE, '"CAN_CREATE" of value $CAN_CREATE is true');
			#end */
		return CAN_CREATE;
	}

	inline function get_next()
		return storage[0];

	inline function get_length()
		return cap;

	inline function get_atCap()
		return available <= 0 && count >= cap && !hasAvailable;

	inline function get_hasAvailable()
		return available > 0;

	inline function set_next(_id:Int)
		return storage[0] = _id;

	inline function onUpdate()
		state = Update;

	inline function onCreate()
		state = Create;

	inline function parseVersion(_id)
		return ((_id & VERSION_MASK) >>> ID_BITS_AMOUNT);

	inline function parseIdx(_id:Int)
		return _id & ID_MASK;

	inline function id(_index:Int, _version:Int)
		return (((_version << ID_BITS_AMOUNT) & VERSION_MASK) | (_index & ID_MASK));

	inline function doCreate() {
		final IDX = count + 1;
		final ID = id(IDX, 0);
		storage[IDX] = ID;
		count++;
		onUpdate();
	}

	inline function doDestroy() {
		final IDX = parseIdx(toDestroy);
		final ID = id(IDX, parseVersion(toDestroy) + 1);
		storage[IDX] = ID;
		next = ID;
		available++;
		onUpdate();
	}

	inline function recycle() {
		var pop = next;
		var push = pop;
		var idx = parseIdx(push);
		for (i in 0...available) {
			pop = storage[idx];
			storage[idx] = push;
			push = pop;
			idx = parseIdx(push);
			if (i == available)
				next = push;
		}
		available--;
		onUpdate();
	}

	public inline function new(_size:Int = 4096) {
		cap = _size < COUNT_MIN ? COUNT_MIN : _size > COUNT_MAX ? COUNT_MAX : _size;
		for (i in 1...cap + 1)
			storage[i] = id(i, 0);
		available = cap;
		for (_ in 1...available + 1)
			doCreate();
		for (i in 1...count + 1) {
			toDestroy = id(i, 0);
			doDestroy();
		}
		state = Init;
	}

	public inline function update() {
		#if debug
		Precondition.requires(canUpdate, '"canUpdate" of value $canUpdate is true');
		#end
		switch (state) {
			case Init:
				onUpdate();
			case Create:
				if (hasAvailable)
					recycle();
				else if (atCap)
					onCreate();
				else
					doCreate();
			case Destroy:
				doDestroy();
			case _:
				onUpdate();
		}
	}

	public inline function create() {
		#if debug
		Precondition.requires(canCreate, '"canCreate" of value $canCreate is true');
		#end
		if (canCreate)
			onCreate();
	}

	public inline function destroy(_id:Int) {
		if (canDestroy(_id)) {
			toDestroy = _id;
			state = Destroy;
		}
	}

	public inline function canDestroy(_id:Int) {
		final CAN_DESTROY = storage[parseIdx(_id)] == _id;
		/*#if debug
			Precondition.requires(CAN_DESTROY, '"CAN_DESTROY" of value $CAN_DESTROY is true');
			#end */
		return CAN_DESTROY;
	}
}

enum State {
	None;
	Init;
	Update;
	Create;
	Destroy;
}
