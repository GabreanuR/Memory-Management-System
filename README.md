# Memory Management Simulator in Assembly  

## Overview  
This project is a **memory management simulator** implemented in **x86 Assembly (AT&T syntax)**. It simulates file allocation, retrieval, deletion, and defragmentation within a fixed-size memory block. The goal is to explore low-level memory operations and understand how simple file systems manage storage.  

## Features  
- **File Allocation (`opadd`)** – Adds a new file to memory while ensuring efficient space usage.  
- **File Retrieval (`opget`)** – Finds the start and end positions of a file in memory.  
- **File Deletion (`opdelete`)** – Removes a file and marks its space as free.  
- **Memory Defragmentation (`opdefragmentation`)** – Rearranges files to eliminate fragmentation.  
- **File List Sorting (`opsortflist`)** – Sorts stored files for better memory management.  

## Technologies Used  
- **x86 Assembly (AT&T syntax)**  
- **Linux System Calls**  
- **Manual Memory Management Techniques**  

## Installation & Usage  
### Prerequisites  
You need:  
- **GCC with Assembly support**  
- **A Linux environment (or WSL for Windows users)**

### Usage
- gcc -m32 [file].s -o [file]
- ./[file]
