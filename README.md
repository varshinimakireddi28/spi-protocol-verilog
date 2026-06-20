# SPI Protocol — Verilog Implementation

A complete SPI (Serial Peripheral Interface) Master and Slave design written in Verilog, with a self-checking testbench and waveform-level verification of bit-by-bit data transfer.

## Overview

This project implements the SPI communication protocol from scratch in Verilog RTL, covering:
- A configurable SPI Master with an internal clock divider and a 4-state FSM (IDLE → LOAD → TRANSFER → FINISH)
- An edge-detecting SPI Slave that synchronizes to the Master's clock without generating its own
- A top-level wrapper connecting Master and Slave through internal MOSI/MISO wires
- A self-checking testbench covering three data patterns: alternating bits, all-ones, and all-zeros

Currently supports **SPI Mode 0** (CPOL=0, CPHA=0), with parameters in place for extending to all four SPI modes.

## Why this project

After implementing UART and a basic ALU, I wanted to understand a synchronous serial protocol and the engineering tradeoffs against UART's asynchronous design — specifically clock-edge sampling, shift-register timing, and multi-slave addressing via chip select.

## Architecture

```
                    SCLK
Master ───────────────────────────► Slave
       ◄─────────────────────────── 
                    MOSI / MISO
       ───────────────────────────►
                    CS (active LOW)
```

- **SPI_MASTER.v** — generates SCLK via a clock divider, controls CS, and shifts data out on MOSI / in from MISO
- **SPI_SLAVE.v** — detects SCLK and CS edges using the system clock, loads its reply on `CS` falling, and shifts data in/out synchronized to the Master's clock
- **SPI_TOP.v** — instantiates Master and Slave and wires them together
- **SPI_TB.v** — drives three test transfers and checks Master/Slave received data against expected values

## Verification

All three test cases pass:

| Test | Master sends | Slave sends | Result |
|---|---|---|---|
| 1 | 0xA5 (10100101) | 0x3C (00111100) | PASS |
| 2 | 0xFF (11111111) | 0x00 (00000000) | PASS |
| 3 | 0x00 (00000000) | 0xAB (10101011) | PASS |

Beyond the testbench pass/fail check, I traced the internal `shift_tx` / `shift_rx` registers cycle-by-cycle in the waveform viewer to manually confirm every bit shifted out on MOSI was correctly reassembled by the Slave's `shift_rx`, and vice versa for MISO — see `waveforms/bit_level_trace.png`.

## Tools used

- Xilinx Vivado (behavioral simulation, xsim)
- Verilog HDL

## What I'd add next

- Full CPOL/CPHA support for Modes 1, 2, and 3
- Multi-slave bus example with independent CS lines
- Synthesis + timing report on a target FPGA part

## Files

```
src/SPI_MASTER.v   — Master FSM and clock divider
src/SPI_SLAVE.v    — Slave edge-detection logic
src/SPI_TOP.v      — Top-level interconnect
tb/SPI_TB.v        — Self-checking testbench
waveforms/         — Simulation screenshots
```

