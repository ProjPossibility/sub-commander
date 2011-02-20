package  {
	
	public class StageClass {

		private static var theStage;

		public function StageClass() {
			// constructor code
		}
		
		public static function getStage(){
			return theStage;
		}
		
		public static function setStage(stage){
			theStage = stage;
		}

	}
	
}
