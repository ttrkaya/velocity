package parse
{
	import flash.geom.Point;
	
	/**
	 * position information of level objects
	 * @author Paul Brinkkemper
	 */
	
	public var waypoint:ShapeDefinition;
	public var beginRatio:Number;
	public var startingPosition:Point;
	public var width:Number;
	public var height:Number;
	public var rotation:Number;
	public var tag:int;
	
	public class ShapeDefinition extends Object
	{
		
		public function ShapeDefinition (_startPos:Point, _width:Number, _height:Number, _rotation:Number = 0)
		{
			startingPosition = _startPos;
			width = _width;
			height = _height;
			rotation = _rotation;
		}
		public function setId (_id:int):void
		{
			tag = _id;
		}
		public function setIdAndRatio (_id:int, _ratio:Number):void
		{
			tag = _id;
			ratio = _ratio;
		}
		public function addWayPoint (_wayPoint:ShapeDefinition):void
		{
			waypoint = _wayPoint;
		}
	}
	
}