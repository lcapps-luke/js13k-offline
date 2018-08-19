package lcann.offline.grid;

import lcann.offline.Entity;
import js.html.CanvasRenderingContext2D;
import js.Browser;

/**
 * ...
 * @author ekool
 */
class Grid extends Entity
{
	public var hCell:Int;
	public var vCell:Int;
	public var cellPad:Float;
	
	private var cell:List<Cell>;
	
	public function new(hCell:Int, vCell:Int, cellPad:Float = 5) 
	{
		cell = new List<Cell>();
		this.hCell = hCell;
		this.vCell = vCell;
		this.cellPad = cellPad;
	}
	
	public function addCell(x:Int, y:Int, w:Int, h:Int, e:Entity){
		cell.add({
			x: x,
			y: y,
			w: w,
			h: h,
			e: e
		});
	}
	
	override public function update(s:Float, c:CanvasRenderingContext2D) 
	{
		super.update(s, c);
		
		var cellWidth:Float = width / hCell;
		var cellHeight:Float = height / vCell;
		
		for(i in cell){
			i.e.x = x + cellWidth * i.x + cellPad;
			i.e.y = y + cellHeight * i.y + cellPad;
			i.e.width = cellWidth * i.w - cellPad * 2;
			i.e.height = cellHeight * i.h - cellPad * 2;
			
			i.e.update(s, c);
		}
	}
}