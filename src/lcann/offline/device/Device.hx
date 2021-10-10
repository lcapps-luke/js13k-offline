package lcann.offline.device;

import js.html.CanvasRenderingContext2D;
import js.html.ImageElement;

/**
 * ...
 * @author Luke Cann
 */
class Device extends Entity {
	public var connectionLimit(default, null):Int;
	public var subnet(default, null):String;

	private var imageOffline:ImageElement;
	private var imageOnline:ImageElement;

	public var connectedDevice(default, null):List<Device>;

	private var online:Bool = false;
	private var connectionChecked:Bool = false;
	private var connectionChecking:Bool = false;

	public function new(imgName:String, limit:Int = 1, subnet:String = null) {
		connectionLimit = limit;
		this.subnet = subnet;

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

		// subnet
		var sn:String = getSubnetName();
		if (sn != null) {
			c.font = "bold 94px monospace";
			c.fillText(sn, x, y);
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
		if (connectionChecking) {
			return null;
		}

		if (!connectionChecked) {
			connectionChecking = true;

			var allChecked:Bool = true;
			for (c in connectedDevice) {
				var otherConnected:Bool = c.checkConnection();

				if (otherConnected == null) {
					allChecked = false;
					continue;
				}

				if (otherConnected) {
					online = true;
				}
			}

			connectionChecking = false;
			connectionChecked = allChecked;
		}

		return isOnline();
	}

	public function hasOpenConnections():Bool {
		return connectionLimit > connectedDevice.length;
	}

	private function getEffectiveSubnet():String {
		return subnet == null ? "" : subnet;
	}

	public function checkSubnet(other:Device, checkOther:Bool = true):Bool {
		return getEffectiveSubnet() == other.getEffectiveSubnet() || (checkOther && other.checkSubnet(this, false));
	}

	private function getSubnetName():String {
		return getEffectiveSubnet();
	}
}