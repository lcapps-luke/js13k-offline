package lcann.offline.device;

/**
 * ...
 * @author Luke Cann
 */
class Pc extends Device {

	public function new(subnet:String) {
		super("pc", 2, subnet);
	}

}