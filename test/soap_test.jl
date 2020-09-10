@testset "DScribe SOAP Descriptor" begin

@info("Testing DScribe SOAP Descriptor for DC Si with cutoff=6.5, n=4, l=4")
using JuLIP, DScribe, Test

at = bulk(:Si, cubic=true)
desc = dscribe_soap(at, 6.5, n_max=4, l_max=4)
# Reference is from the output of the QUIP command as follows
# quip atoms_filename=test.xyz descriptor_str="soap cutoff=6.5 l_max=4 n_max=4 atom_sigma=0.5 normalise=T n_Z=1 Z={14} n_species=1 species_Z={14}"
soap_ref = [0.47285277, 1.7203233, -1.6327636, 4.0070906, 6.258845, -5.940287, 14.578514, 5.637943, -13.836509, 33.957237, 3.5743687e-33, -1.0012961e-32, 1.5516055e-32, -4.7689123e-33, 2.8058653e-32, -4.353206e-32, 1.3339438e-32, 6.878232e-32, -2.1905732e-32, 8.337165e-33, 7.119684e-33, -2.2345982e-32, 2.8977972e-32, -2.1937631e-32, 7.015937e-32, -9.1644326e-32, 6.978438e-32, 1.4435643e-31, -1.2865728e-31, 1.2816743e-31, 0.025995005, -0.113665685, 0.20420578, 0.19071767, 0.49701422, -0.8929096, -0.8339315, 1.6041543, 1.4981973, 1.3992391, 0.00081991457, -0.0046709054, 0.009903433, 0.037733737, 0.026609303, -0.056418065, -0.21496229, 0.11961975, 0.4557713, 1.7365651]
soap_now = vcat(desc[1,:]...)
println("DScribe.jl SOAP:",soap_now)
println("Reference:",soap_ref)
#println(@test soap_now  ≈  soap_ref)
tst = [isapprox(soap_now[x], soap_ref[x]; atol=0.00001) for x=1:length(soap_ref)]
println(@test all(x->x==true, tst))


end
