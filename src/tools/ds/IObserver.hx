package tools.ds;

interface IObserver {
	public function signal(_sender:Observable, ?_data:Any):Void;
}
