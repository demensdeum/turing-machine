# 🧠 Dart Turing Machine Emulator

A minimalistic **Turing Machine emulator** implemented entirely in **Dart**, featuring an extendable opcode system, infinite tape simulation, and several sample "programs" (tapes) that demonstrate printing, arithmetic, conditional branching, user input, and even a **self-replicating quine**.

---

## 🚀 Features

- 🧾 **Finite State Control** — Centralized control flow handling all instructions.
- ♾️ **Infinite Tape** — Implemented as a sparse map for unbounded memory access.
- 🪄 **Tape Head** — Supports moving, reading, and writing across infinite cells.
- 🧩 **Opcodes System** — Extensible instruction set (print, increment, input, copy, etc).
- 🌀 **Non-deterministic Option** — Optional chaos mode for random opcode substitution.
- 🧍 **Delegate Interface** — Clean separation between logic and memory management.
- 💡 **Example Programs**:
  - **Hello World**
  - **Count to Sixteen**
  - **Count Down to Zero**
  - **Number Guessing Game**
  - **Quine (self-replicating program)**

---

## 🧩 Opcodes

| Opcode | Description |
|--------|--------------|
| `stop` | Halts the machine |
| `print` | Prints the next symbol |
| `increment next` | Increments the numeric value of the next symbol |
| `decrement next` | Decrements the numeric value of the next symbol |
| `if previous not equal` | Conditional execution block |
| `move to index` | Moves the tape head to a specific index |
| `copy from index to index` | Copies a value from one cell to another |
| `input to next` | Reads user input and writes it to the next cell |
| `generate random number from zero to next and write after` | Writes a random integer to tape |

---

## 🧮 Example Tapes

The `main()` function defines and runs several tapes sequentially:

### 🖨️ 1. Hello World
Prints “hello world” and stops.
```dart
helloWorldTape.write(symbol: "print", at: 0);
helloWorldTape.write(symbol: "hello world", at: 1);
helloWorldTape.write(symbol: "stop", at: 2);
```

### 🔢 2. Count to Sixteen
Increments numbers from 0 to 16 and prints each value.

### 🔻 3. Count Down to Zero
Decrements numbers from 16 to 0 and prints each value.

### 🎲 4. Guess the Number
Asks user to guess a random number between 0 and 4.

### 🪞 5. Quine
A self-replicating Turing program that outputs its own tape source.

---

## ⚙️ Running the Emulator

### 🧱 Requirements
- Dart SDK ≥ 3.0  
  Install from [dart.dev](https://dart.dev/get-dart)

### ▶️ Run
```bash
dart run main.dart
```

You’ll see several demo tapes execute in sequence, printing results to the console.

---

## 🧠 Architecture Overview

```text
FiniteStateControl
 ├─ handles opcodes and logic
 │
 ├── delegate → TuringMachine (implements FiniteStateControlDelegate)
 │     ├── TapeHead (controls current position)
 │     └── InfiniteTape (Map-based memory)
```

---

## 🔍 Debug Options

Enable various debug flags at the top of the file:

```dart
const DEBUG_PRINT_ENABLED = true;
const DEBUG_MODE_ENABLED = true;
const DEBUG_PRINT_TAPE = true;
```

- `DEBUG_PRINT_ENABLED` → Log every symbol and opcode  
- `DEBUG_MODE_ENABLED` → Step-by-step execution (press Enter to continue)  
- `DEBUG_PRINT_TAPE` → Print tape contents after each operation  

---

## 🧪 Extending the Machine

To add a new opcode:

1. Define it as a new constant:
   ```dart
   const OPCODE_NEW_OPERATION = "new operation";
   ```
2. Add it to the `opcodes` list.
3. Implement its behavior in `FiniteStateControl.handle()`.

---

## 🧰 Example Output

```
---Next Tape---
hello world

---Next Tape---
16
15
...
0
Finished!

---Next Tape---
Guess number (0-4):
> 2
Wrong!
Number: 3

---Next Tape---
????????????????
(copying and printing itself...)
```

---

## 📜 License

MIT License  
Copyright (c) 2025  

Free to use, modify, and experiment.

---

## 🧑‍💻 Author

Developed by **Ilia Prokhorov**  
A playful exploration of computation theory, recursion, and chaos—implemented in Dart.
