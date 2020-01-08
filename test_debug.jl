# debug script

pos = particles[2].x

for particle in particles
    vi = vinduced(particle,pos)
    println(vi)
end
# passed


for particle in particles
    vi = netv(particles, particle.x) .+ Uinf(particle.x)
    println(vi)
end
# passed

for particle in particles
    println(netv(particles, particle.x) .+ Uinf(particle.x))
end
# passed

timestep = 0.01
for particle in particles
    newx = particle.x + particle.v * timestep
    println(newx)
end
# passed

for particle in particles
    particle.v .= netv(particles, particle.x) .+ Uinf(particle.x)
end
# DID NOT PASS

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