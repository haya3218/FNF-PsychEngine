package poc;

import flixel.util.FlxTimer;
import openfl.net.FileReference;
import lime.ui.FileDialog;
#if sys
import sys.io.FileOutput;
import sys.FileSystem;
import sys.io.File;
import sys.io.FileInput;
#end
import openfl.utils.ByteArray;
import flixel.input.keyboard.FlxKey;
import flixel.FlxG;
import flixel.util.FlxColor;
import lime.ui.MouseCursor;
import openfl.ui.Mouse;
import openfl.events.MouseEvent;
import openfl.events.Event;
import openfl.geom.Rectangle;
import openfl.display.BitmapData;
import openfl.display.Bitmap;
import openfl.display.Sprite;

/**
 * The canvas for said mario paint clone.
 * 
 * I got most of the code from https://github.com/epocti/CandidEditor/blob/master/source/Canvas.hx, I just modified it
 *  for use with FNF as well as add extra features.
 */
class MarioPaintCanvas extends Sprite
{
	public var canvas:Bitmap;
	public var lastBitmap:BitmapData;

	public var lastMouseX:Int = 0;
	public var lastMouseY:Int = 0;

	var mouseIsDown:Bool = false;

	public var cScale:Int = 1;

	public var currentColor:Int = FlxColor.BLACK;

	var _iwidth:Int;
	var _iheight:Int;

	public function new(width:Int, height:Int, initFill:Int = 0xFFFFFFFF)
	{
		super();

		_iwidth = width;
		_iheight = height;

		canvas = new Bitmap(new BitmapData(width, height));
		canvas.bitmapData.fillRect(new Rectangle(0, 0, width, height), initFill);
		canvas.smoothing = false;
		addChild(canvas);

		addEventListener(Event.ENTER_FRAME, onUpdate);
	}

	function onUpdate(evt:Event):Void
	{
		if (FlxG.mouse.justPressed || FlxG.mouse.justPressedRight)
			lastBitmap = canvas.bitmapData;

		if (FlxG.mouse.pressed)
			drawLine(lastMouseX, lastMouseY, Std.int((stage.mouseX - this.x)), Std.int((stage.mouseY - this.y)), currentColor);
		else if (FlxG.mouse.pressedRight)
			canvas.bitmapData.floodFill(lastMouseX, lastMouseY, currentColor);
		lastMouseX = Std.int(stage.mouseX - this.x);
		lastMouseY = Std.int(stage.mouseY - this.y);

		if (FlxG.keys.pressed.CONTROL)
		{
			// ! DOESNT WORK :(
			//if (FlxG.keys.justPressed.Z)
			//	canvas.bitmapData = lastBitmap;
			if (FlxG.keys.justPressed.S)
				savePNG();	
		}
	}

	function savePNG() {
		var encoded:ByteArray = new ByteArray();
		canvas.bitmapData.encode(canvas.bitmapData.rect, new flash.display.PNGEncoderOptions(), encoded);
		new FlxTimer().start(0.5, function(_) {
			var fileR:FileReference = new FileReference();
			fileR.save(encoded, "canvas.png");
		});
	}

	public function drawLine(x1:Int, y1:Int, x2:Int, y2:Int, color:Int):Void
	{
		// delta of exact value and rounded value of the dependant variable
		var d:Int = 0;

		var dy:Int = Std.int(Math.abs(y2 - y1));
		var dx:Int = Std.int(Math.abs(x2 - x1));

		var dy2:Int = (dy << 1); // slope scaling factors to avoid floating
		var dx2:Int = (dx << 1); // point

		var ix:Int = x1 < x2 ? 1 : -1; // increment direction
		var iy:Int = y1 < y2 ? 1 : -1;

		if (dy <= dx)
		{
			while (true)
			{
				canvas.bitmapData.fillRect(new Rectangle(x1 - cScale, y1 - cScale, cScale * 2, cScale * 2), color);
				if (x1 == x2)
					break;
				x1 += ix;
				d += dy2;
				if (d > dx)
				{
					y1 += iy;
					d -= dx2;
				}
			}
		}
		else
		{
			while (true)
			{
				canvas.bitmapData.fillRect(new Rectangle(x1 - cScale, y1 - cScale, cScale * 2, cScale * 2), color);
				if (y1 == y2)
					break;
				y1 += iy;
				d += dx2;
				if (d > dy)
				{
					x1 += ix;
					d -= dy2;
				}
			}
		}
	}
}