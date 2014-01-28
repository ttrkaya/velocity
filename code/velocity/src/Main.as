package
{
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.ui.Keyboard;
	import flash.utils.Timer;
	
	import levels.*;
	
	import parse.Parser;
	
	[SWF(width="800",height="600",frameRate="30",backgroundColor="#888888")]
	
	public class Main extends Sprite
	{
		private var _level:LevelBase;
		private var _currentLevelId:int = 0;
		
		private var _lastUpdateTime:Number;
		
		private var _edgeShades:Shape;
		
		public static var stage:Stage;
		
		private var _screenBG:MovieClip;
		private var _timer:Timer;
		
		private static const levelClasses:Vector.<Class> = new <Class>[Level0, Level1, Level2, Level3, Level4, Level5, Level6, Level7];
		
		public function Main()
		{
			this.addEventListener(Event.ADDED_TO_STAGE, gameStart);
		
		}
		
		private function onAddedToStage(e:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			SoundManager.playMusic();
			_screenBG = new IntroMovie();
			_screenBG.width = 800;
			_screenBG.height = 600;
			_screenBG.play();
			addChild(_screenBG);
			_timer = new Timer(10000, 1);
			_timer.addEventListener(TimerEvent.TIMER_COMPLETE, initMenu);
		
		}
		
		public function initMenu(e:Event):void
		{
			_screenBG = new MenuBackGround();
			_screenBG.width = 800;
			_screenBG.height = 600;
			
			var startBtn:PlayGameBtn = new PlayGameBtn();
			startBtn.y = 300;
			startBtn.x = 100;
			_screenBG.addChild(startBtn);
			
			var creditsBtn:CreditsBtn = new CreditsBtn();
			creditsBtn.y = 300;
			creditsBtn.x = 700 - creditsBtn.width;
			_screenBG.addChild(creditsBtn);
			
			startBtn.addEventListener(MouseEvent.CLICK, gameStart);
			creditsBtn.addEventListener(MouseEvent.CLICK, rollCredits);
		
		}
		
		private function rollCredits(e:MouseEvent):void
		{
			_screenBG = new CreditScreen();
			var startBtn:PlayGameBtn = new PlayGameBtn();
			startBtn.y = 194.05;
			startBtn.x = 533.7;
			_screenBG.addChild(startBtn);
			startBtn.addEventListener(MouseEvent.CLICK, gameStart);
		
		}
		
		public function gameStart(m:Event):void
		{
			if (_screenBG != null)
				removeChild(_screenBG);
			
			stage.scaleMode = StageScaleMode.SHOW_ALL;
			stage.align = StageAlign.TOP;
			Main.stage = this.stage;
			
			_level = new levelClasses[_currentLevelId](this);
			this.addChild(_level);
			
			_edgeShades = new Shape();
			_edgeShades.graphics.beginFill(0);
			_edgeShades.graphics.drawRect(-1000, -1000, 1000, 3000);
			_edgeShades.graphics.drawRect(800, -1000, 1000, 3000);
			_edgeShades.graphics.drawRect(-1000, -1000, 3000, 1000);
			_edgeShades.graphics.drawRect(-1000, 600, 3000, 1000);
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
			if (e.keyCode == Keyboard.A || e.keyCode == Keyboard.LEFT)
			{
				PlayerInput.left = true;
			}
			if (e.keyCode == Keyboard.D || e.keyCode == Keyboard.RIGHT)
			{
				PlayerInput.right = true;
			}
			if (e.keyCode == Keyboard.W || e.keyCode == Keyboard.UP)
			{
				PlayerInput.up = true;
			}
			if (e.keyCode == Keyboard.S || e.keyCode == Keyboard.DOWN)
			{
				PlayerInput.down = true;
			}
			if (e.keyCode == Keyboard.R)
			{
				this.restart();
			}
			if (e.keyCode == Keyboard.O)
			{
				if (_currentLevelId < Parser.levelDefs.length - 1)
				{
					_currentLevelId++;
					this.restart();
				}
			}
			if (e.keyCode == Keyboard.P)
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
			if (e.keyCode == Keyboard.A || e.keyCode == Keyboard.LEFT)
			{
				PlayerInput.left = false;
			}
			if (e.keyCode == Keyboard.D || e.keyCode == Keyboard.RIGHT)
			{
				PlayerInput.right = false;
			}
			if (e.keyCode == Keyboard.W || e.keyCode == Keyboard.UP)
			{
				PlayerInput.up = false;
			}
			if (e.keyCode == Keyboard.S || e.keyCode == Keyboard.DOWN)
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
			this.setChildIndex(_edgeShades, this.numChildren - 1);
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