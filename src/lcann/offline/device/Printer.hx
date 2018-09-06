package lcann.offline.device;

/**
 * ...
 * @author ekool
 */
class Printer extends Device {

	public function new(subnet:String) {
		super("printer", 1, subnet);
	}

}