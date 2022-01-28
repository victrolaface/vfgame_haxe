package tools.system;

import sys.FileSystem;
import sys.io.Process;
import haxe.io.BytesOutput;
import haxe.io.Eof;
import tools.debug.Precondition;
import tools.debug.Log;
import haxe.io.Path in HaxePath;

class System {
	static final STR_EMPTY = "";
	static final ZERO_STR = "0";
	static var cores:Int = 0;
	static var platform:HostPlatform = null;
	static var dryRun:Bool = false;
	public static var hostPlatform(get, never):HostPlatform;
	public static var processorCores(get, never):Int;

	static inline function isNull<T>(_val:T)
		return _val == null;

	static inline function isEmpty(_str:String)
		return _str == STR_EMPTY;

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
		final DRY_RUN_CACHED = dryRun;
		dryRun = false;
		if (cores < 1) {
			var n:String = null;
			switch (hostPlatform) {
				case WINDOWS:
					final WINDOWS_CORES = Sys.getEnv("NUMBER_OF_PROCESSORS");
					n = WINDOWS_CORES != null ? WINDOWS_CORES : ZERO_STR;
				case LINUX:
					final LINUX_PROCESS = runProcess(STR_EMPTY, "nproc", [], true, true, true);
					if (isNull(LINUX_PROCESS)) {
						final LINUX_CORES = runProcess(STR_EMPTY, "cat", ["/proc/cpuinfo"], true, true, true);
						n = LINUX_CORES != null ? Std.string((LINUX_CORES.split("processor")).length - 1) : ZERO_STR;
					}
				case MAC:
					final MAC_CORES = ~/Total Number of Cores: (\d+)/;
					n = MAC_CORES.match(runProcess(STR_EMPTY, "/usr/sbin/system_profiler",
						["-detailLevel", "full", "SPHardwareDataType"])) ? MAC_CORES.matched(1) : ZERO_STR;
				case _:
					n = ZERO_STR;
			}
			cores = isNull(n) || Std.parseInt(n) < 1 ? 1 : Std.parseInt(n);
		}
		dryRun = DRY_RUN_CACHED;
		return cores;
	}

	static inline function runProcess(_path:String, _cmd:String, _args:Array<String>, _wait:Bool = true, _safe:Bool = true, _ignore:Bool = false,
			_prnt:Bool = false, _ret:Bool = false) {
		if (_prnt) {
			var ln = _cmd;
			for (a in _args) {
				if (a.indexOf(" ") > -1)
					ln += " \"" + a + "\"";
				else
					ln += " " + a;
			}
			Sys.println(ln);
		}
		var run = true;
		#if debug
		if (_safe) {
			run = !isNull(_path) && !isEmpty(_path) && hasPath(_path, true) && hasPath(_path, false);
			Precondition.requires(run, 'path "$_path" exists');
		#end
		}
		return run ? process(_path, _cmd, _args, _wait, _safe, _ignore, _ret) : STR_EMPTY;
	}

	static inline function hasPath(_path:String, _init:Bool)
		return FileSystem.exists(_init ? new HaxePath(_path).dir : _path);

	static inline function process(_path:String, _cmd:String, _args:Array<String>, _wait:Bool, _safe:Bool, _ignore:Bool, _ret:Bool) {
		var initPath = STR_EMPTY; // strEmpty;
		if (!isNull(_path) && !isEmpty(_path)) {
			#if debug
			Log.info(STR_EMPTY, ' - \x1b[1mChanging directory:\x1b[0m $_path ');
			#end
			if (!dryRun) {
				initPath = Sys.getCwd();
				Sys.setCwd(_path);
			}
		}
		var args = STR_EMPTY;
		for (a in _args) {
			if (a.indexOf(' ') > -1)
				args += ' \"$a"\"';
			else
				args += ' $a';
		}
		#if debug
		Log.info(STR_EMPTY, ' - \x1b[1mRunning process:\x1b[0m $_cmd $args');
		#end
		var out = STR_EMPTY;
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
						final CURR = p.stdout.readAll(1024);
						buff.write(CURR);
						if (CURR.length == 0)
							doWait = false;
					} catch (e:Eof)
						doWait = false;
				}
				res = p.exitCode();
				out = buff.getBytes().toString();
				if (isEmpty(out)) {
					final ERR = p.stderr.readAll().toString();
					p.close();
					if (res != 0 || !isEmpty(ERR)) {
						if (_ignore)
							out = ERR;
						#if debug
						else if (!_safe)
							throw ERR;
						else
							Log.error(ERR);
						#end
						if (!_ret)
							out = STR_EMPTY;
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
