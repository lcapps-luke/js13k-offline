package lcann.offline.resource;

import js.Browser;
import js.html.ImageElement;

/**
 * ...
 * @author ekool
 */
class ImageLoader {
	private var img:Map<String, ImageElement>;
	private var loadCount:Int;
	private var callback:Map<String, ImageElement>->Void;

	public function new(def:Array<ImgDef>, callback:Map<String, ImageElement>->Void) {
		var colours:Array<Dynamic> = [ {n: "red", c: "#FF0000"}, {n: "green", c: "#00FF00"}];

		img = new Map<String, ImageElement>();
		loadCount = def.length * colours.length;
		this.callback = callback;

		for (d in def) {
			for (c in colours) {
				var data = "data:image/svg+xml;base64," + Browser.window.btoa(StringTools.replace(d.data, "#FFFFFF", c.c));
				var name = d.name + "_" + c.n;

				var i:ImageElement = cast Browser.window.document.createElement("img");
				i.onload = loadCallback;
				i.onerror = function() {
					Browser.console.error("Failed to load image resource: " + name);
				}
				i.src = data;

				img.set(name, i);

			}
		}
	}

	private function loadCallback() {
		loadCount--;

		if (loadCount == 0) {
			callback(img);
		}
	}
}