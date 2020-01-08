# run all tests
using Test
@testset "vm2d Unit Tests" begin

    include("test_advance.jl")
    for i in 1:4
        @test particles[i].v ≈ particles2[i].v atol=0.00001
    end

    for script in ["plottools","debug","geometry","leapfrog2d","leapfrog2d_2","ring2d","rings2d"]
        teststatus = true
        try 
            include("test_"*script*".jl")
        catch
            teststatus = false
        end
        @test teststatus
    end
end