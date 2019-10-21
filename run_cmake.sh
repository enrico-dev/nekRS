source "$(dirname $0)/nekrs_defs.sh"

mkdir -p "$NEKRS_INSTALL_DIR" 
cmake -DNEK5000_PPLIST="PARRSB DPROCMAP" -DCMAKE_INSTALL_PREFIX="${NEKRS_INSTALL_DIR}" .. 2>&1 | tee config.log
