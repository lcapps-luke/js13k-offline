package lcann.offline;

import js.html.CanvasElement;
import js.html.MouseEvent;

/**
 * ...
 * @author ekool
 */
class Controls {
	public var x(default, null):Float = 0;
	public var y(default, null):Float = 0;
	public var down(default, null):Bool = false;

	public var downListener:Float->Float->Void = null;
	public var upListener:Float->Float->Void = null;
	
	private var c:CanvasElement;

	public function new(c:CanvasElement) {
		this.c = c;
		
		c.onmousedown = onMouseDown;
		c.onmousemove = onMouseMove;
		c.onmouseup = onMouseUp;
	}
	
	private inline function getX(px:Float):Float{
		return ((px - c.offsetLeft) / c.offsetWidth) * c.width;
	}
	
	private inline function getY(py:Float):Float{
		return ((py - c.offsetTop) / c.offsetHeight) * c.height;
	}

	private function onMouseDown(e:MouseEvent) {
		down = true;
		if (downListener != null) {
			downListener(getX(e.pageX), getY(e.pageY));
		}
	}

	private function onMouseMove(e:MouseEvent) {
		x = getX(e.pageX);
		y = getY(e.pageY);
	}

	private function onMouseUp(e:MouseEvent) {
		down = false;
		if (upListener != null) {
			upListener(getX(e.pageX), getY(e.pageY));
		}
	}
}