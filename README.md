# Simple Burst-only Interface

This repository contains a SystemVerilog module that implements **Simple Burst-only Interface (SBI)**, which is a custom-developed protocol designed for memory burst transactions. The interface provides efficient data transfer for applications requiring sequential memory operations.

## Simple Burst-only Interface

Below is a detailed description of **Simple Burst-only Interface (SBI)**:

### Key Feautres

1. Burst Access Only:

   - The SBI is optimized for sequential memory transactions.

2. Read and Write Operations:

   - The SBI supports both read and write operations, buth they cannot occur simultaneously.


### Signals:

| Signal    | Direction | Description |
| --------- | --------- | --- |
| `bCLK`    | input     | System clock signal |
| `bRSTn`   | input     | Active-low reset signal |
| `bADDR`   | input     | Start address for memory access |
| `bSTART`  | input     | Indicates the beginning of a memory operation |
| `bACCESS` | input     | Triggers memory access during an operation |
| `bWRITE`  | input     | Specifies the type of operation (1 for write, 0 for read) |
| `bD`      | input     | Data input for write operations |
| `bQ`      | output    | Data output for read operations |
| `bVALID`  | output    | Indicates that the output data (`bQ`) is valid |

### Operation Flow:

   - Start Address Configuration:
     - The `bSTART` signal and `bADDR` signal are used to set the starting address for the memory operation.
     - If `bWRITE` signal is `1`, the start address corresponds to a write operation.
     - If `bWRITE` signal is `0`, the start address corresponds to a read operation.

   - Memory Access:
     - Once the starting address is configured, the `bACCESS` signal triggers the memory access.
     - If `bWRITE` is `1` during the `bACCESS` signal, a write operation occurs with the data provided on `bD`.
     - If `bWRITE` is `0` during the `bACCESS` signal, a read operation occurs and the data is available on `bQ` in the next clock cycle.

### Parameters

| Parameter | Default Value | Description |
| --------- | ------------- | --- |
| `Width`   | 32            | Bit width of the data |
| `Depth`   | 256           | Memory depth |

## Example Waveforms

![read](https://svg.wavedrom.com/github/shsjung/simple-burst-interface/main/wavedrom/read_0.json)

![write](https://svg.wavedrom.com/github/shsjung/simple-burst-interface/main/wavedrom/write_0.json)

![read_write](https://svg.wavedrom.com/github/shsjung/simple-burst-interface/main/wavedrom/read_write_0.json)

## File Structure

- `rtl/`
  - `ram_single.sv`: Single-port RAM
  - `sbi_interface.sv`
  - `sbi_mem_top.sv`: Top module that instantiates the memory model and the interface module
- `wavedrom/`: Waveform diagrams
- `obj_dir/`: Directory containing object files and executables generated during Verilator simulation
- `tb.cpp`: Testbench top-level file
- `Makefile`: Makefile script to run the testbench
- `README.md`: Project documentation
- `LICENSE`: License information

## Running the Testbench

The provided testbench is designed for simulation using Verilator. Ensure Verilator is installed before running the testbench. Refer to the [Verilator GitHub page](https://github.com/verilator/verilator) for installation instructions.

1. Clone this repository:

   ```bash
   git clone https://github.com/shsjung/simple-burst-interface.git
   ```

2. Navigate to the `simple-burst-interface` directory and run the following command:

   ```bash
   make
   ```

## License

This project is distributed under the MIT License. See the [LICENSE](./LICENSE) file for details.

## Contributions

Contributions are welcome! Please open an issue or submit a Pull Request if you'd like to contribute to this project.
