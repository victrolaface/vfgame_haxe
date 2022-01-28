package tools.ds;

import tools.debug.Error;

typedef CallbackData<T> = (?_err:Error, ?_res:T) -> Void;

@:callable
abstract Callback<T>(CallbackData<T>) from CallbackData<T> {
	public static inline function notNull<T>(?_cb:Callback<T>):Callback<T>
		return _cb == null ? ((_, _) -> {}) : _cb;

	@:from public static inline function fromOptionalErrorOnly(_f:(?_err:Error) -> Void):Callback<NoData> {
		return (?_err:Error, ?_res:NoData) -> _f(_err);
	}

	@:from public static inline function fromErrorOnly(_f:(_err:Error) -> Void):Callback<NoData> {
		return (?_err:Error, ?_res:NoData) -> _f(_err);
	}

	@:from public static inline function fromErrorResult<T>(_f:(_err:Error, _res:T) -> Void):Callback<T> {
		return (?_err:Error, ?_res:T) -> _f(_err, _res);
	}

	#if (hl || neko)
	private inline function toUVNoData()
		return (_err) -> this(_err, null);
	#end
}
