package
{
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	
	public class Main extends Sprite
	{
		private var _level:LevelBase;
		
		public static var stage:Stage;
		
		public function Main()
		{
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(e:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			Main.stage = this.stage;
			
			_level = new Level1();
			this.addChild(_level);
		}
	}
}