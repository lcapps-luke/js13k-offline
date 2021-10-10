package lcann.offline.grid;

import js.html.CanvasRenderingContext2D;
import lcann.offline.Entity;

/**
 * ...
 * @author Luke Cann
 */
class Grid extends Entity {
	public var hCell:Int;
	public var vCell:Int;
	public var cellPad:Float;

	private var cell:List<Cell>;

	public function new(hCell:Int, vCell:Int, cellPad:Float = 5) {
		cell = new List<Cell>();
		this.hCell = hCell;
		this.vCell = vCell;
		this.cellPad = cellPad;
	}

	public function addCell(x:Int, y:Int, w:Int, h:Int, e:Entity) {
		cell.add( {
			x: x,
			y: y,
			w: w,
			h: h,
			e: e
		});
	}

	override public function update(s:Float, c:CanvasRenderingContext2D) {
		super.update(s, c);

		var cellWidth:Float = width / hCell;
		var cellHeight:Float = height / vCell;

		for (i in cell) {
			i.e.x = x + cellWidth * i.x + cellPad;
			i.e.y = y + cellHeight * i.y + cellPad;
			i.e.width = cellWidth * i.w - cellPad * 2;
			i.e.height = cellHeight * i.h - cellPad * 2;

			i.e.update(s, c);
		}
	}

	public function getEntityAt(x:Float, y:Float):Entity {
		var gx:Float = x - this.x;
		var gy:Float = y - this.y;

		if (gx < 0 || gx > width || gy < 0 || gy > height) {
			return null;
		}

		var cellWidth:Float = width / hCell;
		var cellHeight:Float = height / vCell;

		var cx:Int = Math.floor(gx / cellWidth);
		var cy:Int = Math.floor(gy / cellHeight);

		var cell:Cell = getCell(cx, cy);
		return cell == null ? null : cell.e;
	}

	private function getCell(x:Int, y:Int):Cell {
		for (c in cell) {
			if (x >= c.x && x < c.x + c.w && y >= c.y&& y < c.y + c.h) {
				return c;
			}
		}
		return null;
	}

	public function removeCell(x:Int, y:Int) {
		cell.remove(getCell(x, y));
	}

	public function getCenterX(x:Int) {
		return (width / hCell) * (x + 0.5);
	}

	public function getCenterY(y:Int) {
		return (height / vCell) * (y + 0.5);
	}
}