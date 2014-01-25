package
{
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.media.Video;
	
	import parse.Parser;
	import parse.ShapeDefinition;

	public class LevelBase extends Sprite
	{
		protected var _physicsManager:PhysicsManager;
		
		protected var _avatarBody:b2Body;
		protected var _avatarView:MovieClip;
		
		protected var _staticPlatformBodies:Vector.<b2Body>;
		protected var _staticPlatformViews:Vector.<MovieClip>;
		
		protected var _movingPlatformBodies:Vector.<b2Body>;
		protected var _movingPlatformViews:Vector.<MovieClip>;
		protected var _movingPlatformStartingPoints:Vector.<Point>;
		protected var _movingPlatformEndPoints:Vector.<Point>;
		protected var _movingPlatformMoveRatios:Vector.<Number>;
		
		
		public function LevelBase()
		{
			_physicsManager = new PhysicsManager();
			
			_staticPlatformBodies = new Vector.<b2Body>;
			_staticPlatformViews = new Vector.<MovieClip>;
			_movingPlatformBodies = new Vector.<b2Body>;
			_movingPlatformViews = new Vector.<MovieClip>;
			_movingPlatformStartingPoints = new Vector.<Point>;
			_movingPlatformEndPoints = new Vector.<Point>;
			_movingPlatformMoveRatios = new Vector.<Number>;
		}
		
		protected function parse(levelId:int):void
		{
			var i:int;
			
			var parser:Parser = new Parser();
			parser.setLevel(levelId);
			
			var playerPos:Point = parser.player.startingPosition;
			_avatarBody = _physicsManager.createDynamicRectangle(playerPos.x ,playerPos.y, C.PLAYER_W/2, C.PLAYER_H/2);
			_avatarBody.SetFixedRotation(true);
			_avatarView = new AvatarView();
			_avatarView.width = C.PLAYER_W;
			_avatarView.height = C.PLAYER_H;
			this.addChild(_avatarView);
			
			var staticPlatformDefs:Vector.<ShapeDefinition> = parser.staticPlatforms;
			for(i=0; i<staticPlatformDefs.length; i++)
			{
				var staticPlatformDef:ShapeDefinition = staticPlatformDefs[i];
				var staticPlatformerBody:b2Body = _physicsManager.createStaticRectangle(
					staticPlatformDef.startingPosition.x, staticPlatformDef.startingPosition.y, 
					staticPlatformDef.width/2, staticPlatformDef.height/2, staticPlatformDef.rotation*Math.PI/180);
				_staticPlatformBodies.push(staticPlatformerBody);
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
				_movingPlatformStartingPoints.push(movingPlatformDef.startingPosition);
				_movingPlatformEndPoints.push(movingPlatformDef.waypoint);
				_movingPlatformMoveRatios.push(movingPlatformDef.beginRatio);
			}
			
		}
		
		public function update(dt:Number):void
		{
			throw "override this!";
		}
		
		protected function baseUpdate(dt:Number):void
		{
			_physicsManager.update(dt);
			
			
			
			var playerForceX:Number = 0;
			if(PlayerInput.right) playerForceX = C.PLAYER_FORCE_HOR;
			else if(PlayerInput.left) playerForceX = -C.PLAYER_FORCE_HOR;
			var playerForce:b2Vec2 = new b2Vec2(playerForceX, 0);
			_avatarBody.ApplyForce(playerForce, _avatarBody.GetWorldCenter());
			
			if(PlayerInput.up)
			{
				PlayerInput.up = false;
				_avatarBody.ApplyImpulse(new b2Vec2(0,-C.PLAYER_FORCE_JUMP), _avatarBody.GetWorldCenter());
			}
			
			_avatarView.x = _avatarBody.GetPosition().x * PhysicsManager.RATIO;
			_avatarView.y = _avatarBody.GetPosition().y * PhysicsManager.RATIO;
		}
		
		private function isPlayerOnGround():Boolean
		{
			return false;
		}
	}
}