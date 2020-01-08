# TEST SINGLE VORTEX RING

include("vm2d.jl")
# prepare directories
if ~isdir("./sim")
    mkdir("./sim")
end

# create circle geometry
center = [0.0,0.0,0.0]
radius = 0.1
refinement = 31
gamma = 0.1
velocity=[0.0,0.0,0.0]

particles = vortexring(radius,center,refinement,gamma;velocity=velocity)


# set simulation variables
name = "vortexrings"
global currenttime
currenttime = 0.0
timestep = 0.01
numtimesteps = 1

# save plots for debugging

## show circulation vectors
plot_xy(particles; circulation=true, save=true, name="circulation_1ring")

## show velocity field
plot_yz(particles; velocity=true, zs=range(-0.2,stop=0.2,length=8), ys=range(-0.2,stop=0.2,length=9), xs=[0.0], save=true, name="velocityfield_1ring")

# animate!

# set up plot
plt.plot()
plt.hot()
plt.axis("equal")
for particle in particles
    plt.scatter(particle.x[1],particle.x[2],c=particle.gamma[3])
end

plt.title("time: "*string(round(currenttime; digits=3)))
# animate
for i in range(1,length=numtimesteps)
    ## advance timestep
    advance(particles,timestep,Uinf)
    ## evaluate velocity field
    xs = [0.0]
    ys = range(-0.2,stop=0.2,length=20)
    zs = range(particles[1].x[3] - 0.1,
            stop = particles[1].x[3] + 0.1,
            length = 5)
    (x,y,z,u,v,w) = vfield(particles, xs, ys, zs)
    ## update time
    currenttime += timestep
    ## update plot
    plot_yz(particles; title="time: "*string(round(currenttime; digits=3)))
    plt.quiver(y,z,v,w)
    plt.pause(0.001)
end
