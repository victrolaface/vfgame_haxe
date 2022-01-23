package tools.ds;

// using System;
// using System.Collections.Generic;
// using System.Diagnostics;
// using System.Threading.Tasks;
// namespace Permutations {
import tools.math.Factorial;
import haxe.ds.Vector;

// import haxe.macro;
using haxe.Int64;

@:structInit class PermutationOuelletHuttunen<T> {
	var first:Null<Int64> = 0;
	var last:Null<Int64>; // =0;
	var sorted:Vector<Int>;

	public inline function perm(_sorted:Vector<Int>, _first:Int = -1, _last:Int = -1) {
		first = Int64.ofInt(_first) == -1 ? 0 : null;
		last = Int64.ofInt(_last) == -1 ? Factorial.factor(_sorted.length) : null;
		sorted = first < last ? _sorted : null;
	}

	public inline function forEach() {}
}
/*public class PermutationMixOuelletSaniSinghHuttunen {
		public
		void ExecuteForEachPermutation(Action<int[]>action)
		{
			//			Console.WriteLine($"Thread {System.Threading.Thread.CurrentThread.ManagedThreadId} started: {_indexFirst} {_indexLastExclusive}");
			long
			index = _indexFirst;
			PermutationOuelletLexico3<int>
			permutationOuellet = new PermutationOuelletLexico3<int>(_sortedValues);
			permutationOuellet.GetValuesForIndex(index);
			action(permutationOuellet.Result);
			index++;
			int[]
			values = permutationOuellet.Result;
			while (index < _indexLastExclusive) {
				PermutationSaniSinghHuttunen.NextPermutation(values);
				action(values);
				index++;
			}
			//			Console.WriteLine($"Thread {System.Threading.Thread.CurrentThread.ManagedThreadId} ended: {DateTime.Now.ToString("yyyyMMdd_HHmmss_ffffff")}");
		}
		// ************************************************************************
		public static
		void ExecuteForEachPermutationMT(int[]sortedValues, Action<int[]>action)
		{
			int
			coreCount = Environment.ProcessorCount; // Hyper treading are taken into account (ex: on a 4 cores hyperthreaded = 8)
			long
			itemsFactorial = Factorial.GetFactorial(sortedValues.Length);
			long
			partCount = (long)
			Math.Ceiling((double) itemsFactorial / (double) coreCount);
			long
			startIndex = 0;
			var tasks = new List<Task>();
			for (int coreIndex = 0;
			coreIndex < coreCount;
			coreIndex++
		)
			{
				long
				stopIndex = Math.Min(startIndex + partCount, itemsFactorial);
				PermutationMixOuelletSaniSinghHuttunen
				mix = new PermutationMixOuelletSaniSinghHuttunen(sortedValues, startIndex, stopIndex);
				Task
				task = Task.Run(() => mix.ExecuteForEachPermutation(action));
				tasks.Add(task);
				if (stopIndex == itemsFactorial) {
					break;
				}
				startIndex = startIndex + partCount;
			}
			Task.WaitAll(tasks.ToArray());
		}
		// ************************************************************************
	}
}*/
