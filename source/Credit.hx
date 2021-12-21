package;

import flixel.FlxSprite;

class Credit extends FlxSprite
{
	public var link:String;
	public var name:String;

	public function new(x:Float = 0, y:Float=0, iconname:String = '', ?linkname:String = '')
	{
		super(x, y);
		link = linkname;
		name = iconname;
		loadGraphic(Paths.image('1280x720 creditsMenu/icons/' + iconname + 'Icon'));
	}
}
