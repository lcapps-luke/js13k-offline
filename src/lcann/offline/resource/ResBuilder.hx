package lcann.offline.resource;

#if macro
import haxe.io.Path;
import sys.io.File;
import sys.FileSystem;
import haxe.macro.Context;

import lcann.offline.resource.ImgDef;
#end

/**
 * ...
 * @author ekool
 */
class ResBuilder 
{
	private static inline var imagePath = "res/svg/";

	macro public static function build() 
	{
		// Images
		var images:Array<ImgDef> = new Array<ImgDef>();
		var imagePath:String = "res/svg/";
		for (f in FileSystem.readDirectory(imagePath)) {
			var path:Path = new Path(imagePath + f);
			if(path.ext == "svg"){
				images.push(buildImage(path));
			}
		}
		
		// Construct resource type
		var c = macro class R {
			public var img:Array<lcann.offline.resource.ImgDef> = $v { images };
			public function new(){}
		}
		
		Context.defineType(c);
		
		return macro new R();
	}
	
	#if macro
	private static function buildImage(path:Path):ImgDef{
		var content:String = File.getContent(path.toString());
		
		return {
			name: path.file,
			data: content
		};
	}
	#end
}