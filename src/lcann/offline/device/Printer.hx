package lcann.offline.device;

/**
 * ...
 * @author Luke Cann
 */
class Printer extends Device {

	public function new(subnet:String) {
		super("printer", 1, subnet);
	}

}