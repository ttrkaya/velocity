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
		
		private static const levelClasses:Vector.<Class> = new <Class>[Level0, Level1, Level2, Level5, Level6, Level4, Level3, LevelLast];
		private var _introMovie:MovieClip;
		private var _screenBG:MovieClip;
		private var _timer:Timer;
		

		
		public function Main()
		{
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		
		}
		
		private function onAddedToStage(e:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			SoundManager.playMusic();
			_introMovie = new IntroMovie();
			_introMovie.x = stage.stageWidth / 2;
			_introMovie.y = stage.stageHeight / 2;
			_introMovie.play();
			this.addChild(_introMovie);
			this.addEventListener(Event.ENTER_FRAME, initMenu);
			this.addEventListener(MouseEvent.CLICK, initMenu);
		}
		
		public function initMenu(e:Event):void
		{
			if ( _introMovie.currentFrame < 265 && !(e is MouseEvent))
				return;
			
			//init the starting menu	
			removeEventListener(Event.ENTER_FRAME, initMenu);
			removeEventListener(MouseEvent.CLICK, initMenu);
			
			SoundManager.playLevelEndSound(); 
			SoundManager.playMovingMusic();
			
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
		
		private function rollCredits(e:Event):void
		{
			clearScreens();

				
			removeEventListener(MouseEvent.CLICK, rollCredits);
			
			_screenBG = new CreditScreen();
			var startBtn:PlayGameBtn = new PlayGameBtn();
			startBtn.x = 200;
			startBtn.y = 480;
			_screenBG.addChild(startBtn);
			startBtn.addEventListener(MouseEvent.CLICK, gameStart);
			addChild(_screenBG);
		}
		
		private function clearScreens():void
		{
			if (_introMovie != null && this.contains(_introMovie))
			{
				removeChild(_introMovie);
				_introMovie = null;
			}
			
			if (_screenBG != null && this.contains(_screenBG) )
			{
				removeChild(_screenBG);
				_screenBG = null;
			}
			while (this.numChildren > 0)
			{
				this.removeChildAt(0);
			}
		}
		
		public function gameStart(m:Event):void
		{
			clearScreens();
			
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
			stage.focus = stage;
			
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
			if (_currentLevelId == levelClasses.length)
				gameWin();
			else
			{
				SoundManager.restartMusic();
				_currentLevelId %= levelClasses.length;
				this.restart();
			}
			
		} 
		
		public function gameWin():void 
		{
			this.removeChild(_level);
			_level.destroy();
			_level = null;
			this.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			_screenBG = new EndScreen();
			_screenBG.alpha = 0;
			this.addChild(_screenBG);
			TweenMax.to(_screenBG, 1, { alpha: 1 } );
			
			
			var creditsBtn:CreditsBtn = new CreditsBtn();
			creditsBtn.x = 190;
			creditsBtn.y = 433;
			creditsBtn.alpha = 0;
			TweenMax.to(creditsBtn, 5, { alpha:1 } );
			_screenBG.addChild(creditsBtn);
			
			creditsBtn.addEventListener(MouseEvent.CLICK, rollCredits);
			_currentLevelId = 0;
		}
	}
}