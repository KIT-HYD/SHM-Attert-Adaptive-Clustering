function [clus_reps, clus_labels,all_reps, num_reps] = f_find_cluster_representatives(data,ratio_rep,min_rep_per_clus,max_rep_per_clus)
% finds a representative subset of cluster members
% Input
% - data [n,1] :double. Array of (numeric) cluster labels for each element.
% - ratio_rep [1,1] :double. Number of representatives divided by number of elements
% - optional: min_rep_per_clus [1,1] :double. Minimum number of elements to represent a cluster
% - optional: max_rep_per_clus [1,1] :double. Maximum number of elements to represent a cluster
% Output
% - clus_reps {c,1} cell array :double. Each cell contains the [x,1] array
%   with indices (in data) of randomly chosen cluster representatives.
%   The indices are ordered by size
% - clus_labels [c,1] :double. Unique cluster labels found in 'data'
%   The order of the labels corresponds with the order in 'clus_reps'
% - all_reps [y,1]: double. indices (in data) of all representatives of all
%   clusters. The indices are ordered by size
% - num_reps [1,1]: double. Length of 'all_reps'
% Version
% - 2019/07/08 Uwe Ehret: initial version
% - 2019/08/17 Uwe Ehret: added 'all_reps' and 'num_reps' to output
% - 2020/02/28: Uwe Ehret, version published in GitHub

% check input 
if (~exist('min_rep_per_clus', 'var'))
    min_rep_per_clus = 0;
end

if (~exist('max_rep_per_clus', 'var'))
    max_rep_per_clus = Inf;
end

% unique cluster labels
clus_labels = unique(data);

% number of unique cluster labels
num_clus = length(clus_labels);

% find number of elements in each cluster
    num_in_clus = NaN(num_clus,1);

    % loop over all clusters
    for c = 1 : num_clus
        num_in_clus(c) = length(find(clus_labels(c) == data));
    end

% find number of reps in each cluster
num_rep_in_clus = num_in_clus * ratio_rep;

% check the number of representatives are within set limits
% and round to integers

    % loop over all clusters
    for c = 1 : num_clus

        % assure each cluster has at most 'max_rep_per_clus' representatives
        if num_rep_in_clus(c) > max_rep_per_clus
            num_rep_in_clus(c) = max_rep_per_clus;

        % assure each cluster has at least 'min_rep_per_clus' representatives
        elseif num_rep_in_clus(c) < min_rep_per_clus
            % ... but this cannot be more than the number of elements in the cluster
            num_rep_in_clus(c) = min([min_rep_per_clus num_in_clus(c)]);

        % number of representatives lies between min and max    
        else
            % round the number of representatives to nearest integer
            num_rep_in_clus(c) = round(num_rep_in_clus(c));    
        end
    end

% randomly select the cluster representatives in each cluster
    clus_reps = cell(num_clus,1);
    
    % loop over all clusters
    for c = 1 : num_clus
        
        % find indices of all elements belonging to the cluster
        indx = find(data == clus_labels(c));             

        % randomly select the required number of representatives from the cluster
        % and order them by size
        clus_reps{c} = sort(indx(randperm(numel(indx), num_rep_in_clus(c))));    
    end

% put together the list of all representatives of all clusters and sort them
    all_reps = cell2mat(clus_reps);
    all_reps = sort(all_reps);

% get size of all_reps
    num_reps = length(all_reps);
    
end

