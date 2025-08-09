# 16-bit ALU with Multi-Cycle Signed Division in Verilog

This project implements a **16-bit Arithmetic Logic Unit (ALU)** in Verilog HDL, capable of performing a wide range of arithmetic, logical, and shift operations. It includes **multi-cycle signed division** with proper handling of negative numbers, zero division, and overflow detection.

The ALU is modular in design, making it easy to extend or integrate into larger FPGA or digital logic projects.

**Features**

* **Arithmetic Operations**

  * Addition (`add`) – signed addition with overflow detection
  * Subtraction (`subtract`) – signed subtraction with overflow detection
  * Division (`divide`) – signed multi-cycle division with remainder output

* **Logical Operations**

  * AND, OR, XOR, NOR (bitwise)
  
* **Shift Operations**

  * Logical Shift Left (`LSL`)
  * Logical Shift Right (`LSR`)
  * Arithmetic Shift Right (`ASR`)
  
* **Comparison Operations**

  * Equal to (`equal`)
  * Greater than (`great`)
  * Less than (`less`)
  
* **Status Flags**

  * `sign_flag` – sign bit of result
  * `zero_flag` – high when result is zero
  * `overflow` – high when arithmetic overflow occurs
  
* **Multi-Cycle Division**

  * Handles signed numbers
  * Prevents divide-by-zero errors
  * Produces quotient and remainder

  
## 📂 Module Structure

*alu_design.v*
│
├── alu_design       # Main ALU controller
├── signed_addition  # Signed addition using full adders
├── signed_subtraction # Signed subtraction using full adders
├── signed_division  # Multi-cycle signed division FSM
├── AND / OR / XOR / NOR # Bitwise logic modules
├── lsl / lsr / asr  # Shift modules
└── full_adder       # Basic 1-bit full adder

## Control Signal Mapping

| Operation | Control Signal (4-bit) |
| --------- | ---------------------- |
| ADD       | `0000`                 |
| SUBTRACT  | `0001`                 |
| DIVIDE    | `0010`                 |
| AND       | `0011`                 |
| OR        | `0100`                 |
| XOR       | `0101`                 |
| NOR       | `0110`                 |
| LSL       | `0111`                 |
| LSR       | `1000`                 |
| ASR       | `1001`                 |
| EQUAL     | `1010`                 |
| GREATER   | `1011`                 |
| LESS      | `1100`                 |

---

## 🚀 How It Works

* The **alu_design** module takes in two signed 16-bit inputs (input0, input1), a **control signal** to choose the operation, and additional select lines for shift operations.
* Arithmetic and logic results are calculated using dedicated modules for modularity.
* **Signed division** is implemented using a **finite state machine (FSM)** that runs over multiple clock cycles, shifting and subtracting until the result is complete.
* **Flags** (sign_flag, zero_flag, overflow) are updated based on the operation result.

---

## Simulation & Testing

You can simulate this design using tools like:

* **ModelSim** / **QuestaSim**
* **Xilinx Vivado**
* **Icarus Verilog** + **GTKWave**

## 📜 License

This project is open-source under the **MIT License** – feel free to use, modify, and share.

---

## ✍ Author

**Rohith Addepalli**
📌 [LinkedIn](https://www.linkedin.com/in/rohith-addepalli)

