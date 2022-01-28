package tools.ds;

class SparseSet {
	var sparse:Array<Int> = []; // Vector<Int>;
	var dense:Array<Int> = []; // Vector<Int>;
	var count:Int;
	var pop:Int;
	var push:Int;
	var idx:Int;

	public function new(_size) {
		sparse = new Array<Int>(); // Vector(_size);
		dense = new Array<Int>(); // Vector(_size);
		count = 0;
		for (i in 0...sparse.length)
			sparse[i] = 0;
		for (i in 0...dense.length)
			dense[i] = -1;
	}

	public function has(_item:Int) {
		idx = _item;
		var dirty = sparse[idx] > count;
		if (!dirty) {
			idx = sparse[idx];
			dirty = dense[idx] != _item;
		} else
			return false;
		return !dirty;
	}

	public function insert(_item:Int) {
		idx = count;
		dense[idx] = _item;
		idx = _item;
		sparse[idx] = count;
		count++;
	}

	public function remove(_item:Int) {
		pop = dense[count - 1];
		push = pop;
		idx = _item;
		idx = sparse[idx];
		dense[idx] = push;
		idx = _item;
		pop = sparse[idx];
		push = pop;
		idx = push;
		sparse[idx] = push;
		count--;
	}

	public function getDense(_idx:Int)
		return dense[_idx];

	public function getSparse(_item:Int) {
		idx = _item;
		return sparse[idx];
	}

	public function size()
		return count;
}
