# Memory Management Simulator in Assembly

## Overview
This project is a **memory management simulator** implemented entirely in **x86 Assembly (AT&T syntax)**. It simulates file allocation, retrieval, deletion, and defragmentation within a fixed-size memory block. The goal is to explore low-level memory operations, understand how simple file systems manage storage, and manipulate data structures directly at the CPU register level.

**Authors & Contributors:**
* Răzvan - [@GabreanuR](https://github.com/GabreanuR)

## Features
* **File Allocation (`opadd`)** – Adds a new file to memory while ensuring efficient space usage.
* **File Retrieval (`opget`)** – Finds the start and end positions of a file in memory.
* **File Deletion (`opdelete`)** – Removes a file and marks its space as free.
* **Memory Defragmentation (`opdefragmentation`)** – Rearranges files to eliminate fragmentation and consolidate free space.
* **File List Sorting (`opsortflist`)** – Sorts stored files for better memory management.

## Technologies Used
* **x86 Assembly (AT&T syntax - 32-bit)**
* **Linux System Calls** (Direct kernel interrupts)
* **Manual Memory Management Techniques**

## Installation & Usage

### Prerequisites
To compile and run this project, you need:
* **GCC with Assembly support** (specifically the `gcc-multilib` package for 32-bit compilation on 64-bit systems).
* **A Linux environment** (Native Linux or WSL for Windows users).

### Compiling
Compile the source code using the `-m32` flag to target the 32-bit architecture. Since the project includes both 1D and 2D memory models, you can compile them separately:

```bash
# Compile the 1D Memory Simulator
gcc -m32 memory_simulator_1d.s -o simulator_1d

# Compile the 2D Memory Simulator
gcc -m32 memory_simulator_2d.s -o simulator_2d
```

### Running
Execute the compiled binary:
```bash
# Run the 1D Simulator
./simulator_1d

# Run the 2D Simulator
./simulator_2d
```