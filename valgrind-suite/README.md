# Enhanced Valgrind Analysis Suite

A comprehensive script for running all Valgrind analysis tools on C programs in one command. Perfect for ZSO (Advanced Operating Systems) course projects and assignments.

## Overview

The Enhanced Valgrind Analysis Suite automates the process of running multiple Valgrind tools on your C programs, collects all results in one place, and provides a concise summary of findings. Instead of manually running each tool separately, this "shoot and forget" script lets you start the analysis and take a break while the comprehensive check runs.

## Features

- **All-in-one analysis**: Runs all major Valgrind tools in sequence
- **Organized output**: Saves all logs to a structured directory
- **Visual summaries**: Color-coded summaries of findings
- **Long-running friendly**: Start it and come back later to review results
- **Perfect for university assignments**: Designed with ZSO assignments in mind

## Tools Included

The suite runs these Valgrind tools:

| Tool | Purpose | What it finds |
|------|---------|--------------|
| **Memcheck** | Memory error detector | Memory leaks, use of uninitialized values, double-free errors |
| **Helgrind** | Thread error detector | Data races, deadlocks, misuse of pthread API |
| **DRD** | Thread synchronization detector | Different thread synchronization issues |
| **Callgrind** | Call profiler | Function call frequency and costs |
| **Cachegrind** | Cache profiler | Cache misses and branch prediction stats |
| **Massif** | Heap profiler | Memory usage over time, peak allocation |

## Usage

```bash
./valgrind-suite.sh -p ./your_program [OPTIONS]
```

### Options

- `-p, --program PATH`: Path to the program to analyze (required)
- `-a, --args "ARGS"`: Optional arguments to pass to the analyzed program (use quotes)
- `-h, --help`: Display help information

### Examples

```bash
# Basic usage
./valgrind-suite.sh -p ./my_zso_assignment

# With program arguments
./valgrind-suite.sh -p ./my_zso_assignment -a "input.txt 100 verbose"

# Saving output to a log file
./valgrind-suite.sh -p ./my_zso_assignment > valgrind_suite.log
```

The script's output can be easily redirected to a log file using the standard `>` redirection operator. This is useful when running the analysis on a remote server or when you want to preserve the summary for later review.

## Output

All results are saved to the `./valgrind_logs/` directory:

```
valgrind_logs/
├── memcheck.log      - Memory error findings
├── helgrind.log      - Thread error findings
├── drd.log           - Thread sync error findings
├── callgrind.log     - Call profile summary
├── callgrind.out     - Raw callgrind data
├── cachegrind.log    - Cache usage summary
├── cachegrind.out    - Raw cachegrind data
├── massif.log        - Memory usage profile
├── massif.out        - Raw massif data
└── massif_run.log    - Execution output
```

The script also displays a color-coded summary after completion, highlighting key findings from each tool.

## Advantages for ZSO Course

- **Time-saving**: Run all required analyses with one command
- **Consistent results**: Get standardized output for all tools
- **Grading-friendly**: Use the same analysis environment for all assignments
- **Focus on coding**: Spend less time on tool configuration and more time on actual development
- **Break-friendly**: Start the analysis before a break and review results afterward

## Requirements

- Valgrind (with all tools)
- Bash shell

## License

MIT-0 License - See license information in the script header.

## Author

Copyright (c) 2025 Arrow
