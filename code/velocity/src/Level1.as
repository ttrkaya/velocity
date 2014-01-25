package
{
	public class Level1 extends LevelBase
	{
		public function Level1()
		{
			super();
			
			_physicsManager.createDynamicCircle(50, 50, 30);
		}
	}
}