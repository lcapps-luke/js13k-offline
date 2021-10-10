package lcann.offline.resource;

import js.Browser;
import js.html.AudioElement;

/**
 * ...
 * @author Luke Cann
 */
@:initPackage
class SoundManager {

	private var s:Map<String, AudioElement>;
	private var v:Float;

	public function new(soundDefList:Array<SoundDef>) {
		s = new Map<String, AudioElement>();
		v = 1;

		for (sd in soundDefList) {
			var url:String = untyped jsfxr(sd.d);

			var e:AudioElement = Browser.document.createAudioElement();
			e.src = url;
			s.set(sd.n, e);
		}
	}

	public function play(n:String):Void {
		s[n].currentTime = 0;
		s[n].volume = v;
		s[n].play();
	}

	private static function __init__() {
		haxe.macro.Compiler.includeFile("res/jsfxr.js");
	}
}