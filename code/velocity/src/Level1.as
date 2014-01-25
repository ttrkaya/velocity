package
{
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;

	public class Level1 extends LevelBase
	{
		
		
		public function Level1(levelID:int = 0)
		{
			super();
			parse(levelID);
		}
		
		public override function update(dt:Number):void
		{	
			baseUpdate(dt);
		}
	}
}