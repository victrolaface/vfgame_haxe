#if debug
package tools.debug;

import haxe.io.Bytes;
import tools.system.System;
import sys.io.Process;

@:structInit class Log {
	static final strEmpty = '';
	static final preMsg = '\x1b[3';
	static final midMsg = ':\x1b[0m\x1b[1m';
	static final postMsg = '\x1b[0m';
	static var colorCodes:EReg = ~/\x1b\[[^m]+m/g;
	static var colorSupported:Bool = false;
	static var colorSupportedDirty:Bool = true;
	static var sentWarnings:Map<String, Bool> = new Map<String, Bool>();

	public static var accentColor = '\x1b[32;1m';
	public static var enableColor = true;
	public static var mute = false;
	public static var resetColor = '\x1b[0m';
	public static var verbose = false;

	static inline function msg(_type:Message, _msg:String, _verbose:String, ?_repeat:Bool = false, ?_e:Dynamic = null) {
		var out = strEmpty;
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
					out = strEmpty;
			}
		}
	}

	static inline function isEmpty(_msg:String)
		return _msg == strEmpty;

	static inline function err(_msg:String)
		return preMsg + '1;1mError$midMsg $_msg $postMsg\n';

	static inline function warning(_msg:String)
		return preMsg + '3;1mWarning$midMsg $_msg $postMsg';

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
		return enableColor && colorSupported ? _msg : colorCodes.replace(_msg, strEmpty);
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
