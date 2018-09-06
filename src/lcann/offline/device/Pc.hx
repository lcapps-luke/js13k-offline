package lcann.offline.device;

/**
 * ...
 * @author ekool
 */
class Pc extends Device {

	public function new(subnet:String) {
		super("pc", 2, subnet);
	}

}