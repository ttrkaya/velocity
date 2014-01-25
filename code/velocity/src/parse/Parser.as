package parse
{
	import flash.display.MovieClip;
	import flash.geom.Point;

	public class Parser
	{
		private static const levelDefs:Vector = new <MovieClip>[
			new DefLevel1(),
			new DefLevel2()];
		
		private var staticPlatforms:Vector.<
		
		public function Parser()
		{
			
		}
		
		public function setLevel(levelId:int):void
		{
			var level:MovieClip = levelDefs[levelId];
			
			//TODO: parsing
			//traverse children hiearcgy
			
		}
		
		public function getPlayerPosition():Point
		{
			
		}
		
		public function getNumStaticPlatforms():int
		{
			
		}
		
		public function getWidthOfStaticPlatform(platformId:int):Number
		{
			
		}
	}
}