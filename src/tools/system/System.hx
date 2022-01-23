package tools.system;

import sys.FileSystem;
import sys.io.Process;
import haxe.io.BytesOutput;
import haxe.io.Eof;
import tools.debug.Precondition;
import tools.debug.Log;
import haxe.io.Path in HaxePath;

@:structInit class System {
	static var strEmpty = '';
	static var cores:Int = 0;
	static var platform:HostPlatform = null;
	static var dryRun:Bool = false;
	public static var hostPlatform(get, never):HostPlatform;
	public static var processorCores(get, never):Int;

	static inline function isNull<T>(_val:T)
		return _val == null;

	static inline function isEmpty(_str:String)
		return _str == strEmpty;

	static inline function get_hostPlatform():HostPlatform {
		var p:HostPlatform;
		if (isNull(platform)) {
			final flag = 'i';
			if (matchedSystem('window', '$flag'))
				p = WINDOWS;
			else if (matchedSystem('linux', '$flag'))
				p = LINUX;
			else if (matchedSystem('mac', '$flag'))
				p = MAC;
			platform = p;
		} else
			p = platform;
		return p;
	}

	static inline function matchedSystem(_sys:String, _flag:String)
		return new EReg('$_sys', '$_flag').match(Sys.systemName());

	static inline function get_processorCores():Int {
		final dryRunCached = dryRun;
		dryRun = false;
		if (cores < 1) {
			var n:String = null;
			switch (hostPlatform) {
				case WINDOWS:
					final out = Sys.getEnv("NUMBER_OF_PROCESSORS");
					n = out != null ? out : null;
				case LINUX:
					n = runProcess(strEmpty, "nproc", [], true, true, true);
					if (isNull(n)) {
						final out = runProcess(strEmpty, "cat", ["/proc/cpuinfo"], true, true, true);
						n = out != null ? Std.string((out.split("processor")).length - 1) : null;
					}
				case MAC:
					final msg = ~/Total Number of Cores: (\d+)/;
					n = msg.match(runProcess(strEmpty, "/usr/sbin/system_profiler", ["-detailLevel", "full", "SPHardwareDataType"])) ? msg.matched(1) : null;
				case _:
					n = null;
			}
			cores = isNull(n) || Std.parseInt(n) < 1 ? 1 : Std.parseInt(n);
		}
		dryRun = dryRunCached;
		return cores;
	}

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
			run = !isNull(_path) && !isEmpty(_path) && pathExists(_path, true) && pathExists(_path, false);
			Precondition.requires(run, 'path "$_path" exists');
		#end
		}
		return run ? process(_path, _cmd, _args, _wait, _safe, _ignoreErr, _retErr) : null;
	}

	static inline function pathExists(_path:String, _init:Bool)
		return FileSystem.exists(_init ? new HaxePath(_path).dir : _path);

	static inline function process(_path:String, _cmd:String, _args:Array<String>, _wait:Bool, _safe:Bool, _ignore:Bool, _retErr:Bool) {
		var initPath = strEmpty;
		if (!isNull(_path) && !isEmpty(_path)) {
			#if debug
			Log.info(strEmpty, ' - \x1b[1mChanging directory:\x1b[0m $_path ');
			#end
			if (!dryRun) {
				initPath = Sys.getCwd();
				Sys.setCwd(_path);
			}
		}
		var args = strEmpty;
		for (a in _args) {
			if (a.indexOf(' ') > -1)
				args += ' \"$a"\"';
			else
				args += ' $a';
		}
		#if debug
		Log.info(strEmpty, ' - \x1b[1mRunning process:\x1b[0m $_cmd $args');
		#end
		var out = strEmpty;
		var res = 0;
		if (!dryRun) {
			var p:Process;
			if (!isNull(_args) && _args.length > 0)
				p = new Process(_cmd, _args);
			else
				p = new Process(_cmd);
			if (_wait) {
				var buff = new BytesOutput();
				var doWait = _wait;
				while (doWait) {
					try {
						var cur = p.stdout.readAll(1024);
						buff.write(cur);
						if (cur.length == 0)
							doWait = false;
					} catch (e:Eof)
						doWait = false;
				}
				res = p.exitCode();
				out = buff.getBytes().toString();
				if (isEmpty(out)) {
					var err = p.stderr.readAll().toString();
					p.close();
					if (res != 0 || !isEmpty(err)) {
						if (_ignore)
							out = err;
						#if debug
						else if (!_safe)
							throw err;
						else
							Log.error(err);
						#end
						if (!_retErr)
							out = null;
					}
				} else
					p.close();
			}
			if (!isEmpty(initPath))
				Sys.setCwd(initPath);
		}
		return out;
	}
}
