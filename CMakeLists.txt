cmake_minimum_required(VERSION 3.20)

project(MemorySimulator ASM)

set(CMAKE_ASM_FLAGS "${CMAKE_ASM_FLAGS} -m32")
set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -m32")

add_executable(simulator_1d memory_simulator_1d.s)
add_executable(simulator_2d memory_simulator_2d.s)