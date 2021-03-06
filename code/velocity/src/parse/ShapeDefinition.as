package parse
{
	import flash.display.Shape;
	import flash.geom.Point;
	
	public class ShapeDefinition
	{
		public var waypoint:Point;
		public var beginRatio:Number;
		public var startingPosition:Point;
		public var width:Number;
		public var height:Number;
		public var rotation:Number;
		public var tag:int = 0;
		public var speed:Number = 1;
		
		public function ShapeDefinition (_startPos:Point, _width:Number, _height:Number, _rotation:Number = 0)
		{
			startingPosition = _startPos;
			width = _width;
			height = _height;
			rotation = _rotation;
		}
		public function setId (_id:int):ShapeDefinition
		{
			tag = _id;
			
			return this;
		}
		public function setIdAndRatio (_id:int, _ratio:Number, _speed:Number = 1):ShapeDefinition
		{
			tag = _id;
			beginRatio = _ratio;
			speed = _speed;
			
			return this;
		}
		
		public function addWayPoint (_wayPoint:Point):void
		{
			waypoint = _wayPoint;
		}
	}
	
}