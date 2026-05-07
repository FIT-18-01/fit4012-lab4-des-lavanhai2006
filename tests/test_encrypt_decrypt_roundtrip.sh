#!/usr/bin/env bash
set -euo pipefail

g++ -std=c++17 -Wall -Wextra -pedantic des.cpp -o des_test

PLAINTEXT="1100101011110000101010101111000011110000111100001010101011001100"
KEY="1010101010111011000010010001100000100111001101101100110011011101"

CIPHER=$(printf "1\n%s\n%s\n" "$PLAINTEXT" "$KEY" | ./des_test | tail -n 1)
DECRYPTED=$(printf "2\n%s\n%s\n" "$CIPHER" "$KEY" | ./des_test | tail -n 1)

if [[ "$DECRYPTED" != "$PLAINTEXT" ]]; then
  echo "[FAIL] Roundtrip DES failed"
  echo "Plaintext: $PLAINTEXT"
  echo "Cipher:    $CIPHER"
  echo "Decoded:   $DECRYPTED"
  exit 1
fi

echo "[PASS] DES encrypt/decrypt roundtrip succeeded."
rm -f des_test
