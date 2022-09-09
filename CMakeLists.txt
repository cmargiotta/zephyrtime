cmake_minimum_required(VERSION 3.22)

set(BOARD nrf52dk_nrf52810)

find_package(Zephyr REQUIRED HINTS $ENV{ZEPHYR_BASE})

project(zephyrtime LANGUAGES CXX VERSION 0.0.1)

target_sources(app PRIVATE ./src/main.cpp)