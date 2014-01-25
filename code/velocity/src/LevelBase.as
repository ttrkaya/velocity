package
{
	import flash.display.Sprite;

	public class LevelBase extends Sprite
	{
		protected var _physicsManager:PhysicsManager;
		
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