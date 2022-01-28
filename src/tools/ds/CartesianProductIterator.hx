package tools.ds;

class CartesianProductIterator {
	var sets:Array<Array<Dynamic>>;
	var curIndexes:Array<Int>;

	public inline function new(_sets:Array<Array<Dynamic>>) {
		sets = _sets;
		curIndexes = [for (i in 0...sets.length) 0];
	}

	public inline function hasNext():Bool
		return curIndexes[0] < sets[0].length;

	public inline function next() {
		var out = [for (i in 0...sets.length) sets[i][curIndexes[i]]];
		var j = sets.length - 1;
		curIndexes[j]++;
		while (j > 0 && curIndexes[j] >= sets[j].length) {
			curIndexes[j] = 0;
			j--;
			curIndexes[j]++;
		}
		return out;
	}
}
