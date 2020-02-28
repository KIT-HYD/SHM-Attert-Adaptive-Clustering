% Run the model in standard mode (full resolution) up to the time when the jumpback decision was made
% Version
% - 2019/07/10: Uwe Ehret, initial version
% - 2019/09/21: Uwe Ehret, Changed clustering control variable from cat_su to cat_qout
% - 2020/02/28: Uwe Ehret, version published in GitHub

while t <= told

    % loop over all subcatchments
    for c = 1 : num_cats
        % do catchment processes for
        % - a single time step (index 't') and
        % - a single catchment (index 'c')
        shm_cat_processes 
        
    end
    
    % count the number of 'shm_cat_processes' calls for the time step
    num_calls_shm_cat_processes(t) = num_calls_shm_cat_processes(t) + num_cats;  
    
    % raise the time counter
    t = t + 1; 

end

% do a new reference clustering of all cats based on the states at t=told

    % normalize states of the clustering control variable
    % - Note this is done at t-1, as the time counter was already raised
    %   by one before leaving the previous while-loop
    dummy = (cat_qout(:,t-1) - cat_qout_min) ./ (cat_qout_max - cat_qout_min);

    % bin --> this is also the clustering step
    [~,~,clus_ref] = histcounts(dummy,edges{1});
    
    % find new cluster representatives
    [clus_reps,clus_labels,all_reps, num_reps] = f_find_cluster_representatives(clus_ref,ratio_reps,min_reps_per_clus,max_reps_per_clus);

    % extract the clustering of the reps (for later evaluation of clustering similarity)
    clus_ref_reps = clus_ref(all_reps); 
    

% leave the jumpback mode
jumpback_yesno = 0;