package poc;

import flixel.math.FlxMath;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.effects.FlxFlicker;
import lime.app.Application;
import flixel.addons.transition.FlxTransitionableState;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;

/**
 * Now, you would be asking, why?
 * 
 * "Yes."
 * 
 * And yes, this is a full blown paint program (without undo, redo, just classic mario paint style)
 * 
 * codenamed "Mario paint clon"
 */
class MarioPaintState extends MusicBeatState
{
	public var canvas:MarioPaintCanvas;
	var eraserSprite:FlxSprite;
    var cursorSprite:FlxSprite;
    var sizeText:FlxText;
	var colorArray:Array<Int> = [
		0xFF000000,
		0xFF008000,
		0xFF00FF00,
		0xFFFFFF00,
		0xFFFFA500,
		0xFFFF0000,
		0xFF800080,
		0xFF0000FF,
		0xFF8B4513,
		0xFFFFC0CB,
		0xFFFF00FF,
		0xFF00FFFF,
		0xFF808080];
	var currentColor:Int = 0;

	override function create()
	{
		super.create();

		var bg:FlxSprite = new FlxSprite().makeGraphic(ClientPrefs.getResolution()[0], ClientPrefs.getResolution()[1], FlxColor.GRAY);
		add(bg);

        canvas = new MarioPaintCanvas(640, 480);
		canvas.x = (ClientPrefs.getResolution()[0] / 2) - (canvas.width / 2);
		canvas.y = (ClientPrefs.getResolution()[1] / 2) - (canvas.height / 2);
        FlxG.sound.playMusic(Paths.music("paint_loop"));

		cursorSprite = new FlxSprite(10, ClientPrefs.getResolution()[1] - 64 - 10).loadGraphic(Paths.image("poc/paintCursor"));
		cursorSprite.color = FlxColor.BLACK;
		eraserSprite = new FlxSprite(10, ClientPrefs.getResolution()[1] - 64 - 10).loadGraphic(Paths.image("poc/eraser"));
		eraserSprite.visible = false;

		sizeText = new FlxText(10, ClientPrefs.getResolution()[1] - 64 - 32, 0, "Pen size: " + canvas.cScale * 2, 10);
		sizeText.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        
		var edgeSprite:FlxSprite = new FlxSprite(0, ClientPrefs.getResolution()[1] - 145).loadGraphic(Paths.image("poc/edge"));
		add(edgeSprite);
		add(sizeText);
		add(cursorSprite);
		add(eraserSprite);
        
        FlxG.addChildBelowMouse(canvas);
		currentColor = 0;
		FlxG.game.addEventListener(openfl.events.MouseEvent.MOUSE_WHEEL, onMouseScroll);
	}

	var color:Int = 0;

	override function update(elapsed:Float)
	{
		if (controls.BACK)
        {
			FlxG.sound.playMusic(Paths.music('freakyMenu'));
			MusicBeatState.switchState(new MainMenuState());
        }

		if (!FlxG.mouse.pressedMiddle) {
			if (FlxG.keys.justPressed.J)
				currentColor--;
			else if (FlxG.keys.justPressed.L)
				currentColor++;
			currentColor = Std.int(CoolUtil.reverseClamp(currentColor, 0, 12));
			color = colorArray[currentColor];
		} else {
			color = FlxColor.WHITE;
		}

		cursorSprite.color = color;
		cursorSprite.loadGraphic((!FlxG.mouse.pressedRight) ? Paths.image("poc/paintCursor") : Paths.image("poc/bucket"));
		cursorSprite.visible = (cursorSprite.color != FlxColor.WHITE) ? true : false;
		eraserSprite.visible = !cursorSprite.visible;

		canvas.currentColor = cursorSprite.color;
		super.update(elapsed);
	}

	public function onMouseScroll(evt:openfl.events.MouseEvent):Void
	{
        if (evt.delta > 0) {
			canvas.cScale += 1;
        } else {
			canvas.cScale -= 1;
        }
		canvas.cScale = Std.int(CoolUtil.clamp(canvas.cScale, 1, 20));
		sizeText.text = "Pen size: " + Std.string(canvas.cScale * 2);
	}
}
