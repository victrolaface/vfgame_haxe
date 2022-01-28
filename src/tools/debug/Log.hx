#if debug
package tools.debug;

import haxe.io.Bytes;
import tools.system.System;
import sys.io.Process;

@:structInit class Log {
	static final STR_EMPTY = '';
	static final PRE_MSG = '\x1b[3';
	static final MSG = ':\x1b[0m\x1b[1m';
	static final POST_MSG = '\x1b[0m';
	static var colorCodes:EReg = ~/\x1b\[[^m]+m/g;
	static var colorSupported:Bool = false;
	static var colorSupportedDirty:Bool = true;
	static var sentWarnings:Map<String, Bool> = new Map<String, Bool>();

	public static var enableColor = true;
	public static var mute = false;
	public static var verbose = false;

	static inline function msg(_type:Message, _msg:String, _verbose:String, ?_repeat:Bool = false, ?_e:Dynamic = null) {
		var out = STR_EMPTY;
		if (!mute && !isEmpty(_msg)) {
			final isVerbose = verbose && !isEmpty(_verbose);
			switch (_type) {
				case Info:
					out = isVerbose ? _verbose : _msg;
					println(out);
				case Warning:
					out = isVerbose ? warning(_verbose) : warning(_msg);
					if (_repeat != null && _repeat && !sentWarnings.exists(out)) {
						sentWarnings.set(out, true);
						println(out);
					}
				case Error:
					out = isVerbose ? err(_verbose) : err(_msg);
					Sys.stderr().write(Bytes.ofString(stripColor(out)));
					if (verbose && _e != null)
						throw _e;
					Sys.exit(1);
				case _:
					out = STR_EMPTY;
			}
		}
	}

	static inline function isEmpty(_msg:String)
		return _msg == STR_EMPTY;

	static inline function err(_msg:String)
		return PRE_MSG + '1;1mError$MSG $_msg $POST_MSG\n';

	static inline function warning(_msg:String)
		return PRE_MSG + '3;1mWarning$MSG $_msg $POST_MSG';

	static inline function stripColor(_msg:String) {
		if (colorSupportedDirty) {
			if (System.hostPlatform == WINDOWS)
				colorSupported = Sys.getEnv("TERM") == "xterm" || Sys.getEnv("ANSICON") != null ? true : false;
			else {
				var res = -1;
				try {
					var process = new Process("tput", ["colors"]);
					res = process.exitCode();
					process.close();
				} catch (e:Dynamic) {};
				colorSupported = res == 0;
			}
			colorSupportedDirty = false;
		}
		return enableColor && colorSupported ? _msg : colorCodes.replace(_msg, STR_EMPTY);
	}

	public static inline function print(_msg:String)
		Sys.print(stripColor(_msg));

	public static inline function println(_msg:String)
		Sys.println(stripColor(_msg));

	public static inline function info(_msg:String, _verbose:String = '')
		msg(Info, _msg, _verbose);

	public static inline function warn(_msg:String, _verbose:String = '', _repeat:Bool = false)
		msg(Warning, _msg, _verbose, _repeat);

	public static inline function error(_msg:String, _verbose:String = '', _e:Dynamic = null)
		msg(Error, _msg, _verbose, false, _e);
}

enum Message {
	Info;
	Warning;
	Error;
}
#end
