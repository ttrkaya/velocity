package parse
{
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.geom.Point;
	
	public class Parser
	{
		private static const levelDefs:Vector.<MovieClip> = new <MovieClip>[new DefLevel1(), new DefLevel1()];
		
		private var _staticPlatforms:Vector.<ShapeDefinition>;
		private var _movingPlatforms:Vector.<ShapeDefinition>;
		private var _movingEnemies:Vector.<ShapeDefinition>;
		private var _flyingEnemies:Vector.<ShapeDefinition>;
		private var _staticEnemies:Vector.<ShapeDefinition>;
		private var _waypoints:Vector.<ShapeDefinition>;
		
		private var _endPoint:ShapeDefinition;
		private var _player:ShapeDefinition;
		
		public function Parser()
		{
		
		}
		
		public function setLevel(levelId:int):void
		{
			_staticEnemies = new Vector.<ShapeDefinition>();
			_staticPlatforms = new Vector.<ShapeDefinition>();
			_movingEnemies = new Vector.<ShapeDefinition>();
			_movingPlatforms = new Vector.<ShapeDefinition>();
			_flyingEnemies = new Vector.<ShapeDefinition>();
			_waypoints = new Vector.<ShapeDefinition>();
			
			var level:MovieClip = levelDefs[levelId];
			
			for (var i:uint = 0; i < level.numChildren; i++)
			{ //populate the vectors
				var el:MovieClip = level.getChildAt(i) as  MovieClip;
				var rotation:Number = el.rotation;
				el.rotation = 0;
				if (el is StaticEnemy)
					_staticEnemies.push(new ShapeDefinition(new Point(el.x, el.y), el.width, el.height, rotation));
				else if (el is MovingEnemy)
					_movingEnemies.push(new ShapeDefinition(new Point(el.x, el.y), el.width, el.height, rotation).setIdAndRatio(el.gotoId, el.beginRatio, el.speed));
				else if (el is FlyingEnemy)
					_flyingEnemies.push(new ShapeDefinition(new Point(el.x, el.y), el.width, el.height, rotation).setIdAndRatio(el.gotoId, el.beginRatio, el.speed));
				else if (el is StaticPlatform)
					_staticPlatforms.push(new ShapeDefinition(new Point(el.x, el.y), el.width, el.height, rotation));
				else if (el is MovingPlatform)
					_movingPlatforms.push(new ShapeDefinition(new Point(el.x, el.y), el.width, el.height, rotation).setIdAndRatio(el.gotoId, el.beginRatio, el.speed));
				else if (el is Player)
					_player = new ShapeDefinition(new Point(el.x, el.y), el.width, el.height, rotation);
				else if (el is EndPoint)
					_endPoint = new ShapeDefinition(new Point(el.x, el.y), el.width, el.height, rotation);
				else if (el is Waypoint)
					_waypoints.push(new ShapeDefinition(new Point(el.x, el.y), el.width, el.height, rotation).setId(el.id));
			}
			for each (var waypoint:ShapeDefinition in waypoints)
			{ //add the waypoints to the moving elements
				var wayPointPoint:Point = waypoint.startingPosition;
				for each (var movingEnemy:ShapeDefinition in _movingEnemies)
					if (movingEnemy.tag == waypoint.tag)
						movingEnemy.addWayPoint(wayPointPoint);
				
				for each (var flyingEnemy:ShapeDefinition in flyingEnemies)
					if (flyingEnemy.tag == waypoint.tag)
						flyingEnemy.addWayPoint(wayPointPoint);
				
				for each (var movingPlatform:ShapeDefinition in movingPlatforms)
					if (movingPlatform.tag == waypoint.tag)
						movingPlatform.addWayPoint(wayPointPoint);
			}
		}
		
		
		public function get staticPlatforms():Vector.<ShapeDefinition> 
		{
			return _staticPlatforms;
		}
		
		public function get movingPlatforms():Vector.<ShapeDefinition> 
		{
			return _movingPlatforms;
		}
		
		public function get movingEnemies():Vector.<ShapeDefinition> 
		{
			return _movingEnemies;
		}
		
		public function get flyingEnemies():Vector.<ShapeDefinition> 
		{
			return _flyingEnemies;
		}
		
		public function get staticEnemies():Vector.<ShapeDefinition> 
		{
			return _staticEnemies;
		}
		
		public function get waypoints():Vector.<ShapeDefinition> 
		{
			return _waypoints;
		}
		
		public function get endPoint():ShapeDefinition 
		{
			return _endPoint;
		}
		
		public function get player():ShapeDefinition 
		{
			return _player;
		}
	}
}