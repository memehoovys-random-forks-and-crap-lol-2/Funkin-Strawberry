import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxMath;
import flixel.util.FlxTimer;

using StringTools;








class NoteTypeBase
{
    public var name:String = "default";
    public var shouldbehit:Bool = true;
    public var opponentshouldhit:Bool = true;
	public var scrollspeedoverride:Float = -1;


    public function new()
    {

    }

    public function InitializeVisuals(sprite:Note,notedata:Int,issustain:Bool,noteskin:Int,daStage:String,prevNote:Note,ineditor:Bool)
    {

        var swagWidth:Float = 160 * 0.7;

        switch (daStage)
		{
			case 'school' | 'schoolEvil':
				sprite.loadGraphic(Paths.image('weeb/pixelUI/arrows-pixels'), true, 17, 17);

				sprite.animation.add('greenScroll', [6]);
				sprite.animation.add('redScroll', [7]);
				sprite.animation.add('blueScroll', [5]);
				sprite.animation.add('purpleScroll', [4]);

				if (issustain)
				{
					sprite.loadGraphic(Paths.image('weeb/pixelUI/arrowEnds'), true, 7, 6);

					sprite.animation.add('purpleholdend', [4]);
					sprite.animation.add('greenholdend', [6]);
					sprite.animation.add('redholdend', [7]);
					sprite.animation.add('blueholdend', [5]);

					sprite.animation.add('purplehold', [0]);
					sprite.animation.add('greenhold', [2]);
					sprite.animation.add('redhold', [3]);
					sprite.animation.add('bluehold', [1]);

				}

				sprite.setGraphicSize(Std.int(sprite.width * PlayState.daPixelZoom));

				sprite.updateHitbox();

				if (issustain)
				{
					sprite.noteOffset = (sprite.width * 0.75);
				}

			default:
				sprite.frames = Paths.getSparrowAtlas('NOTE_assets');

				sprite.animation.addByPrefix('greenScroll', 'green0');
				sprite.animation.addByPrefix('redScroll', 'red0');
				sprite.animation.addByPrefix('blueScroll', 'blue0');
				sprite.animation.addByPrefix('purpleScroll', 'purple0');

				sprite.animation.addByPrefix('purpleholdend', 'pruple end hold');
				sprite.animation.addByPrefix('greenholdend', 'green hold end');
				sprite.animation.addByPrefix('redholdend', 'red hold end');
				sprite.animation.addByPrefix('blueholdend', 'blue hold end');

				sprite.animation.addByPrefix('purplehold', 'purple hold piece');
				sprite.animation.addByPrefix('greenhold', 'green hold piece');
				sprite.animation.addByPrefix('redhold', 'red hold piece');
				sprite.animation.addByPrefix('bluehold', 'blue hold piece');

				sprite.setGraphicSize(Std.int(sprite.width * 0.7));
				sprite.updateHitbox();
				sprite.antialiasing = true;

				if (issustain)
				{
					sprite.noteOffset = sprite.width / 3;
				}
		}

		switch (notedata)
		{
			case 0:
				sprite.animation.play('purpleScroll');
			case 1:
				sprite.animation.play('blueScroll');
			case 2:
				sprite.animation.play('greenScroll');
			case 3:
				sprite.animation.play('redScroll');
		}

		// trace(prevNote);

		if (issustain && prevNote != null)
		{
			sprite.alphaMult = 0.6;

			if (FlxG.save.data.downscroll) //flip the trail on the last note so it looks right
				{
					sprite.flipY = true;
				}

			switch (notedata)
			{
				case 2:
					sprite.animation.play('greenholdend');
				case 3:
					sprite.animation.play('redholdend');
				case 1:
					sprite.animation.play('blueholdend');
				case 0:
					sprite.animation.play('purpleholdend');
			}

			sprite.updateHitbox();

			if (prevNote.isSustainNote)
			{
				switch (prevNote.noteData)
				{
					case 0:
						prevNote.animation.play('purplehold');
					case 1:
						prevNote.animation.play('bluehold');
					case 2:
						prevNote.animation.play('greenhold');
					case 3:
						prevNote.animation.play('redhold');
				}

				prevNote.scale.y *= Conductor.stepCrochet / 100 * 1.5 * PlayState.SONG.speed;
				prevNote.updateHitbox();
				// prevNote.setGraphicSize();
			}
		}
    }

    public function OnHit(note:Note,state:PlayState)
    {
        state.goodNoteHit(note);
    }

    public function OnMiss(note:Note,state:PlayState)
    {
        state.noteMiss(note.noteData % state.KeyAmount,!note.isSustainNote,note.isSustainNote);
    }

}

class TIKYNOTE extends NoteTypeBase //example note type you probably shouldn't use this
{
    public function new()
    {
        super();
        name = "tiky";
		opponentshouldhit = false;
		scrollspeedoverride = 3;
    }

    override function InitializeVisuals(sprite:Note,notedata:Int,issustain:Bool,noteskin:Int,daStage:String,prevNote:Note,ineditor:Bool)
    {
        super.InitializeVisuals(sprite,notedata,issustain,noteskin,daStage,prevNote,ineditor);
        sprite.color = FlxColor.RED;
    }


    override function OnHit(note:Note,state:PlayState)
    {
        state.health = 0;
    }

    override function OnMiss(note:Note,state:PlayState)
    {
        state.boyfriend.playAnim("hey");
    }
}