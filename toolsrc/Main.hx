package;

import haxe.Template;
import sys.FileSystem;
import sys.io.File;

class Main {
	private static inline var finalDir:String = "build/final/";
	private static inline var finalUnDir:String = finalDir + "uncompressed/";
	private static inline var finalMinDir:String = finalDir + "min/";

	public static function main() {
		var pageTemplate:String = File.getContent("res/index.tpl");
		var script:String = File.getContent("build/Offline.js");

		var tpl:Template = new Template(pageTemplate);
		var out:String = tpl.execute({src: script});

		FileSystem.createDirectory(finalUnDir);

		File.saveContent(finalUnDir + "index.html", out);
		File.copy("res/manifest.webmanifest", finalUnDir + "manifest.webmanifest");

		// minify
		FileSystem.createDirectory(finalMinDir);
		Sys.command("html-minifier", [
						"--collaspse-boolean-attributes",
						"--collapse-inline-tag-whitespace",
						"--collapse-whitespace",
						"--decode-entities",
						"--html5",
						"--minify-css",
						"--minify-js",
						"--remove-attribute-quotes",
						"--remove-comments",
						"--remove-empty-attributes",
						"--remove-optional-tags",
						"--remove-redundant-attributes",
						"--use-short-doctype",
						"-o", finalMinDir + "index.html",
						finalUnDir + "index.html"]);

		File.copy(finalUnDir + "manifest.webmanifest", finalMinDir + "manifest.webmanifest");

		// Compress
		var finalZip:String = finalDir + "Offline.zip";
		if (FileSystem.exists(finalZip)) {
			FileSystem.deleteFile(finalZip);
		}
		Sys.command("7z", ["a", finalZip, "./" + finalMinDir + "*"]);

		// Report
		var bytes:Int = FileSystem.stat(finalDir + "Offline.zip").size;
		trace(Std.string(bytes / 1024) + " / 13kb bytes used!");
	}

}