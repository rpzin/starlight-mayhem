package;

import flixel.FlxSprite;

class Tag extends FlxSprite
{
	public var name:String;

	public function new(x:Float = 0, y:Float=0, iconname:String = '')
	{
		super(x, y);
		name = iconname;
		loadGraphic(Paths.image('1280x720 creditsMenu/textUnders/' + iconname + 'Credit'));
	}
}
