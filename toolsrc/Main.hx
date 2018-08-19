package;

import haxe.io.Bytes;
import haxe.io.Output;
import haxe.zip.Entry;
import sys.FileSystem;
import sys.io.File;
import haxe.Template;
import zip.ZipWriter;

class Main{
	private static inline var finalDir:String = "build/final/";
	private static inline var finalUnDir:String = finalDir + "uncompressed/";
	
	public static function main(){
		var pageTemplate:String = File.getContent("res/index.tpl");
		var script:String = File.getContent("build/Offline.js");

		var tpl:Template = new Template(pageTemplate);
		var out:String = tpl.execute({src: script});

		if(FileSystem.exists(finalDir)){
			//FileSystem.deleteDirectory(finalDir);
		}
		FileSystem.createDirectory(finalUnDir);
		
		File.saveContent(finalUnDir + "index.html", out);
		File.copy("res/manifest.webmanifest", finalUnDir + "manifest.webmanifest");
		
		// Compress
		var writer:ZipWriter = new ZipWriter();
		
		for (name in FileSystem.readDirectory(finalUnDir)){
			writer.addBytes(File.getBytes(finalUnDir + name), name, false);
		}
		
		var outFile:Output = File.write(finalDir + "Offline.zip");
		outFile.write(writer.finalize());
		outFile.close();
		
		// Report
		var bytes:Int = FileSystem.stat(finalDir + "Offline.zip").size;
		trace(Std.string(bytes / 1024) + " / 13kb bytes used!");
	}

}