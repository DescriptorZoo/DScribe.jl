![CI](https://github.com/DescriptorZoo/DScribe.jl/workflows/CI/badge.svg)

# DScribe.jl
Julia wrapper for DScribe Python Package

This package includes a simple code that demonstrates how to access DScribe descriptors using PyCall and DScribe Python package. 

## Dependencies:

- [DScribe](https://github.com/SINGROUP/dscribe)
- [JuLIP.jl](https://github.com/JuliaMolSim/JuLIP.jl)
- [PyCall.jl](https://github.com/JuliaPy/PyCall.jl)
- [ASE.jl](https://github.com/JuliaMolSim/ASE.jl)

## Installation:

First, install DScribe following the code's [installation document](https://singroup.github.io/dscribe/latest/install.html) at [https://singroup.github.io/dscribe/](https://singroup.github.io/dscribe/) of [DScribe](https://github.com/SINGROUP/dscribe)

Once you have installed the Python package that is used by your Julia installation, you can simply add this package to your Julia environment with the following command in Julia package manager and test whether the code producesdescriptors for test system of Si:
```
] add https://github.com/DescriptorZoo/DScribe.jl.git
] test DScribe
```

## How to cite:

If you use this code, we would appreciate if you cite the following paper:
- Berk Onat, Christoph Ortner, James R. Kermode, 	[arXiv:2006.01915 (2020)](https://arxiv.org/abs/2006.01915)

and since the code has dependency to [DScribe](https://github.com/SINGROUP/dscribe), you need to accept the license of [DScribe](https://github.com/SINGROUP/dscribe) and cite both the code and the reference papers as they are described in code's [webpage](https://singroup.github.io/dscribe/latest/citing.html).
- Lauri Himanen et al., ["DScribe: Library of descriptors for machine learning in materials science", Computer Physics Communications, 247 (2020), 106949](https://doi.org/10.1016/j.cpc.2019.106949)
