package levels
{
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	
	import flash.display.MovieClip;

	public class Level6 extends LevelBase
	{
		
		public function Level6(main:Main)
		{
			super(main);
			parseLevelFromSwcWithID(6);
		}
		
		public override function update(dt:Number):void
		{	
			baseUpdate(dt);
		}
	}
}