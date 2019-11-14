# TEST SINGLE VORTEX RING

include("vm2d.jl")

# create circle geometry
center = [0.0,0.0]
radius = 0.1
thetastart = 0.0
thetaend = 2*pi
refinement = 9
points = circlexy(center,radius,refinement,thetastart,thetaend)

# set vectorial vortex strengths
gamma = [0,0,1.0]
gammas = Array{Float64,1}[]
for point in points
    push!(gammas,gamma)
end

# set initial particle velocities
vs = Array{Float64,1}[]
for point in points
    v = Uinf(point)
    push!(vs,v)
end

particles = place(points,gammas,vs)


# set simulation variables
name = "vortexrings"
global currenttime
currenttime = 0.0
timestep = 0.01
numtimesteps = 150

# plot
## OPTION 1: toggle 2D x-y plot
plt.plot()
plt.hot()
plt.axis("equal")
for particle in particles
    plt.scatter(particle.x[1],particle.x[2],c=particle.gamma[3])
end
plt.title("time: "*string(round(currenttime; digits=3)))
## save frame
for i in range(1,length=numtimesteps)
    ## advance timestep
    advance(particles,timestep,Uinf)
    currenttime += timestep
    ## update plot
    plt.clf()
    for particle in particles
        plt.scatter(particle.x[1],particle.x[2],c=particle.gamma[3])
    end
    plt.title("time: "*string(round(currenttime; digits=3)))
    plt.axis("equal")
    ## save frame
    # println(particles[1])
    plt.pause(0.0001)
end