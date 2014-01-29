package
{
	import com.greensock.TweenMax;
	import flash.display.*;
	import flash.events.*;
	import flash.ui.*;
	import flash.utils.*;
	import levels.*;
	import parse.*;
	
	
	
	
	[SWF(width="800",height="600",frameRate="30",backgroundColor="#000000")]
	
	public class Main extends Sprite
	{
		
		private var _level:LevelBase;
		private var _currentLevelId:int = 0;
		
		private var _lastUpdateTime:Number;
		
		private var _edgeShades:Shape;
		
		public static var stage:Stage;
		
		private var _introMovie:MovieClip;
		private var _screenBG:MovieClip;
		private var _timer:Timer;
		
		private static const levelClasses:Vector.<Class> = new <Class>[ Level0, Level1, Level2, Level3, Level4, Level5, Level6, Level7];
		
		public function Main()
		{
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		
		}
		
		private function onAddedToStage(e:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			SoundManager.playMusic();
			_introMovie = new IntroMovie();
			//_screenBG.width = 800;
			//_screenBG.height = 600;
			_introMovie.x = stage.stageWidth / 2;
			_introMovie.y = stage.stageHeight / 2;
			_introMovie.play();
			this.addChild(_introMovie);
			this.addEventListener(Event.ENTER_FRAME, initMenu);
		
		}
		
		public function initMenu(e:Event):void
		{
			if ( _introMovie.currentFrame < 265)
				return;
			
			//init the starting menu	
			removeEventListener(Event.ENTER_FRAME, initMenu);
			
			SoundManager.playLevelEndSound();
			TweenMax.to(_introMovie, 2, { alpha:0 } );
			
			
			_screenBG = new MenuBackGround();
			_screenBG.x = 275;
			_screenBG.y = 200;
			addChild(_screenBG);
			
			var startBtn:PlayGameBtn = new PlayGameBtn();
			startBtn.y = 50;
			startBtn.x = -60;
			startBtn.alpha = 0;
			_screenBG.addChild(startBtn);
			TweenMax.to(startBtn, 1, { alpha:1 } );
			
			var creditsBtn:CreditsBtn = new CreditsBtn();
			creditsBtn.y = 150;
			creditsBtn.x = -60;
			creditsBtn.alpha = 0;
			TweenMax.to(creditsBtn, 1, { alpha:1 } );
			_screenBG.addChild(creditsBtn);
			
			startBtn.addEventListener(MouseEvent.CLICK, gameStart);
			creditsBtn.addEventListener(MouseEvent.CLICK, rollCredits);
		
		}
		
		private function rollCredits(e:MouseEvent):void
		{
			removeChild(_screenBG);
			_screenBG = new CreditScreen();
			var startBtn:PlayGameBtn = new PlayGameBtn();
			startBtn.y = 194.05;
			startBtn.x = 533.7;
			_screenBG.addChild(startBtn);
			startBtn.addEventListener(MouseEvent.CLICK, gameStart);
			addChild(_screenBG);
		}
		
		public function gameStart(m:Event):void
		{
			if (_introMovie != null)
				removeChild(_introMovie);
			
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