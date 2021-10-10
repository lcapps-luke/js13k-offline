package lcann.offline.resource;

/**
 * @author Luke Cann
 */
typedef LvlDef = {
	var name:String;
	var device:Array<LvlDeviceDef>;
	@:optional var connection:Array<LvlConnectionDef>;
	@:optional var help:LvlHelpDef;
}