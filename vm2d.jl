# """
#     2-D vortex method.

#     # AUTHORSHIP
#         * Author    : Ryan Anderson
#         * Email     : rymanderson@gmail.com
#         * Created   : 2019
#         * License   : MIT License
# """
# module vm2d

# Import Modules
# import GeometricTools
# gt = GeometricTools
import LinearAlgebra
la = LinearAlgebra  
import PyPlot
plt = PyPlot
include("vm2d_geometry.jl")
include("vm2d_particle.jl")
include("vm2d_plottools.jl")

# set freestream
function Uinf(x::Array{Float64,1})
    Uinf = [0.0,0.0,0.0]
    return Uinf
end

# # plot x-y view
# function plot_xy(particles::Array{Particle,1}; title::String="", save::Bool=false, name::String="default_sim", pause::Float64=-1.0)
#     # plot
#     plt.clf()
#     for particle in particles
#         plt.scatter(particle.x[1],particle.x[2],c=la.norm(particle.gamma))
#     end
#     plt.title(title)
#     plt.xlabel("x")
#     plt.ylabel("y")
#     plt.axis("equal")

#     # save frame
#     if save==true
#         plt.savefig("sim/"*name*".png")
#     end

#     # pause frame
#     if pause > 0.0    
#         plt.pause(pause)
#     end
# end

# # plot y-z view
# function plot_yz(particles::Array{Particle,1}; title::String="", save::Bool=false, name::String="default_sim", pause::Float64=-1.0)
#     # plot
#     plt.clf()
#     for particle in particles
#         plt.scatter(particle.x[2],particle.x[3],c=la.norm(particle.gamma))
#     end
#     plt.title(title)
#     plt.xlabel("y")
#     plt.ylabel("z")
#     plt.axis("equal")

#     # save frame
#     if save==true
#         plt.savefig("sim/"*name*".png")
#     end

#     # pause frame
#     if pause > 0.0    
#         plt.pause(pause)
#     end
# end

# Uinf(x) = [0.0,0.0,0.0] # default freestream velocity function
# # animate
# function animate(particles,timestart,timestep,numtimesteps; Uinf=Uinf)
#     currenttime = timestart
#     # set up plot
#     plt.plot()
#     plt.hot()
#     plt.axis("equal")
#     for particle in particles
#         plt.scatter(particle.x[1],particle.x[2],c=particle.gamma[3])
#     end
#     plt.title("time: "*string(round(currenttime; digits=3)))
#     # animate
#     for i in range(1,length=numtimesteps)
#         ## advance timestep
#         advance(particles,timestep,Uinf)
#         currenttime += timestep
#         ## update plot
#         plot_xy(particles; title="time: "*string(round(currenttime; digits=3)))
#     end
# end

# OPTION ONE: CIRCLE
# create circle geometry
# center = [0.0,0.0]
# radius = 0.1
# thetastart = 0.0
# thetaend = 2*pi
# refinement = 9
# points = circlexy(center,radius,refinement,thetastart,thetaend)

# # set vectorial vortex strengths
# gamma = [0,0,1.0]
# gammas = Array{Float64,1}[]
# for point in points
#     push!(gammas,gamma)
# end

# # set initial particle velocities
# vs = Array{Float64,1}[]
# for point in points
#     v = Uinf(point)
#     push!(vs,v)
# end

# particles = place(points,gammas,vs)


# # set simulation variables
# name = "vortexrings"
# global currenttime
# currenttime = 0.0
# timestep = 0.01
# numtimesteps = 150
# END OPTION 1

# OPTION 2: 2D VORTEX RINGS
# # create vortex ring geometry
# radius1 = 0.1
# radius2 = 0.1
# spacing = 0.05
# points = [[-spacing,radius1,0.0],[-spacing,-radius1,0.0],[0.0,radius2,0.0],[0.0,-radius2,0.0]]

# # set vectorial vortex strengths
# gamma = 0.1
# gamma_upper = [0,0,gamma]
# gamma_lower = [0,0,-gamma]
# gammas = [gamma_upper,gamma_lower,gamma_upper,gamma_lower]

# # set initial velocities
# v0 = 0.0
# vs = [[v0,0.0,0.0],[v0,0.0,0.0],[0.0,0.0,0.0],[0.0,0.0,0.0]]

# particles = place(points,gammas,vs)


# # set simulation variables
# name = "vortexrings"
# global currenttime
# currenttime = 0.0
# timestep = 0.01
# numtimesteps = 150
# END OPTION 2

# # OPTION 3: 3D VORTEX RINGS
# # create vortex ring geometry
# ## required arguments
# radius1 = 0.1
# radius2 = 0.1
# spacing = 0.05
# refinement = 9

# ## build geometry
# thetastart = 0.0
# thetaend = 2*pi

# center = [0.0,0.0,0.0]
# radius = radius1
# ring1 = circlexy(center,radius,refinement,thetastart,thetaend)

# center = [0.0,0.0,spacing]
# radius = radius2
# ring1 = circlexy(center,radius,refinement,thetastart,thetaend)

# # set vectorial vortex strengths
# gamma = 0.1
# gamma_upper = [0,0,gamma]
# gamma_lower = [0,0,-gamma]
# gammas = [gamma_upper,gamma_lower,gamma_upper,gamma_lower]

# # set initial velocities
# v0 = 0.0
# vs = [[v0,0.0,0.0],[v0,0.0,0.0],[0.0,0.0,0.0],[0.0,0.0,0.0]]

# particles = place(points,gammas,vs)


# # set simulation variables
# name = "vortexrings"
# global currenttime
# currenttime = 0.0
# timestep = 0.01
# numtimesteps = 150
# # END OPTION 3


# # plot
# ## OPTION 1: toggle 2D x-y plot
# plt.plot()
# plt.hot()
# plt.axis("equal")
# for particle in particles
#     plt.scatter(particle.x[1],particle.x[2],c=particle.gamma[3])
# end
# plt.title("time: "*string(round(currenttime; digits=3)))
# ## save frame
# plt.savefig("sim/"*name*"_"*string(currenttime)*".png")
# ## run simulation
# for i in range(1,length=numtimesteps)
#     ## advance timestep
#     advance(particles,timestep,Uinf)
#     currenttime += timestep
#     ## update plot
#     plt.clf()
#     for particle in particles
#         plt.scatter(particle.x[1],particle.x[2],c=particle.gamma[3])
#     end
#     plt.title("time: "*string(round(currenttime; digits=3)))
#     plt.axis("equal")
#     ## save frame
#     plt.savefig("sim/"*name*"_"*string(i)*".png")
#     println(particles)
# end

