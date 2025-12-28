#!/usr/bin/env python3

import sys

def read_binary_file(filename):
    """Read binary file and return bytes"""
    try:
        with open(filename, 'rb') as f:
            return f.read()
    except FileNotFoundError:
        print(f"Error: File '{filename}' not found")
        sys.exit(1)

def bytes_to_words(data):
    """Convert byte array to 64-bit words (little-endian)"""
    words = []
    
    # Pad to 8-byte boundary
    padding = (8 - len(data) % 8) % 8
    data = data + b'\x00' * padding
    
    # Convert to 64-bit words
    for i in range(0, len(data), 8):
        word = int.from_bytes(data[i:i+8], byteorder='little')
        words.append(word)
    
    return words

def generate_case_rom(words):
    """Generate clocked case statement ROM with 64-bit data"""
    
    num_words = len(words)
    
    # Calculate address width (round up to power of 2)
    addr_width = max(1, (num_words - 1).bit_length())
    total_entries = 2 ** addr_width
    
    print("always_ff @(posedge clock) begin")
    print("  case (raddr)")
    
    # Write all entries (pad with zeros if needed)
    for i in range(total_entries):
        addr_binary = format(i, f'0{addr_width}b')
        
        if i < num_words:
            word = words[i]
        else:
            word = 0  # Zero padding
        
        print(f"    {addr_width}'b{addr_binary}: rdata <= 64'h{word:016X};")
    
    print("  endcase")
    print("end")

def main():

    filename = '../bin/rom.bin'
    
    binary_data = read_binary_file(filename)
    
    words = bytes_to_words(binary_data)
    
    generate_case_rom(words)

if __name__ == '__main__':
    main()