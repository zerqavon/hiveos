#!/usr/bin/env bash

miner_ver() {
    echo "1.0.6"
}

miner_config_echo() {
    local config="${CUSTOM_CONFIG_FILENAME:-/hive/miners/custom/zerqavon-miner/zerqavon.conf}"
    if [[ -f "$config" ]]; then
        sed -E 's/^(POOL_PASSWORD=).*/\1********/' "$config"
    else
        echo "Zerqavon configuration has not been generated yet"
    fi
}

miner_config_gen() {
    local config="${CUSTOM_CONFIG_FILENAME:-/hive/miners/custom/zerqavon-miner/zerqavon.conf}"
    local pool="${CUSTOM_URL%%$'\n'*}"
    pool="${pool%% *}"
    local wallet="${CUSTOM_TEMPLATE:-${CUSTOM_WALLET:-}}"
    local password="${CUSTOM_PASS:-x}"
    local extra="${CUSTOM_USER_CONFIG//$'\n'/ }"

    pool="${pool#stratum+tcp://}"
    pool="${pool#stratum://}"
    pool="${pool#tcp://}"

    [[ -z "$pool" ]] && echo "Zerqavon: Pool URL is required" >&2 && return 1
    [[ -z "$wallet" ]] && echo "Zerqavon: Wallet and worker template is required" >&2 && return 1

    mkdir -p "$(dirname "$config")"
    {
        printf 'POOL_URL=%q\n' "$pool"
        printf 'POOL_USER=%q\n' "$wallet"
        printf 'POOL_PASSWORD=%q\n' "$password"
        printf 'EXTRA_ARGS=%q\n' "$extra"
    } > "$config"
}

# The legacy HiveOS custom launcher only sources h-config.sh; unlike the newer
# generic launcher, it does not invoke miner_config_gen afterwards. Generate
# the file while sourcing when a complete Flight Sheet is available. Calling
# the function a second time on newer HiveOS releases is safe and idempotent.
if [[ -n "${CUSTOM_URL:-}" && -n "${CUSTOM_TEMPLATE:-${CUSTOM_WALLET:-}}" ]]; then
    miner_config_gen
fi
