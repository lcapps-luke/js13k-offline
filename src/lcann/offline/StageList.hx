package lcann.offline;

import js.html.CanvasRenderingContext2D;
import js.html.TextMetrics;
import lcann.offline.grid.Grid;
import lcann.offline.resource.LvlDef;

/**
 * ...
 * @author ekool
 */
class StageList extends Entity {
	private var grid:Grid;
	private var lvlEnt:Array<LvlEnt>;

	public function new(lvlList:Array<LvlDef>) {
		grid = new Grid(5, 16, 10);
		lvlEnt = new Array<LvlEnt>();

		var gy:Int = 0;
		for (d in lvlList) {
			var e:LvlEnt = new LvlEnt(d.name);

			lvlEnt.push(e);
			grid.addCell(0, gy, 4, 1, e);

			gy++;
		}

		Main.controls.downListener = onDown;
	}

	private function onDown(x:Float, y:Float) {
		var touchEntity:LvlEnt = cast grid.getEntityAt(x, y);
		if (touchEntity != null) {
			var id:Int = lvlEnt.indexOf(touchEntity);

			Main.setScreenToStage(id);
		}
	}

	override public function update(s:Float, c:CanvasRenderingContext2D) {
		super.update(s, c);

		c.fillStyle = "#f00";
		c.font = "bold 240px monospace";

		var met:TextMetrics = c.measureText("Offline");
		c.fillText("Offline", width / 2 - met.width / 2, 240);

		grid.y = 240;
		grid.width = width;
		grid.height = height - 240;
		grid.update(s, c);
	}
}

private class LvlEnt extends Entity {
	private var name:String;

	public function new(name:String) {
		this.name = name;
	}

	override public function update(s:Float, c:CanvasRenderingContext2D) {
		super.update(s, c);

		c.fillStyle = "#fff";
		c.font = "bold " + height + "px monospace";

		c.fillText(name, x, y + height);
	}
}