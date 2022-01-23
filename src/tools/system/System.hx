package tools.system;

import sys.FileSystem;
import sys.io.Process;
import haxe.io.BytesOutput;
import haxe.io.Eof;
import tools.debug.Precondition;

@:structInit class System {
	static var cores:Int = 0;
	static var platform:HostPlatform = null;
	static var dryRun:Bool = false;
	public static var hostPlatform(get, never):HostPlatform;
	public static var processorCores(get, never):Int;

	static inline function get_hostPlatform():HostPlatform {
		var p:HostPlatform;
		if (platform != null)
			p = platform;
		else {
			final flag = 'i';
			if (matchedSystem("window", '$flag'))
				p = WINDOWS;
			else if (matchedSystem("linux", '$flag'))
				p = LINUX;
			else if (matchedSystem("mac", '$flag'))
				p = MAC;
			platform = p;
		}
		return p;
	}

	static inline function matchedSystem(_sys:String, _flag:String)
		return new EReg('$_sys', '$_flag').match(Sys.systemName());

	static inline function get_processorCores():Int {
		final dryRunCached = dryRun;
		dryRun = false;
		if (cores < 1) {
			var res:String;
			switch (hostPlatform) {
				case WINDOWS:
					final out = Sys.getEnv("NUMBER_OF_PROCESSORS");
					res = out != null ? out : null;
				case LINUX:
					res = runProcess("", "nproc", [], true, true, true);
					if (res == null) {
						final out = runProcess("", "cat", ["/proc/cpuinfo"], true, true, true);
						res = out != null ? Std.string((out.split("processor")).length - 1) : null;
					}
				case MAC:
					var n = ~/Total Number of Cores: (\d+)/;
					res = n.match(runProcess("", "/usr/sbin/system_profiler", ["-detailLevel", "full", "SPHardwareDataType"])) ? n.matched(1) : null;
				case _:
					res = null;
			}
			cores = res == null || Std.parseInt(res) < 1 ? 1 : Std.parseInt(res);
		}
		dryRun = dryRunCached;
		return cores;
	}

	static inline function pathExists(_path:String, _init:Bool)
		return FileSystem.exists(_init ? new Path(_path).dir : _path);

	static inline function runProcess(_path:String, _cmd:String, _args:Array<String>, _wait:Bool = true, _safe:Bool = true, _ignoreErr:Bool = false,
			_prnt:Bool = false, _retErr:Bool = false) {
		if (_prnt) {
			var out = _cmd;
			for (a in _args) {
				if (a.indexOf(" ") > -1)
					out += " \"" + a + "\"";
				else
					out += " " + a;
			}
			Sys.println(out);
		}
		var run = true;
		#if debug
		if (_safe) {
			run = _path != null && _path != '' && pathExists(_path, true) && pathExists(_path, false);
			Precondition.requires(run, 'path "$_path" exists');
		#end
		}
		return run ? doRunProcess(_path, _cmd, _args, _wait, _safe, _ignoreErr, _retErr) : null;
	}

	static inline function doRunProcess(_path:String, _cmd:String, _args:Array<String>, _wait:Bool, _safe:Bool, _ignore:Bool, _retErr:Bool) {
		var initPath='';
        //if(_path != null && path !=''){}
         //   #if debug
            
         //   #end
        /*
		var oldPath:String = "";

		if (path != null && path != "") {
			// Log.info("", " - \x1b[1mChanging directory:\x1b[0m " + path + "");

			if (!dryRun) {
				oldPath = Sys.getCwd();
				Sys.setCwd(path);
			}
		}

		var argString = "";

		for (arg in args) {
			if (arg.indexOf(" ") > -1) {
				argString += " \"" + arg + "\"";
			} else {
				argString += " " + arg;
			}
		}

		// Log.info("", " - \x1b[1mRunning process:\x1b[0m " + command + argString);

		var output = "";
		var result = 0;

		if (!dryRun) {
			var process = new Process(command, args);
			var buffer = new BytesOutput();

			if (waitForOutput) {
				var waiting = true;

				while (waiting) {
					try {
						var current = process.stdout.readAll(1024);
						buffer.write(current);

						if (current.length == 0) {
							waiting = false;
						}
					} catch (e:Eof) {
						waiting = false;
					}
				}

				result = process.exitCode();

				output = buffer.getBytes().toString();

				if (output == "") {
					var error = process.stderr.readAll().toString();
					process.close();

					if (result != 0 || error != "") {
						if (ignoreErrors) {
							output = error;
						} else if (!safeExecute) {
							throw error;
						} else {
							// Log.error(error);
						}

						if (returnErrorValue) {
							return output;
						} else {
							return null;
						}
					}

					/*if (error != "") {

					Log.error (error);

	}*/

		// }
		// else {
		//	process.close();
		//	}
		// } if (oldPath != "") {
		//	Sys.setCwd(oldPath);
		// }
		// } return output;
		//*/
		return '';
	}
}
