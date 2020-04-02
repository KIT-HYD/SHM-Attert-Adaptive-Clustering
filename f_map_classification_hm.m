function [class_mapped] = f_map_classification_hm(class_keepme,class_changeme)
% maps labels of classification 'class_changme' to labels of classification 'keepme' using the hungarian method
% the hungarian method is encoded in function 'munkres'
% Note
% Input
% - class_keepme [m,1] :double. Classification lables of the reference classification
% - class_changeme [m,1] :double. Classification labels of the classification to be mapped
% Output
% - class_mapped [m,1] :double. Classification labels of the mapped classification
% Version
% - 2019/07/03 Uwe Ehret: initial version

% check input
    % length of input vectors must agree
    if length(class_keepme)~=length(class_changeme)
        error('length of input vectors does not agree!')
    end  
    % input vectors must be NaN-free
    if ~isempty(find(isnan(class_keepme))) || ~isempty(find(isnan(class_changeme)))
        error('input vectors contain NaNs!')
    end  
    
% find length of data sets    
num_data = length(class_keepme);
    
% find unique labels of each classification
classlables_keepme = unique(class_keepme);
classlables_changeme = unique(class_changeme);

% find number of unique labels
num_classes_keepme = length(classlables_keepme);
num_classes_changeme = length(classlables_changeme);

% prepare output vector
class_mapped = NaN(num_data,1);

% build matrix of paired classifications
    % - rows = labels of class_changeme, same order as in class_changeme
    % - cols = labels of class_keepme, same order as in class_keepme

    mpc = zeros(num_classes_changeme,num_classes_keepme);     % matrix with all possible classification pairs (e.g. 1-1, 1-2, 2-1, 2-2)
    
    % loop over all classified objects
    for i = 1 : num_data 
        indx_keepme = find(classlables_keepme == class_keepme(i));
        indx_changeme = find(classlables_changeme == class_changeme(i));
        mpc(indx_changeme, indx_keepme) = mpc(indx_changeme, indx_keepme) + 1;
    end    

% reverse the counts in the matrix of paired classifications
    % reason: mpc includes the joint counts, i.e. the higher the number the better (benefits).
    % The hungarian method we use later requires COSTS as matrix entries,
    % i.e. the linkage will be found by minimzation of costs rather than
    % maximization of benefits
    % the reversal is done by subtracting each cell value from the maximum
    % value in the matrix --> the former maximum becomes zero    
    mpc_r = max(mpc(:)) - mpc;
    
% find the best label-match between the classifications using the hungarian method
[label_link,~] = f_munkres(mpc_r);

% replace the labels of 'class_changeme' with the corresponding labels of 'class_keepme'
    
    % loop over all labels of class_changme
    for i = 1 : num_classes_changeme
        
        % labels in class_changeme that found no match have a '0' in label_link
        % if this is the case, leave the 'NaN' in class_mapped
        if label_link(i) ~= 0 
        
            % find the indices of the data with the corresponding 'changme' classlabel ...
            indx_out = find(class_changeme == classlables_changeme(i));

            % ... and fill them with the corresponding 'keepme' classlabel
            class_mapped(indx_out) = classlables_keepme(label_link(i));

        end
        
    end
    
    