function calcularOrbitasNBody(pos, vel, massas, G, dt, T, save_freq, nome_arquivo)
    num_passos = round(T / dt);
    N = length(massas);

    f_pos = fopen(nome_arquivo, 'w');
    if f_pos == -1, error('Não foi possível abrir o arquivo para escrita.'); end
    
    fwrite(f_pos, pos, 'double');

    for t = 1:num_passos
        forcas = zeros(2, N); 
        
        for i = 1:N
            for j = i+1:N
                d_ij = pos(:, j) - pos(:, i); % Vetor distância
                distancia = norm(d_ij);      % Magnitude da distância
                
                if distancia > 1e-9 % Evita divisão por zero
                    magnitude_forca = (G * massas(i) * massas(j)) / (distancia^2);
                    
                    direcao = d_ij / distancia;
                    
                    vetor_forca = magnitude_forca * direcao;
                    
                    forcas(:, i) = forcas(:, i) + vetor_forca;
                    forcas(:, j) = forcas(:, j) - vetor_forca;
                end
            end
        end
        
        acc = forcas ./ massas; % Vetorizado
        
        vel = vel + acc * dt; % Atualiza a velocidade
        pos = pos + vel * dt; % Atualiza a posição com a NOVA velocidade
        
        if mod(t, save_freq) == 0
            fwrite(f_pos, pos, 'double');
        end
    end
    
    fclose(f_pos);
end