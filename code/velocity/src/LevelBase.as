package
{
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
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
		
		
		public function LevelBase()
		{
			_physicsManager = new PhysicsManager();
			
			_avatarBody = _physicsManager.createDynamicRectangle(0,0, C.PLAYER_HW, C.PLAYER_HH);
			_avatarBody.SetFixedRotation(true);
			_avatarView = new AvatarView();
			this.addChild(_avatarView);
		}
		
		protected function parse(levelId:int):void
		{
			var i:int;
			
			var parser:Parser = new Parser();
			parser.setLevel(levelId);
			var staticPlatformDefs:Vector.<ShapeDefinition> = parser.staticPlatforms;
			
			for(i=0; i<staticPlatformDefs.length; i++)
			{
				var staticPlatformDef:ShapeDefinition = staticPlatformDefs[i];
				_physicsManager.createStaticRectangle(
					staticPlatformDef.startingPosition.x, staticPlatformDef.startingPosition.y, 
					staticPlatformDef.width/2, staticPlatformDef.height/2, staticPlatformDef.rotation*Math.PI/180);
			}
		}
		
		public function update(dt:Number):void
		{
			throw "override this!";
		}
		
		protected function baseUpdate(dt:Number):void
		{
			var playerForceX:Number = 0;
			if(PlayerInput.right) playerForceX = C.PLAYER_FORCE_HOR;
			else if(PlayerInput.left) playerForceX = -C.PLAYER_FORCE_HOR;
			var playerForce:b2Vec2 = new b2Vec2(playerForceX, 0);
			_avatarBody.ApplyForce(playerForce, _avatarBody.GetWorldCenter());
			
			_avatarView.x = _avatarBody.GetPosition().x * PhysicsManager.RATIO;
			_avatarView.y = _avatarBody.GetPosition().y * PhysicsManager.RATIO;
		}
	}
}