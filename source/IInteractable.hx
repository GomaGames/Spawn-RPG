package;

import sprites.pickups.Gem;

interface IInteractable {
  public function interact(cb:Void->Void):Void;
}

class Test {
  static function main() {
    var objects:Array<IInteractable> = new Array<IInteractable>();    
  }
}