package levels
{
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	
	import flash.display.MovieClip;

	public class Level5 extends LevelBase
	{
		
		public function Level5(main:Main)
		{
			super(main);
			parseLevelFromSwcWithID(5);
		}
		
		public override function update(dt:Number):void
		{	
			baseUpdate(dt);
		}
	}
}