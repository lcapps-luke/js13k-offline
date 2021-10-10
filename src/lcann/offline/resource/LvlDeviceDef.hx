package lcann.offline.resource;

/**
 * @author Luke Cann
 */
typedef LvlDeviceDef = {
	var type:String;
	var x:Int;
	var y:Int;
	@:optional var id:String;
	@:optional var subnet:String;
}