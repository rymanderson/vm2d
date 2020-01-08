# TEST SINGLE VORTEX RING

include("vm2d.jl")

# create circle geometry
center = [0.0,0.0,0.0]
radius = 0.1
refinement = 9
gamma = 0.1
velocity=[0.0,0.0,0.0]

particles = vortexring(radius,center,refinement,gamma;velocity=velocity)

# set simulation variables
name = "vortexrings"
timestart = 0.0
timestep = 0.01
numtimesteps = 150

# plot
## TEST 1: try making 2D x-y plot
# plot_xy(particles)

## TEST 2: try animating
# animate(particles,timestart,timestep,numtimesteps)

# TEST `packVTK`
# particles = vortexring(radius,center,refinement,gamma;velocity=velocity) # primitive
center = [0.0,0.0,0.0]
radius = 0.1
refinement = 150
gamma = -0.002
velocity=[0.0,0.0,0.0]
spacing = 0.05

ring1 = vortexring(radius,center,refinement,gamma;velocity=velocity)
ring2 = vortexring(radius,center.+[0.0,0.0,spacing],refinement,gamma;velocity=velocity)
particles = vcat(ring1,ring2)

filename = "test_plottools"
numtimesteps = 10
timestep = 0.01
# xs = range(center[1] - 2*radius, stop = center[1] + 2*radius, length = 19)
# ys = range(center[1] - 2*radius, stop = center[1] + 2*radius, length = 19)
# zs = [center[3]]

margin = 0.2
for i in range(1,stop=numtimesteps)
    ## advance timestep
    ## evaluate velocity field
    ### get center
    xcoordinates = Float64[]
    ycoordinates = Float64[]
    zcoordinates = Float64[]
    for particle in particles
        push!(xcoordinates, particle.x[1])
        push!(ycoordinates, particle.x[2])
        push!(zcoordinates, particle.x[3])
    end
    # xs = [sum(xcoordinates)/length(xcoordinates) + xoffset]
    xhi = maximum(xcoordinates)
    xlo = minimum(xcoordinates)
    xs = range(xlo-margin, stop = xhi + margin, length = 21)
    # ycenter = sum(ycoordinates)/length(ycoordinates)
    yhi = maximum(ycoordinates)
    ylo = minimum(ycoordinates)
    # ys = range(ycenter - 0.2, stop = ycenter + 0.2,length = 20)
    ys = range(ylo-margin, stop = yhi + margin, length = 21)
    zhi = maximum(zcoordinates)
    zlo = minimum(zcoordinates)
    zrefinement = Integer(ceil(abs(zhi-zlo) / radius*4))
    if zrefinement < 2
        zrefinement = 2
    end
    zs = range(zlo-margin, stop = zhi+margin, length=zrefinement)
    zs = range(particles[1].x[3] - 0.07,
    stop = particles[1].x[3] + 0.1,
    length = 10)
    # zs = [sum(zcoordinates)/length(zcoordinates)]
    # name = "rings2d_150particles_yz"*"_"*string(i)
    packVTK(filename, particles::Array{Particle,1}; xs=xs, ys=ys, zs=zs, num=i)
    
    advance(particles,timestep,Uinf)
    currenttime += timestep
end