package levels
{
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.Contacts.b2Contact;
	import Box2D.Dynamics.Contacts.b2ContactEdge;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2Fixture;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.media.Video;
	
	import parse.Parser;
	import parse.ShapeDefinition;
	
	import view.MonkViewPlus;

	public class LevelBase extends Sprite
	{
		protected var _main:Main;
		
		protected var _camera:Sprite;
		protected var _physicsManager:PhysicsManager;
		
		protected var _avatarBody:b2Body;
		protected var _avatarFootBody:b2Body;
		protected var _avatarView:MonkViewPlus;
		protected var _jumpWaitTime:Number;
		
		protected var _endBody:b2Body;
		
		protected var _staticPlatformBodies:Vector.<b2Body>;
		protected var _staticPlatformViews:Vector.<MovieClip>;
		protected var _staticAlpha:Number;
		
		protected var _movingPlatformBodies:Vector.<b2Body>;
		protected var _movingPlatformViews:Vector.<MovieClip>;
		protected var _movingPlatformStartingPoints:Vector.<Point>;
		protected var _movingPlatformEndPoints:Vector.<Point>;
		protected var _movingPlatformMoveRatios:Vector.<Number>;
		
		protected var _staticEnemyBodies:Vector.<b2Body>;
		protected var _staticEnemyViews:Vector.<MovieClip>;
		
		protected var _movingEnemyBodies:Vector.<b2Body>;
		protected var _movingEnemyViews:Vector.<MovieClip>;
		protected var _movingEnemyStartingPoints:Vector.<Point>;
		protected var _movingEnemyEndPoints:Vector.<Point>;
		protected var _movingEnemyMoveRatios:Vector.<Number>;
		
		protected var _bgStatic:MovieClip;
		protected var _bgMoving:MovieClip;
		protected var _foreGround:MovieClip;
		protected var _platformsView:MovieClip;
		protected var _isBgMoving:Boolean;
		
		protected var _hasBeenHurtTime:Number;
		protected var _hasBeenInNirvanaTime:Number;
		
		protected var parser:Parser;
		
		private static const MAX_JUMP_WAIT:Number = 0.6;
		private static const HURT_WAIT_TIME:Number = 1.2;
		private static const NIRVANA_WAIT_TIME:Number = 4.5;
		private static const GHOST_PASSING_SOUND_DISTANCE:Number = 40;
		
		public function LevelBase(main:Main)
		{
			_main = main;
			
			_physicsManager = new PhysicsManager();
			
			_jumpWaitTime = 0;
			_isBgMoving = false;
			_hasBeenHurtTime = 0;
			_hasBeenInNirvanaTime = 0;
			
			_staticPlatformBodies = new Vector.<b2Body>;
			_staticPlatformViews = new Vector.<MovieClip>;
			_staticAlpha = 1;
			
			_movingPlatformBodies = new Vector.<b2Body>;
			_movingPlatformViews = new Vector.<MovieClip>;
			_movingPlatformStartingPoints = new Vector.<Point>;
			_movingPlatformEndPoints = new Vector.<Point>;
			_movingPlatformMoveRatios = new Vector.<Number>;
			
			_staticEnemyBodies = new Vector.<b2Body>;
			_staticEnemyViews = new Vector.<MovieClip>;
			
			_movingEnemyBodies = new Vector.<b2Body>;
			_movingEnemyViews = new Vector.<MovieClip>;
			_movingEnemyStartingPoints = new Vector.<Point>;
			_movingEnemyEndPoints = new Vector.<Point>;
			_movingEnemyMoveRatios = new Vector.<Number>;
			
			_camera = new Sprite();
			this.addChild(_camera);
		}
		
		public function destroy():void
		{
			_physicsManager.destroy();
		}
		protected function parseLevelFromSwcWithID(levelId:int):void
		{
			parser = new Parser();
			parser.setLevel(levelId);	
			parse();
		}
		protected function parseLevelFromMovieClip(movieClip:MovieClip):void
		{
			parser = new Parser();
			parser.loadLevel(movieClip);	
			parse();
		}
		
		protected function parse():void
		{
			var i:int;
			
			var playerPos:Point = parser.player.startingPosition;
			_avatarBody = _physicsManager.createPlayer(playerPos.x ,playerPos.y);
				//_physicsManager.createDynamicRectangle(playerPos.x ,playerPos.y, C.PLAYER_W/2, C.PLAYER_H/2);
			_avatarBody.SetFixedRotation(true);
			_avatarBody.SetLinearDamping(2.5);
			_avatarFootBody = _physicsManager.createDynamicCircle(0, 0, C.PLAYER_W*0.45);
			_avatarFootBody.GetFixtureList().SetSensor(true);
			_avatarView = new MonkViewPlus();
			_avatarView.stop();
			_avatarView.idle();
			_avatarView.width = C.PLAYER_W;
			_avatarView.height = C.PLAYER_H;
			_camera.addChild(_avatarView);
			
			var endPos:Point = parser.endPoint.startingPosition;
			_endBody = _physicsManager.createStaticCircle(endPos.x, endPos.y, 5);
			_endBody.GetFixtureList().SetSensor(true);
			
			var staticPlatformDefs:Vector.<ShapeDefinition> = parser.staticPlatforms;
			for(i=0; i<staticPlatformDefs.length; i++)
			{
				var staticPlatformDef:ShapeDefinition = staticPlatformDefs[i];
				var staticPlatformerBody:b2Body = _physicsManager.createStaticRectangle(
					staticPlatformDef.startingPosition.x, staticPlatformDef.startingPosition.y, 
					staticPlatformDef.width/2, staticPlatformDef.height/2, staticPlatformDef.rotation*Math.PI/180);
				_staticPlatformBodies.push(staticPlatformerBody);
				var staticPlatformView:MovieClip = new StaticPlatformerView();
				staticPlatformView.x = staticPlatformDef.startingPosition.x;
				staticPlatformView.y = staticPlatformDef.startingPosition.y;
				staticPlatformView.width = staticPlatformDef.width;
				staticPlatformView.height = staticPlatformDef.height;
				staticPlatformView.rotation = staticPlatformDef.rotation;
				_camera.addChild(staticPlatformView);
				_staticPlatformViews.push(staticPlatformView);
			}
			
			var movingPlatformDefs:Vector.<ShapeDefinition> = parser.movingPlatforms;
			for(i=0; i<movingPlatformDefs.length; i++)
			{
				var movingPlatformDef:ShapeDefinition = movingPlatformDefs[i];
				var movingPlatformBody:b2Body = _physicsManager.createKinematicRectangle(
					movingPlatformDef.startingPosition.x, movingPlatformDef.startingPosition.y, 
					movingPlatformDef.width/2, movingPlatformDef.height/2, movingPlatformDef.rotation*Math.PI/180);
				_movingPlatformBodies.push(movingPlatformBody);
				var movingPlatformView:MovieClip = new MovingPlatformerView();
				movingPlatformView.x = movingPlatformDef.startingPosition.x;
				movingPlatformView.y = movingPlatformDef.startingPosition.y;
				movingPlatformView.width = movingPlatformDef.width;
				movingPlatformView.height = movingPlatformDef.height * 2;
				movingPlatformView.rotation = movingPlatformDef.rotation * 2;
				_movingPlatformViews.push(movingPlatformView);
				_camera.addChild(movingPlatformView);
				_movingPlatformStartingPoints.push(movingPlatformDef.startingPosition);
				_movingPlatformEndPoints.push(movingPlatformDef.waypoint);
				_movingPlatformMoveRatios.push(movingPlatformDef.beginRatio);
			}
			
			var staticEnemyDefs:Vector.<ShapeDefinition> = parser.staticEnemies;
			for(i=0; i<staticEnemyDefs.length; i++)
			{
				var staticEnemyDef:ShapeDefinition = staticEnemyDefs[i];
				var staticEnemyBody:b2Body = _physicsManager.createStaticCircle(
					staticEnemyDef.startingPosition.x, staticEnemyDef.startingPosition.y, staticEnemyDef.width/2);
				_staticEnemyBodies.push(staticEnemyBody);
				
				var staticEnemyView:MovieClip = new GhostView();
				staticEnemyView.width = staticEnemyDef.width;
				staticEnemyView.height = staticEnemyDef.height;
				staticEnemyView.x = staticEnemyDef.startingPosition.x;
				staticEnemyView.y = staticEnemyDef.startingPosition.y;
				_staticEnemyViews.push(staticEnemyView);
				_camera.addChild(staticEnemyView);
			}
			
			var movingEnemyDefs:Vector.<ShapeDefinition> = parser.movingEnemies;
			for(i=0; i<movingEnemyDefs.length; i++)
			{
				var movingEnemyDef:ShapeDefinition = movingEnemyDefs[i];
				var movingEnemyBody:b2Body = _physicsManager.createKinematicRectangle(
					movingEnemyDef.startingPosition.x, movingEnemyDef.startingPosition.y, 
					movingEnemyDef.width/2, movingEnemyDef.height/2, movingEnemyDef.rotation*Math.PI/180);
				_movingEnemyBodies.push(movingEnemyBody);
				var movingEnemyView:MovieClip = new GhostView();
				movingEnemyView.x = movingEnemyDef.startingPosition.x;
				movingEnemyView.y = movingEnemyDef.startingPosition.y;
				movingEnemyView.width = movingEnemyDef.width;
				movingEnemyView.height = movingEnemyDef.height;
				movingEnemyView.rotation = movingEnemyDef.rotation;
				_movingEnemyViews.push(movingEnemyView);
				_camera.addChild(movingEnemyView);
				_movingEnemyStartingPoints.push(movingEnemyDef.startingPosition);
				_movingEnemyEndPoints.push(movingEnemyDef.waypoint);
				_movingEnemyMoveRatios.push(movingEnemyDef.beginRatio);
			}
		}
		
		public function update(dt:Number):void
		{
			throw "override this!";
		}
		
		protected function baseUpdate(dt:Number):void
		{
			var i:int;
			
			_physicsManager.update(dt);
			
			var isAvatarOnGround:Boolean = this.isPlayerOnGround();
			_avatarFootBody.SetPosition(new b2Vec2(_avatarBody.GetPosition().x, 
												_avatarBody.GetPosition().y + C.PLAYER_H * 0.5 / PhysicsManager.RATIO));
			_avatarFootBody.SetLinearVelocity(new b2Vec2());
			
			if(!_avatarView.isHurt && !_avatarView.isInNirvana)
			{
				var playerForceX:Number = 0;
				if(PlayerInput.right) playerForceX = C.PLAYER_FORCE_HOR;
				else if(PlayerInput.left) playerForceX = -C.PLAYER_FORCE_HOR;
				var playerForce:b2Vec2 = new b2Vec2(playerForceX, 0);
				_avatarBody.ApplyForce(playerForce, _avatarBody.GetWorldCenter());
			}
			
			_jumpWaitTime -= dt;
			if(PlayerInput.up)
			{
				if(_avatarBody.GetLinearVelocity().y < -2)
				{
					_avatarBody.ApplyForce(new b2Vec2(0,-C.PLAYER_FORCE_JUMP_ENRFORCE), _avatarBody.GetWorldCenter());
				}
				
				if(_jumpWaitTime < 0 && isAvatarOnGround)
				{
					_jumpWaitTime = MAX_JUMP_WAIT;
					_avatarBody.ApplyImpulse(new b2Vec2(0,-C.PLAYER_FORCE_JUMP), _avatarBody.GetWorldCenter());
				}
			}
			
			for(var avatarContactList:b2ContactEdge = _avatarBody.GetContactList();
				avatarContactList != null;
				avatarContactList = avatarContactList.next)
			{
				for(i=0; i<_staticEnemyBodies.length; i++)
				{
					if(avatarContactList.contact.GetFixtureA() == _staticEnemyBodies[i].GetFixtureList()
						|| avatarContactList.contact.GetFixtureB() == _staticEnemyBodies[i].GetFixtureList())
					{
						if(avatarContactList.contact.IsTouching())
						{
							_avatarView.hurt();
						}
					}
				}
				for(i=0; i<_movingEnemyBodies.length; i++)
				{
					if(avatarContactList.contact.GetFixtureA() == _movingEnemyBodies[i].GetFixtureList()
						|| avatarContactList.contact.GetFixtureB() == _movingEnemyBodies[i].GetFixtureList())
					{
						if(avatarContactList.contact.IsTouching())
						{
							_avatarView.hurt();
						}
					}
				}
			}
			
			for(var avatarEndContactList:b2ContactEdge = _avatarBody.GetContactList();
				avatarEndContactList != null;
				avatarEndContactList = avatarEndContactList.next)
			{
				if(avatarEndContactList.contact.GetFixtureA() == _endBody.GetFixtureList()
					|| avatarEndContactList.contact.GetFixtureB() == _endBody.GetFixtureList())
				{
					_avatarView.nirvana();
					SoundManager.fadeOutMovingMusic();
					SoundManager.playLevelEndSound();
				}
			}
			
			for(i=0; i<_movingPlatformBodies.length; i++)
			{
				var platformRatio:Number = _movingPlatformMoveRatios[i];
				platformRatio += dt * 0.2;
				if(platformRatio > 1) platformRatio -= 1;
				var platformTarget:Point = new Point();
				if(platformRatio < 0.5) 
				{
					platformTarget.x = _movingPlatformStartingPoints[i].x + 
						platformRatio * 2 * (_movingPlatformEndPoints[i].x - _movingPlatformStartingPoints[i].x);
					platformTarget.y = _movingPlatformStartingPoints[i].y +
						platformRatio * 2 * (_movingPlatformEndPoints[i].y - _movingPlatformStartingPoints[i].y);
				}
				else
				{
					platformTarget.x = _movingPlatformStartingPoints[i].x +
						(1-platformRatio) * 2 * (_movingPlatformEndPoints[i].x - _movingPlatformStartingPoints[i].x);
					platformTarget.y = _movingPlatformStartingPoints[i].y +
						(1-platformRatio) * 2 * (_movingPlatformEndPoints[i].y - _movingPlatformStartingPoints[i].y);
				}
				_movingPlatformMoveRatios[i] = platformRatio;
				_movingPlatformBodies[i].SetLinearVelocity(new b2Vec2(
					(platformTarget.x/PhysicsManager.RATIO - _movingPlatformBodies[i].GetPosition().x) / dt,
					(platformTarget.y/PhysicsManager.RATIO - _movingPlatformBodies[i].GetPosition().y) / dt));
				
				_movingPlatformViews[i].x = _movingPlatformBodies[i].GetPosition().x * PhysicsManager.RATIO;
				_movingPlatformViews[i].y = _movingPlatformBodies[i].GetPosition().y * PhysicsManager.RATIO;
			}
			
			for(i=0; i<_movingEnemyBodies.length; i++)
			{
				var enemyRatio:Number = _movingEnemyMoveRatios[i];
				enemyRatio += dt * 0.2;
				if(enemyRatio > 1) enemyRatio -= 1;
				var enemyTarget:Point = new Point();
				if(enemyRatio < 0.5) 
				{
					enemyTarget.x = _movingEnemyStartingPoints[i].x + 
						enemyRatio * 2 * (_movingEnemyEndPoints[i].x - _movingEnemyStartingPoints[i].x);
					enemyTarget.y = _movingEnemyStartingPoints[i].y +
						enemyRatio * 2 * (_movingEnemyEndPoints[i].y - _movingEnemyStartingPoints[i].y);
				}
				else
				{
					enemyTarget.x = _movingEnemyStartingPoints[i].x +
						(1-enemyRatio) * 2 * (_movingEnemyEndPoints[i].x - _movingEnemyStartingPoints[i].x);
					enemyTarget.y = _movingEnemyStartingPoints[i].y +
						(1-enemyRatio) * 2 * (_movingEnemyEndPoints[i].y - _movingEnemyStartingPoints[i].y);
				}
				_movingEnemyMoveRatios[i] = enemyRatio;
				_movingEnemyBodies[i].SetLinearVelocity(new b2Vec2(
					(enemyTarget.x/PhysicsManager.RATIO - _movingEnemyBodies[i].GetPosition().x) / dt,
					(enemyTarget.y/PhysicsManager.RATIO - _movingEnemyBodies[i].GetPosition().y) / dt));
				
				_movingEnemyViews[i].x = _movingEnemyBodies[i].GetPosition().x * PhysicsManager.RATIO;
				_movingEnemyViews[i].y = _movingEnemyBodies[i].GetPosition().y * PhysicsManager.RATIO;
				
				var dist:Number = Math.abs(_avatarView.x - _movingEnemyViews[i].x);//Point.distance(new Point(_movingEnemyViews[i].x, _movingEnemyViews[i].y), new Point(_avatarView.x, _avatarView.y));
				if (dist < GHOST_PASSING_SOUND_DISTANCE)
					SoundManager.playGhostSound();
			}
			
			var cameraTarget:Number = 400 - _avatarView.x;
			_camera.x += (cameraTarget - _camera.x) * 3 * dt;
			if(_camera.x > 0) _camera.x = 0;
			var rightLimit:Number = -_platformsView.width + 800;
			if(_camera.x < rightLimit) _camera.x = rightLimit;
			_bgMoving.x = _bgStatic.x = _camera.x / 3;

			const staticAlphaRatio:Number = 5;
			var staticAlphaTarget:Number = (staticAlphaRatio - _avatarBody.GetLinearVelocity().LengthSquared()) / staticAlphaRatio;
			if(staticAlphaTarget < -0.1) staticAlphaTarget = -0.1;
			else if(staticAlphaTarget > 1.5) staticAlphaTarget = 1.5;
			_staticAlpha += (staticAlphaTarget - _staticAlpha) * 5 * dt;
			for(i=0; i<_staticPlatformViews.length; i++)
			{
				_staticPlatformViews[i].alpha = _staticAlpha;
			}
			for(i=0; i<_staticEnemyViews.length; i++)
			{
				_staticEnemyViews[i].alpha = _staticAlpha;
			}
			
			var avatarSpeed:Number = _avatarBody.GetLinearVelocity().Length();
			const movingAlphaRatio:Number = 3;
			var movingAlpha:Number = (avatarSpeed - movingAlphaRatio) / movingAlphaRatio;
			if(movingAlpha > 0 || _avatarView.isHurt) movingAlpha = 1;
			for(i=0; i<_movingPlatformBodies.length; i++)
			{
				_movingPlatformViews[i].alpha = movingAlpha
			}
			for(i=0; i<_movingEnemyBodies.length; i++)
			{
				_movingEnemyViews[i].alpha = movingAlpha;
			}
			
			var speedX:Number = _avatarBody.GetLinearVelocity().x;
			var absSpeedX:Number = Math.abs(speedX);
			if(speedX != 0 && !_avatarView.isInNirvana) _avatarView.scaleX = (_avatarBody.GetLinearVelocity().x > 0) ? 1 : -1;
			if(!_avatarView.isHurt && !_avatarView.isInNirvana)
			{
				if(isAvatarOnGround)
				{
					if(!PlayerInput.left && !PlayerInput.right)
					{
						_avatarView.idle();
					}
					else
					{
						if(absSpeedX < 5)
						{
							_avatarView.walk();
						}
						else
						{
							_avatarView.run();
						}
					}
				}
				else
				{
					_avatarView.jump();
				}
			}
			_avatarView.x = _avatarBody.GetPosition().x * PhysicsManager.RATIO;
			_avatarView.y = _avatarBody.GetPosition().y * PhysicsManager.RATIO + 10;
			
			if(!isAvatarOnGround)
			{
				_isBgMoving = true;
			}
			else
			{
				_isBgMoving = _avatarView.currentFrame != 1;
			}
			_bgStatic.alpha = _isBgMoving ? 0 : 1;
			if(_avatarView.isInNirvana) _bgStatic.alpha = 1;
			
			_platformsView.alpha = _staticAlpha;
			_foreGround.alpha = 1 - _platformsView.alpha;
			
			if (_isBgMoving && !_avatarView.isInNirvana)
				SoundManager.playMovingMusic();
			else
				SoundManager.fadeOutMovingMusic();
			
			if(_avatarView.isHurt && !_avatarView.isInNirvana) _hasBeenHurtTime += dt;
			if(_hasBeenHurtTime > HURT_WAIT_TIME) _main.restart();
			if(_avatarBody.GetPosition().y * PhysicsManager.RATIO > 1000) _main.restart();
			
			if(_avatarView.isInNirvana) _hasBeenInNirvanaTime += dt;
			if(_hasBeenInNirvanaTime > NIRVANA_WAIT_TIME) _main.advanceLevel();
		}
		
		private function isPlayerOnGround():Boolean
		{
			var i:int;
			
			for(var footContacts:b2ContactEdge = _avatarFootBody.GetContactList();
				footContacts != null; footContacts = footContacts.next)
			{
				var contact:b2Contact = footContacts.contact;
				if(contact.IsTouching())
				{
					var other:b2Fixture;
					if(contact.GetFixtureA() == _avatarFootBody.GetFixtureList())
					{
						other = contact.GetFixtureB();
					}
					else if(contact.GetFixtureB() == _avatarFootBody.GetFixtureList())
					{
						other = contact.GetFixtureA();
					}
					else
					{
						continue;
					}
					
					for(i=0; i<_staticPlatformBodies.length; i++)
					{
						if(other == _staticPlatformBodies[i].GetFixtureList()) return true;
					}
					for(i=0; i<_movingPlatformBodies.length; i++)
					{
						if(other == _movingPlatformBodies[i].GetFixtureList()) return true;
					}
				}
			}

			return false;
		}
	}
}