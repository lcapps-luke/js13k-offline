package lcann.offline.geom;

/**
 * ...
 * @author ekool
 */
class Point {
	public var x:Float;
	public var y:Float;

	public function new(x:Float = 0, y:Float = 0) {
		this.x = x;
		this.y = y;
	}

	public function set(x:Float, y:Float) {
		this.x = x;
		this.y = y;
	}

	public function minus(other:Point):Point {
		return new Point(x - other.x, y - other.y);
	}
}