package
{
	import Box2D.Dynamics.b2Body;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;

	public class LevelBase extends Sprite
	{
		protected var _physicsManager:PhysicsManager;
		
		protected var _avatarBody:b2Body;
		protected var _avatarView:MovieClip;
		
		protected var _staticPlatformBodies:Vector.<b2Body>;
		protected var _staticPlatformViews:Vector.<MovieClip>;
		protected var _movingPlatformBodies:Vector.<b2Body>;
		protected var _movingPlatformViews:Vector.<MovieClip>;
		
		
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