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
animate(particles,timestart,timestep,numtimesteps)