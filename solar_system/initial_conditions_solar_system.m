function [pos, vel, mass, radius, color, n, G] = initial_conditions_solar_system()
  % Unidade de distancia: AU
  % Unidade de tempo: Anos
  % Unidade de massa: Massa Solar

  n = 10;
  pos = zeros(3, n);
  vel = zeros(3, n);
  mass = zeros(1, n);

  G = 4 * pi^2;

  % [Sol, Mercúrio, Vênus, Terra, Marte, Jupiter, Saturno, Urano, Netuno, Plutão]
  mass = [1.0, 1.6601e-7, 2.4478e-6, 3.0035e-6, 3.2272e-7, 9.5458e-4, 2.8581e-4, 4.3641e-5, 5.1497e-5, 6.556e-9];

  pos(:,1) = [0;0;0]; % Sol no centro (inicialmente)

  radii = [0.387098, 0.723332, 1.000000, 1.523679, 5.204267, 9.582017, 19.191263, 30.068963, 39.482000];
  z_rot = [7.00, 3.39, 0.00, 1.85, 1.30, 2.49, 0.77, 1.77, 17.16];
  z_rot_rad = deg2rad(z_rot);

  angles = rand(1, n-1) * 2 * pi;

  pos(1, 2:n) = radii .* cos(angles);
  pos(2, 2:n) = radii .* sin(angles) .* cos(z_rot_rad);
  pos(3, 2:n) = radii .* sin(angles) .* sin(z_rot_rad);

  % Cálculo da Velocidade
  planet_pos = pos(:, 2:n);
  r = vecnorm(planet_pos);
  v_mag = sqrt(G * mass(1) ./ r);
  n_vec = [sin(z_rot_rad); zeros(1, n-1); cos(z_rot_rad)];
  v_vec = cross(n_vec, planet_pos, 1);
  v_vec_normalized = v_vec ./ vecnorm(v_vec);
  vel(:, 2:n) = v_vec_normalized .* v_mag;

  % Ajuste do baricentro
  % O Sol não fica parado; ele se move constantemente.

  % Calcula o momento total dos planetas (P = m*v)
  % m_planets [1, n-1], v_planets [3, n-1]
  m_planets_broadcast = mass(2:n);
  v_planets = vel(:, 2:n);

  % Broadcasting multiplica m(1,j) por v(i,j)
  momentum_planets = v_planets .* m_planets_broadcast;
  total_momentum_planets = sum(momentum_planets, 2);

  % Defini a velocidade do Sol para que o momento total seja zero
  % P_sol = -P_planetas
  % v_sol = -P_planetas / m_sol
  vel(:, 1) = -total_momentum_planets / mass(1);

  % Dados visuais
  radius = zeros(1, n);
  radius(1) = 0.25;
  radius(2:n) = 0.25;
  color = ['y','k','m','b','r','c','g','c','b','m'];
end
