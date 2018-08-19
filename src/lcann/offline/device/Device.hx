package lcann.offline.device;
import js.html.CanvasRenderingContext2D;
import js.html.ImageElement;

/**
 * ...
 * @author ekool
 */
class Device extends Entity 
{
	private var img:ImageElement;
	
	public function new(imgName:String) 
	{
		this.img = Main.imageMap.get(imgName + "_red");
	}
	
	override public function update(s:Float, c:CanvasRenderingContext2D) 
	{
		super.update(s, c);
		c.drawImage(img, 0, 0, img.width, img.height, x, y, width, height);
	}
}