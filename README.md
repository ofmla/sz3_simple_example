# Fortran Bindings for SZ3 Compression Library

## Overview

This repository provides Fortran bindings for the [SZ3 lossy compression library](https://github.com/szcompressor/SZ3), 
allowing seamless integration of SZ3 compression capabilities into Fortran projects. The repository includes a test driver to check the correctness and functionality of the Fortran bindings.

## Prerequisites

Before using the SZ3 Fortran bindings, make sure you have the SZ3 library installed on your system. You can follow the [instructions](https://github.com/szcompressor/SZ3?tab=readme-ov-file#installation) from the SZ3 repository.

## Testing

To build the test driver that makes use of the SZ3 Fortran bindings, follow these steps:

1. Clone this repository: `git clone https://github.com/ofmla/sz3_simple_example.git)`
2. Navigate to the repository directory: `cd sz3_simple_example`
3. Modify the Makefile to include the paths to the SZ3 installed library:
  - Open the Makefile in a text editor.
  - Locate the variables `C_INCLUDE`, `LIBS`, and `RPATH`.
  - Set `C_INCLUDE` to the directory containing the SZ3 header files (e.g., `-I/path/to/external/SZ3library/include`).
  - Set `LIBS` to link against the SZ3 library (e.g., `-L/path/to/external/SZ3library/lib -lSZ3c`).
  - Set `RPATH` to specify the runtime library search path (e.g., `-Wl,-rpath=/path/to/external/SZ3library/lib`).
4. Build the bindings and the test driver using the modified Makefile: `make`

After building the project, you can run the provided test driver to ensure that the Fortran bindings work properly. **Please 
note that the test driver requires [sample data](https://github.com/NCAR/SPERR/blob/main/test_data/density_128x128x256.d64)**. Download the sample data 
file and place it in the same directory as the test driver executable. Then, execute the following command to run the test driver:

```
./test_fsz3
```

## License

This project is licensed under the BSD License - see the [LICENSE](https://github.com/ofmla/sz3_simple_example/blob/main/LICENSE) file for details.

## Contributing

Contributions are welcome! If you encounter any issues or have suggestions for improvements, please feel free to open an issue or submit a pull request.
