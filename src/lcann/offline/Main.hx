package lcann.offline;

import js.Browser;
import js.html.CanvasElement;
import js.html.CanvasRenderingContext2D;
import js.html.ImageElement;
import lcann.offline.grid.Grid;
import lcann.offline.resource.ImageLoader;
import lcann.offline.resource.ResBuilder;
import lcann.offline.stage.StageBuilder;

class Main {
	private static var r(default, null) = ResBuilder.build();

	private static var canvas:CanvasElement;
	private static var context:CanvasRenderingContext2D;

	private static var lastTime:Float;

	public static var imageMap(default, null):Map<String, ImageElement>;
	public static var controls(default, null):Controls;
	public static var save(default, null):Save;

	private static var grid:Grid;
	private static var screen:Entity;

	public static function main() {
		canvas = cast Browser.window.document.getElementsByTagName("canvas").item(0);
		context = canvas.getContext2d();

		controls = new Controls(canvas);
		save = new Save();

		new ImageLoader(r.img, function(i:Map<String, ImageElement>) {
			imageMap = i;

			init();

			lastTime = Browser.window.performance.now();
			step(lastTime);
		});
	}

	private static function init() {
		grid = new Grid(9, 16, 10);
		grid.x = 0;
		grid.y = 0;
		grid.width = canvas.width;
		grid.height = canvas.height;

		setScreenToLevelSelect();
	}

	public static function setScreenToLevelSelect(unlockFrom:Int = -1, markLevelComplete:Bool = false) {
		if (markLevelComplete) {
			save.setLevelComplete(unlockFrom);
		}

		setScreen(new StageList(r.lvl, unlockFrom));
	}

	public static function setScreenToStage(stgIdx:Int) {
		setScreen(StageBuilder.build(r.lvl[stgIdx], stgIdx));
	}

	private static function setScreen(entity:Entity) {
		if (screen != null) {
			grid.removeCell(0, 0);
		}
		screen = entity;
		grid.addCell(0, 0, 9, 16, screen);
	}

	private static function step(ms:Float) {
		var delta:Float = (ms - lastTime) / 1000;
		lastTime = ms;

		context.fillStyle = "#000";
		context.fillRect(0, 0, canvas.width, canvas.height);

		grid.update(delta, context);

		Browser.window.requestAnimationFrame(step);
	}

}