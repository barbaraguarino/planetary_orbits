function [pos, vel, mass] = gen_initial_conditions_3body()
    n = 3;
    mass = [1, 1, 1];

    % posições iniciais: triângulo equilátero no plano XY
    a = 1;
    pos = zeros(3, n);
    pos(:,1) = [0; 0; 0];
    pos(:,2) = [a; 0; 0];
    pos(:,3) = [a/2; sqrt(3)/2*a; 0]; % z = 0 (plano XY)

    % velocidades iniciais (em 3D, mas z = 0)
    vel = zeros(3, n);
    vel(:,1) = [0; 0.5; 0];
    vel(:,2) = [0; -0.25; 0];
    vel(:,3) = [0; -0.25; 0];

    % centraliza o centro de massa na origem
    cm = sum(pos .* mass, 2) / sum(mass);
    for i = 1:n
        pos(:,i) = pos(:,i) - cm;
    end
end
