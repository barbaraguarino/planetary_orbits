function [pos, vel, mass] = gen_initial_conditions_3body()
    n = 3;
    mass = [1, 1, 1];

    % posições iniciais: triângulo equilátero
    a = 1;
    pos = zeros(2,n);
    pos(:,1) = [0;0];
    pos(:,2) = [a;0];
    pos(:,3) = [a/2; sqrt(3)/2*a];

    % velocidades iniciais (aprox. órbita circular do CM)
    vel = zeros(2,n);
    vel(:,1) = [0; 0.5];
    vel(:,2) = [0; -0.25];
    vel(:,3) = [0; -0.25];

    % centraliza o centro de massa na origem
    cm = sum(pos .* mass, 2) / sum(mass);
    for i = 1:n
        pos(:,i) = pos(:,i) - cm;
    end
end

