% Calculates all SHM catchment processes
% Note
% - when called, the catchment processes are calculated for
%   - a single time step (index 't') and
%   - a single catchment (index 'c')
% - When calling this script, the following variables must be in the workspace:
%   - basically all structure, state and flux variables of SHM
% Version
% - 2019/07/08: Uwe Ehret, initial version
% - 2020/02/28: Uwe Ehret, version published in GitHub
            
% split rainfall into runoff and unsatured zone wetting
    p_vol = obs_p(cat_p_station_index(c),t) * cat_area(c);  % rainfall volume [m�]
    psi = (cat_su(c,t-1) / cat_sumax(c) ) ^ cat_beta(c);    % runoff coefficient [-] (part of rain becoming runoff) 
    cat_quout(c,t) = p_vol * psi;                           % runoff [m�]
    cat_su(c,t) = cat_su(c,t-1) + ((p_vol * (1 - psi)) / cat_area(c) ); % wetting of unsaturated zone [m]

% limit unsaturated zone to sumax, excess becomes direct runoff
    if cat_su(c,t) > cat_sumax(c)
        cat_quout(c,t) = cat_quout(c,t) + ((cat_su(c,t) - cat_sumax(c)) * cat_area(c)) ; % [m�] add excess volume to direct runoff
        cat_su(c,t) = cat_sumax(c); % [m] limit the fill level to sumax
    end

% evapotranspiration

    % land use correction factor [-]
    klu = kc(cat_lu_index(c),month(DateTimeSeries(t)));

    % soil moisture correction factor [-]
    kteta = f_r_teta(cat_su(c,t),cat_sumax(c));

    % reference evapotranspiration [m�]
        T = obs_t(cat_t_station_index(c),t);    % [�C]  air temperature
        Rg = obs_rg(cat_rg_station_index(c),t); % [W/m�]global radiation
        v2 = obs_v(cat_v_station_index(c),t);   % [m/s] 2m wind velocity
        RH = obs_rh(cat_rh_station_index(c),t); % [%]   relative humidity

        etpo = cat_area(c) * f_ETpo_Penman(T, dt*3600, Rg, v2, RH) / 1000; % [m�]

        % limit etpo to values >=0 (can become negative if RH > 100%)
        if etpo < 0
            etpo = 0;
        end

    % final evapotranspiration [m�]
    cat_et(c,t) = etpo * klu * kteta;

% subtract evapotranspiration from unsaturated zone reservoir [m]
    cat_su(c,t) = cat_su(c,t) - (cat_et(c,t) / cat_area(c));

% limit evapotranspiration if necessary
    if cat_su(c,t) < 0
        cat_et(c,t) = cat_et(c,t) + ( cat_su(c,t) * cat_area(c) ); % [m�] Note: As cat_su(c,t) is negative, cat_et will become smaller
        cat_su(c,t) = 0; % [m]
    end

% inflow to interflow reservoir [m�]
    cat_qiin(c,t) = cat_quout(c,t) * cat_perc(c);

% new storage in interflow reservoir due to inflow [m]
    cat_si(c,t) = cat_si(c,t-1) + ( cat_qiin(c,t) / cat_area(c) );

% outflow from interflow reservoir [m�]
    cat_qiout(c,t) = (cat_si(c,t) / cat_ki(c)) * cat_area(c);

% new storage in interflow reservoir due to outflow [m]            
    cat_si(c,t) = cat_si(c,t) - ( cat_qiout(c,t) / cat_area(c) );

% inflow to baseflow reservoir [m�]
    cat_qbin(c,t) = cat_quout(c,t) * (1 - cat_perc(c));

% new storage in baseflow reservoir due to inflow [m]
    cat_sb(c,t) = cat_sb(c,t-1) + ( cat_qbin(c,t) / cat_area(c) );

% outflow from baseflow reservoir [m�]
    cat_qbout(c,t) = (cat_sb(c,t) / cat_kb(c)) * cat_area(c);

% new storage in baseflow reservoir due to outflow [m]            
    cat_sb(c,t) = cat_sb(c,t) - ( cat_qbout(c,t) / cat_area(c) );  

% total outflow (sum of interflow and baseflow) [m�]
    cat_qout(c,t) = cat_qiout(c,t) + cat_qbout(c,t);

