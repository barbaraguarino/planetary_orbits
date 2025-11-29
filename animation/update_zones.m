function update_zones(handles, zones, theta, center)
    fn = fieldnames(zones);
    for i = 1:numel(fn)
        z = zones.(fn{i});
        r_inner = z(1);
        r_outer = z(2);

        % Cria os vértices do anel (borda externa -> borda interna invertida)
        x_out = r_outer * cos(theta) + center(1);
        y_out = r_outer * sin(theta) + center(2);
        x_in  = r_inner * cos(theta) + center(1);
        y_in  = r_inner * sin(theta) + center(2);

        X_patch = [x_out, fliplr(x_in)];
        Y_patch = [y_out, fliplr(y_in)];

        set(handles.(fn{i}), 'XData', X_patch, 'YData', Y_patch);
    end
end
