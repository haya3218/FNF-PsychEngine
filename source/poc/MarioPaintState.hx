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

class MarioPaintState extends MusicBeatState
{
	public var canvas:MarioPaintCanvas;
    var cursorSprite:FlxSprite;
    var sizeText:FlxText;

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

		sizeText = new FlxText(10, ClientPrefs.getResolution()[1] - 64 - 32, 0, "Pen size: 2", 10);
		sizeText.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        add(sizeText);
		add(cursorSprite);
        
        FlxG.addChildBelowMouse(canvas);
		FlxG.game.addEventListener(openfl.events.MouseEvent.MOUSE_WHEEL, onMouseScroll);
	}

	override function update(elapsed:Float)
	{

		if (controls.BACK)
        {
			FlxG.sound.playMusic(Paths.music('freakyMenu'));
			MusicBeatState.switchState(new MainMenuState());
        }
        if (FlxG.keys.justPressed.ONE)
            cursorSprite.color = FlxColor.BLACK;
		else if (FlxG.keys.justPressed.TWO)
			cursorSprite.color = FlxColor.RED;
		else if (FlxG.keys.justPressed.THREE)
			cursorSprite.color = FlxColor.YELLOW;
		else if (FlxG.keys.justPressed.FOUR)
			cursorSprite.color = FlxColor.BLUE;
		else if (FlxG.keys.justPressed.FIVE)
			cursorSprite.color = FlxColor.ORANGE;
		else if (FlxG.keys.justPressed.SIX)
			cursorSprite.color = FlxColor.GREEN;
		else if (FlxG.keys.justPressed.SEVEN)
			cursorSprite.color = FlxColor.MAGENTA;
		else if (FlxG.keys.justPressed.EIGHT)
			cursorSprite.color = FlxColor.PINK;
		else if (FlxG.keys.justPressed.NINE)
			cursorSprite.color = FlxColor.WHITE;

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
		canvas.cScale = Std.int(CoolUtil.clamp(canvas.cScale, 1, 5));
		sizeText.text = "Pen size: " + Std.string(canvas.cScale * 2);
	}
}
