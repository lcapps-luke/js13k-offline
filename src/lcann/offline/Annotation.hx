package lcann.offline;

import js.html.CanvasRenderingContext2D;
import js.html.ImageElement;

/**
 * ...
 * @author ekool
 */
class Annotation extends Entity {
	private var image:ImageElement;

	public function new(imageName:String) {
		image = Main.imageMap.get(imageName);
	}

	override public function update(s:Float, c:CanvasRenderingContext2D) {
		super.update(s, c);

		c.drawImage(image, 0, 0, image.width, image.height, x, y, width, height);
	}
}