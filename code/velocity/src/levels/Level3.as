package levels
{
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;

	public class Level3 extends LevelBase
	{
		
		
		public function Level3(main:Main)
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