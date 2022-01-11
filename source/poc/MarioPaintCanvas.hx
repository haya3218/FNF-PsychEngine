package poc;

import flixel.util.FlxColor;
import lime.ui.MouseCursor;
import openfl.ui.Mouse;
import openfl.events.MouseEvent;
import openfl.events.Event;
import openfl.geom.Rectangle;
import openfl.display.BitmapData;
import openfl.display.Bitmap;
import openfl.display.Sprite;

class MarioPaintCanvas extends Sprite
{
	public var canvas:Bitmap;

	public var lastMouseX:Int = 0;
	public var lastMouseY:Int = 0;

	var mouseIsDown:Bool = false;

	public var cScale:Int = 1;

	public var currentColor:Int = FlxColor.BLACK;

	public function new(width:Int, height:Int, initFill:Int = 0xFFFFFFFF)
	{
		super();

		canvas = new Bitmap(new BitmapData(width, height));
		canvas.bitmapData.fillRect(new Rectangle(0, 0, width, height), initFill);
		canvas.smoothing = false;
		addChild(canvas);

		addEventListener(Event.ENTER_FRAME, onUpdate);
		addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		addEventListener(MouseEvent.MOUSE_OVER, onMouseEnter);
		addEventListener(MouseEvent.MOUSE_OUT, onMouseLeave);
	}

	function onUpdate(evt:Event):Void
	{
		if (mouseIsDown)
		{
			drawLine(Std.int(lastMouseX), Std.int(lastMouseY), Std.int((stage.mouseX - this.x)), Std.int((stage.mouseY - this.y)), currentColor);
			lastMouseX = Std.int(stage.mouseX - this.x);
			lastMouseY = Std.int(stage.mouseY - this.y);
		}
	}

	private function onMouseDown(evt:MouseEvent):Void
	{
		lastMouseX = Std.int(stage.mouseX - this.x);
		lastMouseY = Std.int(stage.mouseY - this.y);
		mouseIsDown = true;
	}

	private function onMouseUp(evt:MouseEvent):Void
	{
		mouseIsDown = false;
	}

	// Change mouse cursor on canvas enter/exit
	private function onMouseEnter(evt:MouseEvent):Void
	{
		Mouse.cursor = MouseCursor.CROSSHAIR;
		mouseIsDown = false;
	}

	private function onMouseLeave(evt:MouseEvent):Void
	{
		Mouse.cursor = MouseCursor.DEFAULT;
		mouseIsDown = false;
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
				write2canvas(x1, y1, color);
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
				write2canvas(x1, y1, color);
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

	function write2canvas(x1:Int, y1:Int, color:Int)
	{
		canvas.bitmapData.fillRect(new Rectangle(x1 - cScale, y1 - cScale, cScale * 2, cScale * 2), color);
	}
}