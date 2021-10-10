package lcann.offline.geom;

/**
 * ...
 * @author Luke Cann
 */
class Line {
	public var a:Point;
	public var b:Point;

	public function new(x1:Float = 0, y1:Float = 0, x2:Float = 0, y2:Float = 0) {
		a = new Point(x1, y1);
		b = new Point(x2, y2);
	}

}