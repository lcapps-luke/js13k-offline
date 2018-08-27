package lcann.offline;

import js.html.CanvasRenderingContext2D;
import lcann.offline.device.Connection;
import lcann.offline.device.Device;
import lcann.offline.grid.Grid;

/**
 * ...
 * @author ekool
 */
class Stage extends Entity {
	private var grid:Grid;
	private var connectionList:List<Connection>;

	private var connectFrom:Device = null;

	public function new() {
		grid = new Grid(9, 16, 10);
		connectionList = new List<Connection>();
		Main.controls.downListener = onDown;
		Main.controls.upListener = onUp;
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

		if (connectFrom != null) {
			c.strokeStyle = "#00f";
			c.lineWidth = 3;
			c.beginPath();
			c.moveTo(connectFrom.x + connectFrom.width / 2, connectFrom.y + connectFrom.height / 2);
			c.lineTo(Main.controls.x, Main.controls.y);
			c.stroke();
		}

		grid.update(s, c);
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

		for (e in grid) {
			var d:Device = cast e.e;
			d.checkConnection();
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

	public function addConnection(a:Device, b:Device, check:Bool = true) {
		//validate connection limits
		if (!a.hasOpenConnections() || !b.hasOpenConnections()) {
			return;
		}

		// skip if connection already exists
		var existing:Connection = getConnection(a, b);
		if (existing != null) {
			return;
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
		connectFrom = cast grid.getEntityAt(x, y);
	}

	private function onUp(x:Float, y:Float) {
		var connectTo:Device = cast grid.getEntityAt(x, y);

		if (connectFrom != null && connectTo != null) {
			addConnection(connectFrom, connectTo);
		}

		connectFrom = null;
	}
}