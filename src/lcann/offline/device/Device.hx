package lcann.offline.device;

import js.html.CanvasRenderingContext2D;
import js.html.ImageElement;

/**
 * ...
 * @author ekool
 */
class Device extends Entity {
	public var connectionLimit(default, null):Int;
	private var imageOffline:ImageElement;
	private var imageOnline:ImageElement;

	public var connectedDevice(default, null):List<Device>;

	private var online:Bool = false;
	private var connectionChecked:Bool = false;

	public function new(imgName:String, limit:Int = 1) {
		connectionLimit = limit;
		connectedDevice = new List<Device>();

		this.imageOffline = Main.imageMap.get(imgName + "_red");
		this.imageOnline = Main.imageMap.get(imgName + "_green");
	}

	override public function update(s:Float, c:CanvasRenderingContext2D) {
		super.update(s, c);

		var img:ImageElement = isOnline() ? imageOnline : imageOffline;
		c.drawImage(img, 0, 0, img.width, img.height, x, y, width, height);

		c.fillStyle = "#fff";
		c.strokeStyle = "#fff";
		c.lineWidth = 3;

		// connection limits
		var cr:Float = width / 8;
		for (i in 0...connectionLimit) {
			var cx:Float = (cr * 2) * i + cr;

			c.beginPath();
			c.ellipse(x + cx, y + height + cr, cr, cr, 0, 0, Math.PI * 2);
			if (i < connectedDevice.length) {
				c.fill();
			} else {
				c.stroke();
			}
		}

		// online status
		if (isOnline()) {
			c.beginPath();
			c.ellipse(x + width - cr, y - cr, cr, cr / 2, 0, 0, Math.PI * 2);
			c.fill();
		} else {
			c.beginPath();
			c.ellipse(x + width - cr * 2, y - cr, cr / 2, cr, Math.PI * 0.5, 0, Math.PI);
			c.fill();

			c.beginPath();
			c.ellipse(x + width - cr, y - cr, cr / 2, cr, Math.PI * 0.5, Math.PI, Math.PI * 2);
			c.fill();
		}
	}

	public function isOnline():Bool {
		return online;
	}

	public function resetConnection() {
		connectionChecked = false;
		online = false;
	}

	public function checkConnection():Bool {
		if (!connectionChecked) {
			connectionChecked = true;
			for (c in connectedDevice) {
				if (c.checkConnection()) {
					online = true;
				}
			}
		}

		return isOnline();
	}

	public function hasOpenConnections():Bool {
		return connectionLimit > connectedDevice.length;
	}
}