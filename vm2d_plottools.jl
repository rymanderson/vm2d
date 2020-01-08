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

# plot y-z view
function plot_2d(particles::Array{Particle,1}, dims::String; velocity::Bool=false, xs=nothing, ys=nothing, zs=nothing, circulation::Bool=false, title::String="", save::Bool=false, name::String="default_sim", pause::Float64=-1.0)
    # set up axes
    xaxis = collect(dims)[1]
    yaxis = collect(dims)[2]
    if xaxis == 'x'
        xindex = 1
    elseif xaxis == 'y'
        xindex = 2
    elseif xaxis == 'z'
        xindex = 3
    end
    if yaxis == 'x'
        yindex = 1
    elseif yaxis == 'y'
        yindex = 2
    elseif yaxis == 'z'
        yindex = 3
    end
    
    # plot
    plt.clf()
    plt.cool()
    for particle in particles
        plt.scatter(particle.x[xindex],particle.x[yindex],c=la.norm(particle.gamma))
    end

    # velocity field
    if velocity
        gridxv, gridyv, gridzv, vx, vy, vz = vfield(particles, xs, ys, zs)
        gridv = [gridxv, gridyv, gridzv]
        v = [vx, vy, vz]
        plt.quiver(gridv[xindex], gridv[yindex], v[xindex], v[yindex])
    end

    # circulation vectors
    if circulation
        gridxc, gridyc, gridzc, gx, gy, gz = gfield(particles)
        gridc = [gridxc, gridyc, gridzc]
        g = [gx, gy, gz]
        plt.quiver(gridc[xindex], gridc[yindex], g[xindex], g[yindex])
    end

    plt.title(title)
    plt.xlabel(string(xaxis))
    plt.ylabel(string(yaxis))
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
function packVTK(filename, particles::Array{Particle,1}; xs=Nothing, ys=Nothing, zs=Nothing, num=nothing)
    # make array of points defining vortex particles
    points = Array{Float64,1}[]
    for particle in particles
        push!(points,particle.x)
    end

    # compile circulation and particle velocity vector data
    gammavecs = Array{Float64,1}[]
    particlevelocities = Array{Number,1}[]
    for particle in particles
        push!(gammavecs, particle.gamma)
        push!(particlevelocities, particle.v)
    end
    gammadata = Dict(
        "field_name" => "Circulation",
        "field_type" => "vector",
        "field_data" => gammavecs
    )
    particlevdata = Dict(
        "field_name" => "ParticleVelocity",
        "field_type" => "vector",
        "field_data" => particlevelocities
    )

    # compile all vtk data for particles
    point_data = [gammadata, particlevdata]
        
    # generate VTK file for particles
    generateVTK(filename, points; point_data = point_data, path = "vtk/", num=num)
    
    if xs != Nothing
        # compile velocity field data
        gridxv, gridyv, gridzv, vx, vy, vz = vfield(particles, xs, ys, zs)
        velocityvecs = Array{Number,1}[]
        velocitycoordinates = Array{Number,1}[]
        for i in range(1, length=length(gridxv))
            push!(velocityvecs, [vx[i], vy[i], vz[i]])
            push!(velocitycoordinates, [gridxv[i], gridyv[i], gridzv[i]])
        end
        velocitydata = Dict(
            "field_name" => "Velocity",
            "field_type" => "vector",
            "field_data" => velocityvecs
        )

        # compile all vtk data for velocity field
        velocity_data = [velocitydata]

        # generate VTK file for velocity field
        generateVTK(filename*"_velocityfield", velocitycoordinates; point_data = velocity_data, path = "vtk/", num=num)
    end

    
end