package;

import flixel.system.FlxSound;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.text.FlxTypeText;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxSpriteGroup;
import flixel.input.FlxKeyManager;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
#if sys
import sys.FileSystem;
#end

using StringTools;

class Cutsceneshit extends FlxSpriteGroup
{
	// static inline final I = '[i]';

	public var box:FlxSprite;

    var background:FlxSprite;
	var box2:FlxSprite;
	var vade:FlxSprite;
	var chris:FlxSprite;
	var curBg:String = '';
	var curSound:FlxSound;
	var aaa:Bool = false;

	// var bgMusic;
	// var curMus:String = '';

	var curCharacter:String = '';
	var idklol:Bool;

	var dialogue:Alphabet;
	var dialogueList:Array<String> = [];

	// SECOND DIALOGUE FOR THE PIXEL SHIT INSTEAD???
	var swagDialogue:FlxTypeText;
	var skip:Array<String> = [];

	// var dropText:FlxText;

	public var finishThing:Void->Void;

	var tags:FlxSprite;
	// var portraitRightNobody:FlxSprite;

	var handSelect:FlxSprite;
	var bgFade:FlxSprite;
    var black:FlxSprite;
	var volumee:Float;

	public function new(talkingRight:Bool = true, ?dialogueList:Array<String>)
	{
		super();
		skip = ['bg', 'voice','showbox','cm'];
		// bgMusic = FlxG.sound.playMusic(Paths.music('silence'));
		// bgMusic.fadeIn(3, 0, 0.7);

		var songName:String = Paths.formatToSongPath(PlayState.SONG.song);
		switch (songName)
		{
			case 'its-complicated':
					volumee = 0;
					idklol = true;
			case 'parallax':
				volumee = 0;
				idklol = false;
			default:
				idklol = false;
				if (!ClientPrefs.oldvoice)
					{
						volumee = 0.5;
					}
		}

		FlxG.sound.playMusic(Paths.music('givealilbitback'), 0.1);

        black = new FlxSprite(0,0).makeGraphic(1280,720,FlxColor.BLACK);
		black.scrollFactor.set();
		black.y += 555;
		black.alpha = 0.6;
        add(black);

		box = new FlxSprite(111190, 438);
		box.frames = Paths.getSparrowAtlas('tags');
		box.animation.addByPrefix('normalOpen', 'btags', 24, false);
		box.animation.addByPrefix('normal', 'btags', 24, false);
		box2 = new FlxSprite(111190, 438);
		box2.screenCenter();
		box2.frames = Paths.getSparrowAtlas('speech_bubble');
		box2.animation.addByPrefix('normalOpen', 'speech bubble normal', 24);
		box2.x -= 600;
		// box.frames = Paths.getSparrowAtlas('speech_bubble_talking', 'shared');
		// box.animation.addByPrefix('normalOpen', 'Speech Bubble Normal Open', 24, false);
		// box.animation.addByPrefix('normal', 'speech bubble normal', 24, false);
		
        // box.y = FlxG.height * 0.64;

        this.dialogueList = dialogueList;

		background = new FlxSprite(0,0);
		background.visible = true;
		add(background);

		tags = new FlxSprite(-900, 230);
		tags.frames = Paths.getSparrowAtlas('tags');
		tags.animation.addByPrefix('bf', '1tags bf', 24, false);
		tags.animation.addByPrefix('cj', '2tags cj', 24, false);
		tags.animation.addByPrefix('gf', '3tags gf', 24, false);
		tags.animation.addByPrefix('mystery', '4tags mystery', 24, false);
		tags.animation.addByPrefix('ruby', '5tags ruby', 24, false);
		tags.animation.addByPrefix('singer', '6tags singer', 24, false);
		tags.animation.addByPrefix('vade', '7tags vade', 24, false);
		tags.scale.set(0.1,0.1);
		add(tags);
		tags.visible = false;

		chris = new FlxSprite(0,0);
		chris.loadGraphic(Paths.image('cutscenes/chris'));
		chris.updateHitbox();
		chris.screenCenter();
		chris.antialiasing = true;
		add(chris);

		vade = new FlxSprite(0,0);
		vade.loadGraphic(Paths.image('cutscenes/vade'));
		vade.updateHitbox();
		vade.screenCenter();
		vade.antialiasing = true;
		add(vade);
		vade.alpha = 0;
		chris.alpha = 0;

		box.animation.play('normalOpen');
		box.updateHitbox();
		add(box);
		box2.animation.play('normalOpen');
		box2.visible = false;
		box2.updateHitbox();
		add(box2);
			
		//handSelect = new FlxSprite(FlxG.width * 0.88, FlxG.height * 0.9).loadGraphic(Paths.image('weeb/pixelUI/hand_textbox'));

		/*dropText = new FlxText(242, 502, Std.int(FlxG.width * 0.6), "", 32);
		dropText.font = 'Candara';
		dropText.bold = true;
		dropText.color = 0xFFD89494;
		add(dropText);*/

		swagDialogue = new FlxTypeText(240, 580, Std.int(FlxG.width * 0.7), "", 41);
		swagDialogue.setFormat("p5hatty", 43, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		swagDialogue.bold = true;
		swagDialogue.color = 0xFFFFFFFF;
		swagDialogue.screenCenter(X);
		add(swagDialogue);

		dialogue = new Alphabet(0, 80, "", false, true);

        tags.visible = false;

		// dropText.y -= 15;
		// swagDialogue.y -= 15;
	}

	var dialogueOpened:Bool = false;
	var dialogueStarted:Bool = false;

	override function update(elapsed:Float)
	{
		// dropText.text = swagDialogue.text;

		dialogueOpened = true;

		if (dialogueOpened && !dialogueStarted)
		{
			startDialogue();
			dialogueStarted = true;
		}
		if (curCharacter == 'bg' && dialogueStarted == true)
		{
			dialogueList.remove(dialogueList[0]);
			startDialogue();
		}

		if (chris.alpha != 0)
			{
				black.screenCenter();
			}

		/*if (cutEl == true && dialogueStarted == true)
		{
			dialogueList.remove(dialogueList[0]);
			startDialogue();
		}*/

		skip = ['bg', 'voice','showbox','cm'];
		
		if (FlxG.keys.justPressed.ANY || (dialogueList.length > 0 && skip.contains(curCharacter))  && dialogueStarted == true)
		{
			remove(dialogue);

			if (dialogueList[1] == null && dialogueList[0] != null)
			{
				if (!isEnding)
				{
					isEnding = true;

					FlxG.sound.music.fadeOut(2.2, 0);

					FlxTween.tween(background, {alpha: 0}, 1.1);
					FlxTween.tween(tags, {alpha: 0}, 1.1);
					FlxTween.tween(black, {alpha: 0}, 1.1);
					FlxTween.tween(swagDialogue, {alpha: 0}, 1.1);
					FlxTween.tween(box2, {alpha: 0}, 1.1);
					FlxTween.tween(vade, {alpha: 0}, 1.1);
					FlxTween.tween(chris, {alpha: 0}, 1.1);
					if (curSound != null && curSound.playing)
						{
							curSound.stop();
						}

					new FlxTimer().start(1.125, function(tmr:FlxTimer)
					{
						finishThing();
						kill();
					});
				}
			}
			else
			{
				dialogueList.remove(dialogueList[0]);
				startDialogue();
			}
		}
		
		super.update(elapsed);
	}

	var isEnding:Bool = false;

	// var cutEl = false;

	function startDialogue():Void
	{
		cleanDialog();
		swagDialogue.resetText(dialogueList[0]);
		swagDialogue.start(0.04, true);

		if (!box.visible)
		{
			box.visible = false;
		}
		remove(black);
		switch (curCharacter)
		{
			case 'voice':
				var songName:String = Paths.formatToSongPath(PlayState.SONG.song);
				switch (songName)
				{
					case 'its-complicated':
						if (curSound != null && curSound.playing)
							{
								curSound.stop();
							}
							if (idklol)
								curSound = new FlxSound().loadEmbedded(Paths.sound('complicated/' + dialogueList[0]));
							else
								curSound = new FlxSound().loadEmbedded(Paths.sound(dialogueList[0]));
							curSound.volume = 1;
							curSound.play();
					case 'parallax':
						if (curSound != null && curSound.playing)
							{
								curSound.stop();
							}
							curSound = new FlxSound().loadEmbedded(Paths.sound(dialogueList[0]));
							curSound.volume = 1;
							curSound.play();
					default:
						if (!ClientPrefs.oldvoice)
							{
								if (curSound != null && curSound.playing)
									{
										curSound.stop();
									}
									curSound = new FlxSound().loadEmbedded(Paths.sound(dialogueList[0]));
									curSound.volume = 1;
									curSound.play();
							}
				}
			case 'bg':			
				remove(background);
				background.loadGraphic(Paths.image('cutscenes/$curBg'));
				background.setGraphicSize(1280,720);
				background.updateHitbox();
				background.screenCenter();
				background.antialiasing = true;
				add(background);
			case 'bgnoskip':			
				remove(background);
				background.loadGraphic(Paths.image('cutscenes/$curBg'));
				add(background);
			case 'cm':
				FlxG.sound.playMusic(Paths.music('showtimeYEAAA'), 0);
				FlxG.sound.music.fadeIn(0.5, 0, 0.125);
			case 'nar':
				tags.visible = false;
			case 'showbox':
				box2.visible = true;
				tags.visible = false;
			case 'chris':
				if (aaa)
					vade.alpha = 0.75;
				chris.alpha = 1;
				swagDialogue.setFormat("p5hatty", 48, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
				swagDialogue.y = 500;
				swagDialogue.borderSize = 2;
				box2.flipX = false;
			case 'vade':
				aaa = true;
				vade.alpha = 1;
				chris.alpha = 0.75;
				box2.flipX = true;
			default:
				tags.visible = true;
				tags.animation.play(curCharacter);
				if (curCharacter == 'bf')
					{
						if (curSound != null && curSound.playing)
							{
								curSound.stop();
							}
						FlxG.sound.play(Paths.sound('boop'),0.4);
					}
		}
		add(black);
	}

	function cleanDialog():Void
	{
		var splitData:Array<String> = dialogueList[0].split(":");
		curCharacter = splitData[1];
		dialogueList[0] = dialogueList[0].substr(splitData[1].length + 2).trim();
		
		curBg = dialogueList[0];
	}
}
