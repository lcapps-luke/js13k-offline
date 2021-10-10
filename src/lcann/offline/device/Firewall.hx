package lcann.offline.device;

/**
 * ...
 * @author Luke Cann
 */
class Firewall extends Device {

	public function new() {
		super("firewall", 3);
	}

	override public function checkSubnet(other:Device, checkOther:Bool = true):Bool {
		return true;
	}

}