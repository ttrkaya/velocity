package
{
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2World;
	
	import flash.display.Sprite;
	
	public class velocity extends Sprite
	{
		public function velocity()
		{
			var a:b2World = new b2World(new b2Vec2(), false);
		}
	}
}