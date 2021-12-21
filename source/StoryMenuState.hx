package;

#if desktop
import Discord.DiscordClient;
#end
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.tweens.FlxEase;
import flixel.addons.transition.FlxTransitionableState;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import lime.net.curl.CURLCode;
import WeekData;

using StringTools;

class StoryMenuState extends MusicBeatState
{
	// Wether you have to beat the previous week for playing this one
	// Not recommended, as people usually download your mod for, you know,
	// playing just the modded week then delete it.
	// defaults to True
	public static var weekCompleted:Map<String, Bool> = new Map<String, Bool>();

	var scoreText:FlxText;

	private static var curDifficulty:Int = 1;

	var txtWeekTitle:FlxText;
	var bgSprite:FlxSprite;
	var aaa1:FlxTween;
	var aaa2:FlxTween;
	var aaa3:FlxTween;
	var aaa4:FlxTween;

	var left:FlxTween;
	var right:FlxTween;

	var bop1:FlxTween;
	var bop2:FlxTween;
	var bop3:FlxTween;
	var bop4:FlxTween;
	var bop5:FlxTween;
	var bop6:FlxTween;
	var bop7:FlxTween;
	var bop8:FlxTween;
	var bop9:FlxTween;

	private static var curWeek:Int = 0;

	var txtTracklist:FlxText;

	var grpWeekText:FlxTypedGroup<MenuItem>;
	var grpWeekCharacters:FlxTypedGroup<MenuCharacter>;

	var grpLocks:FlxTypedGroup<FlxSprite>;

	var difficultySelectors:FlxGroup;
	var sprDifficultyGroup:FlxTypedGroup<FlxSprite>;
	var leftArrow:FlxSprite;
	var rightArrow:FlxSprite;

	var tutgrp:FlxTypedGroup<FlxSprite>;
	var cjgrp:FlxTypedGroup<FlxSprite>;
	var vadegrp:FlxTypedGroup<FlxSprite>;
	var bonusgrp:FlxTypedGroup<FlxSprite>;

	var star1:FlxSprite;
	var star2:FlxSprite;
	var bg:FlxSprite;
	var bg2:FlxSprite;
	var bg3:FlxSprite;
	var bg4:FlxSprite;
	var one:FlxSprite;
	public static var stary1:Float;
	public static var stary2:Float;
	var tut:FlxSprite;
	var cj:FlxSprite;
	var vade:FlxSprite;
	var bonus:FlxSprite;

	var gf:FlxSprite;
	var sm:FlxSprite;
	var cjruby:FlxSprite;
	var vadechar:FlxSprite;

	override function create()
	{
		#if MODS_ALLOWED
		//Paths.destroyLoadedImages();
		#end
		WeekData.reloadWeekFiles(true);

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
		star1.y = stary1;
		star1.x += 1;
		add(star1);

		star2 = new FlxSprite().loadGraphic(Paths.image('1280x720 selectMenu/selectStars2'));
		star2.scrollFactor.set(0, 0);
		star2.updateHitbox();
		star2.screenCenter();
		star2.antialiasing = true;
		star2.y = stary2;
		star2.x += 136;
		add(star2);

		one = new FlxSprite(10).loadGraphic(Paths.image('1280x720 freeplayMenu/pillarLeft'));
		one.antialiasing = true;
		add(one);

		one.x -= one.width;
		FlxTween.tween(one, {x: one.x +one.width}, 1, {startDelay: 0.0,
			ease: FlxEase.expoOut});

		bg3 = new FlxSprite().loadGraphic(Paths.image('1280x720 storyMenu/stageOutlineScreen'));
		bg3.scrollFactor.set(0, 0);
		bg3.updateHitbox();
		bg3.antialiasing = true;
		add(bg3);

		bg3.x -= bg3.width + 295;
		FlxTween.tween(bg3, {x: bg3.x +bg3.width + (295 *2)}, 1, {startDelay: 0.0,
			ease: FlxEase.expoOut});

		bg2 = new FlxSprite().loadGraphic(Paths.image('1280x720 storyMenu/stageOutline'));
		bg2.scrollFactor.set(0, 0);
		bg2.updateHitbox();
		bg2.antialiasing = true;
		add(bg2);

		bg2.x -= bg2.width;
		FlxTween.tween(bg2, {x: bg2.x +bg2.width}, 1, {startDelay: 0.0,
			ease: FlxEase.expoOut});

		if(curWeek >= WeekData.weeksList.length) curWeek = 0;
		persistentUpdate = persistentDraw = true;

		scoreText = new FlxText(10, 10, 0, "SCORE: 49324858", 36);
		scoreText.setFormat("VCR OSD Mono", 32);

		txtWeekTitle = new FlxText(FlxG.width * 0.7, 10, 0, "", 32);
		txtWeekTitle.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, RIGHT);
		txtWeekTitle.alpha = 0.7;

		var rankText:FlxText = new FlxText(0, 10);
		rankText.text = 'RANK: GREAT';
		rankText.setFormat(Paths.font("vcr.ttf"), 32);
		rankText.size = scoreText.size;
		rankText.screenCenter(X);

		var ui_tex = Paths.getSparrowAtlas('campaign_menu_UI_assets');
		var bgYellow:FlxSprite = new FlxSprite(0, 56).makeGraphic(FlxG.width, 386, 0xFFF9CF51);
		bgSprite = new FlxSprite(0, 56);
		bgSprite.antialiasing = ClientPrefs.globalAntialiasing;

		grpWeekText = new FlxTypedGroup<MenuItem>();
		add(grpWeekText);

		var blackBarThingie:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, 56, FlxColor.BLACK);

		grpWeekCharacters = new FlxTypedGroup<MenuCharacter>();

		grpLocks = new FlxTypedGroup<FlxSprite>();
		add(grpLocks);

		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		for (i in 0...WeekData.weeksList.length)
		{
			WeekData.setDirectoryFromWeek(WeekData.weeksLoaded.get(WeekData.weeksList[1]));
			var weekThing:MenuItem = new MenuItem(0, bgSprite.y + 396, WeekData.weeksList[1]);
			weekThing.y += ((weekThing.height + 20) * i);
			weekThing.targetY = i;
			grpWeekText.add(weekThing);
			weekThing.visible = false;

			weekThing.screenCenter(X);
			weekThing.antialiasing = ClientPrefs.globalAntialiasing;
			// weekThing.updateHitbox();

			// Needs an offset thingie
			if (weekIsLocked(i))
			{
				var lock:FlxSprite = new FlxSprite(weekThing.width + 10 + weekThing.x);
				lock.frames = ui_tex;
				lock.animation.addByPrefix('lock', 'lock');
				lock.animation.play('lock');
				lock.ID = i;
				lock.antialiasing = ClientPrefs.globalAntialiasing;
				grpLocks.add(lock);
			}
		}

		WeekData.setDirectoryFromWeek(WeekData.weeksLoaded.get(WeekData.weeksList[0]));
		var charArray:Array<String> = WeekData.weeksLoaded.get(WeekData.weeksList[0]).weekCharacters;
		for (char in 0...3)
		{
			var weekCharacterThing:MenuCharacter = new MenuCharacter((FlxG.width * 0.25) * (1 + char) - 150, charArray[char]);
			weekCharacterThing.y += 70;
			grpWeekCharacters.add(weekCharacterThing);
		}

		difficultySelectors = new FlxGroup();
		add(difficultySelectors);

		leftArrow = new FlxSprite(grpWeekText.members[0].x + grpWeekText.members[0].width + 10, grpWeekText.members[0].y + 25);
		leftArrow.loadGraphic(Paths.image('1280x720 storyMenu/selectLeft'));
		leftArrow.x -= 120;
		leftArrow.y += 110;
		leftArrow.antialiasing = ClientPrefs.globalAntialiasing;
		difficultySelectors.add(leftArrow);

		sprDifficultyGroup = new FlxTypedGroup<FlxSprite>();
		add(sprDifficultyGroup);

		
		for (i in 0...CoolUtil.difficultyStuff.length) {
			var sprDifficulty:FlxSprite = new FlxSprite(leftArrow.x + 10 + leftArrow.width, leftArrow.y).loadGraphic(Paths.image('menudifficulties/' + CoolUtil.difficultyStuff[i][0].toLowerCase()));
			sprDifficulty.x += (308 - sprDifficulty.width) / 2;
			sprDifficulty.ID = i;
			sprDifficulty.antialiasing = ClientPrefs.globalAntialiasing;
			sprDifficultyGroup.add(sprDifficulty);
		}
		changeDifficulty(0);

		difficultySelectors.add(sprDifficultyGroup);

		rightArrow = new FlxSprite(sprDifficultyGroup.members[1].x + 60 + sprDifficultyGroup.members[1].width - 52.5, leftArrow.y);
		rightArrow.loadGraphic(Paths.image('1280x720 storyMenu/selectRight'));
		rightArrow.antialiasing = ClientPrefs.globalAntialiasing;
		difficultySelectors.add(rightArrow);

		var tracksSprite:FlxSprite = new FlxSprite(FlxG.width * 0.07, bgSprite.y + 425).loadGraphic(Paths.image('Menu_Tracks'));
		tracksSprite.antialiasing = ClientPrefs.globalAntialiasing;
		//add(tracksSprite);

		txtTracklist = new FlxText(FlxG.width * 0.05, tracksSprite.y + 60, 0, "", 32);
		txtTracklist.alignment = CENTER;
		txtTracklist.font = rankText.font;
		txtTracklist.color = 0xFFe55777;
		//add(txtTracklist);
		// add(rankText);
		add(scoreText);
		//add(txtWeekTitle);

		
		funnyfloat();

		sprDifficultyGroup.forEach(function(spr:FlxSprite)
			{
				spr.x += 400;
				FlxTween.tween(spr, {x: spr.x-400}, 0.85, {
					ease: FlxEase.backOut});
			});
			leftArrow.x += 400;
			FlxTween.tween(leftArrow, {x: leftArrow.x-400}, 0.85, {
				ease: FlxEase.backOut});
				rightArrow.x += 400;
			FlxTween.tween(rightArrow, {x: rightArrow.x-400}, 0.85, {
				ease: FlxEase.backOut});

		tutgrp = new FlxTypedGroup<FlxSprite>();
		add(tutgrp);
		vadegrp = new FlxTypedGroup<FlxSprite>();
		add(vadegrp);
		bonusgrp = new FlxTypedGroup<FlxSprite>();
		add(bonusgrp);
		cjgrp = new FlxTypedGroup<FlxSprite>();
		add(cjgrp);

		tut = new FlxSprite().loadGraphic(Paths.image('1280x720 storyMenu/weekTutorial'));
		tut.antialiasing = ClientPrefs.globalAntialiasing;
		tut.screenCenter();
		tut.x += 360;
		tut.y -= 213;
		tut.updateHitbox();
		tutgrp.add(tut);

		var tutd:FlxSprite = new FlxSprite().loadGraphic(Paths.image('1280x720 storyMenu/weekTutorialDesc'));
		tutd.antialiasing = ClientPrefs.globalAntialiasing;
		tutd.screenCenter();
		tutd.x += 354;
		tutd.y += 19;
		tutd.updateHitbox();
		tutgrp.add(tutd);

		cj = new FlxSprite().loadGraphic(Paths.image('1280x720 storyMenu/weekStarlight'));
		cj.antialiasing = ClientPrefs.globalAntialiasing;
		cj.screenCenter();
		cj.x += 360;
		cj.y -= 234;
		cj.updateHitbox();
		cjgrp.add(cj);

		var cjd:FlxSprite = new FlxSprite().loadGraphic(Paths.image('1280x720 storyMenu/weekStarlightDesc'));
		cjd.antialiasing = ClientPrefs.globalAntialiasing;
		cjd.screenCenter();
		cjd.x += 354;
		cjd.y += 19;
		cjd.updateHitbox();
		cjgrp.add(cjd);

		bonus = new FlxSprite().loadGraphic(Paths.image('1280x720 storyMenu/aaa2'));
		bonus.antialiasing = ClientPrefs.globalAntialiasing;
		bonus.screenCenter();
		bonus.x += 360;
		bonus.y -= 234;
		bonus.updateHitbox();
		bonusgrp.add(bonus);

		var bonusd:FlxSprite = new FlxSprite().loadGraphic(Paths.image('1280x720 storyMenu/aaa'));
		bonusd.antialiasing = ClientPrefs.globalAntialiasing;
		bonusd.screenCenter();
		bonusd.x += 354;
		bonusd.y += 19;
		bonusd.updateHitbox();
		bonusgrp.add(bonusd);

		vade = new FlxSprite().loadGraphic(Paths.image('1280x720 storyMenu/weekVade'));
		vade.antialiasing = ClientPrefs.globalAntialiasing;
		vade.screenCenter();
		vade.x += 360;
		vade.y -= 232;
		vade.updateHitbox();
		vadegrp.add(vade);

		var vaded:FlxSprite = new FlxSprite().loadGraphic(Paths.image('1280x720 storyMenu/weekVadeDesc'));
		vaded.antialiasing = ClientPrefs.globalAntialiasing;
		vaded.screenCenter();
		vaded.x += 355;
		vaded.y += 4;
		vaded.updateHitbox();
		vadegrp.add(vaded);

		new FlxTimer().start(0.732, function(tmr:FlxTimer)
			{
				bop();
			},0);

		bg4 = new FlxSprite(50).loadGraphic(Paths.image('1280x720 storyMenu/spotlight'));
		bg4.scrollFactor.set(0, 0);
		bg4.updateHitbox();
		bg4.antialiasing = true;
		bg4.alpha = 0.0001;

		gf = new FlxSprite(bg4.x - 150, bg4.y + 150);
		gf.frames = Paths.getSparrowAtlas('1280x720 storyMenu/MENUTUTORIAL');
		gf.animation.addByPrefix('idle', 'GF Dancing Beat', 24,true);
		gf.animation.play('idle');
		gf.antialiasing = ClientPrefs.globalAntialiasing;
		gf.scale.set(0.49,0.49);
		add(gf);

		sm = new FlxSprite(bg4.x - 200, bg4.y - 730);
		sm.frames = Paths.getSparrowAtlas('1280x720 storyMenu/MENUcj_assets');
		sm.animation.addByPrefix('idle', 'penis', 24,true);
		sm.animation.play('idle');
		sm.antialiasing = ClientPrefs.globalAntialiasing;
		sm.scale.set(0.188,0.188);
		add(sm);

		cjruby = new FlxSprite(bg4.x - 200, bg4.y -40);
		cjruby.frames = Paths.getSparrowAtlas('1280x720 storyMenu/MENUduet_assets');
		cjruby.animation.addByPrefix('idle', 'duet idle dance', 24,true);
		cjruby.animation.play('idle');
		cjruby.antialiasing = ClientPrefs.globalAntialiasing;
		cjruby.scale.set(0.565,0.565);
		add(cjruby);

		vadechar = new FlxSprite(bg4.x - 100, bg4.y +20);
		vadechar.frames = Paths.getSparrowAtlas('1280x720 storyMenu/whatmenu');
		vadechar.animation.addByPrefix('idle', 'Dad idle dance', 24,true);
		vadechar.animation.play('idle');
		vadechar.antialiasing = ClientPrefs.globalAntialiasing;
		vadechar.scale.set(0.55,0.55);
		add(vadechar);

		add(bg4);

		FlxTween.tween(bg4, {alpha: 1}, 0.6, {startDelay: 0.0,
			ease: FlxEase.expoIn});

		layer(0);
		changeWeek();

		super.create();
	}

	function layer(aaa:Int) {
		remove(sm);
		remove(gf);
		remove(cjruby);
		remove(vadechar);

		gf = new FlxSprite(bg4.x - 150, bg4.y + 150);
		gf.frames = Paths.getSparrowAtlas('1280x720 storyMenu/MENUTUTORIAL');
		gf.animation.addByPrefix('idle', 'GF Dancing Beat', 24,true);
		gf.animation.play('idle');
		gf.antialiasing = ClientPrefs.globalAntialiasing;
		gf.scale.set(0.49,0.49);
		sm = new FlxSprite(bg4.x - 200, bg4.y - 730);
		sm.frames = Paths.getSparrowAtlas('1280x720 storyMenu/MENUcj_assets');
		sm.animation.addByPrefix('idle', 'penis', 24,true);
		sm.animation.play('idle');
		sm.antialiasing = ClientPrefs.globalAntialiasing;
		sm.scale.set(0.190,0.190);
		cjruby = new FlxSprite(bg4.x - 200, bg4.y -40);
		cjruby.frames = Paths.getSparrowAtlas('1280x720 storyMenu/MENUduet_assets');
		cjruby.animation.addByPrefix('idle', 'duet idle dance', 24,true);
		cjruby.animation.play('idle');
		cjruby.antialiasing = ClientPrefs.globalAntialiasing;
		cjruby.scale.set(0.565,0.565);
		vadechar = new FlxSprite(bg4.x - 100, bg4.y +20);
		vadechar.frames = Paths.getSparrowAtlas('1280x720 storyMenu/whatmenu');
		vadechar.animation.addByPrefix('idle', 'Dad idle dance', 24,true);
		vadechar.animation.play('idle');
		vadechar.antialiasing = ClientPrefs.globalAntialiasing;
		vadechar.scale.set(0.55,0.55);
		sm.color = FlxColor.WHITE;
		vadechar.color = FlxColor.WHITE;
		cjruby.color = FlxColor.WHITE;
		gf.color = FlxColor.WHITE;

		switch (aaa)
		{
			case 0:
				//add(cjruby);
				add(sm);
				add(vadechar);
				add(gf);
				gf.x = bg4.x - 150;
				gf.y = bg4.y + 150;
				sm.x = bg4.x - 200;
				sm.y = bg4.y - 730;
				vadechar.x = bg4.x - 100;
				vadechar.y =bg4.y +20;
				sm.color = FlxColor.fromHSL(sm.color.hue, sm.color.saturation, sm.color.lightness - 0.80, 1);
				vadechar.color = FlxColor.fromHSL(vadechar.color.hue, vadechar.color.saturation, vadechar.color.lightness - 0.80, 1);
			case 1:
				add(gf);
				add(cjruby);
				add(sm);
				gf.x = bg4.x - 250;
				gf.y = bg4.y + 60;
				cjruby.x = bg4.x + 150;
				cjruby.y =bg4.y -40;
				sm.x = bg4.x - 350;
				sm.y = bg4.y - 670;
				cjruby.color = FlxColor.fromHSL(cjruby.color.hue, cjruby.color.saturation, cjruby.color.lightness - 0.80, 1);
				gf.color = FlxColor.fromHSL(gf.color.hue,gf.color.saturation, gf.color.lightness - 0.80, 1);
			case 2:
				add(vadechar);
				add(sm);
				add(cjruby);
				cjruby.x = bg4.x - 60;
				cjruby.y =bg4.y + 40;
				sm.x = bg4.x - 500;
				sm.y = bg4.y - 730;
				vadechar.x = bg4.x + 200;
				vadechar.y =bg4.y +20;
				sm.color = FlxColor.fromHSL(sm.color.hue, sm.color.saturation, sm.color.lightness - 0.80, 1);
				vadechar.color = FlxColor.fromHSL(vadechar.color.hue, vadechar.color.saturation, vadechar.color.lightness - 0.80, 1);
			case 3:
				add(gf);
				add(cjruby);
				add(vadechar);
				gf.x = bg4.x + 90;
				gf.y = bg4.y + 60;
				vadechar.x = bg4.x + 70;
				vadechar.y =bg4.y +100;
				cjruby.x = bg4.x - 150;
				cjruby.y =bg4.y -40;
				cjruby.color = FlxColor.fromHSL(cjruby.color.hue, cjruby.color.saturation, cjruby.color.lightness - 0.80, 1);
				gf.color = FlxColor.fromHSL(gf.color.hue,gf.color.saturation, gf.color.lightness - 0.80, 1);
		}

		if(!ClientPrefs.mainweek)
			{
				cjruby.color = FlxColor.fromHSL(cjruby.color.hue, cjruby.color.saturation, cjruby.color.lightness - 100, 1);
				vadechar.color = FlxColor.fromHSL(vadechar.color.hue, vadechar.color.saturation, vadechar.color.lightness - 100, 1);
			}
	}

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

	override function closeSubState() {
		persistentUpdate = true;
		changeWeek();
		super.closeSubState();
	}

	override function update(elapsed:Float)
	{
		// scoreText.setFormat('VCR OSD Mono', 32);
		switch (curWeek)
		{
			case 0:
				for (i in tutgrp) {
					i.alpha = 1;
				}
				for (i in 0...2) {
					vadegrp.members[i].alpha = 0.0001;
					cjgrp.members[i].alpha = 0.0001;
					bonusgrp.members[i].alpha = 0.0001;
				}
			case 1:
				for (i in cjgrp) {
					i.alpha = 1;
				}
				for (i in 0...2) {
					vadegrp.members[i].alpha = 0.0001;
					tutgrp.members[i].alpha = 0.0001;
					bonusgrp.members[i].alpha = 0.0001;
				}
			case 2:
				for (i in bonusgrp) {
					i.alpha = 1;
				}
				for (i in 0...2) {
					vadegrp.members[i].alpha = 0.0001;
					cjgrp.members[i].alpha = 0.0001;
					tutgrp.members[i].alpha = 0.0001;
				}
			case 3:
				for (i in vadegrp) {
					i.alpha = 1;
				}
				for (i in 0...2) {
					bonusgrp.members[i].alpha = 0.0001;
					cjgrp.members[i].alpha = 0.0001;
					tutgrp.members[i].alpha = 0.0001;
				}
		}
		lerpScore = Math.floor(FlxMath.lerp(lerpScore, intendedScore, CoolUtil.boundTo(elapsed * 30, 0, 1)));
		if(Math.abs(intendedScore - lerpScore) < 10) lerpScore = intendedScore;

		scoreText.text = "WEEK SCORE:" + lerpScore;

		// FlxG.watch.addQuick('font', scoreText.font);

		difficultySelectors.visible = !weekIsLocked(curWeek);

		if (!movedBack && !selectedWeek)
		{
			if (controls.UI_UP_P)
			{
				if (curWeek == 0)
					{
						if(ClientPrefs.mainweek)
							{
								changeWeek(-1);
								FlxG.sound.play(Paths.sound('scrollMenu'));
							}
					}
					else
						{
							changeWeek(-1);
							FlxG.sound.play(Paths.sound('scrollMenu'));
						}
			}

			if (controls.UI_DOWN_P)
			{
				if (curWeek == 1)
					{
						if(ClientPrefs.mainweek)
							{
								changeWeek(1);
								FlxG.sound.play(Paths.sound('scrollMenu'));
							}
					}
					else
						{
							changeWeek(1);
							FlxG.sound.play(Paths.sound('scrollMenu'));
						}
			}

			if (controls.UI_RIGHT_P)
				changeDifficulty(1);
			if (controls.UI_LEFT_P)
				changeDifficulty(-1);

			if (controls.ACCEPT && curWeek != 3)
			{
				selectWeek();
			}
			else if(controls.RESET)
			{
				persistentUpdate = false;
				openSubState(new ResetScoreSubState('', curDifficulty, '', curWeek));
				FlxG.sound.play(Paths.sound('scrollMenu'));
			}
		}

		if (controls.BACK && !movedBack && !selectedWeek)
		{
			FlxTween.tween(FlxG.camera, {zoom: 5}, 1, {ease: FlxEase.expoIn});
			FlxTween.tween(bg, {angle: 45}, 1, {ease: FlxEase.expoIn});
			FlxG.sound.play(Paths.sound('cancelMenu'));
			movedBack = true;
			new FlxTimer().start(0.4, function(tmr:FlxTimer)
				{
					MusicBeatState.switchState(new MainMenuState());
				});
			
		}

		super.update(elapsed);

		grpLocks.forEach(function(lock:FlxSprite)
		{
			lock.y = grpWeekText.members[lock.ID].y;
		});
	}

	var movedBack:Bool = false;
	var selectedWeek:Bool = false;
	var stopspamming:Bool = false;

	function selectWeek()
	{
		if (!weekIsLocked(curWeek))
		{
			if (stopspamming == false)
			{
				FlxG.sound.play(Paths.sound('confirmMenu'));

				grpWeekText.members[curWeek].startFlashing();
				if(grpWeekCharacters.members[1].character != '') grpWeekCharacters.members[1].animation.play('confirm');
				stopspamming = true;
			}

			// We can't use Dynamic Array .copy() because that crashes HTML5, here's a workaround.
			var songArray:Array<String> = [];
			var leWeek:Array<Dynamic> = WeekData.weeksLoaded.get(WeekData.weeksList[curWeek]).songs;
			for (i in 0...leWeek.length) {
				songArray.push(leWeek[i][0]);
			}

			// Nevermind that's stupid lmao
			PlayState.storyPlaylist = songArray;
			PlayState.isStoryMode = true;
			selectedWeek = true;

			var diffic = CoolUtil.difficultyStuff[curDifficulty][1];
			if(diffic == null) diffic = '';

			PlayState.storyDifficulty = curDifficulty;

			var thingy:String = '';
			if (ClientPrefs.oldvoice && curWeek == 1)
				thingy = '-old';

			PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0].toLowerCase() + diffic, PlayState.storyPlaylist[0].toLowerCase() + thingy);
			if (curWeek <= 1)
				{
					PlayState.abelSONG = Song.loadFromJson('abel',  PlayState.storyPlaylist[0].toLowerCase());
					PlayState.maxSONG = Song.loadFromJson('max',  PlayState.storyPlaylist[0].toLowerCase());
					PlayState.olleySONG = Song.loadFromJson('olley',  PlayState.storyPlaylist[0].toLowerCase());
				}
			if (curWeek == 2)
				PlayState.altSONG = Song.loadFromJson('alt',  PlayState.storyPlaylist[0].toLowerCase());
			PlayState.storyWeek = curWeek;
			PlayState.campaignScore = 0;
			PlayState.campaignMisses = 0;
			FlxTween.tween(FlxG.camera, {zoom: 5}, 1, {ease: FlxEase.expoIn});
			FlxTween.tween(bg, {angle: 45}, 1, {ease: FlxEase.expoIn});
			new FlxTimer().start(0.4, function(tmr:FlxTimer)
			{
				LoadingState.loadAndSwitchState(new PlayState(), true);
				FreeplayState.destroyFreeplayVocals();
			});
		} else {
			FlxG.sound.play(Paths.sound('cancelMenu'));
		}
	}

	function changeDifficulty(change:Int = 0):Void
	{
		if (change == 1)
			{
				rightArrow.x = sprDifficultyGroup.members[1].x + 60 + sprDifficultyGroup.members[1].width - 52.5;
				if(right != null) {
					right.cancel();
				}
				rightArrow.x += 25;
				right = FlxTween.tween(rightArrow, {x:rightArrow.x - 25}, 0.6, {startDelay: 0.0,
					ease: FlxEase.expoOut,
					onComplete: function(twn:FlxTween) {
						right = null;
					}
				});
			}
			else if (change == -1)
			{
				leftArrow.x = grpWeekText.members[0].x + grpWeekText.members[0].width + 10;
				leftArrow.x -= 120;
				if(left != null) {
					left.cancel();
				}
				leftArrow.x -= 25;
				left = FlxTween.tween(leftArrow, {x:leftArrow.x + 25}, 0.6, {startDelay: 0.0,
					ease: FlxEase.expoOut,
					onComplete: function(twn:FlxTween) {
						left = null;
					}
				});
			}	
		curDifficulty += change;

		if (curDifficulty < 0)
			curDifficulty = CoolUtil.difficultyStuff.length-1;
		if (curDifficulty >= CoolUtil.difficultyStuff.length)
			curDifficulty = 0;

		sprDifficultyGroup.forEach(function(spr:FlxSprite) {
			spr.visible = false;
			if(curDifficulty == spr.ID) {
				spr.visible = true;
				spr.alpha = 0;
				spr.y = leftArrow.y - 10;
				spr.scale.set(1.1,1.1);
				FlxTween.tween(spr, {y: leftArrow.y + 10, alpha: 1,"scale.x": 1,"scale.y": 1}, 0.07);
			}
		});

		#if !switch
		intendedScore = Highscore.getWeekScore(WeekData.weeksList[curWeek], curDifficulty);
		#end
	}

	var lerpScore:Int = 0;
	var intendedScore:Int = 0;

	function changeWeek(change:Int = 0):Void
	{
		curWeek += change;

		if (curWeek >= WeekData.weeksList.length)
			curWeek = 0;
		if (curWeek < 0)
			curWeek = WeekData.weeksList.length - 1;

		var leWeek:WeekData = WeekData.weeksLoaded.get(WeekData.weeksList[curWeek]);
		WeekData.setDirectoryFromWeek(leWeek);

		var leName:String = leWeek.storyName;
		txtWeekTitle.text = leName.toUpperCase();
		txtWeekTitle.x = FlxG.width - (txtWeekTitle.width + 10);

		var bullShit:Int = 0;

		for (item in grpWeekText.members)
		{
			item.targetY = bullShit - curWeek;
			if (item.targetY == Std.int(0) && !weekIsLocked(curWeek))
				item.alpha = 1;
			else
				item.alpha = 0.6;
			bullShit++;
		}

		bgSprite.visible = true;
		var assetName:String = leWeek.weekBackground;
		if(assetName == null || assetName.length < 1) {
			bgSprite.visible = false;
		} else {
			bgSprite.loadGraphic(Paths.image('menubackgrounds/menu_' + assetName));
		}
		updateText();
		layer(curWeek);
	}

	function weekIsLocked(weekNum:Int) {
		var leWeek:WeekData = WeekData.weeksLoaded.get(WeekData.weeksList[weekNum]);
		return (!leWeek.startUnlocked && leWeek.weekBefore.length > 0 && (!weekCompleted.exists(leWeek.weekBefore) || !weekCompleted.get(leWeek.weekBefore)));
	}

	function updateText()
	{
		var weekArray:Array<String> = WeekData.weeksLoaded.get(WeekData.weeksList[curWeek]).weekCharacters;
		for (i in 0...grpWeekCharacters.length) {
			grpWeekCharacters.members[i].changeCharacter(weekArray[i]);
		}

		var leWeek:WeekData = WeekData.weeksLoaded.get(WeekData.weeksList[curWeek]);
		var stringThing:Array<String> = [];
		for (i in 0...leWeek.songs.length) {
			stringThing.push(leWeek.songs[i][0]);
		}

		txtTracklist.text = '';
		for (i in 0...stringThing.length)
		{
			txtTracklist.text += stringThing[i] + '\n';
		}

		txtTracklist.text = txtTracklist.text.toUpperCase();

		txtTracklist.screenCenter(X);
		txtTracklist.x -= FlxG.width * 0.35;

		#if !switch
		intendedScore = Highscore.getWeekScore(WeekData.weeksList[curWeek], curDifficulty);
		#end
	}
	function bop() {
		for (i in 0...2) {
			bonusgrp.members[i].scale.set(1.1,1.1);
			cjgrp.members[i].scale.set(1.1,1.1);
			tutgrp.members[i].scale.set(1.1,1.1);
			vadegrp.members[i].scale.set(1.1,1.1);

			if(bop1 != null) {
				bop1.cancel();
			}
			bop1 = FlxTween.tween(bonusgrp.members[i], {"scale.x": 1,"scale.y": 1}, 0.6, {startDelay: 0.0,
				ease: FlxEase.expoOut,
				onComplete: function(twn:FlxTween) {
					bop1 = null;
				}
			});

			if(bop5 != null) {
				bop5.cancel();
			}
			bop5 = FlxTween.tween(tut, {"scale.x": 1,"scale.y": 1}, 0.6, {startDelay: 0.0,
				ease: FlxEase.expoOut,
				onComplete: function(twn:FlxTween) {
					bop5 = null;
				}
			});

			if(bop7 != null) {
				bop7.cancel();
			}
			bop7 = FlxTween.tween(cj, {"scale.x": 1,"scale.y": 1}, 0.6, {startDelay: 0.0,
				ease: FlxEase.expoOut,
				onComplete: function(twn:FlxTween) {
					bop7 = null;
				}
			});
			if(bop6 != null) {
				bop6.cancel();
			}
			bop6 = FlxTween.tween(bonus, {"scale.x": 1,"scale.y": 1}, 0.6, {startDelay: 0.0,
				ease: FlxEase.expoOut,
				onComplete: function(twn:FlxTween) {
					bop6 = null;
				}
			});
			if(bop8 != null) {
				bop8.cancel();
			}
			bop8 = FlxTween.tween(vade, {"scale.x": 1,"scale.y": 1}, 0.6, {startDelay: 0.0,
				ease: FlxEase.expoOut,
				onComplete: function(twn:FlxTween) {
					bop8 = null;
				}
			});

			if(bop2 != null) {
				bop2.cancel();
			}
			bop2 = FlxTween.tween(vadegrp.members[i], {"scale.x": 1,"scale.y": 1}, 0.6, {startDelay: 0.0,
				ease: FlxEase.expoOut,
				onComplete: function(twn:FlxTween) {
					bop2 = null;
				}
			});

			if(bop3 != null) {
				bop3.cancel();
			}
			bop3 = FlxTween.tween(cjgrp.members[i], {"scale.x": 1,"scale.y": 1}, 0.6, {startDelay: 0.0,
				ease: FlxEase.expoOut,
				onComplete: function(twn:FlxTween) {
					bop3 = null;
				}
			});

			if(bop4!= null) {
				bop4.cancel();
			}
			bop4 = FlxTween.tween(tutgrp.members[i], {"scale.x": 1,"scale.y": 1}, 0.6, {startDelay: 0.0,
				ease: FlxEase.expoOut,
				onComplete: function(twn:FlxTween) {
					bop4 = null;
				}
			});
		}
	}
}
