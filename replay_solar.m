function replay_solar(filename)

    clc;

    if exist('solar_system', 'dir'), addpath('solar_system'); end

    if ~exist('simulation_examples', 'dir')
        mkdir('simulation_examples');
    end

    % --- Tratamento da Entrada ---

    if nargin < 1
        % Se não tiver argumentos
        target_name = 'simulacao_solar';
    else
        % Se tiver argumentos
        target_name = filename;
    end

    % Remove extensão .bin se tiver
    target_name = regexprep(target_name, '\.bin$', '');

    % --- Lógica de Busca Inteligente ---

    % Tenta achar na pasta de exemplos
    path_examples = fullfile('simulation_examples', target_name);

    % Tenta achar na pasta padrão
    path_data = fullfile('data', target_name);

    final_path = '';

    if exist([path_examples, '.bin'], 'file')
        final_path = path_examples;
        disp(['[INFO] Arquivo encontrado em Exemplos: ', final_path]);

    elseif exist([path_data, '.bin'], 'file')
        final_path = path_data;
        disp(['[INFO] Arquivo encontrado em Data: ', final_path]);

    else
        error(['Erro: O arquivo "' target_name '" não foi encontrado em "simulation_examples" nem em "data".']);
    end

    disp('Recuperando metadados do Sistema Solar...');

    % --- Carrega os Dados Visuais ---

    % Recupera cores, nomes e tamanhos.
    [sys] = initial_conditions_solar_system();

    % --- Executa a Animação ---

    try
        disp('Iniciando player...');
        animate_solar(final_path, length(sys.name), sys.name, sys.color, sys.size, false, true);

    catch ME
        disp('--- [ERRO] Falha ao reproduzir a animação ---');
        disp(['Mensagem: ' ME.message]);
    end
end
