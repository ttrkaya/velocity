package parse
{
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.geom.Point;
	
	public class Parser
	{
		private static const levelDefs:Vector = new <MovieClip>[new DefLevel1(), new DefLevel1()];
		
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
			staticEnemies = new Vector.<ShapeDefinition>();
			staticPlatforms = new Vector.<ShapeDefinition>();
			movingEnemies = new Vector.<ShapeDefinition>();
			movingPlatforms = new Vector.<ShapeDefinition>();
			flyingEnemies = new Vector.<ShapeDefinition>();
			
			var level:MovieClip = levelDefs[levelId];
			
			for (var i:uint = 0; i < level.numChildren; i++)
			{ //populate the vectors
				var el:MovieClip = level.getChildAt(i);
				if (el is StaticEnemy)
					staticEnemies.push(new ShapeDefinition(new Point(el.x, el.y), el.width, el.height, el.rotation));
				else if (el is MovingEnemy)
					movingEnemies.push(new ShapeDefinition(new Point(el.x, el.y), el.width, el.height, el.rotation).setIdAndRatio(el.gotoId, el.beginRatio));
				else if (el is FlyingEnemy)
					flyingEnemies.push(new ShapeDefinition(new Point(el.x, el.y), el.width, el.height, el.rotation).setIdAndRatio(el.gotoId, el.beginRatio));
				else if (el is StaticPlatform)
					staticPlatforms.push(new ShapeDefinition(new Point(el.x, el.y), el.width, el.height, el.rotation));
				else if (el is MovingPlatform)
					movingPlatforms.push(new ShapeDefinition(new Point(el.x, el.y), el.width, el.height, el.rotation).setIdAndRatio(el.gotoId, el.beginRatio));
				else if (el is Player)
					player = new ShapeDefinition(new Point(el.x, el.y), el.width, el.height, el.rotation);
				else if (el is EndPoint)
					endPoint = new ShapeDefinition(new Point(el.x, el.y), el.width, el.height, el.rotation);
				else if (el is Waypoint)
					waypoints.push(new ShapeDefinition(new Point(el.x, el.y), el.width, el.height, el.rotation).setId(el.id));
			}
			for each (var waypoint:Waypoint in waypoints)
			{ //add the waypoints to the moving elements
				for each (var movingEnemy:ShapeDefinition in movingEnemies)
					if (movingEnemy.tag == waypoint.tag)
						movingEnemy.addWayPoint(new Point(waypoint.x, waypoint.y));
				
				for each (var flyingEnemy:ShapeDefinition in flyingEnemies)
					if (flyingEnemy.tag == waypoint.tag)
						flyingEnemy.addWayPoint(new Point(waypoint.x, waypoint.y));
				
				for each (var movingPlatform:ShapeDefinition in movingPlatforms)
					if (movingPlatform.tag == waypoint.tag)
						movingPlatform.addWayPoint(new Point(waypoint.x, waypoint.y));
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
		
		public function get startPoint():ShapeDefinition 
		{
			return _startPoint;
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