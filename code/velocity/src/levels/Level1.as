package levels
{
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;

	public class Level1 extends LevelBase
	{
		
		
		public function Level1()
		{
			super();
			parse(0);
		}
		
		public override function update(dt:Number):void
		{	
			baseUpdate(dt);
		}
	}
}