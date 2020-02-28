% Loads and initializes all data required to run the SHM model in dynamical clustering (dynac) mode
% Note
% - additional data must be loaded with script 'shm_load_and_initialize'
% Version
% - 2019/07/10: Uwe Ehret, initial version
% - 2019/09/21: Uwe Ehret, Changed clustering control variable from cat_su to cat_qout
% - 2020/02/28: Uwe Ehret, version published in GitHub

%% General dynac settings

    % create binlevels
    % specifies the number of equal-sized bins the datatype range [min, max] is subdivided in
    % [n,1] :double
    binlevels = [0 1 2 4 8 16 32 64 128 256 512 1024 2048]';

    % create datatypes
    % one datatype for each unique type
    % for min and max, give edge_lo and edge_up values
    % [o,1] :struct
    datatypes(1) = struct('type','normalized data','unit','-','min',0,'max',1);

    % set binlevel and datatype, calculate bin edges
    % - 'hist_binlevel' sets into how many bins the value range is to be subdivided
    %   '1': zero bins, '2': one bin, '3': two bins, ... '8': 64 bins (see 'binlevels')
    % - 'data_datatypes' sets the data type (here, only one datatype 'normalized data' is possible)
    % - 'edges' are the edges of the bins (required for function 'histcount')
    hist_binlevel = 8;    % specify binlevel
    data_datatypes = 1; % specify datatypes (here only one, as we work with normalized data throughout)
    [edges, ~] = f_binlevels2edges(hist_binlevel, data_datatypes, binlevels, datatypes); % calculate bin edges
    
    % set parameters for selection of cluster representatives
    min_reps_per_clus = 1;  % minimum number of cats to represent a cluster
    max_reps_per_clus = 10; % maximum number of cats to represent a cluster
    ratio_reps = 0.08;       % total number of representatives divided by total number of cats
    
    % set parameters and variables for re-clustering and bookkeeping
    clus_perc_crit = 55;        % threshold for new clustering: Whenever the percentage of cats 
                                % falling into the same clusters when comparing two clusterings
                                % falls below this threshold, jumpback mode is triggered and a new clustering is done
    clus_perc_crit_2 = 75;      % if jumpback mode is triggered, go back in time until clustering similarity is >= this threshold
                                % Note: This must be > clus_perc_crit
    t_new_clus_decision = NaN(1,num_ts); % contains a '1' whenever the decision was made to do a new clustering
    t_new_clus_jumpback = NaN(1,num_ts); % contains a '1' at the jumpback landing time whenever the decision was made to do a new clustering
    num_calls_shm_cat_processes = zeros(1,num_ts);  % number of 'shm_cat_processes' calls in each time step
                                        % this potentially adds several cases:
                                        % - during forward mode: all representatives processed at the time step
                                        % - during jumpback mode: all cats processed at the time step
    clus_perc_same = NaN(1,num_ts); % percentage of cats falling into the same clusters when comparing 
                                    % the reference clustering with the actual clustering
                                    % Note: This is NOT overwritten in jumpback periods
    
%% Load the [min max] value ranges for the states and fluxes of each cat
% - This is required for normalizing all cat states and fluxes to [0,1]
%   ranges, which is the basis for binning, which is the basis for clustering
% - The [min max] ranges have to be determined beforehand, 
%   e.g. by running the model in full resolution for some time
%   or from physical constraints consideration
% - It must be made sure that during model execution, the actual values of
%   the states and fluxes never fall outside the [min max] range

    load cat_max_min

%% Select and initialize matrix for binned states of the clustering control variable
% - the bin numbers correspond to the bins defined in 'edges'
% - so far, only one variable is used for clustering control. Could later
%   be generalized to joint consideration of several variables

    % states
        
        % fill level of the unsaturated reservoir [num_cats,num_ts]
        % Note: 
        % - This is done in a post-processing step, after all calculations are over. 
        % - This means that during jumpback periods, the fully distributed results are in the variable
        % cat_su_bin = NaN(num_cats,num_ts); 

        % fill level of the interflow reservoir [num_cats,num_ts]
        % cat_si_bin = NaN(num_cats,num_ts);    

        % fill level of the baseflow reservoir [num_cats,num_ts]
        % cat_sb_bin = NaN(num_cats,num_ts);   
    
    % fluxes
    
        % evapotranspiration from the unsaturated reservoir [num_cats,num_ts]
        % cat_et_bin = zeros(num_cats,num_ts);     

        % outflow from unsaturated reservoir [num_cats, num_ts]
        % cat_quout_bin = zeros(num_cats,num_ts); 

        % inflow to interflow reservoir [num_cats, num_ts]
        % cat_qiin_bin = zeros(num_cats,num_ts); 

        % outflow from interflow reservoir [num_cats, num_ts]
        % cat_qiout_bin = zeros(num_cats,num_ts); 

        % inflow to baseflow reservoir [num_cats, num_ts]
        % cat_qbin_bin = zeros(num_cats,num_ts); 
    
        % outflow from baseflow reservoir [num_cats, num_ts]
        % cat_qbout_bin = zeros(num_cats,num_ts); 

        % outflow from subcatchments (interflow + baseflow) [num_cats, num_ts]
        cat_qout_bin = zeros(num_cats,num_ts); 

