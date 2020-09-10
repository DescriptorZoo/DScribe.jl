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

If you use this code and hence dependent code [DScribe](https://github.com/SINGROUP/dscribe), you need to accept the license of [DScribe](https://github.com/SINGROUP/dscribe) and cite both the code and the reference papers as they are described in code's [webpage](https://singroup.github.io/dscribe/latest/citing.html).

This includes the following citation:

```
@article{dscribe,
  author = {Himanen, Lauri and J{\"a}ger, Marc O.~J. and Morooka, Eiaki V. and Federici Canova, Filippo and Ranawat, Yashasvi S. and Gao, David Z. and Rinke, Patrick and Foster, Adam S.},
  title = {{DScribe: Library of descriptors for machine learning in materials science}},
  journal = {Computer Physics Communications},
  volume = {247},
  pages = {106949},
  year = {2020},
  doi = {10.1016/j.cpc.2019.106949},
  url = {https://doi.org/10.1016/j.cpc.2019.106949},
  issn = {0010-4655}
}
```
