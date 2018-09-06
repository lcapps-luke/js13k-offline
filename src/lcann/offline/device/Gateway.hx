package lcann.offline.device;

/**
 * ...
 * @author ekool
 */
class Gateway extends Device {

	public function new(subnet:String) {
		super("gateway", 1, subnet);
	}

	override public function isOnline():Bool {
		return true;
	}

	override public function checkConnection():Bool {
		return true;
	}

}