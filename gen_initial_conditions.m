function [pos, vel, mass] = gen_initial_conditions(n, r, m, G)
  if nargin < 4
    G = 1.0;
  end

  % inicializa arrays
  pos = zeros(3, n);
  vel = zeros(3, n);
  mass = zeros(1, n);

  % massas
  mass = rand(1, n) * (m/10) + (m*0.0005);
  mass(1) = m;

  % posições
  radii = rand(1, n-1) * r + r * 0.5;
  angles = rand(1, n-1) * 2 * pi;
  %gera inclinações de até 15o na coordenada z
  z_rot = (rand(1, n-1) - 0.5) * (2 * deg2rad(15));


  pos(1, 2:n) = radii .* cos(angles);
  pos(2, 2:n) = radii .* sin(angles) .* cos(z_rot_rad);
  pos(3, 2:n) = radii .* sin(angles) .* sin(z_rot_rad);

  for i = 2:n
      r_vec = pos(:,i);
      r_mag = norm(r_vec);
      vel_mag = sqrt(G*m / r_mag);

      % vetor perpendicular usando produto vetorial
      ref = [0;0;1];                     % vetor de referência (eixo Z)

      v_dir = cross(ref, r_vec);         % perpendicular a r_vec
      v_dir = v_dir / norm(v_dir);       % normaliza
      vel(:,i) = vel_mag * v_dir;        % vetor velocidade final
  end
end
