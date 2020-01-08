# test leap-frogging vortex rings in 2d
include("vm2d.jl")

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

# set simulation variables
name = "vortexrings"
global currenttime
currenttime = 0.0
timestep = 0.01
numtimesteps = 5 # try 150

# animate!

# set up plot
plt.plot()
plt.hot()
plt.axis("equal")
for particle in particles
    plt.scatter(particle.x[1],particle.x[2],c=particle.gamma[3])
end
plt.title("time: "*string(round(currenttime; digits=3)))
if ~isdir("./sim")
    mkdir("./sim")
end
# animate
for i in 1:numtimesteps
    ## advance timestep
    advance(particles,timestep,Uinf)
    currenttime += timestep
    ## evaluate velocity field
    zs = range(-radius1, stop=radius1, length=6)
    ys = [0.0] #range(-2*radius1,stop=2*radius1,length=20)
    xs = range(particles[1].x[1] - 4*spacing,
            stop = particles[1].x[1] + 4*spacing,
            length = 11)
    (x,y,z,u,v,w) = vfield(particles, xs, ys, zs)
    ## update plot
    name = "getworking"*string(i)
    plot_2d(particles, "zx"; velocity=true, xs=xs, ys=ys, zs=zs, title="time: "*string(round(currenttime; digits=3)), save=true, name=name)
    # plt.quiver(x,y,u,v)
    plt.pause(0.005)
end