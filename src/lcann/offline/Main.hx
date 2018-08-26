package lcann.offline;

import js.Browser;
import js.html.CanvasElement;
import js.html.CanvasRenderingContext2D;
import js.html.ImageElement;
import js.html.TextMetrics;
import lcann.offline.device.Pc;
import lcann.offline.grid.Grid;
import lcann.offline.resource.ImageLoader;
import lcann.offline.resource.ResBuilder;

class Main {
	private static var r(default, null) = ResBuilder.build();

	private static var canvas:CanvasElement;
	private static var context:CanvasRenderingContext2D;

	private static var lastTime:Float;

	public static var imageMap:Map<String, ImageElement>;
	public static var controls:Controls;

	private static var grid:Grid;
	private static var stage:Stage;

	public static function main() {
		canvas = cast Browser.window.document.getElementsByTagName("canvas").item(0);
		context = canvas.getContext2d();
		
		controls = new Controls(canvas);

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
		/*
		var pc:Pc = new Pc();
		grid.addCell(3, 7, 3, 3, pc);

		grid.addCell(0, 0, 1, 1, new Pc());
		grid.addCell(8, 15, 1, 1, new Pc());
		*/
		stage = new Stage();
		grid.addCell(0, 0, 9, 16, stage);

		//demo stage
		var a = new Pc();
		var b = new Pc();

		stage.addDevice(3, 3, a);
		stage.addDevice(6, 13, b);
		//stage.addConnection(a, b);
	}

	private static function step(ms:Float) {
		var delta:Float = ms - lastTime;
		lastTime = ms;

		context.fillStyle = "#000";
		context.fillRect(0, 0, canvas.width, canvas.height);

		context.strokeStyle = "#fff";
		context.lineWidth = 1;

		for (x in 0...9) {
			var xx = canvas.width / 9 * x;
			context.beginPath();
			context.moveTo(xx, 0);
			context.lineTo(xx, canvas.height);
			context.stroke();

			for (y in 0...16) {
				var yy = canvas.height / 16 * y;
				context.beginPath();
				context.moveTo(0, yy);
				context.lineTo(canvas.width, yy);
				context.stroke();
			}
		}

		context.fillStyle = "#f00";
		context.font = "bold 240px monospace";

		var met:TextMetrics = context.measureText("Offline");
		context.fillText("Offline", canvas.width / 2 - met.width / 2, 240);

		grid.update(delta, context);

		Browser.window.requestAnimationFrame(step);
	}

}