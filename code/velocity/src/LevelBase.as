package
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

	public class LevelBase extends Sprite
	{
		protected var _camera:Sprite;
		protected var _physicsManager:PhysicsManager;
		
		protected var _avatarBody:b2Body;
		protected var _avatarFootBody:b2Body;
		protected var _avatarView:MovieClip;
		
		protected var _staticPlatformBodies:Vector.<b2Body>;
		protected var _staticPlatformViews:Vector.<MovieClip>;
		
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
		
		public function LevelBase()
		{
			_camera = new Sprite();
			this.addChild(_camera);
			
			_physicsManager = new PhysicsManager();
			
			_staticPlatformBodies = new Vector.<b2Body>;
			_staticPlatformViews = new Vector.<MovieClip>;
			
			_movingPlatformBodies = new Vector.<b2Body>;
			_movingPlatformViews = new Vector.<MovieClip>;
			_movingPlatformStartingPoints = new Vector.<Point>;
			_movingPlatformEndPoints = new Vector.<Point>;
			_movingPlatformMoveRatios = new Vector.<Number>;
			
			_staticEnemyBodies = new Vector.<b2Body>;
			_staticEnemyViews = new Vector.<MovieClip>;
			
			
		}
		
		protected function parse(levelId:int):void
		{
			var i:int;
			
			var parser:Parser = new Parser();
			parser.setLevel(levelId);
			
			var playerPos:Point = parser.player.startingPosition;
			_avatarBody = _physicsManager.createPlayer(playerPos.x ,playerPos.y);
				//_physicsManager.createDynamicRectangle(playerPos.x ,playerPos.y, C.PLAYER_W/2, C.PLAYER_H/2);
			_avatarBody.SetFixedRotation(true);
			_avatarBody.SetLinearDamping(1.5);
			_avatarFootBody = _physicsManager.createDynamicCircle(0, 0, C.PLAYER_W*0.45);
			_avatarFootBody.GetFixtureList().SetSensor(true);
			_avatarView = new AvatarView();
			_avatarView.width = C.PLAYER_W;
			_avatarView.height = C.PLAYER_H;
			_camera.addChild(_avatarView);
			
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
				movingPlatformView.height = movingPlatformDef.height;
				movingPlatformView.rotation = movingPlatformDef.rotation;
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
				
				var staticEnemyView:MovieClip = new EnemyView();
				staticEnemyView.width = staticEnemyDef.width;
				staticEnemyView.height = staticEnemyDef.height;
				staticEnemyView.x = staticEnemyDef.startingPosition.x;
				staticEnemyView.y = staticEnemyDef.startingPosition.y;
				_staticEnemyViews.push(staticEnemyView);
				_camera.addChild(staticEnemyView);
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
			
			var playerForceX:Number = 0;
			if(PlayerInput.right) playerForceX = C.PLAYER_FORCE_HOR;
			else if(PlayerInput.left) playerForceX = -C.PLAYER_FORCE_HOR;
			var playerForce:b2Vec2 = new b2Vec2(playerForceX, 0);
			_avatarBody.ApplyForce(playerForce, _avatarBody.GetWorldCenter());
			
			if(PlayerInput.up && isAvatarOnGround)
			{
				_avatarBody.ApplyForce(new b2Vec2(0,-C.PLAYER_FORCE_JUMP), _avatarBody.GetWorldCenter());
			}
			
			_avatarView.x = _avatarBody.GetPosition().x * PhysicsManager.RATIO;
			_avatarView.y = _avatarBody.GetPosition().y * PhysicsManager.RATIO;
			
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
							_avatarView.alpha = 0.2;
						}
					}
				}
			}
			
			
			for(i=0; i<_movingPlatformBodies.length; i++)
			{
				var ratio:Number = _movingPlatformMoveRatios[i];
				ratio += dt * 0.2;
				if(ratio > 1) ratio -= 1;
				var movedToPos:Point = new Point();
				if(ratio < 0.5) 
				{
					movedToPos.x = _movingPlatformStartingPoints[i].x + 
						ratio * 2 * (_movingPlatformEndPoints[i].x - _movingPlatformStartingPoints[i].x);
					movedToPos.y = _movingPlatformStartingPoints[i].y +
						ratio * 2 * (_movingPlatformEndPoints[i].y - _movingPlatformStartingPoints[i].y);
				}
				else
				{
					movedToPos.x = _movingPlatformStartingPoints[i].x +
						(1-ratio) * 2 * (_movingPlatformEndPoints[i].x - _movingPlatformStartingPoints[i].x);
					movedToPos.y = _movingPlatformStartingPoints[i].y +
						(1-ratio) * 2 * (_movingPlatformEndPoints[i].y - _movingPlatformStartingPoints[i].y);
				}
				_movingPlatformMoveRatios[i] = ratio;
				_movingPlatformBodies[i].SetLinearVelocity(new b2Vec2(
					(movedToPos.x/PhysicsManager.RATIO - _movingPlatformBodies[i].GetPosition().x) / dt,
					(movedToPos.y/PhysicsManager.RATIO - _movingPlatformBodies[i].GetPosition().y) / dt));
				
				_movingPlatformViews[i].x = _movingPlatformBodies[i].GetPosition().x * PhysicsManager.RATIO;
				_movingPlatformViews[i].y = _movingPlatformBodies[i].GetPosition().y * PhysicsManager.RATIO;
			}
			
			var cameraTarget:Number = 400 - _avatarView.x;
			_camera.x += (cameraTarget - _camera.x) * 3 * dt;
			if(_camera.x > 0) _camera.x = 0;
			//_camera.y = 100 - _avatarView.y;
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