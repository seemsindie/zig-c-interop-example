# zig-c-interop-example

This project demonstrates how to build and run a C and Zig application that interoperate with each other.

## Prerequisites

- GCC (GNU Compiler Collection)
- Zig programming language

## Building the Project

To build the project, run the following command:

```sh
make
```

This will create the following binaries in the `bin/` directory:

- `c_app`
- `zig_app`

## Running the Project

To run the project, execute the following command:

```sh
make run-c
```

This will run the C application. To run the Zig application, execute the following command:

```sh
make run-zig
```

## Cleaning 

To clean the project, run the following command:

```sh
make clean
```

## Building with Zig build system

To build the project with the Zig build system, run the following command:

```sh
zig build run-c
```

```sh
zig build run-zig
```

## Summary

To the a summary of the build sizes, run:

```sh
make summary
```

## License

This project is released into the public domain. For more information, please refer to the `LICENSE` file.