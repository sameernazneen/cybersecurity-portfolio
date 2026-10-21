#!/usr/bin/env bash
# Hashing lab: md5sum and shasum (Qwiklabs / Google Cybersecurity Certificate)
# Run in a disposable lab shell or any Linux terminal.

# --- MD5 ---
echo 'This is some text in a file, just so we have some data' > file.txt
md5sum file.txt > file.txt.md5          # compute and save hash
cat file.txt.md5                        # inspect
md5sum -c file.txt.md5                  # verify -> file.txt: OK

# --- Tamper test ---
cp file.txt badfile.txt
md5sum badfile.txt > badfile.txt.md5
cat badfile.txt.md5                     # same hash as file.txt (only data is hashed, not the name)
cat file.txt.md5

# Add ONE space at the end of the line (nano badfile.txt, Ctrl+X, Y, Enter)
nano badfile.txt

md5sum -c badfile.txt.md5               # -> badfile.txt: FAILED
md5sum badfile.txt > new.badfile.txt.md5
cat new.badfile.txt.md5                 # completely different hash

# --- SHA-1 (shasum default) ---
shasum file.txt > file.txt.sha1
cat file.txt.sha1
shasum -c file.txt.sha1                 # -> file.txt: OK

# --- SHA-256 ---
shasum -a 256 file.txt > file.txt.sha256
cat file.txt.sha256
shasum -c file.txt.sha256               # -> file.txt: OK
