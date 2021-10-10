package lcann.offline.device;

import lcann.offline.device.Device;

/**
 * ...
 * @author Luke Cann
 */
class Switch extends Device {
	private var effectiveSubnet:String;

	private var updatingSubnet:Bool = false;
	private var subnetUpdated:Bool = false;

	public function new(subnet:String) {
		super("switch", 4, subnet);
	}

	override public function resetConnection() {
		super.resetConnection();
		subnetUpdated = false;
		effectiveSubnet = null;
	}

	override public function checkConnection():Bool {
		if (!connectionChecking && !connectionChecked) {
			updateSubnet();
		}

		return super.checkConnection();
	}

	public function updateSubnet():Bool {
		if (updatingSubnet) {
			return false;
		}

		if (subnetUpdated) {
			return true;
		}

		updatingSubnet = true;

		for (d in connectedDevice) {
			if (Std.is(d, Firewall)) {
				continue;
			}

			if (Std.is(d, Switch)) {
				if (!cast (d, Switch).updateSubnet() || d.getEffectiveSubnet() == null) {
					continue;
				}
			}

			if (!subnetUpdated) {
				effectiveSubnet = d.getEffectiveSubnet();
				subnetUpdated = true;
			}
		}

		updatingSubnet = false;
		return true;
	}

	override function getSubnetName():String {
		return effectiveSubnet == null || effectiveSubnet.length == 0 ? subnet : "~" + effectiveSubnet;
	}

	override function getEffectiveSubnet():String {
		return subnet == null ? effectiveSubnet : super.getEffectiveSubnet();
	}

	override function checkSubnet(other:Device, checkOther:Bool = true):Bool {
		return getEffectiveSubnet() == null || super.checkSubnet(other, checkOther);
	}
}