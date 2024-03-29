package lcann.offline;

import js.Browser;
import js.html.Storage;

/**
 * ...
 * @author Luke Cann
 */
class Save {
	private static inline var PREFIX = "uk.co.lc-apps.offline.";
	private var storage:Storage;
	private var failoverMap:Map<String, String> = new Map<String, String>();

	public function new() {
		storage = Browser.getLocalStorage();
	}

	private function getValue(key:String):String {
		return storage == null ? failoverMap.get(key) : storage.getItem(PREFIX + key);
	}

	private function setValue(key:String, value:String) {
		if (storage == null) {
			failoverMap.set(key, value);
		} else {
			storage.setItem(PREFIX + key, value);
		}
	}

	public function isLevelComplete(i:Int):Bool {
		var complete:String = getValue("level_" + Std.string(i));
		return complete == null ? false : (complete == "t");
	}

	public function setLevelComplete(i:Int, complete:Bool = true) {
		setValue("level_" + Std.string(i), complete ? "t" : "f");
	}
}