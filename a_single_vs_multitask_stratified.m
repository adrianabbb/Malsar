%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%     Compare single-task with multi-task learning

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function [multi, single] = a_single_vs_multitask_stratified()

clear all;
close all;

addpath('../MALSAR/data/'); % load data

%% Start -- Setari de paramatri

%rng('default');
writeResultsToFile = 0;
obj_func_str =  'Logistic_Lasso'; %'Logistic_L21';
obj_func  = str2func(obj_func_str);
eval_func_str = 'eval_MTL_Logistic_ACC';
eval_func = str2func(eval_func_str);
higher_better = true; % AUC sau ACC mare e bine (in cazul erorii e invers)


if writeResultsToFile == 1
    workingFolder = [pwd filesep];
    submissionDirectory = [workingFolder 'a_results'];
    if ~exist(submissionDirectory,'dir') mkdir(submissionDirectory); end
    extension='.txt';
    the_date = datestr(now, 'yyyy-mm-dd-HH:MM:SS');
    logfile = [submissionDirectory filesep 'results_Catto_multitask_vs_singletask.txt'];
    flog=fopen(logfile, 'a');
    scoreFile = [submissionDirectory filesep obj_func_str '_' eval_func_str the_date];
end
%% Citeste datele, si preproceseaza

readdata_7aprilie2014();

% Normalizeza datele de intrare si adauga un bias
for t = 1: length(X)
    X{t} = zscore(X{t}); % normalization
    X{t} = [X{t} ones(size(X{t}, 1), 1)]; % add bias.
end
%% Seteaza parametrii Malsar

opts.init = 0; % compute start point from data.
opts.tFlag = 1; % terminate after relative objective  value does not changes much.
opts.tol = 10^-5; % tolerance.
opts.maxIter = 100; % maximum iteration number of optimization.
cv_fold = 5; % CV pe datele de training pt aflarea parametrilor optimi
param_range = [0.00001 0.0001 0.0008 0.0005 0.001 0.003 0.005 0.008 0.01 0.03 0.05 0.1];  % model parameter range
%param_range = [ 0.001 0.003 0.005 0.008 0.01 0.03]
%param_range = [0.02 0.03 0.04 0.05];  % for Lasso

%% Ruleaza intreaga procedura de mai multe ori (diferite impartiri a datelor in training si testing

for t = 1: length(X)
    index{t} = zeros(length(Y{t}),1);
end

nruns = 10;
for t = 1:length(Y);  
    cv{t} = cvpartition(Y{t},'kfold',nruns);  
end


%% Stratified 5 folds cross-validation
for k = 1:nruns
    fprintf('Rulare: %d \n',k)
    
    for t = 1:length(Y)
        X_tr{t} = X{t}(cv{t}.training(k),:); Y_tr{t} = Y{t}(cv{t}.training(k));
        X_te{t} = X{t}(cv{t}.test(k),:); Y_te{t} = Y{t}(cv{t}.test(k));
    end
    
    % gaseste parameterii optimi folosind CV pe datele de training
    [best_param, perform_mat] = CrossValidation1Param_Logistic(X_tr, Y_tr, obj_func_str , opts, param_range, cv_fold, eval_func_str, higher_better);
    % calculeaza modelul (W,C) pe training cu best_parameters gasiti mai sus
    [W, C] = obj_func(X_tr, Y_tr, best_param, opts);
    
%     aa = 1:size(W,1);
%     for t = 1:size(W,2)
%         aa = intersect(aa,find(W(:,t)));
%     end
    
    % calculeaza performanta pe datele de testing
    [fp, aucm] = eval_func(Y_te, X_te, W, C);
    auc_vec_multi(k,:) = aucm;
    
    clear W, C;
    
    %% Single-task learning
    for t = 1:length(X)
        X_tr_s{1} = X_tr{t};  Y_tr_s{1} = Y_tr{t};
        [best_param, perform_mat] = CrossValidation1Param_Logistic(X_tr_s, Y_tr_s, obj_func_str , opts, param_range, cv_fold, eval_func_str, higher_better);
        [W, C] = obj_func(X_tr_s, Y_tr_s, best_param, opts);
        X_te_s{1} = X_te{t};
        Y_te_s{1} = Y_te{t};
        [fp, auc_vec_single(k,t)] = eval_func(Y_te_s, X_te_s, W, C);
        
        clear W, C;
    end % loop peste taskuri
end % loop peste cross-validation folds

multi = mean(auc_vec_multi)
single = mean(auc_vec_single)

%%  Scrie rezultatele

fprintf('Multitask: \n');
disp(multi)
fprintf('Singletask: \n');
disp(single)

if writeResultsToFile == 1   
    fprintf(flog,'\r\n====================================================================\r\n');
    fprintf(flog, '\r\n%s\t%s\t%s\r\n ', the_date, obj_func_str, eval_func_str);
    fprintf(flog, '\r\n Multi-task  -- Stratified %d folds:  %4.4f   %4.4f   %4.4f ', nruns, multi(1), multi(2), multi(3));
    fprintf(flog, '\r\n Single-task -- Stratified %d folds:  %4.4f   %4.4f   %4.4f ', nruns, single(1), single(2), single(3));
    fprintf(flog,'\r\n====================================================================\r\n\n');
    fclose all;
end

 keyboard



