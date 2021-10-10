package lcann.offline.stage;

import lcann.offline.device.Device;
import lcann.offline.device.Firewall;
import lcann.offline.device.Gateway;
import lcann.offline.device.Pc;
import lcann.offline.device.Printer;
import lcann.offline.device.Switch;
import lcann.offline.resource.LvlDef;
import lcann.offline.resource.LvlDeviceDef;
import lcann.offline.resource.LvlDeviceType;

/**
 * ...
 * @author Luke Cann
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

		if (def.help != null) {
			s.addHelp(def.help.fx, def.help.fy, def.help.tx, def.help.ty);
		}

		return s;
	}

	private static inline function buildDevice(def:LvlDeviceDef):Device {
		return switch (def.type) {
			case LvlDeviceType.GATEWAY:
				new Gateway(def.subnet);
			case LvlDeviceType.PC:
				new Pc(def.subnet);
			case LvlDeviceType.PRINTER:
				new Printer(def.subnet);
			case LvlDeviceType.SWITCH:
				new Switch(def.subnet);
			case LvlDeviceType.FIREWALL:
				new Firewall();
			default:
				throw "Unknown device type: " + def.type;
		}
	}
}