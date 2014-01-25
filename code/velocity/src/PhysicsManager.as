package
{
	import Box2D.Collision.Shapes.b2CircleShape;
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2DebugDraw;
	import Box2D.Dynamics.b2FixtureDef;
	import Box2D.Dynamics.b2World;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.display.Stage;

	public class PhysicsManager
	{
		private var _world:b2World;
		
		private var _debugSpriteContainer:DisplayObjectContainer;
		private var _debugSprite:Sprite;
		
		public static const RATIO:Number = 30;
		
		public function PhysicsManager()
		{
			_debugSpriteContainer = Main.stage;
			
			var gravity:b2Vec2 = new b2Vec2();
			gravity.Set(0,0);
			_world = new b2World(gravity,true);
			
			_debugSprite = new Sprite();
			_debugSprite.mouseChildren = false;
			_debugSprite.mouseEnabled = false;
			var debugDrawer:b2DebugDraw = new b2DebugDraw();
			debugDrawer.SetSprite(_debugSprite);
			debugDrawer.SetDrawScale(RATIO);
			debugDrawer.SetLineThickness(2);
			debugDrawer.SetFillAlpha(0.1);
			debugDrawer.SetFlags(b2DebugDraw.e_shapeBit);
			_world.SetDebugDraw(debugDrawer);
			//_debugSpriteContainer.addChild(_debugSprite);
		}
		
		public function update(dt:Number):void
		{
			_world.Step(dt,10,10);
			_world.ClearForces();
			_world.DrawDebugData();
			
			try{_debugSpriteContainer.setChildIndex(_debugSprite,_debugSpriteContainer.numChildren-1);}catch(e:Error){}
		}
		
		public function createDynamicRectangle(centerX:Number,centerY:Number,halfWidth:Number,halfHeight:Number,angle:Number=0,density:Number=1,friction:Number=0.5,restitution:Number=0.5):b2Body
		{
			var body:b2Body = this.createRectangleToSetType(centerX,centerY,halfWidth,halfHeight,density,friction,restitution);
			body.SetAngle(angle);
			body.SetType(b2Body.b2_dynamicBody);
			
			return body;
		}
		public function createStaticRectangle(centerX:Number,centerY:Number,halfWidth:Number,halfHeight:Number,angle:Number=0,friction:Number=0.5,restitution:Number=0.5):b2Body
		{
			var body:b2Body = this.createRectangleToSetType(centerX,centerY,halfWidth,halfHeight,1,friction,restitution);
			body.SetAngle(angle);
			body.SetType(b2Body.b2_staticBody);
			
			return body;
		}
		private function createRectangleToSetType(x:Number,y:Number,hw:Number,hh:Number,density:Number,friction:Number,restitution:Number):b2Body
		{
			var bodyDef:b2BodyDef = new b2BodyDef();
			bodyDef.position.Set(x/RATIO,y/RATIO);
			
			var shape:b2PolygonShape = new b2PolygonShape();
			shape.SetAsBox(hw/RATIO,hh/RATIO);
			
			var fixDef:b2FixtureDef = new b2FixtureDef();
			fixDef.shape = shape;
			fixDef.density = density;
			fixDef.friction = friction;
			fixDef.restitution = restitution;
			
			var body:b2Body = _world.CreateBody(bodyDef);
			body.CreateFixture(fixDef);
			body.ResetMassData();
			
			return body;
		}
		
		public function createDynamicCircle(centerX:Number,centerY:Number,r:Number,density:Number=1,friction:Number=0.5,restitution:Number=0.5, linearDamping:Number=0, angularDamping:Number=0):b2Body
		{
			var body:b2Body = this.createCircleToSetType(centerX,centerY,r,density,friction,restitution);
			body.SetType(b2Body.b2_dynamicBody);
			body.SetAngularDamping(angularDamping);
			body.SetLinearDamping(linearDamping);
			
			return body;
		}
		public function createStaticCircle(centerX:Number,centerY:Number,r:Number,friction:Number=0.5,restitution:Number=0.5):b2Body
		{
			var body:b2Body = this.createCircleToSetType(centerX,centerY,r,1,friction,restitution);
			body.SetType(b2Body.b2_staticBody);
			
			return body;
		}
		private function createCircleToSetType(x:Number,y:Number,r:Number,density:Number,friction:Number,restitution:Number):b2Body
		{
			var bodyDef:b2BodyDef = new b2BodyDef();
			bodyDef.position.Set(x/RATIO,y/RATIO);
			
			var shape:b2CircleShape = new b2CircleShape(r/RATIO);
			
			var fixDef:b2FixtureDef = new b2FixtureDef();
			fixDef.shape = shape;
			fixDef.density = density;
			fixDef.friction = friction;
			fixDef.restitution = restitution;
			
			var body:b2Body = _world.CreateBody(bodyDef);
			body.CreateFixture(fixDef);
			body.ResetMassData();
			
			return body;
		}
		
		public function destroyBody(body:b2Body):void
		{
			_world.DestroyBody(body);
		}
	}
}