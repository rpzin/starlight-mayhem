package;

#if desktop
import Discord.DiscordClient;
#end
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.util.FlxTimer;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.math.FlxMath;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import lime.app.Application;
import Achievements;
import editors.MasterEditorMenu;

using StringTools;

class MainMenuState extends MusicBeatState
{
	public static var psychEngineVersion:String = '0.4.2'; //This is also used for Discord RPC
	public static var curSelected:Int = 0;

	var menuItems:FlxTypedGroup<FlxSprite>;
	var menustuff:FlxTypedGroup<FlxSprite>;
	var menustuff2:FlxTypedGroup<FlxSprite>;
	var textgrp:FlxTypedGroup<FlxSprite>;
	private var camGame:FlxCamera;
	private var camAchievement:FlxCamera;
	
	var optionShit:Array<String> = ['story', 'freeplay','options', 'credits'];

	var magenta:FlxSprite;
	var camFollow:FlxObject;
	var camFollowPos:FlxObject;
	var canfloat:Bool = false;
	var idklol:Float;
	var star1:FlxSprite;
	var star2:FlxSprite;
	var bg:FlxSprite;

	var aaa1:FlxTween;
	var aaa2:FlxTween;
	var aaa3:FlxTween;
	var aaa4:FlxTween;
	var aaa5:FlxTween;
	var aaa6:FlxTween;
	var aaa7:FlxTween;
	var aaa8:FlxTween;
	var canmove:Bool = true;
	var aa1:FlxTween;
	var aa2:FlxTween;
	var aa3:FlxTween;
	var aa4:FlxTween;
	var aa5:FlxTween;
	var aa6:FlxTween;
	var aa7:FlxTween;
	var aa8:FlxTween;
	var aa9:FlxTween;
	var aa10:FlxTween;

	override function create()
	{
		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		camGame = new FlxCamera();
		camAchievement = new FlxCamera();
		camAchievement.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camAchievement);
		FlxCamera.defaultCameras = [camGame];

		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		persistentUpdate = persistentDraw = true;

		FlxG.camera.zoom = 3;
		FlxTween.tween(FlxG.camera, {zoom: 1}, 1.1, {ease: FlxEase.expoInOut});

		var yScroll:Float = Math.max(0.25 - (0.05 * (optionShit.length - 4)), 0.1);

		bg = new FlxSprite(-80).loadGraphic(Paths.image('1280x720 selectMenu/selectBackground'));
		bg.scrollFactor.set(0, 0);
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = true;
		add(bg);

		star1 = new FlxSprite().loadGraphic(Paths.image('1280x720 selectMenu/selectStars1'));
		star1.scrollFactor.set(0, 0);
		star1.updateHitbox();
		star1.screenCenter();
		star1.antialiasing = true;
		star1.y -= 1000 + 64;
		star1.x += 1;
		add(star1);

		star2 = new FlxSprite().loadGraphic(Paths.image('1280x720 selectMenu/selectStars2'));
		star2.scrollFactor.set(0, 0);
		star2.updateHitbox();
		star2.screenCenter();
		star2.antialiasing = true;
		star2.y += 1000 +  84;
		star2.x += 136;
		add(star2);

		aa1 = FlxTween.tween(star2, {y: star2.y- 1005}, 2.5, {
			ease: FlxEase.expoOut});
		aa2 = FlxTween.tween(star1, {y: star1.y+ 1000}, 2.5, {
			ease: FlxEase.expoOut});

		textgrp = new FlxTypedGroup<FlxSprite>();
		add(textgrp);

		var black1:FlxSprite = new FlxSprite(1080).loadGraphic(Paths.image('1280x720 selectMenu/starlightBlack1'));
		black1.scrollFactor.set(0, 0);
		black1.updateHitbox();
		black1.screenCenter(Y);
		black1.antialiasing = true;
		textgrp.add(black1);

		var black2:FlxSprite = new FlxSprite(1143).loadGraphic(Paths.image('1280x720 selectMenu/starlightBlack2'));
		black2.scrollFactor.set(0, 0);
		black2.updateHitbox();
		black2.screenCenter(Y);
		black2.antialiasing = true;
		textgrp.add(black2);

		var black3:FlxSprite = new FlxSprite(1205).loadGraphic(Paths.image('1280x720 selectMenu/starlightBlack3'));
		black3.scrollFactor.set(0, 0);
		black3.updateHitbox();
		black3.screenCenter(Y);
		black3.antialiasing = true;
		textgrp.add(black3);

		var text1:FlxSprite = new FlxSprite(1070).loadGraphic(Paths.image('1280x720 selectMenu/starlightBlue1'));
		text1.scrollFactor.set(0, 0);
		text1.updateHitbox();
		text1.screenCenter(Y);
		text1.antialiasing = true;
		textgrp.add(text1);

		var text2:FlxSprite = new FlxSprite(1141).loadGraphic(Paths.image('1280x720 selectMenu/starlightBlue2'));
		text2.scrollFactor.set(0, 0);
		text2.updateHitbox();
		text2.screenCenter(Y);
		text2.antialiasing = true;
		textgrp.add(text2);

		var text3:FlxSprite = new FlxSprite(1202).loadGraphic(Paths.image('1280x720 selectMenu/starlightBlue2'));
		text3.scrollFactor.set(0, 0);
		text3.updateHitbox();
		text3.screenCenter(Y);
		text3.antialiasing = true;
		textgrp.add(text3);

		text1.x += 300;
		aa3 = FlxTween.tween(text1, {x: text1.x -300}, 2, {startDelay: 0.1,
			ease: FlxEase.expoOut});
		text2.x += 400;
		aa4 = FlxTween.tween(text2, {x: text2.x -400}, 2, {startDelay: 0.3,
			ease: FlxEase.expoOut});
		text3.x += 500;
		aa5 = FlxTween.tween(text3, {x: text3.x -500}, 2, {startDelay: 0.5,
			ease: FlxEase.expoOut});

		black1.x += 300;
		aa6 = FlxTween.tween(black1, {x: black1.x -300}, 2, {startDelay: 0.7,
			ease: FlxEase.expoOut});
		black2.x += 400;
		aa7 = FlxTween.tween(black2, {x: black2.x -400}, 2, {startDelay: 0.9,
			ease: FlxEase.expoOut});
		black3.x += 500;
		aa8 = FlxTween.tween(black3, {x: black3.x -500}, 2, {startDelay: 1.1,
			ease: FlxEase.expoOut,
			onComplete: function(twn:FlxTween)
			{
				funnyfloat();
				funnyfloat2();
				trace('aaaaa');
				canmove = true;
			}
		});

		camFollow = new FlxObject(0, 0, 1, 1);
		camFollowPos = new FlxObject(0, 0, 1, 1);
		add(camFollow);
		add(camFollowPos);

		magenta = new FlxSprite(-80).loadGraphic(Paths.image('menuDesat'));
		magenta.scrollFactor.set(0, yScroll);
		magenta.setGraphicSize(Std.int(magenta.width * 1.175));
		magenta.updateHitbox();
		magenta.screenCenter();
		magenta.visible = false;
		magenta.antialiasing = ClientPrefs.globalAntialiasing;
		magenta.color = 0xFFfd719b;
		// magenta.scrollFactor.set();

		menustuff2 = new FlxTypedGroup<FlxSprite>();
		add(menustuff2);

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		menustuff = new FlxTypedGroup<FlxSprite>();
		add(menustuff);

		for (i in 0...optionShit.length)
		{
			var offset:Float = 108 - (Math.max(optionShit.length, 4) - 4) * 80;
			var menuItem:FlxSprite = new FlxSprite(0, (i * 140)  + offset);
			menuItem.frames = Paths.getSparrowAtlas('mainmenu/menu_' + optionShit[i]);
			menuItem.animation.addByPrefix('idle', optionShit[i] + " basic", 24);
			menuItem.animation.addByPrefix('selected', optionShit[i] + " white", 24);
			menuItem.animation.play('idle');
			menuItem.ID = i;
			menuItem.screenCenter(X);
			menuItem.alpha = 0;
			menuItems.add(menuItem);
			var scr:Float = (optionShit.length - 4) * 0.135;
			if(optionShit.length < 6) scr = 0;
			menuItem.scrollFactor.set(0, scr);
			menuItem.antialiasing = ClientPrefs.globalAntialiasing;
			//menuItem.setGraphicSize(Std.int(menuItem.width * 0.58));
			menuItem.updateHitbox();
		}

		for (i in 0...optionShit.length)
			{
				var aaa:FlxSprite = new FlxSprite(30,45 + (i * 160)).loadGraphic(Paths.image('1280x720 selectMenu/' + optionShit[i] + 'Default'));
				aaa.scrollFactor.set(0, 0);
				aaa.updateHitbox();
				aaa.antialiasing = true;
				switch(i)
				{
					case 3:
						aaa.x += 10;
						aaa.y -= 30;
				}
				aaa.x -= 600;
				aa9 = FlxTween.tween(aaa, {x: aaa.x+ 600}, 1.5 + (0.2 * i), {startDelay: 0.1+ (0.3 * i),
					ease: FlxEase.expoOut});
				menustuff.add(aaa);
			}

		for (i in 0...optionShit.length)
			{
				var aaa:FlxSprite = new FlxSprite(30,45 + (i * 160)).loadGraphic(Paths.image('1280x720 selectMenu/' + optionShit[i] + 'Selected'));
				aaa.scrollFactor.set(0, 0);
				aaa.updateHitbox();
				aaa.antialiasing = true;
				switch(i)
				{
					case 0:
						aaa.x += 3;
					case 3:
						aaa.x += 10;
						aaa.y -= 30;
				}
				aaa.x -= 600;
				aa10 = FlxTween.tween(aaa, {x: aaa.x+ 600}, 1.5 + (0.2 * i), {startDelay: 0.1+ (0.3 * i),
					ease: FlxEase.expoOut});
				menustuff2.add(aaa);
			}

		FlxG.camera.follow(camFollowPos, null, 1);

		var versionShit:FlxText = new FlxText(12, FlxG.height - 44, 0, "Psych Engine v" + psychEngineVersion, 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		var versionShit:FlxText = new FlxText(12, FlxG.height - 24, 0, "Friday Night Funkin' v" + Application.current.meta.get('version'), 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);

		// NG.core.calls.event.logEvent('swag').send();

		changeItem();

		#if ACHIEVEMENTS_ALLOWED
		Achievements.loadAchievements();
		var leDate = Date.now();
		if (leDate.getDay() == 5 && leDate.getHours() >= 18) {
			var achieveID:Int = Achievements.getAchievementIndex('friday_night_play');
			if(!Achievements.isAchievementUnlocked(Achievements.achievementsStuff[achieveID][2])) { //It's a friday night. WEEEEEEEEEEEEEEEEEE
				Achievements.achievementsMap.set(Achievements.achievementsStuff[achieveID][2], true);
				giveAchievement();
				ClientPrefs.saveSettings();
			}
		}
		#end

		super.create();
	}

	#if ACHIEVEMENTS_ALLOWED
	// Unlocks "Freaky on a Friday Night" achievement
	function giveAchievement() {
		add(new AchievementObject('friday_night_play', camAchievement));
		FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);
		trace('Giving achievement "friday_night_play"');
	}
	#end

	var selectedSomethin:Bool = false;

	function funnyfloat() {
		aaa1 = FlxTween.tween(star1, {y: star1.y + 20}, 3, {ease: FlxEase.quadInOut,
			onComplete: function(twn:FlxTween)
			{
				new FlxTimer().start(0.1, function(tmr:FlxTimer)
					{
						aaa2 = FlxTween.tween(star1, {y: star1.y - 20}, 3, {ease: FlxEase.quadInOut,
							onComplete: function(twn:FlxTween)
							{
								new FlxTimer().start(0.1, function(tmr:FlxTimer)
									{
										funnyfloat();
									});
							}
						});
					});
			}
		});
		aaa3 = FlxTween.tween(star2, {y: star2.y - 20}, 3, {ease: FlxEase.quadInOut,
			onComplete: function(twn:FlxTween)
			{
				aaa4 = FlxTween.tween(star2, {y: star2.y + 20}, 3, {ease: FlxEase.quadInOut,
					onComplete: function(twn:FlxTween)
					{
						//funnyfloat();
					}
				});
			}
		});
	}

	function funnyfloat2() {
		menustuff.forEach(function(spr:FlxSprite)
			{
				aaa5 = FlxTween.tween(spr, {y: spr.y + 10}, 3, {ease: FlxEase.quadInOut,
					onComplete: function(twn:FlxTween)
					{
						new FlxTimer().start(0.1, function(tmr:FlxTimer)
							{
								aaa6 = FlxTween.tween(spr, {y: spr.y - 10}, 3, {ease: FlxEase.quadInOut,
									onComplete: function(twn:FlxTween)
									{
										new FlxTimer().start(0.1, function(tmr:FlxTimer)
											{
												funnyfloat2();
											});
									}
								});
							});
					}
				});
			});
		menustuff2.forEach(function(spr:FlxSprite)
			{
				aaa7 = FlxTween.tween(spr, {y: spr.y + 10}, 3, {ease: FlxEase.quadInOut,
					onComplete: function(twn:FlxTween)
					{
						aaa8 = FlxTween.tween(spr, {y: spr.y - 10}, 3, {ease: FlxEase.quadInOut,
							onComplete: function(twn:FlxTween)
							{
								//funnyfloat2();
							}
						});
					}
				});
			});
	}

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		StoryMenuState.stary1 = star1.y;
		StoryMenuState.stary2 = star2.y;

		for (i in 0...optionShit.length)
			{
				menustuff.members[i].alpha = 1;
				menustuff.members[curSelected].alpha = 0;
				menustuff2.members[i].alpha = 0;
				menustuff2.members[curSelected].alpha = 1;
			}

		var lerpVal:Float = CoolUtil.boundTo(elapsed * 5.6, 0, 1);
		camFollowPos.setPosition(FlxMath.lerp(camFollowPos.x, camFollow.x, lerpVal), FlxMath.lerp(camFollowPos.y, camFollow.y, lerpVal));

		if (!selectedSomethin && canmove)
		{
			if (controls.UI_UP_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(-1);
			}

			if (controls.UI_DOWN_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(1);
			}

			if (controls.BACK)
			{
				selectedSomethin = true;
				FlxG.sound.play(Paths.sound('cancelMenu'));
				MusicBeatState.switchState(new TitleState());
			}

			if (controls.ACCEPT)
			{
				if (optionShit[curSelected] == 'donate')
				{
					CoolUtil.browserLoad('https://ninja-muffin24.itch.io/funkin');
				}
				else
				{
					selectedSomethin = true;
					FlxG.sound.play(Paths.sound('confirmMenu'));


					menuItems.forEach(function(spr:FlxSprite)
					{
						if (curSelected != spr.ID)
						{
							FlxTween.tween(spr, {alpha: 0}, 0.4, {
								ease: FlxEase.quadOut,
								onComplete: function(twn:FlxTween)
								{
									spr.kill();
								}
							});
						}
						else
						{
								var daChoice:String = optionShit[curSelected];

								if(aa1 != null) {
									aa1.cancel();
								}

								if(aa2 != null) {
									aa2.cancel();
								}

								if(aa3 != null) {
									aa3.cancel();
								}

								if(aa4 != null) {
									aa4.cancel();
								}

								if(aa5 != null) {
									aa5.cancel();
								}

								if(aa6 != null) {
									aa6.cancel();
								}

								if(aa7 != null) {
									aa7.cancel();
								}

								if(aa8 != null) {
									aa8.cancel();
								}

								if(aa9 != null) {
									aa9.cancel();
								}

								if(aa10 != null) {
									aa10.cancel();
								}

								if (optionShit[curSelected] == 'story')
									{
										FlxTransitionableState.skipNextTransIn = true;
										FlxTransitionableState.skipNextTransOut = true;
									}
								if (optionShit[curSelected] != 'story')
									{
										FlxTween.tween(FlxG.camera, {zoom: 5}, 1, {ease: FlxEase.expoIn});
										FlxTween.tween(bg, {angle: 45}, 1, {ease: FlxEase.expoIn});
									}
								FlxTween.tween(spr, {x: -600}, 0.6, {
									ease: FlxEase.backIn,
									onComplete: function(twn:FlxTween)
									{
										spr.kill();
									}
								});
								menustuff.forEach(function(spr1:FlxSprite)
									{
										FlxTween.tween(spr1, {x: -600}, 0.6, {
											ease: FlxEase.backIn,
											onComplete: function(twn:FlxTween)
											{
												spr1.kill();
											}
										});
									});
								menustuff2.forEach(function(spr2:FlxSprite)
									{
										FlxTween.tween(spr2, {x: -600}, 0.6, {
											ease: FlxEase.backIn,
											onComplete: function(twn:FlxTween)
											{
												spr2.kill();
											}
										});
									});
								textgrp.forEach(function(spr2:FlxSprite)
									{
										FlxTween.tween(spr2, {x: spr2.x + 600}, 0.6, {
											ease: FlxEase.backIn,
											onComplete: function(twn:FlxTween)
											{
												spr2.kill();
											}
										});
									});

								new FlxTimer().start(0.4, function(tmr:FlxTimer)
									{
										switch (daChoice)
										{
											case 'story':
												new FlxTimer().start(0.5, function(tmr:FlxTimer)
													{
														MusicBeatState.switchState(new StoryMenuState());
													});
											case 'freeplay':
												MusicBeatState.switchState(new FreeplayState());
											case 'awards':
												MusicBeatState.switchState(new AchievementsMenuState());
											case 'credits':
												MusicBeatState.switchState(new CreditsState());
											case 'options':
												MusicBeatState.switchState(new OptionsState());
										}
									});

						}
					});
				}
			}
			#if desktop
			else if (FlxG.keys.justPressed.SEVEN)
			{
				selectedSomethin = true;
				MusicBeatState.switchState(new MasterEditorMenu());
			}
			#end
		}

		super.update(elapsed);

		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.screenCenter(X);
		});
	}

	function changeItem(huh:Int = 0)
	{
		curSelected += huh;

		if (curSelected >= 4)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = 4 - 1;

		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.animation.play('idle');
			spr.offset.y = 0;
			spr.updateHitbox();

			if (spr.ID == curSelected)
			{
				spr.animation.play('selected');
				spr.offset.x = 0.15 * (spr.frameWidth / 2 + 180);
				spr.offset.y = 0.15 * spr.frameHeight;
				FlxG.log.add(spr.frameWidth);
			}
		});
	}
}
