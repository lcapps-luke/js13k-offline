package lcann.offline.resource;

/**
 * @author ekool
 */
typedef LvlDef = {
	var name:String;
	var device:Array<LvlDeviceDef>;
	@:optional var connection:Array<LvlConnectionDef>;
}