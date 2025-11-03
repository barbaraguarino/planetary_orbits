function [pos, vel, mass, radius, color, n, G] = gen_initial_conditions_solar_system()
  %Unidade de distancia: AU (Astronomical Units = Distancia entre a Terra e o Sol)
  %Unidade de tempo: Anos
  %Unidade de massa: Massa Solar

  n = 10;

  % inicializa arrays
  pos = zeros(3, n);
  vel = zeros(3, n);
  mass = zeros(1, n);
  radius = zeros(1, n);

  G = 4 * pi^2; %Constante gravitacional adaptada para as unidades utilizadas

  %Índices em ordem: [Sol, Mercúrio, Vênus, Terra, Marte, Jupiter, Saturno, Urano, Netuno, Plutão]

  mass = [1.0, 1.6601e-7, 2.4478e-6, 3.0035e-6, 3.2272e-7, 9.5458e-4, 2.8581e-4, 4.3641e-5, 5.1497e-5, 6.556e-9];

  pos(:,1) = [0;0;0];

  radii = [0.387098, 0.723332, 1.000000, 1.523679, 5.204267, 9.582017, 19.191263, 30.068963, 39.482000];
  z_rot = [7.00, 3.39, 0.00, 1.85, 1.30, 2.49, 0.77, 1.77, 17.16];
  z_rot_rad = deg2rad(z_rot);

  angles = rand(1, n-1) * 2 * pi;

  pos(1, 2:n) = radii .* cos(angles);
  pos(2, 2:n) = radii .* sin(angles) .* cos(z_rot_rad);
  pos(3, 2:n) = radii .* sin(angles) .* sin(z_rot_rad);

  vel(:,1) = [0;0;0];

  for i = 2:n
    planet_pos = pos(:,i);           % posição do planeta
    r = norm(planet_pos);            % distância ao Sol
    v_mag = sqrt(G * mass(1) / r);   % velocidade circular

    % vetor normal ao plano da órbita (inclinacao)
    inc = z_rot_rad(i-1);

    n_vec = [sin(inc); 0; cos(inc)];  % normal aproximada
    v_vec = cross(n_vec, planet_pos);  % perpendicular ao raio
    v_vec = v_vec / norm(v_vec) * v_mag;  % ajusta módulo

    vel(:,i) = v_vec;
  end

  vel(:,1) = [0;0;0];  % Sol inicialmente parado

  radius(1) = 0.25;
  radius(2:n) = 0.25;

  color = ['y','k','m','b','r','c','g','c','b','m'];
end
