package tools.ds;

@:structInit class Observable {
	var observers:Array<IObserver> = [];

	public function new() {}

	private function signal<T>(?_data:T) {
		for (o in observers)
			o.signal(this, _data);
	}

	public function addObserver(_observer:IObserver)
		observers.push(_observer);
}
