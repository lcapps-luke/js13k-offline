package lcann.offline.geom;

/**
 * ...
 * @author ekool
 */
class LineIntersect {

	private function new() {

	}

	// https://stackoverflow.com/a/1968345
	public static function check(a:Line, b:Line):Point {
		var s1:Point = a.b.minus(a.a);
		var s2:Point = b.b.minus(b.a);

		var s:Float = (-s1.y * (a.a.x - b.a.x) + s1.x * (a.a.y - b.a.y)) / (-s2.x * s1.y + s1.x * s2.y);
		var t:Float = ( s2.x * (a.a.y - b.a.y) - s2.y * (a.a.x - b.a.x)) / (-s2.x * s1.y + s1.x * s2.y);

		if (s >= 0 && s <= 1 && t >= 0 && t <= 1) {
			return new Point(a.a.x + t * s1.x, a.a.y + t * s1.y);
		}

		return null;
	}

}