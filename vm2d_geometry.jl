# geometry engine for vm2d
import LinearAlgebra
la = LinearAlgebra  
include("vm2d_particle.jl")

# circle
"""
`circle(center,radius,points,spacing)`

returns an array of 2-element arrays describing the coordinates of a circle
"""
function circlexy(center::Array{Float64,1},radius::Float64,refinement::Int64,thetastart::Float64,thetaend::Float64)
    thetas = range(thetastart,stop=thetaend,length=refinement)
    points = Array{Float64,1}[]
    if abs(thetaend - 2*pi) < 0.00000001
        thetas = thetas[1:end-1]
    end
    for theta in thetas
        x = center[1] + radius*cos(theta)
        y = center[2] + radius*sin(theta)
        if length(center) == 3
            z = center[3]
            push!(points,[x,y,z])
        elseif length(center) == 2
            push!(points,[x,y,0])
        else
            throw(ArgumentError(center, "argument must be a 2- or 3-element array"))
        end
    end


    return points
end

# ring
"""
`vortexring(radius::Float64,center::Array{Float64,1},refinement::Int64,gamma::Float64; velocity::Array{Float64,1}=[0.0,0.0,0.0])`

* returns an array of vortex particles defining a vortex ring in an xy-plane
* positive values of gamma produce clockwise vorticity from the vantage a traditional x-y view
"""
function vortexring(radius::Float64,center::Array{Float64,1},refinement::Int64,gamma::Float64;velocity::Array{Float64,1}=[0.0,0.0,0.0])
    thetastart = 0.0
    thetaend = 2*pi
    points = circlexy(center,radius,refinement,thetastart,thetaend)
    # get gammas
    gammas = Array{Float64,1}[]
    for point in points
        rhat = (point - center)/la.norm(point-center)# radius unit vector
        # cross product results in a vector tangent to the circle
        # gamma scales to size
        Gamma = la.cross(rhat,[0,0,1.0])*gamma
        push!(gammas,Gamma)
    end
    # get velocities
    vs = Array{Float64,1}[]
    for point in points
        push!(vs,velocity)
    end
    particles = place(points,gammas,vs)
    
    return particles
end

