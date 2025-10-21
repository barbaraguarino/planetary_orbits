function run_simulation(n, r, m, G,n_steps, step_size, steps_between_save, filename)
  [pos_vet, vel_vet, m_vet]=gen_initial_conditions(n,r,m,G);
  %[pos_vet, vel_vet, m_vet]=gen_initial_conditions_3body();
  %simulate_planetary_orbits(pos_vet,vel_vet,m_vet,n_steps,step_size,25,G,filename);
  simulate_planetary_orbits_vectorized(pos_vet,vel_vet,m_vet,n_steps,step_size,steps_between_save,G,filename);
  animate_simulation(filename, m_vet);
end

