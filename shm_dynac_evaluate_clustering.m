% Compares the actual clustering with the reference clustering and
% decides whether it's time for re-clustering
% - this is done for the clustering control variable only!
% - this is done for the representatives only!
% Version
% - 2019/07/10: Uwe Ehret, initial version
% - 2019/08/17: Uwe Ehret, changed clustering comparison
% - 2019/09/21: Uwe Ehret, Changed clustering control variable from cat_su to cat_qout
% - 2020/02/28: Uwe Ehret, version published in GitHub

% normalize and bin (=cluster) the values of the clustering control variable for all representatives at the current time step

    % for all reps, normalize states of the clustering control variable at time t
    dummy = (cat_qout(all_reps,t) - cat_qout_min(all_reps)) ./ (cat_qout_max(all_reps) - cat_qout_min(all_reps));

    % bin --> this is also the clustering step
    [~,~,clus_act_reps] = histcounts(dummy,edges{1}); 
    
% find a mapping between the cluster names of the reference grouping and the actual grouping
clus_act_reps_mapped = f_map_classification_hm(clus_ref_reps,clus_act_reps); 

% with the mapped clustering labels, calculate the confusion matrix
C = confusionmat(clus_ref_reps,clus_act_reps_mapped);

% get the percentage of values on the main diagonal 
clus_perc_same(t) = 100 * (sum(diag(C)) / num_reps);

% decide whether the old (reference) clustering is still ok, or whether a new clustering should be done
% (which means jumpback mode must be entered)
if clus_perc_same(t) < clus_perc_crit % new clustering required

    % find out how long to jump back in time
    % - by default this is back until clus_perc_same >= clus_perc_crit_2
    % - ... but it should not go further back than the time of the last new clustering
    t_new_1 = find(clus_perc_same >= clus_perc_crit_2,1,'last' );
    if isempty(t_new_1);t_new_1 = -Inf;end % if no proper t_new_1 is found, assign it a very small value (so t_new_2 will become decisive)
    t_new_2 = find(t_new_clus_decision == 1,1,'last');
        
    % note that the decision was made to do a new clustering
    t_new_clus_decision(t) = 1;

    % do the jumpback by turning the time counter back
    % - Note: All results already present in the output variables between 
    %   time steps t (before turnback) and t (after turnback) will be overwritten

        % keep the old time when the decision for re-clustering was made
        told = t; 

        % jump back in time
        t = max(t_new_1,t_new_2);
        
        % note the jumpback landing time
        t_new_clus_jumpback(t) = 1;
        
        % enter jumpback mode
        jumpback_yesno = 1;

else % reference clustering still valid --> go on
   
    % raise the time counter
    t = t + 1;    

end