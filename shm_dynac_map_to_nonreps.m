% Maps the results for all state and flux variables from the chosen one representative of a cluster to the non-rep cluster members
% Version
% - 2019/07/11: Uwe Ehret, initial version
% - 2019/09/21: Uwe Ehret, Changed clustering control variable from cat_su to cat_qout
% - 2020/02/28: Uwe Ehret, version published in GitHub

 % for all reps, normalize the result for the cluster control variable
rep_norm = (cat_qout(reps_in_clus,t) - cat_qout_min(reps_in_clus)) ./ (cat_qout_max(reps_in_clus) - cat_qout_min(reps_in_clus));

% from the normalized results, find the rep with the median result from all reps of the cluster
% --> this will be the chosen one donating the results for all non-rep cluster members
dummy = abs(rep_norm - median(rep_norm));   % calculate distance of all results from median
indx_closest_to_median = find(dummy == min(dummy)); % find the result closest to the median
indx_closest_to_median = indx_closest_to_median(1); % if there are more than one, just take the first
indx_chosen_one = reps_in_clus(indx_closest_to_median); % cat index of the chosen one

% find indices of all cluster members
indx_all_in_clus = find(clus_ref == clus_labels(clus));

% find indices of all non-rep cluster members 
dummy = find(~ismember(indx_all_in_clus,reps_in_clus));
indx_non_reps = indx_all_in_clus(dummy);

% map the results for all state and flux variables from the chosen one to the non-rep cluster members
% - for the chosen one, normalize the real data of each variable:
%   all non-rep cluster members will have the same normalized result
% - for each non-rep cluster member, calculate the real result by
%   backtransformation of the normalized value with its own [min max] range

    % cat_su
    chosen_one_norm = (cat_su(indx_chosen_one,t) - cat_su_min(indx_chosen_one)) ./ (cat_su_max(indx_chosen_one) - cat_su_min(indx_chosen_one));
    cat_su(indx_non_reps,t) = chosen_one_norm * (cat_su_max(indx_non_reps) - cat_su_min(indx_non_reps)) + cat_su_min(indx_non_reps);

    % cat_si
    chosen_one_norm = (cat_si(indx_chosen_one,t) - cat_si_min(indx_chosen_one)) ./ (cat_si_max(indx_chosen_one) - cat_si_min(indx_chosen_one));
    cat_si(indx_non_reps,t) = chosen_one_norm * (cat_si_max(indx_non_reps) - cat_si_min(indx_non_reps)) + cat_si_min(indx_non_reps);

    % cat_sb
    chosen_one_norm = (cat_sb(indx_chosen_one,t) - cat_sb_min(indx_chosen_one)) ./ (cat_sb_max(indx_chosen_one) - cat_sb_min(indx_chosen_one));
    cat_sb(indx_non_reps,t) = chosen_one_norm * (cat_sb_max(indx_non_reps) - cat_sb_min(indx_non_reps)) + cat_sb_min(indx_non_reps);

    % cat_et
    chosen_one_norm = (cat_et(indx_chosen_one,t) - cat_et_min(indx_chosen_one)) ./ (cat_et_max(indx_chosen_one) - cat_et_min(indx_chosen_one));
    cat_et(indx_non_reps,t) = chosen_one_norm * (cat_et_max(indx_non_reps) - cat_et_min(indx_non_reps)) + cat_et_min(indx_non_reps);

    % cat_quout
    chosen_one_norm = (cat_quout(indx_chosen_one,t) - cat_quout_min(indx_chosen_one)) ./ (cat_quout_max(indx_chosen_one) - cat_quout_min(indx_chosen_one));
    cat_quout(indx_non_reps,t) = chosen_one_norm * (cat_quout_max(indx_non_reps) - cat_quout_min(indx_non_reps)) + cat_quout_min(indx_non_reps);

    % cat_qiin
    chosen_one_norm = (cat_qiin(indx_chosen_one,t) - cat_qiin_min(indx_chosen_one)) ./ (cat_qiin_max(indx_chosen_one) - cat_qiin_min(indx_chosen_one));
    cat_qiin(indx_non_reps,t) = chosen_one_norm * (cat_qiin_max(indx_non_reps) - cat_qiin_min(indx_non_reps)) + cat_qiin_min(indx_non_reps);

    % cat_qiout
    chosen_one_norm = (cat_qiout(indx_chosen_one,t) - cat_qiout_min(indx_chosen_one)) ./ (cat_qiout_max(indx_chosen_one) - cat_qiout_min(indx_chosen_one));
    cat_qiout(indx_non_reps,t) = chosen_one_norm * (cat_qiout_max(indx_non_reps) - cat_qiout_min(indx_non_reps)) + cat_qiout_min(indx_non_reps);

     % cat_qbin
    chosen_one_norm = (cat_qbin(indx_chosen_one,t) - cat_qbin_min(indx_chosen_one)) ./ (cat_qbin_max(indx_chosen_one) - cat_qbin_min(indx_chosen_one));
    cat_qbin(indx_non_reps,t) = chosen_one_norm * (cat_qbin_max(indx_non_reps) - cat_qbin_min(indx_non_reps)) + cat_qbin_min(indx_non_reps);

    % cat_qbout
    chosen_one_norm = (cat_qbout(indx_chosen_one,t) - cat_qbout_min(indx_chosen_one)) ./ (cat_qbout_max(indx_chosen_one) - cat_qbout_min(indx_chosen_one));
    cat_qbout(indx_non_reps,t) = chosen_one_norm * (cat_qbout_max(indx_non_reps) - cat_qbout_min(indx_non_reps)) + cat_qbout_min(indx_non_reps);

    % cat_qout
    chosen_one_norm = (cat_qout(indx_chosen_one,t) - cat_qout_min(indx_chosen_one)) ./ (cat_qout_max(indx_chosen_one) - cat_qout_min(indx_chosen_one));
    cat_qout(indx_non_reps,t) = chosen_one_norm * (cat_qout_max(indx_non_reps) - cat_qout_min(indx_non_reps)) + cat_qout_min(indx_non_reps);
