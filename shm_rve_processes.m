% Calculates all SHM river processes
% Note
% - When calling this script, the following variables must be in the workspace:
%   - num_ts:               # of time steps of the shm run
%   - num_rves:             # of river elements
%   - cat_nextdown_index:   [-] index of the rve the cat drains into [num_cats,1]
%   - rve_s:                [m³] water volume in river element [num_rves,num_ts]
%   - cat_qout:             [m³/h] outflow from subcatchments (interflow + baseflow) [num_cats, num_ts]
%   - rve_nextdown_index:   [-] index of the rve the rve drains into [num_rves,1]
%   - rve_q:                [m³/h] discharge from river element [num_rves,num_ts]
%   - rve_k:                [m³] water volume in river element [num_rves,num_ts]
% Version
% - 2019/07/08: Uwe Ehret, initial version
% - 2020/02/28: Uwe Ehret, version published in GitHub

% loop over all time steps
for t = 2 : num_ts

    % loop over all river elements
    for r = 1 : num_rves

        % inflow from subcatchments [m³]
            indx_my_cat_inflows = find(cat_nextdown_index == r); % find indices of all subcatchments draining into the rve
            rve_s(r,t) = rve_s(r,t-1) + sum(cat_qout(indx_my_cat_inflows,t)); % add the outflow from all subcatchments to the rve

        % inflow from upstream rivers [m³]
             indx_my_rve_inflows = find(rve_nextdown_index == r); % find indices of all rves draining into the rve
             rve_s(r,t) = rve_s(r,t) + sum(rve_q(indx_my_rve_inflows,t)); % add the outflow from all rves to the rve

        % outflow from river element [m³]
            rve_q(r,t) = rve_s(r,t)/rve_k(r);

        % subtract outflow from rve [m³]
            rve_s(r,t) = rve_s(r,t) - rve_q(r,t);

    end
    
end