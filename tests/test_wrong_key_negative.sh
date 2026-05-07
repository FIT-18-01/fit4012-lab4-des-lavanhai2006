#!/usr/bin/env bash
set -euo pipefail

g++ -std=c++17 -Wall -Wextra -pedantic des.cpp -o des_test

PLAINTEXT="1111000011110000000011110000111101010101010101010011001100110011"
KEY_CORRECT="0001001100110100010101110111100110011011101111001101111111110001"
KEY_WRONG="1111001100110100010101110111100110011011101111001101111111110001"

CIPHER=$(printf "1\n%s\n%s\n" "$PLAINTEXT" "$KEY_CORRECT" | ./des_test | tail -n 1)
DECRYPTED_WRONG=$(printf "2\n%s\n%s\n" "$CIPHER" "$KEY_WRONG" | ./des_test | tail -n 1)

if [[ "$DECRYPTED_WRONG" == "$PLAINTEXT" ]]; then
  echo "[FAIL] Wrong key unexpectedly recovered plaintext"
  exit 1
fi

echo "[PASS] Wrong-key negative test succeeded."
rm -f des_test
