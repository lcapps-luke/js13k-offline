package lcann.offline.device;

/**
 * ...
 * @author ekool
 */
class Switch extends Device {

	public function new(subnet:String) {
		super("switch", 4, subnet);
	}

}