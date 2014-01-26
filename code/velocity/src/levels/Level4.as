package levels
{
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	
	import flash.display.MovieClip;

	public class Level4 extends LevelBase
	{
		
		public function Level4(main:Main)
		{
			super(main);
			parseLevelFromSwcWithID(3);
		}
		
		public override function update(dt:Number):void
		{	
			baseUpdate(dt);
		}
	}
}