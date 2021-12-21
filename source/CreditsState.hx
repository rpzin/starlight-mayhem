package;

#if desktop
import Discord.DiscordClient;
#end
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import flixel.tweens.FlxEase;
import sys.FileSystem;
import lime.utils.Assets;

using StringTools;

class CreditsState extends MusicBeatState
{
	var curSelected:Int = 0;

	private var grpOptions:FlxTypedGroup<Alphabet>;
	private var iconArray:Array<AttachedSprite> = [];
	private var creditsStuff:Array<Dynamic> = [];

	var bg:FlxSprite;
	var one:FlxSprite;
	var two:FlxSprite;
	var descText:FlxText;
	var intendedColor:Int;
	var colorTween:FlxTween;
	var credits:FlxTypedGroup<Credit>;
	var tags:FlxTypedGroup<Tag>;
	var canmove:Bool = false;
	var leftArrow:FlxSprite;
	var rightArrow:FlxSprite;
	var c:FlxSprite;
	var bop1:FlxTween;
	var bop2:FlxTween;

	override function create()
	{
		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		FlxG.mouse.visible = true;

		FlxG.camera.zoom = 3;
		FlxTween.tween(FlxG.camera, {zoom: 1.075}, 0.8, {ease: FlxEase.expoInOut});

		bg = new FlxSprite().loadGraphic(Paths.image('1280x720 freeplayMenu/backgroundCredits'));
		bg.antialiasing = true;
		bg.y -= 35;
		add(bg);

		one = new FlxSprite(10).loadGraphic(Paths.image('1280x720 freeplayMenu/pillarLeft'));
		one.antialiasing = true;
		one.y -=35;
		add(one);

		two = new FlxSprite(1280 - 160 - 10).loadGraphic(Paths.image('1280x720 freeplayMenu/pillarRight'));
		two.antialiasing = true;
		two.y -= 35;
		add(two);

		two.x += 900;
		FlxTween.tween(two, {x: two.x -970}, 1, {startDelay: 0.4,
			ease: FlxEase.expoOut});

		one.x -= 900;
		FlxTween.tween(one, {x: one.x +970}, 1, {startDelay: 0.4,
			ease: FlxEase.expoOut});

		credits = new FlxTypedGroup<Credit>();
		add(credits);
		
		tags = new FlxTypedGroup<Tag>();
		add(tags);

		for (i in 0...25) {
			var iconthingy:Credit = new Credit();
			var taggy:Tag = new Tag();
			switch (i) {
				case 0:
					iconthingy = new Credit(403, 179, 'chris', 'https://twitter.com/TheMaskedChris');
					taggy = new Tag(490, 180, 'chris');
				case 1:
					iconthingy = new Credit(856, 160, 'ash', 'https://twitter.com/ash__i_guess_');
					taggy = new Tag(750, 188, 'ash');
				case 2:
					iconthingy = new Credit(402, 304, 'shadowfi', 'https://twitter.com/shadowfi1385');
					taggy = new Tag(498, 320, 'shadowfi');
					iconthingy.x -= 30;
					taggy.x -= 30;
					iconthingy.y -= 25;
					taggy.y -= 25;
				case 3:
					iconthingy = new Credit(914, 302, 'axion', 'https://twitter.com/4Axion_dev?t=xIDBm3SaVRup0DgEZxwh-w&s=09');
					taggy = new Tag(720, 318, 'axion');
					iconthingy.x -= 30;
					taggy.x -= 30;
					iconthingy.y -= 30;
					taggy.y -= 30;
				case 4:
					iconthingy = new Credit(355, 406, 'cheese', 'https://twitter.com/is_bluecheese?t=lsQgh9PwM4TQy32QmpVkZA&s=09');
					taggy = new Tag(456, 434, 'cheese');
					iconthingy.x -= 30;
					taggy.x -= 30;
					iconthingy.y -= 30;
					taggy.y -= 30;
				case 5:
					iconthingy = new Credit(927, 411, 'uniimations', 'https://twitter.com/UniiAnimates');
					taggy = new Tag(653, 425, 'uniimations');
					iconthingy.x -= 30;
					taggy.x -= 30;
					iconthingy.y -= 30;
					taggy.y -= 30;
				case 6:
					iconthingy = new Credit(388, 530, 'cerbera', 'https://www.youtube.com/channel/UCgfJjMiNGlI7uZu1cVag5NA');
					taggy = new Tag(487, 543, 'cerbera');
					iconthingy.x -= 30;
					taggy.x -= 30;
					iconthingy.y -= 30;
					taggy.y -= 30;
				case 7:
					iconthingy = new Credit(912, 528, 'miyno', 'https://twitter.com/Miyno26');
					taggy = new Tag(723, 533, 'miyno');
					iconthingy.x -= 30;
					taggy.x -= 30;
					iconthingy.y -= 30;
					taggy.y -= 30;
				case 8:
					iconthingy = new Credit(357, 643, 'cynical', 'https://www.twitch.tv/hunter_powder');
					taggy = new Tag(461,634, 'cynical');
					iconthingy.x -= 30;
					taggy.x -= 30;
					iconthingy.y -= 30;
					taggy.y -= 30;
				case 9:
					iconthingy = new Credit(878, 578, 'mudstep', 'https://youtube.com/c/Mudstep');
					taggy = new Tag(660, 611, 'mudstep');
					iconthingy.x += 15;
					iconthingy.y += 20;
				case 10:
					iconthingy = new Credit(340, 169, 'mikegeno', 'https://m.youtube.com/c/MikeGenoTheElectroWarper');
					taggy = new Tag(435, 187, 'mike');
				case 11:
					iconthingy = new Credit(870,167, 'ridingred', 'https://youtube.com/channel/UCsrWG26gb6HCI8tvimTzm4w');
					taggy = new Tag(645,195, 'ridinginthered');
				case 12:
					iconthingy = new Credit(377, 270, 'saster', 'https://www.youtube.com/channel/UCC4CkqOAwulRil3BEK9L3Mg');
					taggy = new Tag(489,278, 'saster');
				case 13:
					iconthingy = new Credit(848, 294, 'saru', 'https://twitter.com/Saruky__');
					taggy = new Tag(687, 283, 'saru');
				case 14:
					iconthingy = new Credit(333, 374, 'bluskys', 'https://twitter.com/bluskystv');
					taggy = new Tag(417, 388, 'bluskys');
				case 16:
					iconthingy = new Credit(834, 389, 'scorchvx', 'https://twitter.com/ScorchVx');
					taggy = new Tag(627, 415, 'scorchvx');
				case 17:
					iconthingy = new Credit(337,464, 'bastianos', 'https://gamebanana.com/members/1772815');
					taggy = new Tag(426, 492, 'bastiano');
				case 18:
					iconthingy = new Credit(814, 497, 'ohya', 'https://twitter.com/ohyaholla');
					taggy = new Tag(634, 513, 'ohya');
				case 19:
					iconthingy = new Credit(323, 563, 'jea', 'https://twitter.com/sprayjea');
					taggy = new Tag(422, 563, 'jea');
				case 20:
					iconthingy = new Credit(861, 582, 'cougar', 'https://twitter.com/CougarMacDowal1');
					taggy = new Tag(614, 612, 'cougar');
				case 21:
					iconthingy = new Credit(357, 201, 'aidan', 'https://twitter.com/vis0iden');
					taggy = new Tag(460, 204, 'aidan');
					taggy.x -= 30;
					iconthingy.x -= 30;
				case 22:
					iconthingy = new Credit(944, 206, 'corrupt', 'https://austinsanders.carrd.co/');
					taggy = new Tag(686, 227, 'corrupt');
					taggy.x -= 30;
					iconthingy.x -= 30;
				case 23:
					iconthingy = new Credit(354, 301, 'kiwiburd', 'https://twitter.com/ItKiwiBurd');
					taggy = new Tag(453, 315, 'kiwi');
					taggy.x -= 30;
					iconthingy.x -= 30;
				case 24:
					iconthingy = new Credit(907, 307, 'pizzapanckess', 'https://twitter.com/pizzapancakess_');
					taggy = new Tag(662, 345, 'hayden');
					taggy.x -= 30;
					iconthingy.x -= 30;
			}
			iconthingy.antialiasing = true;
			taggy.antialiasing = true;
			iconthingy.y -= 25;
			taggy.y -= 25;
			credits.add(iconthingy);
			tags.add(taggy);
		}
		for (i in 0...10)
			{
				credits.members[i].y += 1280;
				tags.members[i].y += 1280;
			}

		for (i in 10...21)
			{
				credits.members[i].x += 1280;
				tags.members[i].x += 1280;
			}
		for (i in 21...25)
			{
				credits.members[i].x += 1280 * 2;
				tags.members[i].x += 1280* 2;
			}
		for (i in 0...2)
			{
				FlxTween.tween(credits.members[i], {y:credits.members[i].y - 1280}, 1, {startDelay: 0.3,
					ease: FlxEase.expoOut});
				FlxTween.tween(tags.members[i], {y:tags.members[i].y - 1280}, 1, {startDelay: 0.3,
					ease: FlxEase.expoOut});
			}
		for (i in 2...4)
			{
				FlxTween.tween(credits.members[i], {y:credits.members[i].y - 1280}, 1, {startDelay: 0.6,
					ease: FlxEase.expoOut});
				FlxTween.tween(tags.members[i], {y:tags.members[i].y - 1280}, 1, {startDelay: 0.6,
					ease: FlxEase.expoOut});
			}
		for (i in 4...6)
			{
				FlxTween.tween(credits.members[i], {y:credits.members[i].y - 1280}, 1, {startDelay: 0.9,
					ease: FlxEase.expoOut});
				FlxTween.tween(tags.members[i], {y:tags.members[i].y - 1280}, 1, {startDelay: 0.9,
					ease: FlxEase.expoOut});
			}
		for (i in 6...8)
			{
				FlxTween.tween(credits.members[i], {y:credits.members[i].y - 1280}, 1, {startDelay: 1.2,
					ease: FlxEase.expoOut});
				FlxTween.tween(tags.members[i], {y:tags.members[i].y - 1280}, 1, {startDelay: 1.2,
					ease: FlxEase.expoOut});
			}
		for (i in 8...10)
			{
				FlxTween.tween(credits.members[i], {y:credits.members[i].y - 1280}, 1, {startDelay: 1.5,
					ease: FlxEase.expoOut});
				FlxTween.tween(tags.members[i], {y:tags.members[i].y - 1280}, 1, {startDelay: 1.5,
					ease: FlxEase.expoOut,
					onComplete: function(twn:FlxTween) {
						canmove = true;
					}
				});
			}

		c = new FlxSprite(0,40 - 200).loadGraphic(Paths.image('1280x720 creditsMenu/creditsTitle'));
		c.updateHitbox();
		c.antialiasing = true;
		c.screenCenter(X);
		add(c);

		FlxTween.tween(c, {y: c.y + 200}, 1, {
			ease: FlxEase.quadOut,
			startDelay: 0.4,
		});

		leftArrow = new FlxSprite(40 - 1280).loadGraphic(Paths.image('1280x720 creditsMenu/selectLeft'));
		leftArrow.updateHitbox();
		leftArrow.antialiasing = true;
		add(leftArrow);

		rightArrow = new FlxSprite(1163 + 1280).loadGraphic(Paths.image('1280x720 creditsMenu/selectRight'));
		rightArrow.updateHitbox();
		rightArrow.antialiasing = true;
		add(rightArrow);
		rightArrow.screenCenter(Y);
		leftArrow.screenCenter(Y);

		FlxTween.tween(leftArrow, {x: 20 + 175},1, {
			ease: FlxEase.quadOut,
			startDelay: 0.4,
		});

		FlxTween.tween(rightArrow, {x: 1183 - 200}, 1, {
			ease: FlxEase.quadOut,
			startDelay: 0.4,
		});

		new FlxTimer().start(0.732, function(tmr:FlxTimer)
			{
				bop();
			},0);
		changeSelection();
		super.create();
	}

	function bop() {
		c.scale.set(1.1,1.1);

					if(bop1 != null) {
				bop1.cancel();
			}
			bop1 = FlxTween.tween(c, {"scale.x": 1,"scale.y": 1}, 0.6, {startDelay: 0.0,
				ease: FlxEase.expoOut,
				onComplete: function(twn:FlxTween) {
					bop1 = null;
				}
			});
	}

	var clicked:Bool = false;

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.7)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		var rightP = controls.UI_RIGHT_P;
		var leftP = controls.UI_LEFT_P;

		if (FlxG.mouse.justPressed && canmove)
			{

				if (FlxG.mouse.overlaps(leftArrow))
				{
					if (curSelected != 0)
						{
							credits.forEach(function(spr:FlxSprite)
								{
									FlxTween.tween(spr, {x: spr.x + 1280}, 1, {
										ease: FlxEase.expoOut,
										onComplete: function(twn:FlxTween) {
											canmove = true;
										}
									});
								});
							tags.forEach(function(spr:FlxSprite)
								{
									FlxTween.tween(spr, {x: spr.x + 1280}, 1, {
										ease: FlxEase.expoOut,
										onComplete: function(twn:FlxTween) {
											canmove = true;
										}
									});
								});
							leftArrow.x -= 10;
							FlxTween.tween(leftArrow, {x: leftArrow.x + 10}, 0.4, {
								ease: FlxEase.expoOut,
								onComplete: function(twn:FlxTween) {
									canmove = true;
								}
							});
							changeSelection(-1);
							canmove =false;
						}
				}
				if (FlxG.mouse.overlaps(rightArrow))
				{
					if (curSelected != 2)
						{
							canmove =false;
							changeSelection(1);
							rightArrow.x += 10;
							credits.forEach(function(spr:FlxSprite)
								{
									FlxTween.tween(spr, {x: spr.x - 1280}, 1, {
										ease: FlxEase.expoOut,
										onComplete: function(twn:FlxTween) {
											canmove = true;
										}
									});
								});
							tags.forEach(function(spr:FlxSprite)
								{
									FlxTween.tween(spr, {x: spr.x -1280}, 1, {
										ease: FlxEase.expoOut,
										onComplete: function(twn:FlxTween) {
											canmove = true;
										}
									});
								});
							FlxTween.tween(rightArrow, {x: rightArrow.x - 10}, 0.4, {
								ease: FlxEase.expoOut,
								onComplete: function(twn:FlxTween) {
								}
							});
						}
				}
			}

		for (i in credits) {
			if (FlxG.mouse.overlaps(i)) {
						i.scale.set(1.08, 1.08);
						if (FlxG.mouse.justPressed) {
							#if linux
							Sys.command('/usr/bin/xdg-open', [i.link, "&"]);
							#else
							FlxG.openURL(i.link);
							#end
						}
					}
					else
						{
							i.scale.set(1, 1);
						}
			}

		if (leftP)
		{
			if (curSelected != 0 && canmove)
				{
					changeSelection(-1);
					canmove = false;
					credits.forEach(function(spr:FlxSprite)
						{
							FlxTween.tween(spr, {x: spr.x + 1280}, 0.9, {
								ease: FlxEase.expoOut,
								onComplete: function(twn:FlxTween) {
									canmove = true;
								}
							});
						});
					tags.forEach(function(spr:FlxSprite)
						{
							FlxTween.tween(spr, {x: spr.x + 1280}, 0.9, {
								ease: FlxEase.expoOut,
								onComplete: function(twn:FlxTween) {
									canmove = true;
								}
							});
						});
				}
		}
		if (rightP)
		{
			if (curSelected != 2 && canmove)
				{
					changeSelection(1);
					canmove = false;
					credits.forEach(function(spr:FlxSprite)
						{
							FlxTween.tween(spr, {x: spr.x - 1280}, 0.9, {
								ease: FlxEase.expoOut,
								onComplete: function(twn:FlxTween) {
									canmove = true;
								}
							});
						});
					tags.forEach(function(spr:FlxSprite)
						{
							FlxTween.tween(spr, {x: spr.x - 1280}, 0.9, {
								ease: FlxEase.expoOut,
								onComplete: function(twn:FlxTween) {
									canmove = true;
								}
							});
						});
				}
		}

		
		if (controls.BACK && !clicked)
		{
			FlxG.mouse.visible = false;
			clicked = true;
			FlxTween.tween(leftArrow, {x: 20 - 1280},1.4, {
				ease: FlxEase.quadOut,
			});
	
			FlxTween.tween(rightArrow, {x: 1183 + 1280}, 1.4, {
				ease: FlxEase.quadOut,
			});
			credits.forEach(function(spr:FlxSprite)
				{
					FlxTween.tween(spr, {y: spr.y - 1280}, 1.4, {
						ease: FlxEase.quadOut,
					});
				});
			tags.forEach(function(spr:FlxSprite)
				{
					FlxTween.tween(spr, {y: spr.y - 1280}, 1.4, {
						ease: FlxEase.quadOut,
					});
				});
			FlxTween.tween(FlxG.camera, {zoom: 5}, 1, {ease: FlxEase.expoIn});
			FlxTween.tween(bg, {angle: 45}, 1, {ease: FlxEase.expoIn});
			FlxG.sound.play(Paths.sound('cancelMenu'));
			new FlxTimer().start(0.4, function(tmr:FlxTimer)
				{
					MusicBeatState.switchState(new MainMenuState());
				});
		}
		super.update(elapsed);
	}

	function changeSelection(change:Int = 0)
	{
		curSelected += change;

		if (curSelected == 3)
			curSelected = 2;
		if (curSelected == -1)
			curSelected = 0;
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
	}
}
