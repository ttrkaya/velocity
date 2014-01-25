package
{
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import parse.Parser;
	
	[SWF(width="800", height="600", frameRate="30",backgroundColor="#888888")]
	public class Main extends Sprite
	{
		private var _level:LevelBase;
		private var _currentLevel:int = 1;
		
		private var _lastUpdateTime:Number;
		
		public static var stage:Stage;
		
		public function Main()
		{
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(e:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			Main.stage = this.stage;
			
			_level = new Level1(_currentLevel);
			this.addChild(_level);

			
			_lastUpdateTime = getNow();
			this.addEventListener(Event.ENTER_FRAME, onEnterFrame);

			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
		}
		
		private function onEnterFrame(e:Event):void
		{
			var now:Number = getNow();
			var dt:Number = now - _lastUpdateTime;
			_lastUpdateTime = now;
			
			_level.update(dt);
			
			
		}
		
		private function getNow():Number
		{
			return (new Date()).time / 1000;
		}
		
		private function onKeyDown(e:KeyboardEvent):void
		{
			if(e.keyCode == Keyboard.A || e.keyCode == Keyboard.LEFT)
			{
				PlayerInput.left = true;
			}
			if(e.keyCode == Keyboard.D || e.keyCode == Keyboard.RIGHT)
			{
				PlayerInput.right = true;
			}
			if(e.keyCode == Keyboard.W || e.keyCode == Keyboard.UP)
			{
				PlayerInput.up = true;
			}
			if(e.keyCode == Keyboard.S || e.keyCode == Keyboard.DOWN)
			{
				PlayerInput.down = true;
			}
			if(e.keyCode == Keyboard.O)
			{
				if (_currentLevel < Parser.levelDefs.length - 1)
				{
					_currentLevel++;
					this.removeChild(_level);
					_level.destroy();
					_level = new Level1(_currentLevel);
					this.addChild(_level);
				}
			}
			if(e.keyCode == Keyboard.P)
			{
				if (_currentLevel > 0)
				{
					_currentLevel--;
					this.removeChild(_level);
					_level.destroy();
					_level = new Level1(_currentLevel);
					this.addChild(_level);
				}
			}
		}
		private function onKeyUp(e:KeyboardEvent):void
		{
			if(e.keyCode == Keyboard.A || e.keyCode == Keyboard.LEFT)
			{
				PlayerInput.left = false;
			}
			if(e.keyCode == Keyboard.D || e.keyCode == Keyboard.RIGHT)
			{
				PlayerInput.right = false;
			}
			if(e.keyCode == Keyboard.W || e.keyCode == Keyboard.UP)
			{
				PlayerInput.up = false;
			}
			if(e.keyCode == Keyboard.S || e.keyCode == Keyboard.DOWN)
			{
				PlayerInput.down = false;
			}
		}
		
	}
}