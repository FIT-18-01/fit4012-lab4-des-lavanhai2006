#!/usr/bin/env bash
set -euo pipefail

g++ -std=c++17 -Wall -Wextra -pedantic des.cpp -o des_test

KEY="0001001100110100010101110111100110011011101111001101111111110001"
PLAINTEXT_70="0001001000110100010101100111100010011010101111001101111011110001010101"

# Build expected by encrypting block-wise with explicit zero padding
BLOCK1=${PLAINTEXT_70:0:64}
TAIL=${PLAINTEXT_70:64}
BLOCK2=$(printf "%-64s" "$TAIL" | tr ' ' '0')

C1=$(printf "1\n%s\n%s\n" "$BLOCK1" "$KEY" | ./des_test | tail -n 1)
C2=$(printf "1\n%s\n%s\n" "$BLOCK2" "$KEY" | ./des_test | tail -n 1)
EXPECTED="$C1$C2"

OUTPUT=$(printf "1\n%s\n%s\n" "$PLAINTEXT_70" "$KEY" | ./des_test | tail -n 1)

if [[ "$OUTPUT" != "$EXPECTED" ]]; then
  echo "[FAIL] Multi-block/padding output mismatch"
  echo "Expected: $EXPECTED"
  echo "Actual:   $OUTPUT"
  exit 1
fi

if [[ ${#OUTPUT} -ne 128 ]]; then
  echo "[FAIL] Expected 128-bit ciphertext for 70-bit input after padding"
  exit 1
fi

echo "[PASS] Multi-block split + zero padding behaved correctly."
rm -f des_test
