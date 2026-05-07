#!/usr/bin/env bash
set -euo pipefail

g++ -std=c++17 -Wall -Wextra -pedantic des.cpp -o des_test

PLAINTEXT="0011001100110011001100110011001100001111000011110000111100001111"
KEY="1010101010111011000010010001100000100111001101101100110011011101"

CIPHER=$(printf "1\n%s\n%s\n" "$PLAINTEXT" "$KEY" | ./des_test | tail -n 1)

# Flip first bit
FIRST=${CIPHER:0:1}
if [[ "$FIRST" == "0" ]]; then
  FLIPPED="1"
else
  FLIPPED="0"
fi
TAMPERED="$FLIPPED${CIPHER:1}"

DECRYPTED_TAMPERED=$(printf "2\n%s\n%s\n" "$TAMPERED" "$KEY" | ./des_test | tail -n 1)

if [[ "$DECRYPTED_TAMPERED" == "$PLAINTEXT" ]]; then
  echo "[FAIL] Tampered ciphertext still decrypts to original plaintext"
  exit 1
fi

echo "[PASS] Tamper negative test succeeded (tampered ciphertext != original after decrypt)."
rm -f des_test
