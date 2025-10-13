function criarFilmeNBody(nome_arquivo, N, massas, T, dt, save_freq)
  
    f_pos = fopen(nome_arquivo, 'r');
    if f_pos == -1
        error('Não foi possível abrir o arquivo para leitura.');
    end
    
    historico = fread(f_pos, [2*N, Inf], 'double');
    fclose(f_pos);
    
    num_frames = size(historico, 2);
    
    nome_video = 'simulacao_nbody.avi';
    video = VideoWriter(nome_video, 'Motion JPEG AVI');
    video.FrameRate = 30;
    open(video);

    fig = figure;
    fig.Position = [100 100 800 800];
    
    tamanhos = sqrt(massas) / 2;
    
    lim_max = max(abs(historico(:))) * 1.1;
    
    for frame_idx = 1:num_frames
        clf;
        
        pos_frame = historico(:, frame_idx);
        x_pos = pos_frame(1:N);
        y_pos = pos_frame(N+1:end);
        
        scatter(x_pos, y_pos, tamanhos, 'filled');
        
        axis equal;
        axis([-lim_max, lim_max, -lim_max, lim_max]);
        grid on;
        
        tempo_atual = (frame_idx - 1) * save_freq * dt;
        title(sprintf('Simulação N-Corpos | Tempo: %.2f', tempo_atual));
        xlabel('Posição X');
        ylabel('Posição Y');
        
        drawnow;
        
        frame = getframe(gcf);
        writeVideo(video, frame);
    end

    close(video);
    close(fig);
end