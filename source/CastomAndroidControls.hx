package;

import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.addons.display.FlxBackdrop;
import flixel.util.FlxColor;
import flixel.util.FlxSave;
import flixel.math.FlxPoint;
import flixel.ui.FlxButton;
import flixel.text.FlxText;
import flixel.FlxG;
import flixel.FlxSprite;
import haxe.Json;
import ui.Hitbox;
import ui.AndroidControls.Config;
import ui.FlxVirtualPad;

using StringTools;

class CastomAndroidControls extends MusicBeatState
{
	var _pad:FlxVirtualPad;
	var _hb:Hitbox;

	var upPozition:FlxText;
	var downPozition:FlxText;
	var leftPozition:FlxText;
	var rightPozition:FlxText;

	var inputvari:FlxText;

	var leftArrow:FlxSprite;
	var rightArrow:FlxSprite;

	var controlitems:Array<String> = ['right control','left control','keyboard','custom','hitbox'];

	var curSelected:Int = 0;

	var buttonistouched:Bool = false;

	var bindbutton:FlxButton;

	var config:Config;

	public static var menuBG:FlxSprite;
	public static var star1:FlxSprite;
	public static var star2:FlxSprite;
	public static var black:FlxSprite;
	public static var left:FlxSprite;
	public static var right:FlxSprite;

	override public function create():Void
	{
		super.create();
		
		config = new Config();
		curSelected = config.getcontrolmode();

		menuBG = new FlxSprite().loadGraphic(Paths.image('1280x720 optionsMenu/Layer 1'));
		menuBG.updateHitbox();
		menuBG.screenCenter();
		menuBG.antialiasing = ClientPrefs.globalAntialiasing;
		add(menuBG);

		black = new FlxSprite().loadGraphic(Paths.image('1280x720 optionsMenu/blackBar'));
		black.updateHitbox();
		black.screenCenter();
		black.x -= 41;
		black.y -= 187;
		black.antialiasing = ClientPrefs.globalAntialiasing;
		add(black);

		FlxG.camera.zoom = 3;
		FlxTween.tween(FlxG.camera, {zoom: 1}, 1.1, {ease: FlxEase.expoInOut});

		black.x -= 1000;
		FlxTween.tween(black, {x: black.x +1000}, 0.9, {startDelay: 0.6,
			ease: FlxEase.expoOut});

		left = new FlxSprite().loadGraphic(Paths.image('1280x720 optionsMenu/optionsLeftPanel'));
		left.updateHitbox();
		left.antialiasing = ClientPrefs.globalAntialiasing;
		add(left);

		left.x -= left.width;
		FlxTween.tween(left, {x: left.x +left.width}, 0.8, {startDelay: 0.6,
			ease: FlxEase.expoOut});

		right = new FlxSprite().loadGraphic(Paths.image('1280x720 optionsMenu/optionsRightPanel'));
		right.updateHitbox();
		right.x += 1280 - right.width;
		right.antialiasing = ClientPrefs.globalAntialiasing;
		add(right);

		right.x += right.width;
		FlxTween.tween(right, {x: right.x -right.width}, 0.8, {startDelay: 0.6,
			ease: FlxEase.expoOut});

		star2 = new FlxSprite().loadGraphic(Paths.image('1280x720 optionsMenu/starsRight'));
		star2.updateHitbox();
		star2.screenCenter();
		star2.x += 334;
		star2.y += 5;
		star2.antialiasing = ClientPrefs.globalAntialiasing;
		add(star2);

		star2.y += 1000;
		FlxTween.tween(star2, {y: star2.y-1000}, 0.8, {startDelay: 0.9,
			ease: FlxEase.expoOut});

		star1 = new FlxSprite().loadGraphic(Paths.image('1280x720 optionsMenu/starsLeft'));
		star1.updateHitbox();
		star1.screenCenter();
		star1.x -= 316;
		star1.antialiasing = ClientPrefs.globalAntialiasing;
		add(star1);

		star1.y -= 1000;
		FlxTween.tween(star1, {y: star1.y+1000}, 0.8, {startDelay: 0.9,
			ease: FlxEase.expoOut});

		var exitbutton = new FlxButton(FlxG.width - 120, 50, "Exit", function()
    	{
			MusicBeatState.switchState(new OptionsState());    	
		});
		exitbutton.setGraphicSize(Std.int(exitbutton.width) * 3);
		exitbutton.label.setFormat(null, 16, 0x333333, "center");
		exitbutton.color = FlxColor.fromRGB(255,0,0);
		add(exitbutton);		

		var savebutton = new FlxButton(exitbutton.x, exitbutton.y + 100, "Save And Exit", function()
		{
			save();
			MusicBeatState.switchState(new OptionsState());
		});
		savebutton.setGraphicSize(Std.int(savebutton.width) * 3);
        savebutton.label.setFormat(null, 16, 0x333333, "center");		
		savebutton.color = FlxColor.fromRGB(0,255,0);
		add(savebutton);

		_pad = new FlxVirtualPad(RIGHT_FULL, NONE);
		_pad.alpha = 0;
		add(_pad);

		_hb = new Hitbox();
		_hb.visible = false;
		add(_hb);

		inputvari = new FlxText(0, 50, 0, controlitems[curSelected], 48);
		inputvari.screenCenter(X);
		add(inputvari);

		var ui_tex = Paths.getSparrowAtlas('campaign_menu_UI_assets');

		leftArrow = new FlxSprite(inputvari.x - 60,inputvari.y - 10);
		leftArrow.frames = ui_tex;
		leftArrow.animation.addByPrefix('idle', "arrow left");
		leftArrow.animation.addByPrefix('press', "arrow push left");
		leftArrow.animation.play('idle');
		add(leftArrow);

		rightArrow = new FlxSprite(inputvari.x + inputvari.width + 10, leftArrow.y);
		rightArrow.frames = ui_tex;
		rightArrow.animation.addByPrefix('idle', 'arrow right');
		rightArrow.animation.addByPrefix('press', "arrow push right", 24, false);
		rightArrow.animation.play('idle');
		add(rightArrow);

		upPozition = new FlxText(125, 200, 0,"Button Up X:" + _pad.buttonUp.x +" Y:" + _pad.buttonUp.y, 24);
		add(upPozition);

		downPozition = new FlxText(125, 250, 0,"Button Down X:" + _pad.buttonDown.x +" Y:" + _pad.buttonDown.y, 24);
		add(downPozition);

		leftPozition = new FlxText(125, 300, 0,"Button Left X:" + _pad.buttonLeft.x +" Y:" + _pad.buttonLeft.y, 24);
		add(leftPozition);

		rightPozition = new FlxText(125, 350, 0,"Button RIght x:" + _pad.buttonRight.x +" Y:" + _pad.buttonRight.y, 24);
		add(rightPozition);

		changeSelection();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		updatethefuckingpozitions();
		
		for (touch in FlxG.touches.list){
			arrowanimate(touch);
			
			if(touch.overlaps(leftArrow) && touch.justPressed){
				changeSelection(-1);
			}else if (touch.overlaps(rightArrow) && touch.justPressed){
				changeSelection(1);
			}

			trackbutton(touch);
		}
	}

	function changeSelection(change:Int = 0)
	{
			curSelected += change;
	
			if (curSelected < 0)
				curSelected = controlitems.length - 1;
			if (curSelected >= controlitems.length)
				curSelected = 0;
	
			inputvari.text = controlitems[curSelected];

			var daChoice:String = controlitems[Math.floor(curSelected)];

			switch (daChoice)
			{
				case 'right control':
					remove(_pad);
					_pad = null;
					_pad = new FlxVirtualPad(RIGHT_FULL, NONE);
					_pad.alpha = 0.75;
					add(_pad);
				case 'left control':
					remove(_pad);
					_pad = null;
					_pad = new FlxVirtualPad(FULL, NONE);
					_pad.alpha = 0.75;
					add(_pad);
				case 'keyboard':
					_pad.alpha = 0;
				case 'custom':
					add(_pad);
					_pad.alpha = 0.75;
					loadcustom();
				case 'hitbox':
					remove(_pad);
					_pad.alpha = 0;
			}

			if (daChoice == "hitbox")
			{
				_hb.visible = true;
				upPozition.visible = false;
				downPozition.visible = false;
				leftPozition.visible = false;
				rightPozition.visible = false;
			}
			else
			{
				_hb.visible = false;
				upPozition.visible = true;
				downPozition.visible = true;
				leftPozition.visible = true;
				rightPozition.visible = true;
			}
	}

	function arrowanimate(touch:flixel.input.touch.FlxTouch){
		if(touch.overlaps(leftArrow) && touch.pressed){
			leftArrow.animation.play('press');
		}
		
		if(touch.overlaps(leftArrow) && touch.released){
			leftArrow.animation.play('idle');
		}
		//right arrow animation
		if(touch.overlaps(rightArrow) && touch.pressed){
			rightArrow.animation.play('press');
		}
		
		if(touch.overlaps(rightArrow) && touch.released){
			rightArrow.animation.play('idle');
		}
	}

	function trackbutton(touch:flixel.input.touch.FlxTouch){
		var daChoice:String = controlitems[Math.floor(curSelected)];

        if (daChoice == 'custom')
        {
			if (buttonistouched){
				
				if (bindbutton.justReleased && touch.justReleased)
				{
					bindbutton = null;
					buttonistouched = false;
				}else 
				{
					movebutton(touch, bindbutton);
					setbuttontexts();
				}

			}else {
				if (_pad.buttonUp.justPressed) {
					movebutton(touch, _pad.buttonUp);
				}
				
				if (_pad.buttonDown.justPressed) {
					movebutton(touch, _pad.buttonDown);
				}

				if (_pad.buttonRight.justPressed) {
					movebutton(touch, _pad.buttonRight);
				}

				if (_pad.buttonLeft.justPressed) {
					movebutton(touch, _pad.buttonLeft);
				}
			}
        }
	}

	function movebutton(touch:flixel.input.touch.FlxTouch, button:flixel.ui.FlxButton) {
		button.x = touch.x - _pad.buttonUp.width / 2;
		button.y = touch.y - _pad.buttonUp.height / 2;
		bindbutton = button;
		buttonistouched = true;
	}

	function setbuttontexts() {
		upPozition.text = "Button Up X:" + _pad.buttonUp.x +" Y:" + _pad.buttonUp.y;
		downPozition.text = "Button Down X:" + _pad.buttonDown.x +" Y:" + _pad.buttonDown.y;
		leftPozition.text = "Button Left X:" + _pad.buttonLeft.x +" Y:" + _pad.buttonLeft.y;
		rightPozition.text = "Button RIght x:" + _pad.buttonRight.x +" Y:" + _pad.buttonRight.y;
	}

	function save() {
		config.setcontrolmode(curSelected);
		var daChoice:String = controlitems[Math.floor(curSelected)];

    	if (daChoice == 'custom'){
			savecustom();
		}
	}

	function savecustom() {
		config.savecustom(_pad);
	}

	function loadcustom():Void{
		_pad = config.loadcustom(_pad);	
	}

	function resizebuttons(vpad:FlxVirtualPad, ?int:Int = 200) {
		for (button in vpad){
				button.setGraphicSize(260);
				button.updateHitbox();
		}
	}

	function updatethefuckingpozitions() {
		leftArrow.x = inputvari.x - 60;
		rightArrow.x = inputvari.x + inputvari.width + 10;
		inputvari.screenCenter(X);
	}

	override function destroy()
	{
		super.destroy();
	}
}
