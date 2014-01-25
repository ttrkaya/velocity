package
{
	import flash.display.Sprite;

	public class LevelBase extends Sprite
	{
		private var _physicsManager:PhysicsManager;
		
		public function LevelBase()
		{
			_physicsManager = new PhysicsManager();
		}
	}
}