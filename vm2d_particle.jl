# vortex particle definition

# import modules
import LinearAlgebra
la = LinearAlgebra

"""
`Particle(args)`

Description here.
"""
mutable struct Particle

    # properties here
    gamma::Array{Float64, 1}       # vortex strength vector
    x::Array{Float64, 1}           # particle position
    v::Array{Float64, 1}           # particle velocity

    Particle(gamma,x,v) = new(gamma,x,v)

end

"""
`vinduced(particle::Particle,X)`

Calculates the induced velocity produced by the vortex particle argument at the specified location.
"""
function vinduced(particle::Particle,x::Array{Float64,1})
    r = x .- particle.x
    vinduced = -la.cross(r/4/pi/la.norm(r)^3, particle.gamma)
    
    return vinduced
end

"""
`place(coordinates::Array{Array{Float64,1},1},gammas::Array{Array{Float64,1},1},vs::Array{Array{Float64,1},1})`

Places vortex particles at the specified locations.
"""
function place(coordinates::Array{Array{Float64,1},1},gammas::Array{Array{Float64,1},1},vs::Array{Array{Float64,1},1})
    particles = Particle[]
    for i = range(1,length=length(coordinates))
        push!(particles,Particle(gammas[i],coordinates[i],vs[i]))
    end

    return particles    
end

"""
`netv(particles::Array{Particle,1},x::Array{Particle,1})`

Returns the net velocity induced by the vector of Particles at location x.
"""
function netv(particles::Array{Particle,1}, x::Array{Float64,1}; err::Float64 = 0.00000001)
    # find velocity induced at a point due to all vortex particles
    velocity = [0.0, 0.0, 0.0]
    for particle in particles
        if la.norm(particle.x .- x) < err
            continue
        else
            velocity .+= vinduced(particle, x)
        end
    end 

    return velocity
end

"""
`step(particles::Array{Particle,1},timestep::Float64,Uinf)`

Calculates induced velocities and advances forward the specified timestep.
"""
function advance(particles::Array{Particle,1},timestep::Float64,Uinf)
    # update velocity of each particle
    for particle in particles
        particle.v .= netv(particles, particle.x) .+ Uinf(particle.x)
    end

    # move each particle
    for particle in particles
        particle.x .= particle.x + particle.v * timestep
    end
end

"""
`vfield(particles::Array{Particle,1},xs::Array{Float64,1},ys::Array{Float64,1},zs::Array{Float64,1})`

Evaluates the velocity field at discrete points on a cartesian grid defined by the arguments:

    * `xs` defines the X values of the cartesian grid
    * `ys` defines the Y values of the cartesian grid
    * `zs` defines the Z values of the cartesian grid

Returns six vectors:

    * `gridx` defines the X coordinate of each grid point
    * `gridy` defines the Y coordinate of each grid point
    * `gridz` defines the Z coordinate of each grid point
    * `vx` defines the X component of the vorticity-induced velocity at each grid point
    * `vy` defines the Y component of the vorticity-induced velocity at each grid point
    * `vz` defines the Z component of the vorticity-induced velocity at each grid point 
"""
function vfield(particles::Array{Particle,1},xs, ys, zs)
    # build grid
    gridx = Float64[]
    gridy = Float64[]
    gridz = Float64[]
    vx = Float64[]
    vy = Float64[]
    vz = Float64[]
    
    for x in xs
        for y in ys
            for z in zs
                # add coordinate
                push!(gridx,x)
                push!(gridy,y)
                push!(gridz,z)
                v = netv(particles,[x,y,z]) # get induced velocity
                # unpack velocity components
                push!(vx,v[1])
                push!(vy,v[2])
                push!(vz,v[3])
            end
        end
    end

    return gridx, gridy, gridz, vx, vy, vz
end

"""
`gfield(particles::Array{Particle,1})`

Useful for plotting the circulation vector of each particle

Returns six vectors:

    * `gridx` defines the X coordinate of each particle
    * `gridy` defines the Y coordinate of each particle
    * `gridz` defines the Z coordinate of each particle
    * `gx` defines the X component of the circulation of each particle
    * `gy` defines the Y component of the circulation of each particle
    * `gz` defines the Z component of the circulation of each particle
"""
function gfield(particles::Array{Particle,1})
    # set up vectors
    gridx = Float64[]
    gridy = Float64[]
    gridz = Float64[]
    gx = Float64[]
    gy = Float64[]
    gz = Float64[]
    # get coordinates and circulations
    for particle in particles
        push!(gridx,particle.x[1])
        push!(gridy,particle.x[2])
        push!(gridz,particle.x[3])
        push!(gx,particle.gamma[1])
        push!(gy,particle.gamma[2])
        push!(gz,particle.gamma[3])
    end

    return gridx, gridy, gridz, gx, gy, gz
end