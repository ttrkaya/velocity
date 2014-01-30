package levels
{
		import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	
	import flash.display.MovieClip;
	import flash.geom.Point;
	
	public class Level0 extends LevelBase
	{
		
		private var _angle:Number;
		
		private var _wheel:MovieClip;
		private var _wheelMoving:MovieClip;
		
		// Edit hier het middenpunt van het wieltje
		private const CENTER:Point = new Point(691, -400);
		private const INNERR:Number = 200;
		private const OUTERR:Number = 520;
		private const ROTATIONSPEED:Number = 0.5;
		private const OUTERSPEED:Number = 0.5;
		private const W:Number = 100;
		private const H:Number = 20;
		
		
		public function Level0(main:Main)
		{
			super(main);
			parseLevelFromMovieClip(new EindLevel());
			
			//parseLevelFromSwcWithID(0);
			
			for(var i:int=0; i<_staticPlatformViews.length; i++)
			{
				_camera.removeChild(_staticPlatformViews[i]);
			}
			
			_bgMoving = new BackgroundMovingLevel8();
			this.addChild(_bgMoving);
			_bgStatic = new BackgroundStaticLevel8();
			this.addChild(_bgStatic);
			
			this.setChildIndex(_camera, this.numChildren-1);
			_platformsView = new EindLevelOverlay();
			_camera.addChild(_platformsView);
			_foreGround = new ForegroundMovingLevel8();
			_camera.addChild(_foreGround);
			_camera.setChildIndex(_avatarView, _camera.numChildren-1);
			
			_wheel = new Wheel();
			_camera.addChild(_wheel);
			
			_wheelMoving = new WheelMoving();
			_wheelMoving.x = 691;
			_wheelMoving.y = -400;
			_camera.addChild(_wheelMoving);
			_camera.setChildIndex(_wheelMoving, 0);
			_camera.setChildIndex(_wheel, 0);
			_bgMoving.y = _camera.y * 0.3;
			_bgStatic.y = _camera.y * 0.3;
			
			_rotatingPlatformBodies = new Vector.<b2Body>;
			_rotatingPlatformViews = new Vector.<MovieClip>;
			
			_angle = 0;
			for(i=0; i<7; i++)
			{
				var angle:Number = 2*Math.PI*i/3;
				var outerAngle:Number = 2*Math.PI*i/4;

				if (i<3)
				{
					var px:Number = Math.cos(angle) * INNERR + CENTER.x;
					var py:Number = Math.sin(angle) * INNERR + CENTER.y;
				}
				else
				{
					var px:Number = Math.cos(outerAngle) * OUTERR + CENTER.x;
					var py:Number = Math.sin(outerAngle) * OUTERR + CENTER.y;
				}
				var movingPlatformBody:b2Body = _physicsManager.createKinematicRectangle(
					px, py, W/2, H/2, 0, 3);
				_rotatingPlatformBodies.push(movingPlatformBody);
				var movingPlatformView:MovieClip = new MovingPlatformerView();
				movingPlatformView.x = px;
				movingPlatformView.y = py;
				movingPlatformView.width = W*2;
				movingPlatformView.height = H*3;
				_rotatingPlatformViews.push(movingPlatformView);
				_camera.addChild(movingPlatformView);
			}
			
		}
		
		public override function update(dt:Number):void
		{	
			var i:int;

			baseUpdate(dt);
			
			//vertical scrolling added here
			var cameraTargetY:Number = 500 - _avatarBody.GetPosition().y * PhysicsManager.RATIO;
			if(cameraTargetY < 0) cameraTargetY = 0;
			_camera.y += (cameraTargetY - _camera.y) * dt * 5;
			
			_angle += dt * ROTATIONSPEED;
			for(i=0; i<7; i++)
			{
				//var angle:Number = 2*Math.PI*i/3;
//				var outerAngle:Number = 2*Math.PI*i/4;
				
				var angle:Number = 2*Math.PI*i/3 + _angle;
				var outerAngle:Number = 2*Math.PI*i/4 - (_angle * OUTERSPEED);
				if (i<3)
				{
					var px:Number = Math.cos(angle) * INNERR + CENTER.x;
					var py:Number = Math.sin(angle) * INNERR + CENTER.y;
				}
				else
				{
					var px:Number = Math.cos(outerAngle) * OUTERR + CENTER.x;
					var py:Number = Math.sin(outerAngle) * OUTERR + CENTER.y;
				}
				
				_rotatingPlatformBodies[i].SetLinearVelocity(new b2Vec2(
					(px/PhysicsManager.RATIO - _rotatingPlatformBodies[i].GetPosition().x) / dt,
					(py/PhysicsManager.RATIO - _rotatingPlatformBodies[i].GetPosition().y) / dt));
				
				_rotatingPlatformViews[i].x = px;
				_rotatingPlatformViews[i].y = py;
			}
			
			
			
			_wheel.alpha = _staticAlpha;
			_wheelMoving.alpha = 1 - _wheel.alpha;
			
		}
	}
}