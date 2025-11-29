function handles = draw_zones(zones, theta, center)
    handles = struct();
    fn = fieldnames(zones);
    for i = 1:numel(fn)
        z = zones.(fn{i});
        r_inner = z(1);
        r_outer = z(2);

        x_out = r_outer * cos(theta) + center(1);
        y_out = r_outer * sin(theta) + center(2);
        x_in  = r_inner * cos(theta) + center(1);
        y_in  = r_inner * sin(theta) + center(2);

        X_patch = [x_out, fliplr(x_in)];
        Y_patch = [y_out, fliplr(y_in)];

        handles.(fn{i}) = patch(X_patch, Y_patch, [z(3) z(4) z(5)], ...
            'FaceAlpha', z(6), ...
            'EdgeColor', 'none', ...
            'HitTest', 'off', ...
            'PickableParts', 'none');
    end
end
