package
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	import levels.*;
	
	import parse.Parser;
	
	[SWF(width="800", height="600", frameRate="30",backgroundColor="#888888")]
	public class Main extends Sprite
	{
		private var _level:LevelBase;
		private var _currentLevelId:int = 0;
		
		private var _lastUpdateTime:Number;
		
		private var _edgeShades:Shape;
		
		public static var stage:Stage;
		
		private static const levelClasses:Vector.<Class> = new <Class>[Level0, Level1, Level2, Level3, Level4, Level5];
		
		public function Main()
		{
			trace('titties galore');
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(e:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			stage.scaleMode = StageScaleMode.SHOW_ALL;
			stage.align = StageAlign.TOP;
			Main.stage = this.stage;
			
			_level = new levelClasses[_currentLevelId](this);
			this.addChild(_level);
			
			_edgeShades = new Shape();
			_edgeShades.graphics.beginFill(0);
			_edgeShades.graphics.drawRect(-1000,-1000,1000,3000);
			_edgeShades.graphics.drawRect(800,-1000,1000,3000);
			_edgeShades.graphics.drawRect(-1000,-1000,3000,1000);
			_edgeShades.graphics.drawRect(-1000,600,3000,1000);
			this.addChild(_edgeShades);

			_lastUpdateTime = getNow();
			this.addEventListener(Event.ENTER_FRAME, onEnterFrame);

			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			
			SoundManager.playMusic();
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
			if(e.keyCode == Keyboard.R)
			{
				this.restart();
			}
			if(e.keyCode == Keyboard.O)
			{
				if (_currentLevelId < Parser.levelDefs.length-1)
				{
					_currentLevelId++;
					this.restart();
				}
			}
			if(e.keyCode == Keyboard.P)
			{
				if (_currentLevelId > 0)
				{
					_currentLevelId--;
					this.restart();
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
		
		public function restart():void
		{
			this.removeChild(_level);
			_level.destroy();
			_level = new levelClasses[_currentLevelId](this);
			this.addChild(_level);
			this.setChildIndex(_edgeShades, this.numChildren-1);
		}
		
		public function advanceLevel():void
		{
			_currentLevelId++;
			_currentLevelId %= levelClasses.length;
			this.restart();
			//SoundManager.playMusic();	
		}
	}
}