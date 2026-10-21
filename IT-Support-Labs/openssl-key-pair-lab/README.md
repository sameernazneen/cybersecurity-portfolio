# OpenSSL Lab: RSA Key Pair, Encrypt/Decrypt, Sign/Verify

Hands-on lab (Google Cybersecurity Professional Certificate) covering the basics of public-key cryptography with OpenSSL.

## What I did
1. **Generated a 2048-bit RSA private key** (`openssl genrsa`)
2. **Derived the matching public key** (`openssl rsa -pubout`)
3. **Encrypted** a message with the public key and **decrypted** it with the private key (confidentiality)
4. **Signed** a SHA-256 digest of the message with the private key and **verified** it with the public key (integrity and authenticity)

## Commands
| Step | Command |
|------|---------|
| Private key | `openssl genrsa -out private_key.pem 2048` |
| Public key | `openssl rsa -in private_key.pem -outform PEM -pubout -out public_key.pem` |
| Create message | `echo 'This is a secret message, for authorized parties only' > secret.txt` |
| Encrypt | `openssl rsautl -encrypt -pubin -inkey public_key.pem -in secret.txt -out secret.enc` |
| Decrypt | `openssl rsautl -decrypt -inkey private_key.pem -in secret.enc` |
| Sign | `openssl dgst -sha256 -sign private_key.pem -out secret.txt.sha256 secret.txt` |
| Verify | `openssl dgst -sha256 -verify public_key.pem -signature secret.txt.sha256 secret.txt` |

Result: decryption returned the original message, and verification printed `Verified OK`.

## Key takeaways
- Public key encrypts, private key decrypts. Anyone can send me a secret, only I can read it.
- Private key signs, public key verifies. Any change to the file makes verification fail.
- The private key must never be shared or committed to a repository, which is why it is **not** included in this folder.
- `rsautl` is deprecated in OpenSSL 3.x; `pkeyutl` is the modern replacement.

## Files in `evidence/`
`public_key.pem`, `secret.txt`, `secret.enc` (ciphertext), `secret.txt.sha256` (signature)
