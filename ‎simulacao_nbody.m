clear; close all; clc;

N = 25;              % Número de corpos
T_total = 10;        % Tempo total da simulação
dt = 1e-3;           % Passo de tempo
save_freq = 25;      % Frequência de salvamento
nome_arquivo = 'nbody_pos.bin'; % Nome do arquivo binário para salvar o histórico

G = 1.0;            
massa_central = 200.0; 
raio_max_orbita = 30.0;  

[pos, vel, massas] = gerarCondicoesIniciaisNBody(N, raio_max_orbita, massa_central, G);

calcularOrbitasNBody(pos, vel, massas, G, dt, T_total, save_freq, nome_arquivo);

criarFilmeNBody(nome_arquivo, N, massas, T_total, dt, save_freq);