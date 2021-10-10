package lcann.offline.stage;

import js.html.CanvasRenderingContext2D;
import lcann.offline.Annotation;
import lcann.offline.grid.Grid;

/**
 * ...
 * @author Luke Cann
 */
class HelpGuide extends Annotation {
	private var grid:Grid;
	private var tx:Int;
	private var ty:Int;

	public function new(grid:Grid, tx:Int, ty:Int) {
		super("touch_green");

		this.grid = grid;
		this.tx = tx;
		this.ty = ty;
	}

	override public function update(s:Float, c:CanvasRenderingContext2D) {
		super.update(s, c);

		c.strokeStyle = "#888";
		c.lineWidth = 10;

		c.beginPath();
		c.moveTo(x + width * 0.25, y + height * 0.25);
		c.lineTo(grid.getCenterX(tx), grid.getCenterY(ty));
		c.stroke();
	}

}