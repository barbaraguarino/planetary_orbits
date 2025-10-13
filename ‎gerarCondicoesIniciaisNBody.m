function [pos, vel, massas] = gerarCondicoesIniciaisNBody(N, R, M, G)

    pos = zeros(2, N);
    vel = zeros(2, N);
    
    massas = rand(1, N) * (M / 40) + (M * 0.00005);
    massas(1) = M; 
    
    pos(:, 1) = [0; 0];
    vel(:, 1) = [0; 0];

    raios = rand(1, N-1) * R + (R * 0.05); 
    angulos = rand(1, N-1) * 2 * pi;
    
    x = raios .* cos(angulos);
    y = raios .* sin(angulos);
    pos(:, 2:N) = [x; y];

    velocidade_orbital = sqrt(G * M ./ raios);
    vel(1, 2:N) = -velocidade_orbital .* sin(angulos);
    vel(2, 2:N) =  velocidade_orbital .* cos(angulos);
end