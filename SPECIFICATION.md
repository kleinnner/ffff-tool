# Fully Flexible File Format (.FFFF) Specification v1.0.0

## Abstract

The Fully Flexible File Format (.FFFF) is a data-agnostic, versioned container file format designed for bundling multiple, arbitrary files into a single, portable archive. Its primary purpose is to provide a reliable and verifiable method for storing and transferring complex digital assets, such as 3D scenes, AI models, datasets, and application project files. The format prioritizes data integrity through SHA-256 checksums and extensibility through a versioned, JSON-based manifest.

---

## Media Type and File Extension

- Proposed MIME Type Name: `application/vnd.0-1gg.ffff`
- File Extension: `.ffff`

---

## Specification Details

An `.FFFF` file is composed of three sequential parts:

### 1. Preamble (8 bytes)

- Format: A 64-bit unsigned integer, stored in little-endian byte order.
- Purpose: Specifies the exact length (in bytes) of the JSON Header Manifest that immediately follows. This allows a parser to read the complete header without ambiguity.

### 2. Header / Manifest (N bytes)

- Format: A UTF-8 encoded JSON string. Length is defined by the value in the Preamble.
- Purpose: Acts as the table of contents for the archive.

#### JSON Structure

```json
{
  "formatVersion": "1.0.0",
  "files": [
    {
      "name": "model.glb",
      "mimeType": "model/gltf-binary",
      "offset": 0,
      "size": 123456,
      "hash": "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855"
    }
  ]
}
```

#### Header Fields

- `formatVersion` (String): Version of the FFFF spec used.
- `files` (Array): Metadata for each file:
  - `name`: Original filename.
  - `mimeType`: Standard MIME type.
  - `offset`: Byte position within the Data Blobs section.
  - `size`: Size in bytes.
  - `hash`: SHA-256 checksum (64-character hexadecimal string).

### 3. Data Blobs

- Format: Contiguous block of raw binary data.
- Purpose: Contains the actual data of all archived files, concatenated in the same order as listed in the Header. No padding or delimiters.

---

## Security Considerations

The .FFFF format is a container and does not contain any executable code itself. However, it can contain files of any type, including potentially malicious scripts or executables.

- Integrity: The mandatory SHA-256 hash for each contained file allows an unpacking application to verify that the file data has not been altered or corrupted since it was packed.
- Content Handling: A consuming application should treat the extracted files with the same security precautions as it would any file downloaded from the internet. For example, it should not automatically execute a file just because it was extracted from a trusted .ffff archive.

---

## Published Specification

This specification is publicly available at:

- https://github.com/kleinnner/ffff-tool/blob/main/README.md
- https://github.com/kleinnner/ffff-tool/blob/main/SPECIFICATION.md

---

## Contact Information

Authors: 0-1.gg, Lois-Kleinner
