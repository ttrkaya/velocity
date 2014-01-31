package parse
{
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.geom.Point;
	
	import levels.Level7;
	
	
	public class Parser
	{
		public static const levelDefs:Vector.<MovieClip> = new <MovieClip>[
	new DefLevel0(), new DefLevel1(), new DefLevel2(), new DefLevel3(), new DefLevel4(), new DefLevel5, new DefLevel6() , new DefLevelLast()];

		
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
			var level:MovieClip = levelDefs[levelId];
			loadLevel(level);
		}
		public function loadLevel(level:MovieClip):void
		{
			_staticEnemies = new Vector.<ShapeDefinition>();
			_staticPlatforms = new Vector.<ShapeDefinition>();
			_movingEnemies = new Vector.<ShapeDefinition>();
			_movingPlatforms = new Vector.<ShapeDefinition>();
			_flyingEnemies = new Vector.<ShapeDefinition>();
			_waypoints = new Vector.<ShapeDefinition>();
			
			
			for (var i:uint = 0; i < level.numChildren; i++)
			{ //populate the vectors
				var el:MovieClip = level.getChildAt(i) as  MovieClip;
				var rotation:Number = el.rotation;
				el.rotation = 0;
				if (el is StaticEnemy || el is StaticEnemyLast)
					_staticEnemies.push(new ShapeDefinition(new Point(el.x, el.y), el.width, el.height, rotation));
				else if (el is MovingEnemy || el is MovingEnemyLast)
					_movingEnemies.push(new ShapeDefinition(new Point(el.x, el.y), el.width, el.height, rotation).setIdAndRatio(el.gotoId, el.beginRatio, el.speed));
				else if (el is StaticPlatform || el is StaticPlatformLast)
					_staticPlatforms.push(new ShapeDefinition(new Point(el.x, el.y), el.width, el.height, rotation));
				else if (el is MovingPlatform || el is MovingPlatformLast)
					_movingPlatforms.push(new ShapeDefinition(new Point(el.x, el.y), el.width, el.height, rotation).setIdAndRatio(el.gotoId, el.beginRatio, el.speed));
				else if (el is Player || el is PlayerLastLast)
					_player = new ShapeDefinition(new Point(el.x, el.y), el.width, el.height, rotation);
				else if (el is EndPoint|| el is EndPointLast)
					_endPoint = new ShapeDefinition(new Point(el.x, el.y), el.width, el.height, rotation);
				else if (el is Waypoint || el is WaypointLast)
					_waypoints.push(new ShapeDefinition(new Point(el.x, el.y), el.width, el.height, rotation).setId(el.id));
//				else
//					throw "wtf is this?";
				el.rotation = rotation;
			}
			for each (var waypoint:ShapeDefinition in waypoints)
			{ //add the waypoints to the moving elements
				var wayPointPoint:Point = waypoint.startingPosition;
				for each (var movingEnemy:ShapeDefinition in _movingEnemies)
					if (movingEnemy.tag == waypoint.tag)
						movingEnemy.addWayPoint(wayPointPoint);
				
				for each (var flyingEnemy:ShapeDefinition in _flyingEnemies)
					if (flyingEnemy.tag == waypoint.tag)
						flyingEnemy.addWayPoint(wayPointPoint);
				
				for each (var movingPlatform:ShapeDefinition in _movingPlatforms)
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