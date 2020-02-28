% Runs the SHM in dynamical clustering (dynac) and forward mode
% - computes all SHM processes for all representatives
% Version
% - 2019/07/10: Uwe Ehret, initial version
% - 2019/08/17 Uwe Ehret: added 'all_reps' and 'num_reps' to output
% - 2020/02/28: Uwe Ehret, version published in GitHub

% loop over all representatives
% - this loop yields the real data, but only for the reps
for rep = 1 : num_reps

    % get the catchment number of the current representative
    c = all_reps(rep);

    % do catchment processes for
    % - a single time step (index 't') and
    % - a single catchment (index 'c')           
    shm_cat_processes  
    
end

% count the number of 'shm_cat_processes' calls for the time step
num_calls_shm_cat_processes(t) = num_calls_shm_cat_processes(t) + num_reps;

% for each cluster separately, assign the results of the cluster
% representatives to the non-rep cluster members

    % get total number of clusters
    num_clus = length(clus_reps);

    % loop over all clusters
    for clus = 1 : num_clus

        % extract the array of cluster representatives
        reps_in_clus = clus_reps{clus};

        % map the results for all state and flux variables from cluster representatives to the non-rep cluster members
        shm_dynac_map_to_nonreps

    end
