import 'dart:io';

class FiniteStateControl {

}

abstract class InfiniteTape {
  String read({required int at}) { return ""; }
  void write({required String symbol, required int at}) {}
}

class MapInfiniteTape implements InfiniteTape {
  final _map = Map<int,String>();
  String read({required int at}) { return ""; }
  void write({required String symbol, required int at}) {
    _map[at] = symbol;
  }
}

class TapeHead {

  int _index = 0;
  InfiniteTape _infiniteTape;

  TapeHead(this._infiniteTape) {}

  String next() {
    move(to: _index + 1);
    return read();
  }

  void move({required int to}) {
    print("Tape head moved to index: ${to}");
    this._index = to;
  }

  String read() {
    return _infiniteTape.read(at: this._index);
  }

  void write(String symbol) {
    _infiniteTape.write(symbol: symbol, at: this._index);
  }

}

class TuringMachine {

  final _finiteStateControl = FiniteStateControl();
  InfiniteTape _infiniteTape;
  TapeHead _tapeHead;

  var _isRunning = false;

  TuringMachine(infiniteTape) :
    this._infiniteTape = infiniteTape,
    this._tapeHead = TapeHead(infiniteTape);

  void start({int at = 0}) {
    print("Turing Machine started");
    _isRunning = true;
    _tapeHead.move(to: at);
    while (_isRunning) {
      print("isRunning");
      final symbol = _tapeHead.next();
      print(symbol);
      if (symbol == "stop") {
        _isRunning = false;
      }
    }
  }

  void halt() {
    print("Turing Machine halted");
    exit(0);
  }

}

void main() {
  final helloWorldTape = MapInfiniteTape();
  helloWorldTape.write(symbol: "print", at: 0);
  helloWorldTape.write(symbol: "hello world", at: 1);
  helloWorldTape.write(symbol: "stop", at: 2);

  final turingMachine = TuringMachine(helloWorldTape);
  turingMachine.start();
}
