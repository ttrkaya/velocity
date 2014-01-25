package levels
{
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;

	public class Level3 extends LevelBase
	{
		
		
		public function Level3()
		{
			super();
			parse(2);
		}
		
		public override function update(dt:Number):void
		{	
			baseUpdate(dt);
		}
	}
}