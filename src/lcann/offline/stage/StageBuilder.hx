package lcann.offline.stage;

import lcann.offline.device.Device;
import lcann.offline.device.Gateway;
import lcann.offline.device.Pc;
import lcann.offline.device.Printer;
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

	public static function build(def:LvlDef):Stage {
		var s:Stage = new Stage();

		for (d in def.device) {
			var dev:Device = buildDevice(d);
			s.addDevice(d.x, d.y, dev);
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
			default:
				throw "Unknown device type: " + def.type;
		}
	}
}