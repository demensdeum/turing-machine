import 'dart:io';
import 'dart:math';

const DEBUG_PRINT_ENABLED = false;

void debugPrint(String? string) {
  if (DEBUG_PRINT_ENABLED) {
    print(string);
  }
}

const OPCODE_STOP = "stop";
const OPCODE_PRINT = "print";
const OPCODE_INCREMENT_NEXT = "increment next";
const OPCODE_DECREMENT_NEXT = "decrement next";
const OPCODE_IF_PREVIOUS_NOT_EQUAL = "if previous not equal";
const OPCODE_MOVE_TO_INDEX = "move to index";
const OPCODE_COPY_FROM_TO = "copy from index to index";
const OPCODE_INPUT_TO_NEXT = "input to next";
const OPCODE_GENERATE_RANDOM_NUMBER_FROM_ZERO_TO_AND_WRITE_AFTER = "generate random number from zero to next and write after";

abstract class FiniteStateControlDelegate {
  String nextSymbol() { return ""; }
  String previousSymbol() { return ""; }
  int index() { return 0; }
  String read() { return ""; }
  void write(String symbol);
  void move({required int to});
  void halt();
}

class FiniteStateControl {
  FiniteStateControlDelegate? delegate = null;

  void handle({required String symbol}) {
    debugPrint("Symbol: ${symbol}");
    if (symbol == OPCODE_PRINT) {
      final argument = delegate?.nextSymbol();
      print(argument);
    }
    else if (symbol == OPCODE_GENERATE_RANDOM_NUMBER_FROM_ZERO_TO_AND_WRITE_AFTER) {
      final to = int.tryParse(delegate!.nextSymbol())!;
      final value = new Random().nextInt(to);
      delegate!.nextSymbol();
      delegate!.write(value.toString());
    }
    else if (symbol == OPCODE_INPUT_TO_NEXT) {
      final input = stdin.readLineSync()!;
      delegate?.nextSymbol();
      delegate?.write(input);
    }
    else if (symbol == OPCODE_COPY_FROM_TO) {
      final currentIndex = delegate!.index();
      final fromIndex = int.tryParse(delegate!.nextSymbol())!;
      final toIndex = int.tryParse(delegate!.nextSymbol())!;

      debugPrint("From: ${fromIndex}");
      debugPrint("To: ${toIndex}");

      delegate?.move(to: fromIndex);
      final value = delegate!.read();
      delegate?.move(to: toIndex);
      delegate?.write(value);
      debugPrint("Revert back to index: ${currentIndex}");
      delegate?.move(to: currentIndex);
    }
    else if (symbol == OPCODE_STOP) {
      delegate?.halt();
    }
    else if (symbol == OPCODE_DECREMENT_NEXT) {
      var value = int.tryParse(delegate!.nextSymbol())!;
      value -= 1;
      delegate?.write(value.toString());
    }
    else if (symbol == OPCODE_INCREMENT_NEXT) {
      var value = int.tryParse(delegate!.nextSymbol())!;
      value += 1;
      delegate?.write(value.toString());
    }
    else if (symbol == OPCODE_IF_PREVIOUS_NOT_EQUAL) {
      final previousSymbol = delegate!.previousSymbol();
      final opcode = delegate!.nextSymbol();
      final nextSymbol = delegate!.nextSymbol();

      if (previousSymbol != nextSymbol) {
        debugPrint("${previousSymbol} != ${nextSymbol} NOT EQUAL!");
      }
      else {
        var symbol = delegate!.nextSymbol();
        while (symbol != "else") {
          symbol = delegate!.nextSymbol();
        }
      }
    }
    else if (symbol == OPCODE_MOVE_TO_INDEX) {
      debugPrint("OPCODE_MOVE_TO_INDEX");
      final index = int.tryParse(delegate!.nextSymbol())!;
      delegate?.move(to: index - 1);
    }
  }
}

abstract class InfiniteTape {
  String read({required int at}) {
    return "";
  }

  void write({required String symbol, required int at}) {}
}

class MapInfiniteTape implements InfiniteTape {
  final _map = Map<int, String>();
  String read({required int at}) {
    return _map[at] ?? "";
  }

  void write({required String symbol, required int at}) {
    debugPrint("Write symbol: ${symbol}; line ${at}");
    _map[at] = symbol;
  }
}

class TapeHead {
  int _index = 0;
  InfiniteTape _infiniteTape;

  TapeHead(this._infiniteTape) {}

  String next() {
    _index += 1;
    move(to: _index);
    final output = read();
    return output;
  }

  String previous() {
    _index -= 1;
    move(to: _index);
    final output = read();
    return output;
  }

  void move({required int to}) {
    debugPrint("Tape head moved to index: ${to}");
    this._index = to;
  }

  String read() {
    return _infiniteTape.read(at: this._index);
  }

  void write(String symbol) {
    _infiniteTape.write(symbol: symbol, at: this._index);
  }

  int index() {
    return _index;
  }
}

class TuringMachine implements FiniteStateControlDelegate {
  final _finiteStateControl = FiniteStateControl();
  InfiniteTape _infiniteTape;
  TapeHead _tapeHead;

  var _isRunning = false;

  TuringMachine(infiniteTape)
      : this._infiniteTape = infiniteTape,
        this._tapeHead = TapeHead(infiniteTape);

  void start({int at = 0}) {
    debugPrint("Turing Machine started");
    _finiteStateControl.delegate = this;
    _isRunning = true;
    _tapeHead.move(to: at);
    var symbol = _tapeHead.read();
    while (_isRunning) {
      debugPrint("isRunning");
      _finiteStateControl.handle(symbol: symbol);
      symbol = _tapeHead.next();
    }
  }

  void halt() {
    debugPrint("Turing Machine halted");
    _isRunning = false;
  }

  String nextSymbol() {
    return _tapeHead.next();
  }

  String previousSymbol() {
    return _tapeHead.previous();
  }

  void move({required int to}) {
    _tapeHead.move(to: to);
  }

  void write(String symbol) {
    _tapeHead.write(symbol);
  }

  int index() {
    return _tapeHead.index();
  }

  String read() {
    return _tapeHead.read();
  }
}

InfiniteTape tape() {
  return MapInfiniteTape();
}

void main() {

  final helloWorldTape = tape();
  helloWorldTape.write(symbol: "print", at: 0);
  helloWorldTape.write(symbol: "hello world", at: 1);
  helloWorldTape.write(symbol: "stop", at: 2);

  final countToSixteenTape = tape();
  countToSixteenTape.write(symbol: "increment next", at: 0);
  countToSixteenTape.write(symbol: "0", at: 1);
  countToSixteenTape.write(symbol: "if previous not equal", at: 2);
  countToSixteenTape.write(symbol: "16", at: 3);
  countToSixteenTape.write(symbol: "copy from index to index", at: 4);
  countToSixteenTape.write(symbol: "1", at: 5);
  countToSixteenTape.write(symbol: "8", at: 6);
  countToSixteenTape.write(symbol: "print", at: 7);
  countToSixteenTape.write(symbol: "?", at: 8);
  countToSixteenTape.write(symbol: "move to index", at: 9);
  countToSixteenTape.write(symbol: "0", at: 10);
  countToSixteenTape.write(symbol: "else", at: 11);
  countToSixteenTape.write(symbol: "copy from index to index", at: 12);
  countToSixteenTape.write(symbol: "1", at: 13);
  countToSixteenTape.write(symbol: "16", at: 14);
  countToSixteenTape.write(symbol: "print", at: 15);
  countToSixteenTape.write(symbol: "?", at: 16);
  countToSixteenTape.write(symbol: "print", at: 17);
  countToSixteenTape.write(symbol: "Finished!", at: 18);
  countToSixteenTape.write(symbol: "stop", at: 19);

  final countToZeroTape = tape();
  countToZeroTape.write(symbol: "decrement next", at: 0);
  countToZeroTape.write(symbol: "16", at: 1);
  countToZeroTape.write(symbol: "if previous not equal", at: 2);
  countToZeroTape.write(symbol: "0", at: 3);
  countToZeroTape.write(symbol: "copy from index to index", at: 4);
  countToZeroTape.write(symbol: "1", at: 5);
  countToZeroTape.write(symbol: "8", at: 6);
  countToZeroTape.write(symbol: "print", at: 7);
  countToZeroTape.write(symbol: "?", at: 8);
  countToZeroTape.write(symbol: "move to index", at: 9);
  countToZeroTape.write(symbol: "0", at: 10);
  countToZeroTape.write(symbol: "else", at: 11);
  countToZeroTape.write(symbol: "copy from index to index", at: 12);
  countToZeroTape.write(symbol: "1", at: 13);
  countToZeroTape.write(symbol: "16", at: 14);
  countToZeroTape.write(symbol: "print", at: 15);
  countToZeroTape.write(symbol: "?", at: 16);
  countToZeroTape.write(symbol: "print", at: 17);
  countToZeroTape.write(symbol: "Finished!", at: 18);
  countToZeroTape.write(symbol: "stop", at: 19);

  final guessNumberTape = tape();
  guessNumberTape.write(symbol: "print", at: 0);
  guessNumberTape.write(symbol: "Guess number (0-4):", at: 1);
  guessNumberTape.write(symbol: "input to next", at: 2);
  guessNumberTape.write(symbol: "?", at: 3);
  guessNumberTape.write(symbol: "copy from index to index", at: 4);
  guessNumberTape.write(symbol: "3", at: 5);
  guessNumberTape.write(symbol: "11", at: 6);
  guessNumberTape.write(symbol: "generate random number from zero to next and write after", at: 7);
  guessNumberTape.write(symbol: "4", at: 8);
  guessNumberTape.write(symbol: "?", at: 9);
  guessNumberTape.write(symbol: "if previous not equal", at: 10);
  guessNumberTape.write(symbol: "?", at: 11);
  guessNumberTape.write(symbol: "print", at: 12);
  guessNumberTape.write(symbol: "Wrong!", at: 13);
  guessNumberTape.write(symbol: "copy from index to index", at: 14);
  guessNumberTape.write(symbol: "9", at: 15);
  guessNumberTape.write(symbol: "20", at: 16);
  guessNumberTape.write(symbol: "print", at: 17);
  guessNumberTape.write(symbol: "Number:", at: 18);
  guessNumberTape.write(symbol: "print", at: 19);
  guessNumberTape.write(symbol: "?", at: 20);
  guessNumberTape.write(symbol: "stop", at: 21);
  guessNumberTape.write(symbol: "else", at: 22);
  guessNumberTape.write(symbol: "print", at: 23);
  guessNumberTape.write(symbol: "Correct!", at: 24);
  guessNumberTape.write(symbol: "stop", at: 25);

  var tapes = [helloWorldTape, countToZeroTape, countToSixteenTape, guessNumberTape];

  for (var tape in tapes) {
    print("\n---Next Tape---\n");
    final turingMachine = TuringMachine(tape);
    turingMachine.start();
  }

}
