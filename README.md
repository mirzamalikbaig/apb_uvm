# APB UVM Verification

I built this SystemVerilog/UVM verification environment for a simple APB memory slave, with a directed sequence, reference-memory scoreboard, and functional coverage.

**Author:**   Agha Malik Baig Mirza 

**Original project:** [EDA Playground](https://edaplayground.com/x/Ziek)

## Design

The `slave` module implements 32 words of 32-bit memory. An active-low asynchronous reset clears all words. Writes occur on the rising clock edge when `psel`, `penable`, `pready`, and `pwrite` are asserted. Reads use a combinational memory output.

`pready` is always high and `pslverr` is always low. The memory index is `paddr[4:0]`, so this example uses direct word indices rather than a conventional byte-addressed register map. Upper address bits do not affect the DUT's memory selection.

## Verification environment

| File | Role |
| --- | --- |
| `design.sv` | APB memory slave |
| `testbench.sv` | Top module, 10 ns clock, initial reset, virtual-interface configuration, and UVM startup |
| `apb_if.sv` | Shared APB signals |
| `apb_txn.sv` | Transaction fields for request and response data |
| `apb_sequence.sv` | Directed sequence of 14 transfers |
| `apb_sequencer.sv` | Typed UVM sequencer |
| `apb_driver.sv` | Setup/access/idle signaling and completion handshake |
| `apb_monitor.sv` | Observes completed transfers and publishes transactions |
| `apb_scoreboard.sv` | Stores expected write data and compares reads |
| `apb_coverage.sv` | Samples operation, address, write-data, and cross coverage |
| `apb_agent.sv` | Creates driver, monitor, and sequencer; connects driver to sequencer |
| `apb_env.sv` | Connects the monitor to the scoreboard and coverage subscriber |
| `apb_test.sv` | Prints topology and starts the sequence under a run-phase objection |
| `run_vcs.sh` | Compile, simulate, and generate a text coverage report |
| `results/simulation.log` | My EDA Playground simulation and coverage output |

The test starts at time zero. The driver waits for reset release, then drives each transaction on falling clock edges. The monitor samples completed accesses on rising edges.

## Directed test

| Address | Write data | Followed by read comparison |
| --- | --- | --- |
| 5 | 50 | Yes |
| 12 | 100 | Yes |
| 6 | `0x00000000` | No |
| 7 | 500 | No |
| 1 | `0x00000000` | Yes |
| 2 | `0xFFFFFFFF` | Yes |
| 3 | `0xAAAAAAAA` | Yes |
| 4 | `0x55555555` | Yes |

The sequence contains **8 writes and 6 reads**. It assigns stimulus directly; although request fields are declared `rand`, this test does not call `randomize()`.

## Functional coverage

| Coverpoint / cross | Explicit bins |
| --- | --- |
| Operation | Read, write |
| Address | Low: 0–7; high: 8–15 |
| Write data, sampled on writes | Zero; 1–255; 256–`0xFFFFFFFF` |
| Operation × address | Read/write crossed with low/high address ranges |

The recorded run reports **100.00% functional coverage** for these implemented bins. Addresses 16–31 are outside the explicit address bins, and 100% here does not mean every address or every APB scenario was tested.

## Recorded results

Results are from my EDA Playground run with Synopsys VCS.

| Item | Result |
| --- | --- |
| Simulator | Synopsys VCS `X-2025.06-SP1_Full64` |
| UVM | `UVM-1.2.Synopsys` |
| Test | `apb_test` |
| Simulation duration | 430 ns |
| Read comparisons | 6 PASS, 0 FAIL |
| UVM warning / error / fatal counts | 0 / 0 / 0 |

| Metric | Total coverage summary |
| --- | ---: |
| Overall score | 86.09% |
| Line | 100.00% |
| Condition | 60.00% |
| Toggle | 70.43% |
| FSM | Not reported |
| Branch | 100.00% |
| Group | 100.00% |

The top-level instance and total module-definition summaries separately report **82.61%**. These are different summary scopes from the total score of 86.09%.

URG prints `Load Failed:` followed by `Warning-[UCAPI-SNF] Shape Not Found` for FSM coverage. This warning belongs to coverage post-processing, outside the zero UVM-warning count. The RTL has no explicitly declared FSM, and my coverage report contains no FSM coverage value. Condition and toggle coverage remain below 100%.

See [my complete simulation output](results/simulation.log). I formatted the source files for readability, so the log's original line numbers may differ.

## Run with Synopsys VCS

Requirements: Bash, licensed Synopsys VCS with UVM 1.2 support, and URG available on `PATH`.

From the repository directory:

```bash
bash run_vcs.sh
```

I use these commands to compile, run, and generate the coverage report:

```bash
vcs -full64 -licqueue -sverilog -ntb_opts uvm-1.2 \
  -timescale=1ns/1ns \
  -cm line+branch+tgl+fsm+cond \
  design.sv testbench.sv

./simv -cm line+branch+tgl+fsm+cond
urg -dir simv.vdb -format text
cat urgReport/dashboard.txt
```

Compile only `design.sv` and `testbench.sv`; the top testbench includes all remaining SystemVerilog files in dependency order. Compiling the included files separately as well would introduce duplicate definitions. Generated outputs are excluded by `.gitignore`; the recorded log under `results/` remains tracked.

## Current scope

This example checks directed write/read data behavior for an always-ready, error-free slave. It does not exercise wait states, slave-error responses, reset during traffic, or protocol assertions. The scoreboard is populated by observed writes and does not initialize or reset its reference memory; the directed reads follow writes to their addresses. It indexes the full transaction address, while the DUT uses only the lower five bits, so extending stimulus beyond addresses 0–31 requires updating the reference model. There is no independent transaction-count check or simulation timeout.

I included all source files and the simulation log from my EDA Playground run.
