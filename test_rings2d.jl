# TEST PAIR OF VORTEX RINGS

include("vm2d.jl")

# create circle geometry
center = [0.0,0.0,0.0]
radius = 0.1
refinement = 150
gamma = -0.002
velocity=[0.0,0.0,0.0]
spacing = 0.05

ring1 = vortexring(radius,center,refinement,gamma;velocity=velocity)
ring2 = vortexring(radius,center.+[0.0,0.0,spacing],refinement,gamma;velocity=velocity)
particles = vcat(ring1,ring2)
# println("==== INITIAL PARTICLES =====")
# println(particles)
# println("")
# println("")

# save plots for debugging

# ## show circulation vectors
# plot_xy(particles; circulation=true, save=true, name="circulation_2rings")

# ## show velocity field
# plot_yz(particles; velocity=true, zs=range(-0.2,stop=0.2,length=8), ys=range(-0.2,stop=0.2,length=9), xs=[0.0], save=true, name="velocityfield_2rings")


                                                                                # set simulation variables
name = "vortexrings"
global currenttime
currenttime = 0.0
timestep = 0.01
numtimesteps = 120 # try 150
xoffset = 0.0
margin = 0.05


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
    currenttime += timestep
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
    xs = [sum(xcoordinates)/length(xcoordinates) + xoffset]
    # xhi = maximum(xcoordinates)
    # xlo = minimum(xcoordinates)
    # xs = range(xlo-margin, stop = xhi + margin, length = 20)
    # ycenter = sum(ycoordinates)/length(ycoordinates)
    yhi = maximum(ycoordinates)
    ylo = minimum(ycoordinates)
    # ys = range(ycenter - 0.2, stop = ycenter + 0.2,length = 20)
    ys = range(ylo-margin, stop = yhi + margin, length = 20)
    zs = range(particles[1].x[3] - 0.07,
            stop = particles[1].x[3] + 0.1,
            length = 10)
    # zs = [sum(zcoordinates)/length(zcoordinates)]
    ## update plot
    name = "rings2d_150particles_yz"*"_"*string(i)
    println(name)
    plot_2d(particles, "yz"; velocity=true, xs=xs, ys=ys, zs=zs, title="time: "*string(round(currenttime; digits=3)), save=true, name=name)#*string(round(xoffset; digits=2)))
    # println("P1: ",particles[1])
    # println("P2: ",particles[2])
    # println("P3: ",particles[3])
    # println("P4: ",particles[4])
end
