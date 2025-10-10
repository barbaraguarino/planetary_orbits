function [pos, vel, mass] = gen_initial_conditions(n, r, m, G)
  if nargin < 4
    G = 1.0;
  end

  % inicializa arrays
  pos = zeros(2, n);
  vel = zeros(2, n);
  mass = zeros(1, n);

  % massas
  mass = rand(1, n) * (m/40) + (m*0.0005);
  mass(1) = m;

  % posições
  radii = rand(1, n-1) * r + r*0.05;
  angles = rand(1, n-1) * 2 * pi;
  pos(1, 2:n) = radii .* cos(angles);
  pos(2, 2:n) = radii .* sin(angles);

  % velocidades
  x = pos(1, 2:n);
  y = pos(2, 2:n);
  vel(1, 2:n) = -y .* sqrt(G*m ./ radii) ./ radii;
  vel(2, 2:n) =  x .* sqrt(G*m ./ radii) ./ radii;
end
