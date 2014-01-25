package
{
	import Box2D.Dynamics.b2Body;
	
	import flash.display.Sprite;

	public class LevelBase extends Sprite
	{
		protected var _physicsManager:PhysicsManager;
		
		protected var _avatarBody:b2Body;
		
		public function LevelBase()
		{
			_physicsManager = new PhysicsManager();
		}
		
		public function update(dt:Number):void
		{
			throw "override this!";
		}
	}
}