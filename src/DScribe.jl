module DScribe

using ASE
using JuLIP
using PyCall

py_dscribe = pyimport("dscribe")
py_dsd = pyimport("dscribe.descriptors")

export dscribe_cm, dscribe_sm, dscribe_em
export dscribe_soap, dscribe_mbtr, dscribe_acsf, set_Behler2011

# This function is part of ACSF.jl package
function set_Behler2011()
    unit_BOHR = 0.52917721067
    cutoff = 6.5
    Gpack = [
        [   9.0,  100.0,  200.0,  350.0,  600.0, 1000.0, 2000.0, 4000.0], #G2_etas
        [   1.0,    1.0,    1.0,    1.0,   30.0,   30.0,   30.0,   30.0,  
           80.0,   80.0,   80.0,   80.0,  150.0,  150.0,  150.0,  150.0, 
          150.0,  150.0,  150.0,  150.0,  250.0,  250.0,  250.0,  250.0, 
          250.0,  250.0,  250.0,  250.0,  450.0,  450.0,  450.0,  450.0, 
          450.0,  450.0,  450.0,  450.0,  800.0,  800.0,  800.0,  800.0, 
          800.0,  800.0,  800.0], #G4_etas
        [  -1.0,    1.0,   -1.0,    1.0,   -1.0,    1.0,   -1.0,    1.0,  
           -1.0,    1.0,   -1.0,    1.0,   -1.0,    1.0,   -1.0,    1.0,  
           -1.0,    1.0,   -1.0,    1.0,   -1.0,    1.0,   -1.0,    1.0,  
           -1.0,    1.0,   -1.0,    1.0,   -1.0,    1.0,   -1.0,    1.0,  
           -1.0,    1.0,   -1.0,    1.0,   -1.0,    1.0,   -1.0,    1.0,
           -1.0,    1.0,    1.0], #G4_lambdas
        [   1.0,    1.0,    2.0,    2.0,    1.0,    1.0,    2.0,    2.0,
            1.0,    1.0,    2.0,    2.0,    1.0,    1.0,    2.0,    2.0,
            4.0,    4.0,   16.0,   16.0,    1.0,    1.0,    2.0,    2.0,   
            4.0,    4.0,   16.0,   16.0,    1.0,    1.0,    2.0,    2.0,
            4.0,    4.0,   16.0,   16.0,    1.0,    1.0,    2.0,    2.0,
            4.0,    4.0,   16.0] #G4_zetas
    ]
    Gpack[1] ./= 10000.0 * unit_BOHR^2
    Gpack[2] ./= 10000.0 * unit_BOHR^2
    return Dict("G2" => [cutoff,Gpack[1],[ 0.0 for i=1:length(Gpack[1])]],
                "G4" => [cutoff,Gpack[2],Gpack[3],Gpack[4]])
end

function dscribe_matdesc(at; mattyp="cm",
                         n_atoms_max=nothing,
                         permutation="sorted_l2", 
                         sigma=nothing, 
                         seed=nothing, 
                         flatten=true, 
                         sparse=false)
    """
        permutation = sorted_l2 (default), none, random, or eigenspectrum
    """
    if n_atoms_max == nothing
        n_atoms_max = length(at.Z)
    end
  
    #Setting Dscribe matrix descriptor
    if mattyp == "sm"
        mat_desc = py_dsd.SineMatrix(n_atoms_max=n_atoms_max,
                                     permutation=permutation, 
                                     sigma=sigma, 
                                     seed=seed, 
                                     flatten=flatten, 
                                     sparse=sparse)
    elseif matype == "em"
        mat_desc = py_dsd.EwaldSumMatrix(n_atoms_max=n_atoms_max,
                                         permutation=permutation, 
                                         sigma=sigma, 
                                         seed=seed, 
                                         flatten=flatten, 
                                         sparse=sparse)
    else
        mat_desc = py_dsd.CoulombMatrix(n_atoms_max=n_atoms_max,
                                        permutation=permutation, 
                                        sigma=sigma, 
                                        seed=seed, 
                                        flatten=flatten, 
                                        sparse=sparse)
    end

    # Calculate descriptor
    atom_struct = ASEAtoms(at)
    mat_rtn_desc = mat_desc.create(atom_struct.po)
    return mat_rtn_desc
end

dscribe_cm(at; kwargs...) = dscribe_matdesc(at; mattyp="cm", kwargs...)
dscribe_sm(at; kwargs...) = dscribe_matdesc(at; mattyp="sm", kwargs...)
dscribe_em(at; kwargs...) = dscribe_matdesc(at; mattyp="em", kwargs...)

function dscribe_acsf(at; cutoff=nothing, 
                          species=nothing, 
                          periodic=false, 
                          sparse=false,
                          g2_params="Behler2011",
                          g3_params=nothing,
                          g4_params="Behler2011",
                          g5_params=nothing)

all_unique_nums = unique(collect(at.Z))
all_unique_species = unique(chemical_symbols(at))

if species == nothing
 species = all_unique_species
end

if g2_params == "Behler2011" || g4_params == "Behler2011"
    G = set_Behler2011()
    if g2_params == "Behler2011" 
        g2_params = hcat(G["G2"][2], G["G2"][3])
        cutoff = maximum(G["G2"][1])
    end
    if g4_params == "Behler2011" 
        g4_params = hcat(G["G4"][2] ,G["G4"][4] ,G["G4"][3])
        cutoff = maximum(G["G4"][1])
    end
end

acsf_desc = py_dsd.ACSF(species=species,
                        rcut=cutoff,
                        g2_params=g2_params,
                        g3_params=g3_params,
                        g4_params=g4_params,
                        g5_params=g5_params,
                        periodic=periodic,
                        sparse=sparse)

# Calculate descriptor
atom_struct = ASEAtoms(at)
acsf_rtn_desc = acsf_desc.create(atom_struct.po)
return acsf_rtn_desc
end

dscribe_acsf(at, cutoff; kwargs...) = dscribe_acsf(at; cutoff=cutoff, kwargs...)

function dscribe_soap(at, cutoff; n_max=1, l_max=1, sigma=0.5, 
                      rbf="gto", species=nothing, 
                      periodic=true, crossover=true, 
                      average=false, sparse=false)

if species == nothing
    species = unique(collect(at.Z))
end

#Setting Dscribe SOAP Descriptor
soap_desc = py_dsd.SOAP(cutoff, n_max, l_max, 
                        sigma=sigma, rbf=rbf, 
                        species=species, 
                        periodic=periodic,
                        crossover=crossover, 
                        average=average, 
                        sparse=sparse)

# Calculate descriptor
atom_struct = ASEAtoms(at)
soap_rtn_desc = soap_desc.create(atom_struct.po)

return soap_rtn_desc
end

function dscribe_mbtr(at, periodic; species=nothing, 
                      k1=nothing, k2=nothing, k3=nothing, 
                      normalize_gaussians=true, 
                      normalization="none", 
                      flatten=true, sparse=false)

all_unique_nums = unique(collect(at.Z))
all_unique_species = unique(chemical_symbols(at))

if species == nothing
    species = all_unique_species
end

if k1 ==nothing && k2 == nothing && k3 == nothing
    k2 = Dict()
    k2["geometry"] = Dict()
    k2["geometry"]["function"] = "inverse_distance"
    k2["grid"] = Dict()
    k2["grid"]["min"] = 0.1
    k2["grid"]["max"] = 1.1
    k2["grid"]["n"] = 100
    k2["grid"]["sigma"] = 0.0
    #k2["weighting"] = Dict()
    #k2["weighting"]["function"] = "exponential"
    #k2["weighting"]["scale"] = 0.5
    #k2["weighting"]["cutoff"] = 1e-3

    k3 = Dict()
    k3["geometry"] = Dict()
    k3["geometry"]["function"] = "angle"
    k3["grid"] = Dict()
    k3["grid"]["min"] = 0.15
    k3["grid"]["max"] = 3.45575
    k3["grid"]["n"] = 100
    k3["grid"]["sigma"] = 0.0
    #k3["weighting"] = Dict()
    #k3["weighting"]["function"] = "exponential"
    #k3["weighting"]["scale"] = 0.5
    #k3["weighting"]["cutoff"] = 1e-3
end

#Setting Dscribe MBTR Descriptor
mbtr_desc = py_dsd.MBTR(periodic, species,
                        k1=k1, k2=k2, k3=k3,
                        normalize_gaussians=normalize_gaussians,
                        normalization=normalization,
                        flatten=flatten, 
                        sparse=sparse)

# Calculate descriptor
atom_struct = ASEAtoms(at)
mbtr_rtn_desc = mbtr_desc.create(atom_struct.po)
return mbtr_rtn_desc
end

end # module
