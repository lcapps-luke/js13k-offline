package lcann.offline.stage;

import js.html.CanvasRenderingContext2D;
import js.html.TextMetrics;
import lcann.offline.Annotation;
import lcann.offline.device.Connection;
import lcann.offline.device.Device;
import lcann.offline.geom.Line;
import lcann.offline.geom.LineIntersect;
import lcann.offline.geom.Point;
import lcann.offline.grid.Grid;

/**
 * ...
 * @author ekool
 */
class Stage extends Entity {
	private static inline var backRegion:Float = 240;

	private var index:Int;

	private var grid:Grid;
	private var connectionList:List<Connection>;

	private var connectFrom:Device = null;
	private var cutFrom:Point = null;

	private var allOnline:Bool = false;
	private var transitionTimer:Float = 1;

	private var backIcon:Annotation;
	private var downOnBack:Bool = false;

	public function new(index:Int) {
		this.index = index;
		grid = new Grid(9, 16, 10);
		connectionList = new List<Connection>();
		Main.controls.downListener = onDown;
		Main.controls.upListener = onUp;
		backIcon = new Annotation("back_green");
		backIcon.width = backRegion;
		backIcon.height = backRegion;
	}

	override public function update(s:Float, c:CanvasRenderingContext2D) {
		super.update(s, c);
		grid.x = x;
		grid.y = y;
		grid.width = width;
		grid.height = height;

		for (con in connectionList) {
			updateConnection(con, s, c);
		}

		var stateText:String = "Offline";

		if (allOnline) {
			transitionTimer -= s;
			if (transitionTimer <= 0) {
				Main.setScreenToLevelSelect(index, true);
			}

			c.fillStyle = "#0f0";
			stateText = "Online";
		} else {
			if (connectFrom != null) {
				c.strokeStyle = "#00f";
				c.lineWidth = 3;
				c.beginPath();
				c.moveTo(connectFrom.x + connectFrom.width / 2, connectFrom.y + connectFrom.height / 2);
				c.lineTo(Main.controls.x, Main.controls.y);
				c.stroke();
			}

			if (cutFrom != null) {
				c.strokeStyle = "#f00";
				c.lineWidth = 3;
				c.beginPath();
				c.moveTo(cutFrom.x, cutFrom.y);
				c.lineTo(Main.controls.x, Main.controls.y);
				c.stroke();
			}

			c.fillStyle = "#f00";
		}

		c.font = "bold 240px monospace";
		var met:TextMetrics = c.measureText(stateText);
		c.fillText(stateText, width / 2 - met.width / 2, 240);

		grid.update(s, c);
		backIcon.update(s, c);
	}

	private function updateConnection(connection:Connection, s:Float, c:CanvasRenderingContext2D) {
		inline function centerX(d:Device):Float {
			return d.x + d.width / 2;
		}

		inline function centerY(d:Device):Float {
			return d.y +d.height / 2;
		}

		c.strokeStyle = "#0f0";
		c.lineWidth = 3;
		c.beginPath();
		c.moveTo(centerX(connection.a), centerY(connection.a));
		c.lineTo(centerX(connection.b), centerY(connection.b));
		c.stroke();
	}

	private function checkDeviceConnections() {
		for (e in grid) {
			var d:Device = cast e.e;
			d.resetConnection();
		}

		var allOnline:Bool = true;

		for (e in grid) {
			var d:Device = cast e.e;
			if (!d.checkConnection()) {
				allOnline = false;
			}
		}

		this.allOnline = allOnline;
		if (allOnline) {
			Main.sound.play("online");
		}
	}

	public function addDevice(x:Int, y:Int, device:Device) {
		grid.addCell(x, y, 1, 1, device);
	}

	public function getConnection(a:Device, b:Device) : Connection {
		for (c in connectionList) {
			if ((c.a == a || c.b == a) && (c.a == b || c.b == b)) {
				return c;
			}
		}
		return null;
	}

	public function addConnection(a:Device, b:Device, check:Bool = true):Bool {
		// no self-connections (eww)
		if (a == b) {
			return false;
		}

		// validate connection limits
		if (!a.hasOpenConnections() || !b.hasOpenConnections()) {
			return false;
		}

		// validate subnet
		if (!a.checkSubnet(b)) {
			return false;
		}

		// skip if connection already exists
		var existing:Connection = getConnection(a, b);
		if (existing != null) {
			return false;
		}

		connectionList.add({
			a: a,
			b: b
		});

		a.connectedDevice.add(b);
		b.connectedDevice.add(a);

		if (check) {
			checkDeviceConnections();
		}

		return true;
	}

	public function removeConnection(a:Device, b:Device, check:Bool = true) {
		var existing:Connection = getConnection(a, b);
		if (existing != null) {
			connectionList.remove(existing);
			a.connectedDevice.remove(b);
			b.connectedDevice.remove(a);
		}

		if (check) {
			checkDeviceConnections();
		}
	}

	private function onDown(x:Float, y:Float) {
		if (allOnline) {
			return;
		}

		connectFrom = cast grid.getEntityAt(x, y);

		if (connectFrom == null) {
			if (x < backRegion && y < backRegion) {
				downOnBack = true;
			}

			cutFrom = new Point(x, y);
		}
	}

	private function onUp(x:Float, y:Float) {
		if (downOnBack && x < backRegion && y < backRegion) {
			Main.setScreenToLevelSelect();
			Main.sound.play("select");
			return;
		}

		if (connectFrom == null) {
			if (cutFrom != null) {
				doCut(new Line(cutFrom.x, cutFrom.y, x, y));
				Main.sound.play("cut");
			}
		} else {
			var connectTo:Device = cast grid.getEntityAt(x, y);

			if (connectFrom != null && connectTo != null) {
				if (addConnection(connectFrom, connectTo)) {
					Main.sound.play("connect");
				} else {
					Main.sound.play("noconnect");
				}
			}
		}

		connectFrom = null;
		cutFrom = null;
		downOnBack = true;
	}

	private function doCut(cutLine:Line) {
		inline function cx(d:Device):Float {
			return d.x + d.width / 2;
		}

		inline function cy(d:Device):Float {
			return d.y +d.height / 2;
		}

		var cutConnectionList:List<Connection> = new List<Connection>();
		var connectionLine:Line = new Line();

		for (c in connectionList) {
			connectionLine.a.set(cx(c.a), cy(c.a));
			connectionLine.b.set(cx(c.b), cy(c.b));

			var intersect:Point = LineIntersect.check(cutLine, connectionLine);
			if (intersect != null) {
				cutConnectionList.add(c);
			}
		}

		for (c in cutConnectionList) {
			removeConnection(c.a, c.b, false);
		}

		if (!cutConnectionList.isEmpty()) {
			checkDeviceConnections();
		}
	}
}