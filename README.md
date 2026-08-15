# Zerqavon Miner 1.0.3 for HiveOS

This package is a HiveOS custom miner for CPU mining with ZQVXPOW v1 and RandomX. The included x86-64 miner is statically linked to avoid dependencies on the Linux distribution's glibc or libstdc++ versions.

## Flight Sheet

Choose **Add Miner > Custom** and enter:

- Miner name: `zerqavon-miner`
- Installation URL: `https://github.com/zerqavon/hiveos/releases/download/v1.0.3/zerqavon-miner-1.0.3.tar.gz`
- Hash algorithm: `zqvxpow`
- Wallet and worker template: your pool wallet or username, optionally with its supported worker suffix
- Pool URL: `POOL_HOST:PORT`
- Pass: `x`
- Extra config arguments: `-t 4`

Optional extra arguments include `--light` for low-memory testing and `--fee N` for a fee percentage from 1 to 100. Full-memory RandomX is the default and is recommended for normal mining.

The console reports `Fee mining : 1%`. The compiled fee destination remains documented in the project source and main README.

## Package contents

- `zerqavon-miner`: static Linux x86-64 binary
- `h-manifest.conf`: HiveOS package metadata
- `h-config.sh`: Flight Sheet configuration generator
- `h-run.sh`: miner launcher and log integration
- `h-stats.sh`: HiveOS hashrate/share statistics parser

The package follows the custom-miner layout documented by the official HiveOS Linux repository.
