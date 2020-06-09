# TODO: Need to get value from OCCA?
set(USE_OCCA_MEM_BYTE_ALIGN 64)

# ---------------------------------------------------------
# libparanumal
# ---------------------------------------------------------

set(LIBP_DIR 3rd_party/libparanumal)

set(LIBP_SOURCES
        ${LIBP_DIR}/src/meshConnectPeriodicFaceNodes3D.c
        ${LIBP_DIR}/src/meshConnectPeriodicFaceNodes2D.c
        ${LIBP_DIR}/src/meshSetupBoxHex3D.c
        ${LIBP_DIR}/src/meshSetupBoxQuad2D.c
        ${LIBP_DIR}/src/meshApplyElementMatrix.c
        ${LIBP_DIR}/src/meshConnect.c
        ${LIBP_DIR}/src/meshConnectFaceNodes2D.c
        ${LIBP_DIR}/src/meshConnectFaceNodes3D.c
        ${LIBP_DIR}/src/meshGeometricFactorsTet3D.c
        ${LIBP_DIR}/src/meshGeometricFactorsHex3D.c
        ${LIBP_DIR}/src/meshGeometricFactorsTri2D.c
        ${LIBP_DIR}/src/meshGeometricFactorsTri3D.c
        ${LIBP_DIR}/src/meshGeometricFactorsQuad2D.c
        ${LIBP_DIR}/src/meshGeometricFactorsQuad3D.c
        ${LIBP_DIR}/src/meshGeometricPartition2D.c
        ${LIBP_DIR}/src/meshGeometricPartition3D.c
        ${LIBP_DIR}/src/meshPartitionStatistics.c
        ${LIBP_DIR}/src/meshHaloExchange.c
        ${LIBP_DIR}/src/meshHaloExtract.c
        ${LIBP_DIR}/src/meshHaloSetup.c
        ${LIBP_DIR}/src/meshLoadReferenceNodesTri2D.c
        ${LIBP_DIR}/src/meshLoadReferenceNodesQuad2D.c
        ${LIBP_DIR}/src/meshLoadReferenceNodesTet3D.c
        ${LIBP_DIR}/src/meshOccaSetup2D.c
        ${LIBP_DIR}/src/meshOccaSetup3D.c
        ${LIBP_DIR}/src/meshOccaSetupQuad3D.c
        ${LIBP_DIR}/src/meshParallelConnectNodes.c
        ${LIBP_DIR}/src/meshParallelConnectOpt.c
        ${LIBP_DIR}/src/meshParallelConsecutiveGlobalNumbering.c
        ${LIBP_DIR}/src/meshParallelGatherScatterSetup.c
        ${LIBP_DIR}/src/meshParallelReaderTri2D.c
        ${LIBP_DIR}/src/meshParallelReaderHex3D.c
        ${LIBP_DIR}/src/meshParallelReaderTri3D.c
        ${LIBP_DIR}/src/meshParallelReaderQuad2D.c
        ${LIBP_DIR}/src/meshParallelReaderQuad3D.c
        ${LIBP_DIR}/src/meshParallelReaderTet3D.c
        ${LIBP_DIR}/src/meshPhysicalNodesTri2D.c
        ${LIBP_DIR}/src/meshPhysicalNodesTri3D.c
        ${LIBP_DIR}/src/meshPhysicalNodesQuad2D.c
        ${LIBP_DIR}/src/meshPhysicalNodesQuad3D.c
        ${LIBP_DIR}/src/meshPhysicalNodesTet3D.c
        ${LIBP_DIR}/src/meshPlotVTU2D.c
        ${LIBP_DIR}/src/meshPlotVTU3D.c
        ${LIBP_DIR}/src/meshPrint2D.c
        ${LIBP_DIR}/src/meshPrint3D.c
        ${LIBP_DIR}/src/meshSetup.c
        ${LIBP_DIR}/src/meshSetupTri2D.c
        ${LIBP_DIR}/src/meshSetupTri3D.c
        ${LIBP_DIR}/src/meshSetupQuad2D.c
        ${LIBP_DIR}/src/meshSetupQuad3D.c
        ${LIBP_DIR}/src/meshSetupHex3D.c
        ${LIBP_DIR}/src/meshSetupTet3D.c
        ${LIBP_DIR}/src/meshSurfaceGeometricFactorsTri2D.c
        ${LIBP_DIR}/src/meshSurfaceGeometricFactorsTri3D.c
        ${LIBP_DIR}/src/meshSurfaceGeometricFactorsQuad2D.c
        ${LIBP_DIR}/src/meshSurfaceGeometricFactorsQuad3D.c
        ${LIBP_DIR}/src/meshSurfaceGeometricFactorsTet3D.c
        ${LIBP_DIR}/src/meshSurfaceGeometricFactorsHex3D.c
        ${LIBP_DIR}/src/meshLoadReferenceNodesHex3D.c
        ${LIBP_DIR}/src/meshConnectBoundary.c
        ${LIBP_DIR}/src/meshVTU2D.c
        ${LIBP_DIR}/src/meshVTU3D.c
        ${LIBP_DIR}/src/matrixInverse.c
        ${LIBP_DIR}/src/matrixConditionNumber.c
        ${LIBP_DIR}/src/mysort.c
        ${LIBP_DIR}/src/parallelSort.c
        ${LIBP_DIR}/src/hash.c
        ${LIBP_DIR}/src/setupAide.c
        ${LIBP_DIR}/src/readArray.c
        ${LIBP_DIR}/src/occaHostMallocPinned.c
        ${LIBP_DIR}/src/timer.c)

add_library(libparanumal ${LIBP_SOURCES})
set_target_properties(libparanumal PROPERTIES OUTPUT_NAME paranumal)
target_compile_options(libparanumal PRIVATE -x c++)
target_link_options(libparanumal PRIVATE -x c++)
# TODO:  In updated OCCA CMakeLists, occa/include is  publicly available
# when linking to libocca.  Hence, we can remove it from
# target_include_directories when OCCA is updated.
target_include_directories(libparanumal PUBLIC
        3rd_party/occa/include
        ${CMAKE_BINARY_DIR}/3rd_party/occa
        src/core/
        ${LIBP_DIR}/libs/gatherScatter
        ${LIBP_DIR}/libs/gatherScatter/include
        ${LIBP_DIR}/include)
target_link_libraries(libparanumal PUBLIC libgs libocca blasLapack)
target_compile_definitions(libparanumal PUBLIC
        -DDHOLMES="${LIBP_DIR}"
        )

# ---------------------------------------------------------
# libparAlmond
# ---------------------------------------------------------

set(LIB_PARALMOND_DIR ${LIBP_DIR}/libs/parAlmond)

set(LIB_PARALMOND_SOURCES
        ${LIB_PARALMOND_DIR}/src/agmgLevel.cpp
        ${LIB_PARALMOND_DIR}/src/agmgSmoother.cpp
        ${LIB_PARALMOND_DIR}/src/coarseSolver.cpp
        ${LIB_PARALMOND_DIR}/src/kernels.cpp
        ${LIB_PARALMOND_DIR}/src/level.cpp
        ${LIB_PARALMOND_DIR}/src/matrix.cpp
        ${LIB_PARALMOND_DIR}/src/multigrid.cpp
        ${LIB_PARALMOND_DIR}/src/parAlmond.cpp
        ${LIB_PARALMOND_DIR}/src/pcg.cpp
        ${LIB_PARALMOND_DIR}/src/pgmres.cpp
        ${LIB_PARALMOND_DIR}/src/solver.cpp
        ${LIB_PARALMOND_DIR}/src/SpMV.cpp
        ${LIB_PARALMOND_DIR}/src/utils.cpp
        ${LIB_PARALMOND_DIR}/src/vector.cpp
        ${LIB_PARALMOND_DIR}/src/agmgSetup/agmgSetup.cpp
        ${LIB_PARALMOND_DIR}/src/agmgSetup/constructProlongation.cpp
        ${LIB_PARALMOND_DIR}/src/agmgSetup/formAggregates.cpp
        ${LIB_PARALMOND_DIR}/src/agmgSetup/galerkinProd.cpp
        ${LIB_PARALMOND_DIR}/src/agmgSetup/strongGraph.cpp
        ${LIB_PARALMOND_DIR}/src/agmgSetup/transpose.cpp
        )

add_library(libparAlmond ${LIB_PARALMOND_SOURCES})
set_target_properties(libparAlmond PROPERTIES OUTPUT_NAME parAlmond)
# TODO:  In updated OCCA CMakeLists, occa/include is  publicly available
# when linking to libocca.  Hence, we can remove it from
# target_include_directories when OCCA is updated.
target_include_directories(libparAlmond PUBLIC
        3rd_party/occa/include
        ${CMAKE_BINARY_DIR}/3rd_party/occa
        ${LIBP_DIR}/include
        ${LIBP_DIR}/libs/gatherScatter
        ${LIBP_DIR}/libs/gatherScatter/include
        ${LIB_PARALMOND_DIR}/include
        ${LIB_PARALMOND_DIR}
        ${LIB_PARALMOND_DIR}/hypre
        )
target_compile_options(libparAlmond PRIVATE -x c++)
target_link_options(libparAlmond PRIVATE -x c++)
target_compile_definitions(libparAlmond PUBLIC -DDPARALMOND="${LIB_PARALMOND_DIR}")
target_link_libraries(libparAlmond PUBLIC libocca libgs HYPRE)

# ---------------------------------------------------------
# libelliptic
# ---------------------------------------------------------

set(LIB_ELLIPTIC_DIR ${LIBP_DIR}/solvers/elliptic)

set(LIB_ELLIPTIC_SOURCES
        ${LIB_ELLIPTIC_DIR}/src/ellipticThinOas.c
        ${LIB_ELLIPTIC_DIR}/src/ellipticThinOasSetup.c
        ${LIB_ELLIPTIC_DIR}/src/ellipticZeroMean.c
        ${LIB_ELLIPTIC_DIR}/src/NBFPCG.c
        ${LIB_ELLIPTIC_DIR}/src/ellipticUpdateNBFPCG.c
        ${LIB_ELLIPTIC_DIR}/src/NBPCG.c
        ${LIB_ELLIPTIC_DIR}/src/ellipticUpdateNBPCG.c
        ${LIB_ELLIPTIC_DIR}/src/ellipticKernelInfo.c
        ${LIB_ELLIPTIC_DIR}/src/PCG.c
        ${LIB_ELLIPTIC_DIR}/src/ellipticPlotVTUHex3D.c
        ${LIB_ELLIPTIC_DIR}/src/ellipticBuildContinuous.c
        ${LIB_ELLIPTIC_DIR}/src/ellipticBuildContinuousGalerkin.c
        ${LIB_ELLIPTIC_DIR}/src/ellipticBuildIpdg.c
        ${LIB_ELLIPTIC_DIR}/src/ellipticBuildJacobi.c
        ${LIB_ELLIPTIC_DIR}/src/ellipticBuildLocalPatches.c
        ${LIB_ELLIPTIC_DIR}/src/ellipticBuildMultigridLevel.c
        ${LIB_ELLIPTIC_DIR}/src/ellipticHaloExchange.c
        ${LIB_ELLIPTIC_DIR}/src/ellipticOperator.c
        ${LIB_ELLIPTIC_DIR}/src/ellipticPreconditioner.c
        ${LIB_ELLIPTIC_DIR}/src/ellipticPreconditionerSetup.c
        ${LIB_ELLIPTIC_DIR}/src/ellipticSolve.c
        ${LIB_ELLIPTIC_DIR}/src/ellipticSolveSetup.c
        ${LIB_ELLIPTIC_DIR}/src/ellipticScaledAdd.c
        ${LIB_ELLIPTIC_DIR}/src/ellipticSetScalar.c
        ${LIB_ELLIPTIC_DIR}/src/ellipticUpdatePCG.c
        ${LIB_ELLIPTIC_DIR}/src/ellipticWeightedInnerProduct.c
        ${LIB_ELLIPTIC_DIR}/src/ellipticWeightedNorm2.c
        ${LIB_ELLIPTIC_DIR}/src/ellipticVectors.c
        ${LIB_ELLIPTIC_DIR}/src/ellipticSEMFEMSetup.c
        ${LIB_ELLIPTIC_DIR}/src/ellipticMultiGridSetup.c
        ${LIB_ELLIPTIC_DIR}/src/ellipticMultiGridLevel.c
        ${LIB_ELLIPTIC_DIR}/src/ellipticMultiGridLevelSetup.c
        ${LIB_ELLIPTIC_DIR}/src/ellipticMixedCopy.c
        )

add_library(libelliptic ${LIB_ELLIPTIC_SOURCES})
set_target_properties(libelliptic PROPERTIES OUTPUT_NAME elliptic)
target_compile_options(libelliptic PRIVATE -x c++)
target_link_options(libelliptic PRIVATE -x c++)
# TODO:  In updated OCCA CMakeLists, occa/include is  publicly available
# when linking to libocca.  Hence, we can remove it from
# target_include_directories when OCCA is updated.
target_include_directories(libelliptic PUBLIC
        3rd_party/occa/include
        ${CMAKE_BINARY_DIR}/3rd_party/occa
        ${LIBP_DIR}/include
        ${LIBP_DIR}/libs/gatherScatter
        ${LIBP_DIR}/libs/gatherScatter/include
        ${LIB_PARALMOND_DIR}                # TODO: Why not included with libParalmond
        ${LIB_ELLIPTIC_DIR})
target_link_libraries(libelliptic PUBLIC libocca libparAlmond libgs blasLapack)
target_compile_definitions(libelliptic PUBLIC
        -DUSE_OCCA_MEM_BYTE_ALIGN=${USE_OCCA_MEM_BYTE_ALIGN}
        -DDELLIPTIC="${LIB_ELLIPTIC_DIR}"
        -DDHOLMES="${LIBP_DIR}"
        )



