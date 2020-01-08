# test the vm2d_particle.advance() function
include("vm2d.jl")
timestep = 0.01

# first test the working case
# create vortex ring geometry
radius1 = 0.1
radius2 = 0.1
spacing = 0.05
points = [[radius1,0.0,0.0],[-radius1,0.0,0.0],[radius2,0.0,spacing],[-radius2,0.0,spacing]]

# set vectorial vortex strengths
gamma = 0.1
gamma_upper = [0,gamma,0]
gamma_lower = [0,-gamma,0]
gammas = [gamma_upper,gamma_lower,gamma_upper,gamma_lower]

# set initial velocities
v0 = 0.0
vs = [[v0,0.0,0.0],[v0,0.0,0.0],[0.0,0.0,0.0],[0.0,0.0,0.0]]

particles = place(points,gammas,vs)

# now test the trouble case

# create circle geometry
center = [0.0,0.0,0.0]
radius = 0.1
refinement = 3
gamma = -0.1
velocity=[0.0,0.0,0.0]
spacing = 0.05

ring1 = vortexring(radius,center,refinement,gamma;velocity=velocity)
ring2 = vortexring(radius,center.+[0.0,0.0,spacing],refinement,gamma;velocity=velocity)
particles2 = vcat(ring1,ring2)

println("===== test_advance() =====")
println("Manual case particles velocity BEFORE advance(): ")
for particle in particles
    println(particle.v)
end
println("")
println("Trouble case particles velocity BEFORE advance():")
for particle in particles2
    println(particle.v)
end
println("")
println("")

advance(particles,timestep,Uinf)
advance(particles2,timestep,Uinf)

println("Manual case particles velocity after advance(): ")
for particle in particles
    println(particle.v)
end
println("")
println("Trouble case particles velocity after advance():")
for particle in particles2
    println(particle.v)
end
println("")
println("")
println("===== END TEST =====")

