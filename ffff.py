import argparse
import sys
import os
import tempfile
from src.packer import pack_files
from src.unpacker import read_manifest, unpack_files

def handle_open_file(archive_path):
    """Logic for when a user double-clicks a .ffff file."""
    print(f"--- Contents of {os.path.basename(archive_path)} ---")
    manifest = read_manifest(archive_path)
    
    if not manifest['files']:
        print("This archive is empty.")
        return

    for i, file_info in enumerate(manifest['files']):
        print(f"  [{i + 1}] {file_info['name']} ({file_info['size']} bytes)")

    try:
        choice = int(input("\nEnter the number of the file to open (or 0 to cancel): "))
        if choice == 0 or choice > len(manifest['files']):
            print("Operation cancelled.")
            return
        
        selected_file = manifest['files'][choice - 1]
        
        # Extract the single file to a temporary directory
        with tempfile.TemporaryDirectory() as temp_dir:
            print(f"Extracting '{selected_file['name']}' to a temporary location...")
            
            with open(archive_path, "rb") as f:
                header_bytes = str.encode(str(manifest)) # Simplified for size calculation
                data_start_offset = 8 + len(header_bytes)
                f.seek(data_start_offset + selected_file['offset'])
                file_data = f.read(selected_file['size'])
                
                temp_file_path = os.path.join(temp_dir, selected_file['name'])
                with open(temp_file_path, "wb") as temp_file:
                    temp_file.write(file_data)
                
                print(f"Launching '{selected_file['name']}' with default application...")
                os.startfile(temp_file_path) # This command opens the file with its default app

    except (ValueError, IndexError):
        print("Invalid selection.")
    except Exception as e:
        print(f"An error occurred: {e}")

def main():
    # If the script is run with a single argument that is a .ffff file
    if len(sys.argv) == 2 and sys.argv[1].lower().endswith('.ffff'):
        handle_open_file(sys.argv[1])
        input("\nPress Enter to exit.") # Wait for user
        return

    parser = argparse.ArgumentParser(
        prog="ffff",
        description="A tool to pack and unpack the Fully Flexible File Format (.ffff)."
    )
    # ... (rest of the parser setup is the same)
    subparsers = parser.add_subparsers(dest="command", help="Available commands")
    parser_pack = subparsers.add_parser("pack", help="Pack a list of files into a .ffff archive.")
    parser_pack.add_argument("output_file", help="The path for the output .ffff archive.")
    parser_pack.add_argument("input_files", nargs='+', help="One or more input files to pack.")
    parser_unpack = subparsers.add_parser("unpack", help="Unpack a .ffff archive into a directory.")
    parser_unpack.add_argument("archive_file", help="The .ffff archive to unpack.")
    parser_unpack.add_argument("-o", "--output", dest="output_dir", default=".", help="The directory to extract files to (default: current directory).")
    parser_list = subparsers.add_parser("list", help="List the contents of a .ffff archive.")
    parser_list.add_argument("archive_file", help="The .ffff archive to inspect.")

    # If run with no arguments, argparse shows help and exits. We need to catch that.
    if len(sys.argv) == 1:
        parser.print_help()
        input("\nPress Enter to exit.") # This keeps the window open
        return

    args = parser.parse_args()
    
    # ... (rest of the command execution is the same)
    if args.command == "pack":
        pack_files(file_paths=args.input_files, output_path=args.output_file)
    elif args.command == "unpack":
        unpack_files(archive_path=args.archive_file, output_dir=args.output_dir)
    elif args.command == "list":
        manifest = read_manifest(archive_path=args.archive_file)
        print("\n--- Archive Contents ---")
        for file_info in manifest['files']:
            size_kb = file_info['size'] / 1024
            print(f"  - Name: {file_info['name']} ({size_kb:.2f} KB)")
        print("------------------------")

if __name__ == "__main__":
    main()