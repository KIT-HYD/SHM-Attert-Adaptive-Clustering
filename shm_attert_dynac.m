% 2020/02/28 Uwe Ehret
% SHM Attert in the dynamical clustering version
% Note
% - calculation order is always
%   - with state at t-1 ...
%   - calculate fluxes during dt (t-1-->t) ...
%   - store the fluxes of dt(t-1-->t) at t
%   - with fluxes, calculate state at t
% - time stamp is always END of a time period
% - the model can be operated in two modes
%   - standard mode: the model is run in full resolution, i.e. each cat is
%     calucated independently
%   - dynac mode: the model is run in dynamical clustering mode
%   - static mode: the model is run with a single clustering that is kept throughout
% Version
% - 2019/07/10: Uwe Ehret, initial version
% - 2019/09/21: Uwe Ehret, Changed clustering control variable from cat_su to cat_qout

clear all
close all
clc

% set the operation mode
dynac_yesno = 1; % 0=standard mode, 1=dynac mode, 2=static mode

% Load and initialize all data required to run the SHM model in standard (full resolution) mode
% - this step is required both for standard and dynac mode
shm_load_and_initialize

%% Standard mode
if dynac_yesno == 0
    
    % start timer
    tic
    
    % loop over all time steps
    for t = 2 : num_ts
        % t
        
        % loop over all subcatchments
        for c = 1 : num_cats

            % do catchment processes for
            % - a single time step (index 't') and
            % - a single catchment (index 'c')
            shm_cat_processes 

        end

     end
    
    % do the routing (compute all rve processes)
    shm_rve_processes
    
    % stop timer
    toc
    
    % stop the script
    return
end

%% Dynac mode

if dynac_yesno == 1

    % load  and initialize all data required to run the SHM model in dynamical clustering (dynac) mode
    shm_dynac_load_and_initialize

    % set the initial reference clustering of all cats 
        
        clus_ref = ones(num_cats,1);   % all cats are in one large group

        % find initial cluster representatives
        % clus_reps [num_clus,1]: for each cluster, list of representatives (cat index)
        % clus_labels [num_clus,1]: for each cluster, its label (bin number)
        [clus_reps,clus_labels,all_reps, num_reps] = f_find_cluster_representatives(clus_ref,ratio_reps,min_reps_per_clus,max_reps_per_clus);

        % extract the clustering of the reps (for later evaluation of clustering similarity)
        clus_ref_reps = clus_ref(all_reps);

        % note that a new clustering was done
        t_new_clus_decision(2) = 1; % note: this is done at time step 2, because the time loop starts at t=2

    % set the initial value for the jumpback mode
    jumpback_yesno = 0; % 0=not in jumpback mode, 1=jumpback mode    

    % start timer
    tic
    
    % loop over all time steps
    % - this must be a 'while' loop, as the time index variable can go forward and backward
    % - the loop must start at t = 2, such that values at t-1 exist
    t = 2;
    while t <= num_ts
        t

        % Are we in jumpback mode or not?
        if jumpback_yesno == 0 % we are in normal forward mode

            % run the model in clustering mode
            shm_dynac_forward_mode

            % compare the reference clustering with the current 
            % and decide whether a new clustering must be done
            % (which means entering jumpback mode)
            shm_dynac_evaluate_clustering

        else    % we are in jumpback mode

            % run the model in full resolution during the jumpback period
            % and then do a new clustering
            shm_dynac_jumpback_mode

        end  

    end      

    % do the routing (compute all rve processes)
    shm_rve_processes

    % stop timer
    toc
    
    % some postprocessing
        
        % calculate average number of cats processed per timestep
        average_calls_shm_cat_processes = mean(num_calls_shm_cat_processes)

        % calculate # of new clustering decisions
        new_clusterings = length(find(t_new_clus_decision==1))

    % create plots
    figure
    hold on
    yyaxis left
    plot(DateTimeSeries,t_new_clus_decision,'or');
    plot(DateTimeSeries,t_new_clus_jumpback,'.r');
    plot(DateTimeSeries,clus_perc_same/100);
    plot(DateTimeSeries,zeros(num_ts,1)+clus_perc_crit/100);
    plot(DateTimeSeries,zeros(num_ts,1)+clus_perc_crit_2/100);
    ylim([0 1.1])
    ylabel('clustering similarity [0,1]')
    yyaxis right
    plot(DateTimeSeries,num_calls_shm_cat_processes)
    plot(DateTimeSeries,zeros(num_ts,1)+num_cats)
    ylabel('# of cats calculated')
    xlabel('time steps')
    hold off
    saveas(gcf,'clustering.fig');

    % save the entire run
    save results_run_
end

%% Static mode

if dynac_yesno == 2
    
    % start timer
    tic
    
    % load  and initialize all data required to run the SHM model in static clustering (static) mode
    shm_static_load_and_initialize
    
    % set the static clustering
    	% EITHER
    	load clus_ref_static % static lossless clustering with 24 clusters
    	% OR
    	% load clus_ref_fullresolution %1 cat per cluster (same as standard mode)
    
    % find static cluster representatives
    % clus_reps [num_clus,1]: for each cluster, list of representatives (cat index)
    % clus_labels [num_clus,1]: for each cluster, its label (bin number)
    [clus_reps,clus_labels,all_reps, num_reps] = f_find_cluster_representatives(clus_ref,ratio_reps,min_reps_per_clus,max_reps_per_clus);

    % loop over all time steps
    for t = 2 : num_ts
        % t
        
        % run the model in clustering mode
        shm_dynac_forward_mode
        
     end
    
    % do the routing (compute all rve processes)
    shm_rve_processes

    % stop timer
    toc
    
    % stop the script
    return    
end
