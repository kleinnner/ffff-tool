# Fully Flexible File Format (.FFFF) Tool

A command-line utility by **0-1.gg and Lois-Kleinner** for packing and unpacking the `.ffff` custom archive format.
https://doi.org/10.5281/zenodo.16969001
https://github.com/kleinnner/ffff-tool/blob/main/SPECIFICATION.md
https://github.com/kleinnner/ffff-tool/releases/tag/v1.0.0

The `.ffff` format is a data-agnostic container designed for maximum flexibility and data integrity. It can archive any type of file without modification.

---

## Features

* **Pack**: Bundle multiple files into a single `.ffff` archive.
* **Unpack**: Extract files from an archive, restoring them to their original state.
* **List**: Quickly inspect the contents of an archive without extracting it.
* **Integrity Check**: Uses SHA-256 hashing to verify that extracted files are not corrupted.

---

## File Format Specification (v1.0)

An `.ffff` file consists of three parts:

1.  **Preamble (8 bytes)**: A 64-bit unsigned little-endian integer specifying the exact length of the Header.
2.  **Header (N bytes)**: A UTF-8 encoded JSON string containing the file manifest (metadata for all archived files).
3.  **Data Blobs**: Raw, concatenated data of all the files.

---

## Installation & Usage

**Prerequisites:** Python 3.6+

1.  **Clone the repository (or download the files):**
    ```bash
    git clone <your-repository-url>
    cd ffff-tool
    ```

2.  **Install dependencies (if any):**
    *(Currently, this project uses only standard libraries, so no installation is needed.)*

### Commands

The tool is run using `python ffff.py` followed by a command.

**To Pack Files:**
```bash

python ffff.py pack <output_archive.ffff> <file1> <file2> ...
