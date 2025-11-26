import numpy as np
from matplotlib import pyplot as plt

# constant
G = 1.

# input
#############################################################
precision="32"    # float precision
N = 25            # number of bodies
nt = 50_000       # number of time steps
dt = 1e-04        # time step
save_freq = 25    # output frequency (save state at every ?? steps)
#############################################################

#############################################################
# auxiliary function to generate initial conditions that are
# (visually) similar to planets in a star's  orbit.
def gen_initial_conditions(n,r,m,G=1.0,dtype='float64',pos=None,vel=None,mass=None):
  # check if arrays were provided
  if pos is None:
    pos = np.zeros(2*n, dtype=dtype)
  if vel is None:
    vel = np.zeros(2*n, dtype=dtype)
  if mass is None:
    mass = np.zeros(n, dtype=dtype)

  # central mass at origin, smaller bodies dispersed around it
  mass[:] = np.random.rand(n).astype(dtype)*(m/40) + (m*0.00005)
  mass[0] = m  # central mass

  # generate positions for orbiting particles
  radii = np.random.rand(n-1)*r + (r*0.05)  # avoid r~0
  angles = np.random.rand(n-1)*2*np.pi
  pos[1:n]  = radii * np.cos(angles)
  pos[n+1:] = radii * np.sin(angles)
  x = pos[1:n]
  y = pos[n+1:]

  # velocities perpendicular to radius
  vel[1:n]  = -y * np.sqrt(G*m/radii)/radii
  vel[n+1:] =  x * np.sqrt(G*m/radii)/radii
  
  return pos, vel, mass
#############################################################

pos, vel, mass = gen_initial_conditions(N,30.0,200.0,dtype=f"float{precision}")

acc = np.zeros_like(pos)

ux = pos[:N]
uy = pos[N:]
vx = vel[:N]
vy = vel[N:]
ax = acc[:N]
ay = acc[N:]

pos.tofile('nbody_pos.bin')

f_pos = open('nbody_pos.bin','ab')

for tt in range(1,nt+1):
  pass
  #######################
  # COMPLETAR
  #######################
  
f_pos.close()

#############################################################
# read history from file and plot
history = np.fromfile("nbody_pos.bin",dtype=f'float{precision}')

plt.ion()
circles = []
fig, ax = plt.subplots()
ax.set(xlim=[-40,40],ylim=[-40,40])
for x, y, r in zip(history[:N], history[N:2*N], mass):
    circle = plt.Circle((x, y), (r**0.5)/2., color='b')
    ax.add_patch(circle)
    circles.append(circle)

ax.set_aspect('equal')

for frame in range(1,nt//save_freq):
    xx = history[2*N*frame:2*N*frame+N]
    yy = history[2*N*frame+N:2*N*(frame+1)]
    for x, y, circle in zip(xx,yy,circles):
        circle.set_center((x, y)) 

    plt.draw()
    fig.canvas.flush_events()
    #time.sleep(0.005)

plt.ioff()
plt.show()
#############################################################
