package lcann.offline.stage;

import lcann.offline.device.Device;
import lcann.offline.device.Gateway;
import lcann.offline.device.Pc;
import lcann.offline.device.Printer;
import lcann.offline.device.Switch;
import lcann.offline.resource.LvlDef;
import lcann.offline.resource.LvlDeviceDef;
import lcann.offline.resource.LvlDeviceType;

/**
 * ...
 * @author ekool
 */
class StageBuilder {

	private function new() {

	}

	public static function build(def:LvlDef, idx:Int):Stage {
		var s:Stage = new Stage(idx);
		var dMap:Map<String, Device> = new Map<String, Device>();

		for (d in def.device) {
			var dev:Device = buildDevice(d);
			s.addDevice(d.x, d.y, dev);

			if (d.id != null) {
				dMap.set(d.id, dev);
			}
		}

		if (def.connection != null) {
			for (c in def.connection) {
				s.addConnection(dMap.get(c.a), dMap.get(c.b));
			}
		}

		return s;
	}

	private static inline function buildDevice(def:LvlDeviceDef):Device {
		return switch (def.type) {
			case LvlDeviceType.GATEWAY:
				new Gateway();
			case LvlDeviceType.PC:
				new Pc();
			case LvlDeviceType.PRINTER:
				new Printer();
			case LvlDeviceType.SWITCH:
				new Switch();
			default:
				throw "Unknown device type: " + def.type;
		}
	}
}