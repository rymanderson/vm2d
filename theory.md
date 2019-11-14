# Theory for vm2d

## Background

From \cite{winckelmans1989topics}:

Vortex particle methods are useful for flows where vorticity is concentrated in a relatively small region, and the rest of the flow is vorticity-free. The vorticity field is tracked and is sufficient to calculate the velocity field using the Biot-Savaart law and boundary conditions. Vorticity can be discretized into elements that may be thought of as sections of a vortex tube, and are therefore convected with the local fluid velocity as postulated by Kelvin and Hemholtz. The vorticity gradient, then, is deformed by the velocity gradient. One issue with modeling a vortex tube using a single vortex filament occurs when the perturbation wavelength is less than 5 times the vortex tube core size. Fortunately, a regularization scaling factor can be introduced to reproduce the appropriate velocity field. 

In a vortex particle method (VPM), vortex elements are volumes of assumed constant vorticity vector. The volume is convected with the velocity field and the vorticity vector is convected with the velocity gradient tensor.

 \cite{winckelmans1989topics}

## Governing Equations

### Navier Stokes

The Navier Stokes equation is used to model incompressible flows:

$\frac{\partial \mathbf{u}}{\partial t} + (\mathbf{u} \cdot \nabla) \mathbf{u} = -\nabla \frac{p}{\rho} + \nu \nabla^2 \mathbf{u}$

Vortex methods employ the vorticity form of the Navier Stokes equation:

$\nabla \times \left(\frac{\partial {\bf u}}{\partial t} + ({\bf u}\cdot\nabla){\bf u} \right) = \nabla \times \left(-\frac{1}{\rho}\nabla p + \nu\nabla^2{\bf u}\right)$

Using identities 1, 6, and 7 and the additive distributive property of the curl:

$\frac{\partial \boldsymbol{\omega}}{\partial t} + \nabla \times ( \frac{1}{2} \nabla (\mathbf{u} \cdot \mathbf{u}) - \mathbf{u} \times (\nabla \times \mathbf{u}) ) = \nu\nabla^2{\boldsymbol{\omega}}$

Using identities 1 and 8 and the definition of vorticity:

$\frac{\partial \boldsymbol{\omega}}{\partial t} - \nabla \times (\mathbf{u} \times (\nabla \times \mathbf{u}) ) = \nu\nabla^2{\boldsymbol{\omega}}$

$\frac{\partial \boldsymbol{\omega}}{\partial t} - [\mathbf{u}(\nabla \cdot (\nabla \times \mathbf{u})) - (\nabla \times \mathbf{u})(\nabla \cdot \mathbf{u}) + ((\nabla \times \mathbf{u}) \cdot \nabla)\mathbf{u} - (\mathbf{u} \cdot \nabla)(\nabla \times \mathbf{u})] = \nu\nabla^2{\boldsymbol{\omega}}$

$\frac{\partial \boldsymbol{\omega}}{\partial t} - [\mathbf{u}(\nabla \cdot \boldsymbol{\omega}) - \boldsymbol{\omega}(\nabla \cdot \mathbf{u}) + (\boldsymbol{\omega} \cdot \nabla)\mathbf{u} - (\mathbf{u} \cdot \nabla)\boldsymbol{\omega}] = \nu\nabla^2{\boldsymbol{\omega}}$

Which, assuming the volumetric dilation is zero, simplifies to:

$\frac{\partial \boldsymbol{\omega}}{\partial t} - [0 - 0 + (\boldsymbol{\omega} \cdot \nabla)\mathbf{u} - (\mathbf{u} \cdot \nabla)\boldsymbol{\omega}] = \nu\nabla^2{\boldsymbol{\omega}}$

From the definition of the material derivative:

$\frac{D \boldsymbol{\omega}}{D t} = (\boldsymbol{\omega} \cdot \nabla ){\bf u} + \nu\nabla^2\boldsymbol{\omega}$

### Vortex Filaments

The vorticity field at point $\mathbf{x}$ of a non-regularized vortex filament of length $L$ and circulation $\Gamma$ is described by:

$\boldsymbol{\omega}(\mathbf{s},t) = \Gamma \int_L \delta (\mathbf{x} - \mathbf{x}_p) \frac{\partial \mathbf{x}_p}{\partial s} ds$

Note that __the derivative $\frac{\partial \mathbf{x}_p}{\partial s}$ represents the unit vector in the direction of the vortex filament and moves along its length as the integral is evaluated. It assumes that the vorticity of each differential length _ds_ of the vortex filament is oriented in the direction of its length.__ If the traditional Dirac $\delta(\mathbf{x})$ (evaluates to unity at $\delta(\mathbf{x})$ and zero elsewhere), this is equivalent to saying that the magnitude of vorticity at every point along the vortex filament is equal to the circulation with orientation in the direction of the length. However, if a smoothing function is used in its place which does not evaluate to zero everywhere but $\mathbf{x}=0$, the integral is required to define the now three-dimensional vorticity field, which is no longer zero at points not on the filament.

## Vortex Particles (NEEDS WORK)

The vorticity field is then discretized using a Lagrangian scheme as:

$\boldsymbol{\omega}{\small ({\mathbf{x}},t)} \approx	\sum\limits_p \boldsymbol{\Gamma}_p{\small (t)} \zeta_\sigma {\small ({\bf x} - {\bf x}_p(t))}$

where $\Gamma=\int \vec{\omega} dV_{\text{particle}}\approx \vec{\omega} V$

and $\zeta_\sigma$ is a radial basis function for providing finite volume with radius $\sigma$ and non-infinite vorticity at the particle center. 

Note that the vorticity field is defined by discrete vortex elements (filaments, particles, etc.). The model considers vorticity to be null everywhere else.

First, `vm2d` is implemented using point particles, i.e. $\sigma = 0$. This does imply the possibility of singularities for velocities evaluated at particle centers. This also means that particle collisions will be very unstable. However, this is acceptable for now.

Also of significance,

$\bf v (\bf x) = g_\sigma (\bf x - \bf x_p) (-\frac{\bf x - \bf x_p}{4 \pi \left| \bf x - \bf x_p \right|^3} \times \boldsymbol{\Gamma}_p)$

where $g_\sigma$ is a smoothing function based on $\zeta_\sigma$.

## Stream Function

The velocity field may be obtained using the stream function according to

$\nabla ^2\psi(\boldsymbol x,t) = -\omega(\boldsymbol x,t)$

Note that a stream function is defined only in 2-dimensional flow, or in 2-dimensional flow that is constant in one dimension. In cases where $\psi$ is defined, the velocity field may be evaluated according to

$\boldsymbol u = \nabla \times \psi$

since

$u_x = \frac{\partial \psi}{\partial y}$, $u_y = -\frac{\partial \psi}{\partial x}$

and 

$\nabla \times \psi =$

|$\hat{x}$ | $\hat{y}$ | $\hat{z}$ |
|--------- | --------- | -------------|
|$\frac{\partial}{\partial x}$ |$\frac{\partial}{\partial y}$|$\frac{\partial}{\partial z}$|
| 0 |  0 | $\psi$|

$= \frac{\partial \psi}{\partial y} \hat{x} -\frac{\partial \psi}{\partial x} \hat{y} + 0\hat{z} = \bf u$

Conveniently, the vorticity is then expressed as:

$\boldsymbol \omega = \nabla \times(\nabla \times \boldsymbol \psi)$

From Identity 5,

$\boldsymbol \omega = \nabla(\nabla \cdot \bf \psi) - \nabla^2 \bf \psi$

Using a gauge transform as is common in electromagnetism, this may be expressed as:

$\nabla^2 \bf \psi = -\bf \omega$

which is known as Poisson's Equation.

Note that for an irrotational flow, this reduces to 

$\nabla^2 \boldsymbol{\psi} = 0$

which is verified in Anderson's _Fundamentals of Aerodynamics_.

### 3 Dimensions

(http://ossanworld.com/cfdnotes/cfdnotes_3d_streamfunctions.pdf) In 3 dimensions, a stream function may likewise be defined as follows:

$\mathbf{A} = \psi \nabla \chi$

where $\psi$ and $\chi$ are scalar functions, and $\mathbf{A}$ is the stream function defined such that $\mathbf{u} = \nabla \times \mathbf{A}$.

Then,

$\mathbf{u} = \nabla \times (\psi \nabla \chi) = \psi \nabla \times \nabla \chi + \nabla \psi \times \nabla \chi$

$\mathbf{u} = \nabla \psi \times \nabla \chi$

It can be shown that:

$Q = (\psi_1 - \psi_2)(\chi_1 - \chi_2)$

$\nabla \times \nabla \times \mathbf{A} = \boldsymbol{\omega}$

Finally that:

$- \nabla \cdot \nabla(\psi \nabla \chi) + \nabla \nabla \cdot (\psi \nabla \chi) = \boldsymbol{\omega}$

## Green's Function

For a differential operator $L$ (like $\nabla ^2$), Green's function $G$ is the solution to the differential equation

$LG = \delta$

where $\delta$ is the Dirac delta and signifies a step input. It may be used to solve an initial-value differential equation problem

$Ly = f$

where $L$ is a linear differential operator like $\nabla ^2$ and the solution is 

$y = G * f$

Note that for the Laplacian operator, 

$G = (4\pi \left|\boldsymbol x\right|)^{-1}$

Applied to the earlier equation 

$\nabla ^2\psi(\boldsymbol x,t) = -\omega(\boldsymbol x,t)$, 

we obtain:

$\psi(\boldsymbol x,t) = G(\boldsymbol x) * \boldsymbol \omega(\boldsymbol x,t)$

Or, for each of $p$ vortex filaments,

$\psi = \frac{1}{4\pi} \Sigma_p \Gamma_p \int_{Cp(t)} \frac{1}{\left| \boldsymbol x - \boldsymbol x_p \right|} \frac{\partial \boldsymbol x_p}{\partial s} ds$

## Velocity Field

Recall that $\mathbf{u} = \nabla \times \psi$, where $\psi$ is a scalar-value streamfunction of the flow. Then $\mathbf{u}$ is evaluated as:

$\mathbf{u} = \nabla \times \frac{1}{4\pi} \Sigma_p \Gamma_p \int_{Cp(t)} \frac{1}{\left| \boldsymbol x - \boldsymbol x_p \right|} \frac{\partial \boldsymbol x_p}{\partial s} ds$

Using Identity 9, we obtain:

$\mathbf{u} = \frac{1}{4\pi} \Sigma_p \Gamma_p \int_{Cp(t)} \nabla( \frac{1}{\left| \boldsymbol x - \boldsymbol x_p \right|} ) \times \frac{\partial \boldsymbol x_p}{\partial s} + \frac{1}{\left| \boldsymbol x - \boldsymbol x_p \right|} \nabla \times \frac{\partial \boldsymbol x_p}{\partial s} ds$

Since $\frac{\partial \boldsymbol x_p}{\partial s}$ is spacially constant, 

$\nabla \times \frac{\partial \boldsymbol x_p}{\partial s} = 0$, and we obtain

$\mathbf{u} = \frac{1}{4\pi} \Sigma_p \Gamma_p \int_{Cp(t)} \nabla( \frac{1}{\left| \boldsymbol x - \boldsymbol x_p \right|} ) \times \frac{\partial \boldsymbol x_p}{\partial s} ds$

$\mathbf{u} = -\frac{1}{4\pi} \Sigma_p \Gamma_p \int_{Cp(t)} \frac{ \boldsymbol{x} - \boldsymbol{x_p}}{\left| \boldsymbol x - \boldsymbol x_p \right|^3} \times \frac{\partial \boldsymbol x_p}{\partial s} ds$

## Biot-Savart Kernel

The last equation can be written as:

$\mathbf{u} = \Sigma_p \Gamma_p \int_{Cp(t)} \mathbf{K}(\mathbf{x} - \mathbf{x_p}) \times \frac{\partial \boldsymbol x_p}{\partial s} ds$

Using the definition of the convolution product,

$\mathbf{u} = (\mathbf{K}(\mathbf{x}) \times) * \boldsymbol{\omega}(\mathbf{x},t)$

In this notation, $(\mathbf{K}(\mathbf{x}) \times)$ is called the __Biot-Savart__ kernal:

$\mathbf{K}(\mathbf{x}) \times = -\frac{1}{4\pi\left| \mathbf{x} \right|^3 } \times$

Note that the vorticity is still assumed to be concentrated at the filament, but the induced velocity trails off as an inverse squared law.

## Boundary Conditions (Note from Wincklemans)

While the induced velocity due to vorticity can be evaluated using a stream function as shown above, it becomes necessary to incorporate boundary conditions such as no-flow (and no-slip?). This can be done by superimposing a potential velocity field $\mathbf{u} = \nabla \psi$.

## Regularized Kernel

A problem with using the traditional Dirac $\delta(\mathbf{x})$ for the previous analysis is an infinite discontinuity at points along the filament. In fact, where curvature is nonzero, the filament induces an infinite velocity on itself because adjacent points are infinitely close to the velocity discontinuity. To remedy this, a regularized kernel $\zeta_\sigma$ may be used rather than the Biot-Savart kernel $\mathbf{K}$.

First, vorticity can be modeled as continuously distributed around the vortex filament out to a smoothing radius $\sigma$ rather than concentrated at the center as:

$\boldsymbol{\omega_\sigma}(\mathbf{s},t) = \Gamma \int_L \zeta_\sigma (\mathbf{x} - \mathbf{x}_p) \frac{\partial \mathbf{x}_p}{\partial s} ds$

Where subscripts $_\sigma$ indicate the value has been regularized. This equation can also be written as a convolution product:

$\boldsymbol{\omega_\sigma}(\mathbf{s},t) = \zeta_\sigma * \boldsymbol{\omega}(\mathbf{x},t)$



## Circulation $\Gamma$

$\Gamma = \oint_{\circ} \bf V \cdot d \bf l= \oiint_{cs} \boldsymbol{\omega}\cdot \hat{n}dA$

* But how is this done in 3 dimensions? Why/how is $\Gamma = \int \boldsymbol{\omega}dV$ ?

## Thin Airfoil Theory

(Bertin, 6.3)

We can assume the following:

* the boundary layer has negligible effect
* airfoil is approximated by its mean camber line
* the airflow is approximated by placing vortices along the mean camber line in the presence of a freestream velocity $U_\infty$
* the total circulation is the sum of the circulation of the vortices

    * $\Gamma_{\text{total}} = \Sigma_\text{particles} \Gamma_\text{particle}$

* **The Kutta Condition** mandates that the flow over the upper surface of the wing coincide with the flow over the lower surface at the trailing edge

    * this means a stagnation point will occur at the trailing edge

        * which indicates that the vortex strength at the trailing edge must be zero

# Project Scope

Desired Outcomes for the project include:

* develop an understanding of vortex methods
* understand smoothing radius functions
* understand how to obtain aerodynamic forces using a vortex method

# Math Remarks

## Del, $\nabla$

The following $\nabla$ operations are defined:

| Operation | Result | Name |
| --------- | ------ | -----|
$\nabla \times \vec{v}$ | Tensor | Curl
$\nabla \cdot \vec{v}$ | Scalar | Divergence
$\nabla \vec{v}$ | Tensor | Gradient
$\nabla \times v$ | Undefined | Curl
$\nabla \cdot v$ | Undefined | Divergence
$\nabla v$ | Vector | Gradient

## Identities

1. $\nabla \times \nabla \psi = 0$ (curl of the gradient of a twice-differentiable scalar field is zero)

2. $\nabla \times (\mathbf{a} + \mathbf{b}) = \nabla \times \mathbf{a} + \nabla \times \mathbf{b}$ (curl is addition distributive)

3. $\nabla \cdot (\mathbf{a} + \mathbf{b}) = \nabla \cdot \mathbf{a} + \nabla \times \mathbf{b}$ (divergence is addition distributive)

4. $\nabla \cdot (\nabla \times \mathbf{a}) = 0$ (divergence of the curl of a vector field is zero)

5. $\nabla \times (\nabla \times \mathbf{a}) = \nabla (\nabla \cdot \mathbf{a}) - \nabla^2 \mathbf{a}$ (curl of the curl)

6. $\nabla \times \nabla^2 \mathbf{a} = \nabla^2 (\nabla \times \mathbf{a})$

7. $\frac{1}{2} \nabla (\mathbf{a} \cdot \mathbf{a}) = (\mathbf{a} \cdot \nabla)\mathbf{a} + \mathbf{a} \times (\nabla \times \mathbf{a}) = \mathbf{a} \nabla \mathbf{a}$

8. $\nabla \times (\mathbf{a} \times \mathbf{b}) = \mathbf{a}(\nabla \cdot \mathbf{b}) - \mathbf{b}(\nabla \cdot \mathbf{a}) + (\mathbf{b} \cdot \nabla)\mathbf{a} - (\mathbf{a} \cdot \nabla)\mathbf{b}$

9. $\nabla \times (\psi \mathbf{a}) = \nabla \psi \times \mathbf{a} + \psi\nabla \times \mathbf{a}$ (the curl of the product of a scalar function and a vector function)

## Key Concepts

1. The velocity field may be evaluated as $\mathbf{u} = \nabla \times \psi$ for some streamfunction $\psi$.
2. Vortex methods may assume vorticity to be concentrated solely inside vortex elements, and null elsewhere.
3. Vorticity is convected and deformed according to the local velocity.