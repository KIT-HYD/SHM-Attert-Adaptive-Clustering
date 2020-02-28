% Loads and initializes all data required to run the SHM model in standard (full resolution) mode
% Note
% - bla
% Version
% - 2019/07/08: Uwe Ehret, initial version
% - 2020/02/28: Uwe Ehret, version published in GitHub

%% General settings

    num_ts = 730; %43848; % # of time steps: 35064 = calibration period, 43848 = entire time series, 1 month = 730, 1 year = 8760
    dt = 1; % [h] length of a single time step. NOTE: Keep this at '1'
    startDateTime = datetime('2011-11-01 00:00','InputFormat','yyyy-MM-dd HH:mm');
    num_cats = 173; % # of subcatchment elements
    num_rves = 147; % # of river elements

    % generate a DateTime series
    DateTimeSeries = startDateTime + hours(0:1:num_ts-1);

%% Load the model structural data (from preprocessing.m)

    load shm_attert_structure
        
%% Load observed time series
% Required variables:
% - obs_p   precipitation [m/h]
% - obs_t   air temperature [°C]
% - obs_v   wind [m/s]
% - obs_rh  relative humidity [%]
% - obs_rg  global radiation [W/m²]
% Format of all matrices: 
% - [*,num_ts], where * is the number of individual time series, which can differ among the variables
% - the row a particular time series is in must correspond to the entries in 'cat_*_station_index'
% Time stamp is always END of a time period

    load obs_forcing_timeseries    
    
%% Initialize matrices
% Note: 
% - state variables are initialized with 'NaN'
% - flux variables are initialized with '0'

% subcatchments (cat)

    % [m] fill level of the unsaturated reservoir [num_cats,num_ts]
    cat_su = NaN(num_cats,num_ts); 
    
    % [m³/h] evapotranspiration from the unsaturated reservoir [num_cats,num_ts]
    cat_et = zeros(num_cats,num_ts);     
    
    % [m³/h] outflow from unsaturated reservoir [num_cats, num_ts]
    cat_quout = zeros(num_cats,num_ts); 

    % [m³/h] inflow to interflow reservoir [num_cats, num_ts]
    cat_qiin = zeros(num_cats,num_ts); 

    % [m³/h] inflow to baseflow reservoir [num_cats, num_ts]
    cat_qbin = zeros(num_cats,num_ts); 
    
    % [m] fill level of the interflow reservoir [num_cats,num_ts]
    cat_si = NaN(num_cats,num_ts); 
    
    % [m³/h] outflow from interflow reservoir [num_cats, num_ts]
    cat_qiout = zeros(num_cats,num_ts); 
    
    % [m] fill level of the baseflow reservoir [num_cats,num_ts]
    cat_sb = NaN(num_cats,num_ts);
    
    % [m³/h] outflow from baseflow reservoir [num_cats, num_ts]
    cat_qbout = zeros(num_cats,num_ts); 

    % [m³/h] outflow from subcatchments (interflow + baseflow) [num_cats, num_ts]
    cat_qout = zeros(num_cats,num_ts); 
    
% river elements (rve)

    % [m³] water volume in river element [num_rves,num_ts]
    rve_s = NaN(num_rves,num_ts);
    
    % [m³/h] discharge from river element [num_rves,num_ts]
    rve_q = zeros(num_rves,num_ts); 
    
%% Assign initial values to state variables
% Note: Fluxes don't need initial values, they will be calculated from the states

    % [m] fill level of the unsaturated reservoir [num_cats,num_ts]
    cat_su(:,1) = 0.05;
    
    % [m] fill level of the interflow reservoir [num_cats,num_ts]
    cat_si(:,1) = 0; 

    % [m] fill level of the baseflow reservoir [num_cats,num_ts]
    cat_sb(:,1) = 0.05; 
    
% river elements (rve)

    % [m³] water volume in river element [num_rves,num_ts]
    rve_s(:,1) = 10;      
    
    
    