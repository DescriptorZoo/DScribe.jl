using DScribe
using Test, LinearAlgebra, BenchmarkTools
using JuLIP, JuLIP.Testing
using DScribe: dscribe_acsf, dscribe_soap

@testset "DScribe.jl" begin
    #include("acsf_test.jl")
    include("soap_test.jl")
end

