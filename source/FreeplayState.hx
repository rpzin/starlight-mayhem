package;

#if desktop
import Discord.DiscordClient;
#end
import flash.text.TextField;
import flixel.util.FlxTimer;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.transition.FlxTransitionableState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import lime.utils.Assets;
import flixel.system.FlxSound;
import openfl.utils.Assets as OpenFlAssets;
import WeekData;

using StringTools;

class FreeplayState extends MusicBeatState
{
	var songs:Array<SongMetadata> = [];

	var selector:FlxText;
	private static var curSelected:Int = 0;
	private static var curDifficulty:Int = 1;

	var scoreBG:FlxSprite;
	var scoreText:FlxText;
	var diffText:FlxText;
	var lerpScore:Int = 0;
	var lerpRating:Float = 0;
	var intendedScore:Int = 0;
	var intendedRating:Float = 0;

	private var grpSongs:FlxTypedGroup<Alphabet>;
	private var curPlaying:Bool = false;
	var haventselected:Bool =true;

	private var iconArray:Array<HealthIcon> = [];

	var bg:FlxSprite;
	var one:FlxSprite;
	var two:FlxSprite;
	var arrow:FlxSprite;
	var intendedColor:Int;
	var colorTween:FlxTween;
	var songspr:FlxTypedGroup<FlxSprite>;
	var songsprselected:FlxTypedGroup<FlxSprite>;

	override function create()
	{
		#if MODS_ALLOWED
		Paths.destroyLoadedImages();
		#end
		WeekData.reloadWeekFiles(false);
		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		for (i in 0...WeekData.weeksList.length) {
			var leWeek:WeekData = WeekData.weeksLoaded.get(WeekData.weeksList[i]);
			var leSongs:Array<String> = [];
			var leChars:Array<String> = [];
			for (j in 0...leWeek.songs.length) {
				leSongs.push(leWeek.songs[j][0]);
				leChars.push(leWeek.songs[j][1]);
			}

			WeekData.setDirectoryFromWeek(leWeek);
			for (song in leWeek.songs) {
				var colors:Array<Int> = song[2];
				if(colors == null || colors.length < 3) {
					colors = [146, 113, 253];
				}
				addSong(song[0], i, song[1], FlxColor.fromRGB(colors[0], colors[1], colors[2]));
			}
		}
		WeekData.setDirectoryFromWeek();
		var randostr:String = '';
		randostr = 'freeplaySonglist';

		var initSonglist = CoolUtil.coolTextFile(SUtil.getPath() + Paths.txt(randostr));
		for (i in 0...initSonglist.length)
		{
			if(initSonglist[i] != null && initSonglist[i].length > 0) {
				var songArray:Array<String> = initSonglist[i].split(":");
				addSong(songArray[0], 0, songArray[1], Std.parseInt(songArray[2]));
			}
		}

		// LOAD MUSIC

		// LOAD CHARACTERS

		FlxG.camera.zoom = 3;
		FlxTween.tween(FlxG.camera, {zoom: 1}, 1.1, {ease: FlxEase.expoInOut});

		bg = new FlxSprite().loadGraphic(Paths.image('1280x720 freeplayMenu/backgroundCredits'));
		bg.antialiasing = true;
		add(bg);

		one = new FlxSprite(10).loadGraphic(Paths.image('1280x720 freeplayMenu/pillarLeft'));
		one.antialiasing = true;
		add(one);

		two = new FlxSprite(1280 - 160 - 10).loadGraphic(Paths.image('1280x720 freeplayMenu/pillarRight'));
		two.antialiasing = true;
		add(two);

		two.x += 900;
		FlxTween.tween(two, {x: two.x -900}, 1, {startDelay: 0.0,
			ease: FlxEase.expoOut});

		one.x -= 900;
		FlxTween.tween(one, {x: one.x +900}, 1, {startDelay: 0.0,
			ease: FlxEase.expoOut});

		grpSongs = new FlxTypedGroup<Alphabet>();
		add(grpSongs);

		for (i in 0...songs.length)
		{
			var songText:Alphabet = new Alphabet(0, (70 * i) + 30, songs[i].songName, true, false);
			songText.isFree = true;
			songText.targetY = i;
			grpSongs.add(songText);

			Paths.currentModDirectory = songs[i].folder;


			// songText.x += 40;
			// DONT PUT X IN THE FIRST PARAMETER OF new ALPHABET() !!
			// songText.screenCenter(X);
		}

		songspr = new FlxTypedGroup<FlxSprite>();
		add(songspr);

		var shit:Array<String> = ['Tutorial', 'InvertedAscension','Echoes', 'ArtificialLust', 'Parallax','Starstorm','Coda','Complicated'];

		for (i in 0...songs.length)
			{
				var aaa:FlxSprite = new FlxSprite(30,45 + (i * 160)).loadGraphic(Paths.image('1280x720 freeplayMenu/text/passive' + shit[i]));
				aaa.scrollFactor.set(0, 0);
				aaa.updateHitbox();
				aaa.antialiasing = true;
				songspr.add(aaa);

				var icon:HealthIcon = new HealthIcon(songs[i].songCharacter);
				icon.sprTracker = aaa;
	
				// using a FlxGroup is too much fuss!
				iconArray.push(icon);
				add(icon);
			}

		songsprselected = new FlxTypedGroup<FlxSprite>();
		add(songsprselected);

		for (i in 0...songs.length)
			{
				var aaa:FlxSprite = new FlxSprite(30,45 + (i * 160)).loadGraphic(Paths.image('1280x720 freeplayMenu/text/selected' + shit[i]));
				aaa.scrollFactor.set(0, 0);
				aaa.updateHitbox();
				aaa.antialiasing = true;
				songsprselected.add(aaa);
			}
		WeekData.setDirectoryFromWeek();

		scoreText = new FlxText(FlxG.width * 0.7, 5, 0, "", 32);
		scoreText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, RIGHT);

		scoreBG = new FlxSprite(scoreText.x - 6, 0).makeGraphic(1, 66, 0xFF000000);
		scoreBG.alpha = 0.6;
		add(scoreBG);

		diffText = new FlxText(scoreText.x, scoreText.y + 36, 0, "", 24);
		diffText.font = scoreText.font;
		add(diffText);

		add(scoreText);

		if(curSelected >= songs.length) curSelected = 0;
		bg.color = songs[curSelected].color;
		intendedColor = bg.color;
		arrow = new FlxSprite().loadGraphic(Paths.image('1280x720 freeplayMenu/selectArrow'));
		arrow.antialiasing = true;
		arrow.screenCenter();
		add(arrow);
		changeSelection();
		changeDiff();

		var swag:Alphabet = new Alphabet(1, 0, "swag");

		// JUST DOIN THIS SHIT FOR TESTING!!!
		/* 
			var md:String = Markdown.markdownToHtml(Assets.getText('CHANGELOG.md'));

			var texFel:TextField = new TextField();
			texFel.width = FlxG.width;
			texFel.height = FlxG.height;
			// texFel.
			texFel.htmlText = md;

			FlxG.stage.addChild(texFel);

			// scoreText.textField.htmlText = md;

			trace(md);
		 */

		var textBG:FlxSprite = new FlxSprite(0, FlxG.height - 26).makeGraphic(FlxG.width, 26, 0xFF000000);
		textBG.alpha = 0.6;
		add(textBG);
		#if PRELOAD_ALL
		var leText:String = "Press SPACE to listen to this Song / Press RESET to Reset your Score and Accuracy.";
		#else
		var leText:String = "Press RESET to Reset your Score and Accuracy.";
		#end
		var text:FlxText = new FlxText(textBG.x, textBG.y + 4, FlxG.width, leText, 18);
		text.setFormat(Paths.font("vcr.ttf"), 18, FlxColor.WHITE, RIGHT);
		text.scrollFactor.set();
		add(text);

		for (i in 0...songs.length)
			{
				trace(i);
				songspr.members[i].alpha = 0.6;
				songspr.members[curSelected].alpha = 0;
				songsprselected.members[i].alpha = 0;
				songsprselected.members[curSelected].alpha = 1;
				songspr.members[i].x = grpSongs.members[i].x + 500;
				songspr.members[i].y = grpSongs.members[i].y;
				songsprselected.members[i].x = grpSongs.members[i].x + 500;
				songsprselected.members[i].y = grpSongs.members[i].y;

				songsprselected.members[1].x += 25;
				songsprselected.members[3].x += 25;
				songspr.members[1].x += 25;
				songspr.members[3].x += 25;
				songsprselected.members[4].x += 10;
				songsprselected.members[5].x += 10;
				songsprselected.members[7].x += 115;

				songspr.members[4].x += 10;
				songspr.members[5].x += 10;
				songspr.members[7].x += 115;
			}

			arrow.screenCenter();
			arrow.y += 30;
			switch (curSelected)
			{
				case 0:
					arrow.x += 210;
				case 1:
					arrow.x += 320;
				case 2:
					arrow.x += 180;
				case 3:
					arrow.x += 290;
				case 4:
					arrow.x += 180;
				case 5:
					arrow.x += 190;
				case 6:
					arrow.x += 180;
				case 7:
					arrow.x += 230;
			}

		if (!ClientPrefs.mainweek)
			{
				for (i in 4...8)
					{
						songsprselected.members[i].alpha = 0;
						songspr.members[i].alpha = 0;
					}
			}
		
		super.create();
	}

	override function closeSubState() {
		changeSelection();
		super.closeSubState();
	}

	public function addSong(songName:String, weekNum:Int, songCharacter:String, color:Int)
	{
		songs.push(new SongMetadata(songName, weekNum, songCharacter, FlxColor.WHITE));
	}

	/*public function addWeek(songs:Array<String>, weekNum:Int, weekColor:Int, ?songCharacters:Array<String>)
	{
		if (songCharacters == null)
			songCharacters = ['bf'];

		var num:Int = 0;
		for (song in songs)
		{
			addSong(song, weekNum, songCharacters[num]);
			this.songs[this.songs.length-1].color = weekColor;

			if (songCharacters.length != 1)
				num++;
		}
	}*/

	var instPlaying:Int = -1;
	private static var vocals:FlxSound = null;
	override function update(elapsed:Float)
	{
		for (i in 0...songs.length)
			{
				songspr.members[i].alpha = 0.6;
				songspr.members[curSelected].alpha = 0;
				songsprselected.members[i].alpha = 0;
				songsprselected.members[curSelected].alpha = 1;
				songspr.members[i].x = grpSongs.members[i].x;
				songspr.members[i].y = grpSongs.members[i].y;
				songsprselected.members[i].x = grpSongs.members[i].x;
				songsprselected.members[i].y = grpSongs.members[i].y;

				songsprselected.members[1].x += 25;
				songsprselected.members[3].x += 25;
				songspr.members[1].x += 25;
				songspr.members[3].x += 25;
				songsprselected.members[4].x += 10;
				songsprselected.members[5].x += 10;
				songsprselected.members[7].x += 115;

				songspr.members[4].x += 10;
				songspr.members[5].x += 10;
				songspr.members[7].x += 115;
			}
			if (!ClientPrefs.mainweek)
				{
					for (i in 4...8)
						{
							songsprselected.members[i].alpha = 0;
							songspr.members[i].alpha = 0;
						}
				}

		if (FlxG.sound.music.volume < 0.7 && haventselected)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		lerpScore = Math.floor(FlxMath.lerp(lerpScore, intendedScore, CoolUtil.boundTo(elapsed * 24, 0, 1)));
		lerpRating = FlxMath.lerp(lerpRating, intendedRating, CoolUtil.boundTo(elapsed * 12, 0, 1));

		if (Math.abs(lerpScore - intendedScore) <= 10)
			lerpScore = intendedScore;
		if (Math.abs(lerpRating - intendedRating) <= 0.01)
			lerpRating = intendedRating;

		scoreText.text = 'PERSONAL BEST: ' + lerpScore + ' (' + Math.floor(lerpRating * 100) + '%)';
		positionHighscore();

		var upP = controls.UI_UP_P;
		var downP = controls.UI_DOWN_P;
		var accepted = controls.ACCEPT;
		var space = FlxG.keys.justPressed.SPACE;

		var shiftMult:Int = 1;
		if(FlxG.keys.pressed.SHIFT) shiftMult = 3;

		if (upP)
		{
			if (!ClientPrefs.mainweek)
				{
					if (curSelected != 0)
						changeSelection(-shiftMult);
				}
				else
					changeSelection(-shiftMult);
		}
		if (downP)
		{
			if (!ClientPrefs.mainweek)
				{
					if (curSelected != 3)
						changeSelection(shiftMult);
				}
				else
					changeSelection(shiftMult);
		}

		if (controls.UI_LEFT_P)
			changeDiff(-1);
		if (controls.UI_RIGHT_P)
			changeDiff(1);

		if (controls.BACK)
		{
			if(colorTween != null) {
				colorTween.cancel();
			}
			FlxG.sound.play(Paths.sound('cancelMenu'));
			FlxTween.tween(FlxG.camera, {zoom: 5}, 1, {ease: FlxEase.expoIn});
			FlxTween.tween(bg, {angle: 45}, 0.8, {ease: FlxEase.expoIn});
			new FlxTimer().start(0.4, function(tmr:FlxTimer)
				{
					MusicBeatState.switchState(new MainMenuState());
				});
			
		}

		#if PRELOAD_ALL
		if(space && instPlaying != curSelected)
		{
			destroyFreeplayVocals();
			Paths.currentModDirectory = songs[curSelected].folder;
			var poop:String = Highscore.formatSong(songs[curSelected].songName.toLowerCase(), curDifficulty);
			trace(poop);
			PlayState.SONG = Song.loadFromJson(poop, songs[curSelected].songName.toLowerCase());
			trace(songs[curSelected].songName.toLowerCase());
			if (PlayState.SONG.needsVoices)
				vocals = new FlxSound().loadEmbedded(Paths.voices(PlayState.SONG.song));
			else
				vocals = new FlxSound();

			FlxG.sound.list.add(vocals);
			FlxG.sound.playMusic(Paths.inst(PlayState.SONG.song), 0.7);
			vocals.play();
			vocals.persist = true;
			vocals.looped = true;
			vocals.volume = 0.7;
			instPlaying = curSelected;
		}
		else #end if (accepted && haventselected)
		{
			haventselected = false;
			FlxG.sound.play(Paths.sound('confirmMenu'));
			FlxTween.tween(FlxG.camera, {zoom: 5}, 1, {ease: FlxEase.expoIn});
			FlxTween.tween(bg, {angle: 45}, 0.8, {ease: FlxEase.expoIn});

			var songLowercase:String = Paths.formatToSongPath(songs[curSelected].songName);
			var poop:String = Highscore.formatSong(songLowercase, curDifficulty);
			#if MODS_ALLOWED
			if(!sys.FileSystem.exists(Paths.modsJson(songLowercase + '/' + poop)) && !sys.FileSystem.exists(Paths.json(songLowercase + '/' + poop))) {
			#else
			if(!OpenFlAssets.exists(Paths.json(songLowercase + '/' + poop))) {
			#end
				poop = songLowercase;
				curDifficulty = 1;
				trace('Couldnt find file');
			}
			trace(poop);
			var thingy:String = '';
			if (ClientPrefs.oldvoice && curSelected <= 3 && curSelected != 0)
				thingy = '-old';

			PlayState.SONG = Song.loadFromJson(poop, songLowercase + thingy);
			if (curSelected <= 3)
				{
					PlayState.abelSONG = Song.loadFromJson('abel', songLowercase);
					PlayState.maxSONG = Song.loadFromJson('max', songLowercase);
					PlayState.olleySONG = Song.loadFromJson('olley', songLowercase);
				}
			if (curSelected == 4)
				PlayState.altSONG = Song.loadFromJson('alt',  songLowercase);
			PlayState.isStoryMode = false;
			PlayState.storyDifficulty = curDifficulty;

			PlayState.storyWeek = songs[curSelected].week;
			new FlxTimer().start(0.4, function(tmr:FlxTimer)
				{
					LoadingState.loadAndSwitchState(new PlayState());
				});
			FlxG.sound.music.volume = 0;
					
			destroyFreeplayVocals();
			
		}
		else if(controls.RESET)
		{
			openSubState(new ResetScoreSubState(songs[curSelected].songName, curDifficulty, songs[curSelected].songCharacter));
			FlxG.sound.play(Paths.sound('scrollMenu'));
		}
		super.update(elapsed);
	}

	public static function destroyFreeplayVocals() {
		if(vocals != null) {
			vocals.stop();
			vocals.destroy();
		}
		vocals = null;
	}

	function changeDiff(change:Int = 0)
	{
		curDifficulty += change;

		if (curDifficulty < 0)
			curDifficulty = CoolUtil.difficultyStuff.length-1;
		if (curDifficulty >= CoolUtil.difficultyStuff.length)
			curDifficulty = 0;

		#if !switch
		intendedScore = Highscore.getScore(songs[curSelected].songName, curDifficulty);
		intendedRating = Highscore.getRating(songs[curSelected].songName, curDifficulty);
		#end

		PlayState.storyDifficulty = curDifficulty;
		diffText.text = '< ' + CoolUtil.difficultyString() + ' >';
		positionHighscore();
	}

	function changeSelection(change:Int = 0)
	{
		
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

		curSelected += change;

		if (curSelected < 0)
			curSelected = songs.length - 1;
		if (curSelected >= songs.length)
			curSelected = 0;

		trace(curSelected);

		/*var newColor:Int = songs[curSelected].color;
		if(newColor != intendedColor) {
			if(colorTween != null) {
				colorTween.cancel();
			}
			intendedColor = newColor;
			colorTween = FlxTween.color(bg, 1, bg.color, intendedColor, {
				onComplete: function(twn:FlxTween) {
					colorTween = null;
				}
			});
		}*/

		// selector.y = (70 * curSelected) + 30;

		#if !switch
		intendedScore = Highscore.getScore(songs[curSelected].songName, curDifficulty);
		intendedRating = Highscore.getRating(songs[curSelected].songName, curDifficulty);
		#end

		var bullShit:Int = 0;

		for (i in 0...iconArray.length)
		{
			iconArray[i].alpha = 0.6;
		}

		iconArray[curSelected].alpha = 1;

		if (!ClientPrefs.mainweek)
			{
				for (i in 4...8)
					{
						iconArray[i].alpha = 0;
					}
			}

		for (item in grpSongs.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0;
			// item.setGraphicSize(Std.int(item.width * 0.8));

			if (item.targetY == 0)
			{
				item.alpha = 0;
				// item.setGraphicSize(Std.int(item.width));
			}
		}
		changeDiff();
		Paths.currentModDirectory = songs[curSelected].folder;

		arrow.screenCenter();
		arrow.y += 30;
		switch (curSelected)
		{
			case 0:
				arrow.x += 210;
			case 1:
				arrow.x += 320;
			case 2:
				arrow.x += 180;
			case 3:
				arrow.x += 290;
			case 4:
				arrow.x += 180;
			case 5:
				arrow.x += 190;
			case 6:
				arrow.x += 180;
			case 7:
				arrow.x += 240;
		}
		arrow.x += 125;
		if(colorTween != null) {
			colorTween.cancel();
		}
		colorTween = FlxTween.tween(arrow, {x: arrow.x - 25}, 0.6, {startDelay: 0.0,
			ease: FlxEase.expoOut,
			onComplete: function(twn:FlxTween) {
				colorTween = null;
			}
		});

	}

	private function positionHighscore() {
		scoreText.x = FlxG.width - scoreText.width - 6;

		scoreBG.scale.x = FlxG.width - scoreText.x + 6;
		scoreBG.x = FlxG.width - (scoreBG.scale.x / 2);
		diffText.x = Std.int(scoreBG.x + (scoreBG.width / 2));
		diffText.x -= diffText.width / 2;
	}
}

class SongMetadata
{
	public var songName:String = "";
	public var week:Int = 0;
	public var songCharacter:String = "";
	public var color:Int = -7179779;
	public var folder:String = "";

	public function new(song:String, week:Int, songCharacter:String, color:Int)
	{
		this.songName = song;
		this.week = week;
		this.songCharacter = songCharacter;
		this.color = color;
		this.folder = Paths.currentModDirectory;
		if(this.folder == null) this.folder = '';
	}
}
