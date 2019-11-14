# test leap-frogging vortex rings in 2d
include("vm2d.jl")

# create vortex ring geometry
radius1 = 0.1
radius2 = 0.1
spacing = 0.05
points = [[-spacing,radius1,0.0],[-spacing,-radius1,0.0],[0.0,radius2,0.0],[0.0,-radius2,0.0]]

# set vectorial vortex strengths
gamma = 0.1
gamma_upper = [0,0,gamma]
gamma_lower = [0,0,-gamma]
gammas = [gamma_upper,gamma_lower,gamma_upper,gamma_lower]

# set initial velocities
v0 = 0.0
vs = [[v0,0.0,0.0],[v0,0.0,0.0],[0.0,0.0,0.0],[0.0,0.0,0.0]]

particles = place(points,gammas,vs)

# set simulation variables
name = "vortexrings"
global currenttime
currenttime = 0.0
timestep = 0.01
numtimesteps = 25 # try 150

# animate!
currenttime = timestart
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
    currenttime += timestep
    ## evaluate velocity field
    zs = [0.0]
    ys = range(-0.2,stop=0.2,length=20)
    xs = range(particles[1].x[3] - 0.1,
            stop = particles[1].x[3] + 0.1,
            length = 5)
    (x,y,z,u,v,w) = vfield(particles, xs, ys, zs)
    ## update plot
    plot_xy(particles; title="time: "*string(round(currenttime; digits=3)))
    plt.quiver(x,y,u,v)
    plt.pause(0.5)
end
