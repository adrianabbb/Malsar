

% Acest fisier testeaza mai multi algoritmi: Logistic_Lasso, Logistic_L21,
% Logistic_Trace, Logistic_CMTL


%%
% clear all


%rng('default'); % reset random generator.

% [X,Y] = Catto_readdata();


% seteaza parametrii Malsar
opts.init = 0; % compute start point from data.
opts.tFlag = 1; % terminate after relative objective
opts.tol = 10^-5; % tolerance.
opts.maxIter = 100; % maximum iteration number of optimization.

% Normalizeza datele de intrare si adauga un bias
for t = 1: length(X)
    X{t} = zscore(X{t}); % normalization
    X{t} = [X{t} ones(size(X{t}, 1), 1)]; % add bias.
end


% procentul pentru datele de training, restul e in testing
training_percent = 0.75;


% metoda de evaluare (AUC sau ACC)
eval_func_str = 'eval_MTL_Logistic_AUC';
eval_func = str2func(eval_func_str);

% AUC sau ACC mare e bine (in cazul erorii e invers)
higher_better = true; 

% CV pe datele de training pt aflarea parametrilor optimi
cv_fold = 5;

param_range = sort([0.0000001 0.000001 0.000005 0.000008 0.00001 0.0001 0.0005 0.0008]);

%% Ruleaza intreaga procedura de mai multe ori (diferite impartiri a datelor in training si testing


nruns = 5;
for k = 1:nruns
    
    fprintf('Rulare: %d \n',k)
    
    [X_tr, Y_tr, X_te, Y_te] = mtSplitPerc(X, Y, training_percent);
    
    for t = 1:length(Y);
    
    X_tr_s{1} = X_tr{t};  Y_tr_s{1} = Y_tr{t};
    X_te_s{1} = X_te{t};  Y_te_s{1} = Y_te{t};
    
    %param_range = sort([0.0000001 0.000001 0.000005 0.000008 0.00001 0.0001 0.0005 0.0008]);
    obj_func_str =  'Logistic_Lasso'; obj_func  = str2func(obj_func_str);
    [best_param] = CrossValidation1Param_Logistic(X_tr_s, Y_tr_s, obj_func_str , opts, param_range, cv_fold, eval_func_str, higher_better);
    [W, C] = obj_func(X_tr_s, Y_tr_s, best_param, opts);
    [fp, auc1(k,t)] = eval_func(Y_te_s, X_te_s, W, C);
    
    
    %param_range = sort([ 0.00001 0.0001 0.001 0.1 1]);
    obj_func_str =  'Logistic_L21'; obj_func  = str2func(obj_func_str);
    [best_param] = CrossValidation1Param_Logistic(X_tr_s, Y_tr_s, obj_func_str , opts, param_range, cv_fold, eval_func_str, higher_better);
    [W, C] = obj_func(X_tr_s, Y_tr_s, best_param, opts);
    [fp, auc2(k,t)] = eval_func(Y_te_s, X_te_s, W, C);
    
    
    param_range = sort([ 0.00001 0.0001 0.001 0.1 1]);
    obj_func_str =  'Logistic_Trace'; obj_func  = str2func(obj_func_str);
    [best_param, perform_mat] = CrossValidation1Param_Logistic(X_tr_s, Y_tr_s, obj_func_str , opts, param_range, cv_fold, eval_func_str, higher_better);
    [W, C] = obj_func(X_tr_s, Y_tr_s, best_param, opts);
    [fp, auc3(k)] = eval_func(Y_te_s, X_te_s, W, C);
    
    
    param_range = sort([0.00001 0.0001 0.001]);
    obj_func_str =  'Logistic_CMTL'; obj_func  = str2func(obj_func_str);
    [best_param, best_param2] = CrossValidation2Param_Logistic(X_tr_s, Y_tr_s, obj_func_str , opts, param_range, param_range, cv_fold, eval_func_str, higher_better);
    [W, C] = obj_func(X_tr_s, Y_tr_s, best_param, best_param2, 2, opts);
    [fp, auc4(k,t)] = eval_func(Y_te_s, X_te_s, W, C);
    auc4
    end
end

%%
disp(mean(auc1))
disp(mean(auc2))
disp(mean(auc3))


keyboard


