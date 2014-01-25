package
{
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;

	public class Level1 extends LevelBase
	{
		
		
		public function Level1()
		{
			super();
			
			_avatarBody = _physicsManager.createDynamicCircle(50, 50, 30);
		}
		
		public override function update(dt:Number):void
		{	
			if(PlayerInput.right)
			{
				var f:b2Vec2 = new b2Vec2(5,0);
				_avatarBody.ApplyForce(f,_avatarBody.GetWorldCenter());
			}
			
			_physicsManager.update(dt);
		}
	}
}