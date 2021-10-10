package lcann.offline.resource;

#if macro
	import haxe.io.Path;
	import sys.io.File;
	import sys.FileSystem;
	import haxe.macro.Context;
	import haxe.Json;
#end

/**
 * ...
 * @author Luke Cann
 */
class ResBuilder {
	private static inline var imagePath = "res/svg/";

	macro public static function build() {
		// Images
		var images:Array<ImgDef> = new Array<ImgDef>();
		var imagePath:String = "res/svg/";
		var imagePathMin:String = "build/svgmin/";
		FileSystem.createDirectory(imagePathMin);

		Sys.command("svgo", [
						"-f", imagePath,
						"-o", imagePathMin,
						"-p", "0",
						"--enable", "removeTitle",
						"--enable", "removeDesc",
						"--enable", "removeUselessDefs",
						"--enable", "removeEditorsNSData",
						"--enable", "removeViewBox",
						"--enable", "transformsWithOnePath"]);

		for (f in FileSystem.readDirectory(imagePathMin)) {
			var path:Path = new Path(imagePathMin + f);
			if (path.ext == "svg") {
				images.push(buildImage(path));
			}
		}

		// Levels
		var levels:Array<LvlDef> = new Array<LvlDef>();
		var lvlPath:String = "res/level/";
		for (f in FileSystem.readDirectory(lvlPath)) {
			var path:Path = new Path(lvlPath + f);
			if (path.ext == "json") {
				levels.push(buildLevel(path));
			}
		}

		// Sounds
		var sounds:Array<SoundDef> = new Array<SoundDef>();
		var soundPath:String = "res/sound/";
		for (f in FileSystem.readDirectory(soundPath)) {
			var path:Path = new Path(soundPath + f);
			if (path.ext == "txt") {
				sounds.push(buildSound(path));
			}
		}

		// Construct resource type
		var c = macro class R {
			public var img:Array<lcann.offline.resource.ImgDef> = $v { images };
			public var lvl:Array<lcann.offline.resource.LvlDef> = $v { levels };
			public var snd:Array<lcann.offline.resource.SoundDef> = $v { sounds };
			public function new() {}
		}

		Context.defineType(c);

		return macro new R();
	}

	#if macro
	private static function buildImage(path:Path):ImgDef {
		var content:String = File.getContent(path.toString());

		return {
			name: path.file,
			data: content
		};
	}

	private static function buildLevel(path:Path):LvlDef {
		var content:String = File.getContent(path.toString());
		return cast Json.parse(content);
	}

	private static function buildSound(path:Path):SoundDef {
		var txt = File.getContent(path.toString());

		var arr:Array<Float> = new Array<Float>();

		for (t in txt.split(",")) {
			arr.push(t.length > 0 ? Std.parseFloat(t) : 0);
		}

		return {
			n: path.file,
			d: arr
		}
	}
	#end
}