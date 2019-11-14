# plotting tools
include("generateVTK.jl")
include("vm2d_particle.jl")

# # set freestream
# function Uinf(x::Array{Float64,1})
#     Uinf = [0.0,0.0,0.0]
#     return Uinf
# end

# plot x-y view
function plot_xy(particles::Array{Particle,1}; velocity::Bool=false, xs=nothing, ys=nothing, zs=nothing, circulation::Bool=false, title::String="", save::Bool=false, name::String="default_sim", pause::Float64=-1.0)
    # plot
    plt.clf()
    plt.cool()
    for particle in particles
        plt.scatter(particle.x[1],particle.x[2],c=la.norm(particle.gamma))#la.norm(particle.gamma))
    end

    # velocity field
    if velocity
        gridxv, gridyv, gridzv, vx, vy, vz = vfield(particles, xs, ys, zs)
        plt.quiver(gridxv, gridyv, vx, vy)
    end

    # circulation vectors
    if circulation
        gridxc, gridyc, gridzc, gx, gy, gz = gfield(particles)
        plt.quiver(gridxc, gridyc, gx, gy)
    end

    plt.title(title)
    plt.xlabel("x")
    plt.ylabel("y")
    plt.axis("equal")

    # save frame
    if save==true
        plt.savefig("sim/"*name*".png")
    end

    # pause frame
    if pause > 0.0    
        plt.pause(pause)
    end
end

# plot y-z view
function plot_yz(particles::Array{Particle,1}; velocity::Bool=false, xs=nothing, ys=nothing, zs=nothing, circulation::Bool=false, title::String="", save::Bool=false, name::String="default_sim", pause::Float64=-1.0)
    # plot
    plt.clf()
    plt.cool()
    for particle in particles
        plt.scatter(particle.x[2],particle.x[3],c=la.norm(particle.gamma))
    end

    # velocity field
    if velocity
        gridxv, gridyv, gridzv, vx, vy, vz = vfield(particles, xs, ys, zs)
        plt.quiver(gridyv, gridzv, vy, vz)
    end

    # circulation vectors
    if circulation
        gridxc, gridyc, gridzc, gx, gy, gz = gfield(particles)
        plt.quiver(gridyc, gridzc, gy, gz)
    end

    plt.title(title)
    plt.xlabel("y")
    plt.ylabel("z")
    plt.axis("equal")

    # save frame
    if save==true
        plt.savefig("sim/"*name*".png")
    end

    # pause frame
    if pause > 0.0    
        plt.pause(pause)
    end
end

# plot 3-D view
function plot_3d(particles::Array{Particle,1}; title::String="", save::Bool=false, name::String="default_sim", pause::Float64=-1.0)
    # plot
    plt.clf()
    plt.cool()
    for particle in particles
        plt.scatter(particle.x[2],particle.x[3],c=la.norm(particle.gamma))
    end
    plt.title(title)
    plt.xlabel("y")
    plt.ylabel("z")
    plt.axis("equal")

    # save frame
    if save==true
        plt.savefig("sim/"*name*".png")
    end

    # pause frame
    if pause > 0.0    
        plt.pause(pause)
    end
end

Uinf(x) = [0.0,0.0,0.0] # default freestream velocity function
# animate
function animate(particles,timestart,timestep,numtimesteps; Uinf=Uinf)
    currenttime = timestart
    # set up plot
    plt.plot()
    plt.cool()
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
        ## update plot
        plot_xy(particles; title="time: "*string(round(currenttime; digits=3)))
    end
end

"""
`packVTK(particles::Array{Particle,1},xs,ys,zs)`

Uses Eduardo Alvarez' `generateVTK()` function to generate VTK text files for visualizations with paraview.

Optional arguments `xs`, `ys`, and `zs` define the cartesian grid for visualizing the velocity field.
"""
function packVTK(filename, particles::Array{Particle,1}; xs=Nothing, ys=Nothing, zs=Nothing)
    # make array of points defining vortex particles
    points = Array{Float64,1}[]
    for particle in particles
        push!(points,particle.x)
    end

    # compile circulation vector data
    gammavecs = Array{Float64,1}[]
    for particle in particles
        push!(gammavecs, particle.gamma)
    end
    vectordata = Dict(
        "field_name" => "Circulation",
        "field_type" => "vector",
        "field_data" => gammavecs
    )

    point_data = [vectordata]

    # generate VTK file
    generateVTK(filename, points; point_data = point_data)
end