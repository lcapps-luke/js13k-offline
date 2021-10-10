package lcann.offline;

import js.html.CanvasElement;
import js.html.MouseEvent;
import js.html.TouchEvent;

/**
 * ...
 * @author Luke Cann
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

		c.ontouchstart = onTouchStart;
		c.ontouchmove = onTouchMove;
		c.ontouchend = onTouchEnd;
	}

	private inline function getX(px:Float):Float {
		return ((px - c.offsetLeft) / c.offsetWidth) * c.width;
	}

	private inline function getY(py:Float):Float {
		return ((py - c.offsetTop) / c.offsetHeight) * c.height;
	}

	private function onMouseDown(e:MouseEvent) {
		down = true;

		x = getX(e.pageX);
		y = getY(e.pageY);

		if (downListener != null) {
			downListener(x, y);
		}
	}

	private function onMouseMove(e:MouseEvent) {
		x = getX(e.pageX);
		y = getY(e.pageY);
	}

	private function onMouseUp(e:MouseEvent) {
		down = false;

		x = getX(e.pageX);
		y = getY(e.pageY);

		if (upListener != null) {
			upListener(x, y);
		}
	}

	private function onTouchStart(e:TouchEvent) {
		down = true;

		x = getX(e.touches.item(0).pageX);
		y = getY(e.touches.item(0).pageY);

		if (downListener != null) {
			downListener(x, y);
		}
	}

	private function onTouchMove(e:TouchEvent) {
		x = getX(e.touches.item(0).pageX);
		y = getY(e.touches.item(0).pageY);
	}

	private function onTouchEnd(e:TouchEvent) {
		down = false;

		x = getX(e.changedTouches.item(0).pageX);
		y = getY(e.changedTouches.item(0).pageY);

		if (upListener != null) {
			upListener(x, y);
		}
	}
}