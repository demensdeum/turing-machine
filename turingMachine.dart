class FiniteStateControl {

}

class InfiniteTape {
  var infiniteTape = Map<String, String>();
}

class TapeHead {
  String read() {
    return "1";
  }

  void write(String symbol) {

  }
}

class TuringMachine {

  var finiteStateControl = FiniteStateControl();
  var infiniteTape = InfiniteTape();
  var tapeHead = TapeHead();

  void start() {

  }


}

void main() {

}
