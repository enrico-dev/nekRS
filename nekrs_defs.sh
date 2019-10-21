export CXX="mpic++"
export CC="mpicc"
export FC="mpif77"
export CXXFLAGS="-O2 -g -DUSE_OCCA_MEM_BYTE_ALIGN=32"
export FFLAGS="$CXXFLAGS"
export CFLAGS="$CXXFLAGS"

# ========================================================================
# Compile Time?
# ========================================================================

export NEKRS_CXX="$CXX"
export NEKRS_CC="$CC"
export NEKRS_FC="$FC"
export NEKRS_CXXFLAGS="$CXXFLAGS"
export NEKRS_CFLAGS="$CFLAGS"
export NEKRS_FFLAGS="$FFLAGS"

export NEKRS_LIBP_DEFINES="-DUSE_NULL_PROJECTION=1"
export NEKRS_NEK5000_PPLIST="PARRSB DPROCMAP"
export NEKRS_INSTALL_DIR="$(pwd)/install"
export NEKRS_DIR="$(pwd)"

export NEKRS_UDF_DIR="${NEKRS_INSTALL_DIR}/udf"
export NEKRS_NEKINTERFACE_DIR="${NEKRS_INSTALL_DIR}/nekInterface"
export NEKRS_NEK5000_DIR="${NEKRS_INSTALL_DIR}/nek5000"
export NEKRS_LIBP_DIR="${NEKRS_INSTALL_DIR}/libparanumal"

export OCCA_CXX="$CXX"
export OCCA_CXXFLAGS="${NEKRS_CXXFLAGS} ${NEKRS_LIBP_DEFINES}"
export OCCA_DIR="${NEKRS_INSTALL_DIR}/occa"

# ========================================================================
# Runtime?
# ========================================================================
export OCCA_CUDA_ENABLED=1
export OCCA_HIP_ENABLED=0
export OCCA_OPENCL_ENABLED=0
export OCCA_METAL_ENABLED=0
