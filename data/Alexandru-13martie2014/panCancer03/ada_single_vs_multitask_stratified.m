
% Compare single-task with multi-task learning


%% Setari de paramatri
clear all;

rng('default');

[X,Y] = Catto_readdata();

% Normalizeza datele de intrare si adauga un bias
for t = 1: length(X)
    X{t} = zscore(X{t}); % normalization
    X{t} = [X{t} ones(size(X{t}, 1), 1)]; % add bias.
end

% seteaza parametrii Malsar
opts.init = 0; % compute start point from data.
opts.tFlag = 1; % terminate after relative objective  value does not changes much.
opts.tol = 10^-5; % tolerance.
opts.maxIter = 100; % maximum iteration number of optimization.

obj_func_str =  'Logistic_L21'; %'Logistic_L21';
obj_func  = str2func(obj_func_str);
eval_func_str = 'eval_MTL_Logistic_ACC';
eval_func = str2func(eval_func_str);

% AUC sau ACC mare e bine (in cazul erorii e invers)
higher_better = true; % mse is lower the better.


% procentul pentru datele de training, restul e in testing
training_percent = 0.85;

% CV pe datele de training pt aflarea parametrilor optimi
cv_fold = 5;

% model parameter range
param_range = [0.00001 0.0001 0.0008 0.0005 0.001 0.003 0.005 0.008 0.01 0.03 0.05 0.1];
%param_range = [ 0.001 0.003 0.005 0.008 0.01 0.03]

%param_range = [0.02 0.03 0.04 0.05];  % for Lasso


%% Ruleaza intreaga procedura de mai multe ori (diferite impartiri a datelor in training si testing

for t = 1: length(X)
    index{t} = zeros(length(Y{t}),1);
end


nruns = 5;

for t = 1:length(Y)
    cv{t} = cvpartition(Y{t},'kfold',nruns);
end

for k = 1:nruns
    
    fprintf('Rulare: %d \n',k)
    
    for t = 1:length(Y)
        X_tr{t} = X{t}(cv{t}.training(k),:);
        Y_tr{t} = Y{t}(cv{t}.training(k));
        
        X_te{t} = X{t}(cv{t}.test(k),:);
        Y_te{t} = Y{t}(cv{t}.test(k));
    end
    
    % gaseste parameterii optimi folosind CV pe datele de training
    [best_param, perform_mat] = CrossValidation1Param_Logistic(X_tr, Y_tr, obj_func_str , opts, param_range, cv_fold, eval_func_str, higher_better);
    
    % calculeaza modelul (W,C) pe training cu best_parameters gasiti mai
    % sus
    [W, C] = obj_func(X_tr, Y_tr, best_param, opts);
    
    % calculeaza performanta pe datele de testing
    [fp, aucm] = eval_func(Y_te, X_te, W, C);
    auc_vec_multi(k,:) = aucm;
    
    clear W, C;
    
    for t = 1:length(X)
        X_tr_s{1} = X_tr{t};  Y_tr_s{1} = Y_tr{t};
        [best_param, perform_mat] = CrossValidation1Param_Logistic(X_tr_s, Y_tr_s, obj_func_str , opts, param_range, cv_fold, eval_func_str, higher_better);
        [W, C] = obj_func(X_tr_s, Y_tr_s, best_param, opts);
        X_te_s{1} = X_te{t};
        Y_te_s{1} = Y_te{t};
        [fp, auc_vec_single(k,t)] = eval_func(Y_te_s, X_te_s, W, C);
        
        clear W, C;
    end
end

multi = mean(auc_vec_multi);
single = mean(auc_vec_single);
fprintf('Stratified %d folds Multi AUC: %f %f %f \n', nruns, multi(1), multi(2), multi(3));
fprintf('Stratified %d folds Single AUC: %f %f %f \n', nruns, single(1), single(2), single(3));

fprintf('Stratified %d folds Multi AUC: \n', nruns);
disp(multi)
fprintf('Stratified %d folds Single AUC: \n', nruns);
disp(single)

keyboard

