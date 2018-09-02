package;

import haxe.Template;
import sys.FileSystem;
import sys.io.File;

class Main {
	private static inline var finalDir:String = "build/final/";
	private static inline var finalUnDir:String = finalDir + "uncompressed/";
	private static inline var finalMinDir:String = finalDir + "min/";

	public static function main() {
		var pageTemplate:Template = new Template(File.getContent("res/index.tpl"));
		var pageOut:String = pageTemplate.execute({src: File.getContent("build/Offline.js")});

		var workerTemplate:Template = new Template(File.getContent("res/worker.js"));
		var worker:String = workerTemplate.execute({date: DateTools.format(Date.now(), "%Y%m%d%H%M%S")});

		FileSystem.createDirectory(finalUnDir);

		File.saveContent(finalUnDir + "index.html", pageOut);
		File.copy("res/manifest.webmanifest", finalUnDir + "manifest.webmanifest");
		File.saveContent(finalUnDir + "worker.js", worker);
		File.copy("res/icon.svg", finalUnDir + "icon.svg");
		File.copy("res/icon-192.png", finalUnDir + "icon-192.png");

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

		Sys.command("uglifyjs", [
						"-c",
						"-o", finalMinDir + "worker.js",
						finalUnDir + "worker.js"]);

		Sys.command("svgo", [
						"-i", finalUnDir + "icon.svg",
						"-o", finalMinDir + "icon.svg",
						"-p", "0",
						"--enable", "removeTitle",
						"--enable", "removeDesc",
						"--enable", "removeUselessDefs",
						"--enable", "removeEditorsNSData",
						"--enable", "removeViewBox",
						"--enable", "transformsWithOnePath"]);

		File.copy(finalUnDir + "icon-192.png", finalMinDir + "icon-192.png");

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