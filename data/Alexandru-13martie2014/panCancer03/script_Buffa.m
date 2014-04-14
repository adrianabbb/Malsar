

clear all


%rng('default'); % reset random generator.

[X,Y] = Buffa_readdata('D:\SAIA\date\Buffa\');


opts.init = 0; % compute start point from data.
opts.tFlag = 1; % terminate after relative objective
% value does not changes much.
opts.tol = 10^-5; % tolerance.
opts.maxIter = 100; % maximum iteration number of optimization.


for t = 1: length(X)
    X{t} = zscore(X{t}); % normalization
   X{t} = [X{t} ones(size(X{t}, 1), 1)]; % add bias.
end

training_percent = 0.85;


obj_func_str =  'Logistic_Lasso'; %'Logistic_L21';
obj_func  = str2func(obj_func_str);
eval_func_str = 'eval_MTL_Logistic_AUC';
eval_func = str2func(eval_func_str);

higher_better = true; % mse is lower the better.

cv_fold = 5;

% model parameter range
param_range = sort([0.0000001 0.000001 0.000005 0.000008 0.00001 0.0001 0.0005 0.0008]);
%param_range = [ 0.001 0.003 0.005 0.008 0.01 0.03]


nruns = 10;
for k = 1:nruns
    
    fprintf('Rulare: %d \n',k)
    
    [X_tr, Y_tr, X_te, Y_te] = mtSplitPerc_sameIdx(X, Y, training_percent);
   
    
   % for t = 1:length(X)
     t = 1;     
   
        [best_param, perform_mat] = CrossValidation1Param_Logistic(X_tr, Y_tr, obj_func_str , opts, param_range, cv_fold, eval_func_str, higher_better)
        
        [W, C] = obj_func(X_tr, Y_tr, best_param, opts);
        
        [fp, aucm] = eval_func(Y_te, X_te, W, C);
        auc_vec(k,t) = aucm(t);
        
        clear W, C;
        
        X_tr_s{1} = X_tr{t};    Y_tr_s{1} = Y_tr{t};
        [best_param, perform_mat] = CrossValidation1Param_Logistic(X_tr_s, Y_tr_s, obj_func_str , opts, param_range, cv_fold, eval_func_str, higher_better);
        [W, C] = obj_func(X_tr_s, Y_tr_s, best_param, opts);
        
        X_te_s{1} = X_te{t};  Y_te_s{1} = Y_te{t};
        [fp, auc_vec_single(k,t)] = eval_func(Y_te_s, X_te_s, W, C);
        
        clear W, C;
        
        
         X_tr_s{1} = [X_tr{1} Y_tr{2} Y_tr{3} Y_tr{4} Y_tr{5}];    Y_tr_s{1} = Y_tr{t};
        [best_param, perform_mat] = CrossValidation1Param_Logistic(X_tr_s, Y_tr_s, obj_func_str , opts, param_range, cv_fold, eval_func_str, higher_better);
        [W, C] = obj_func(X_tr_s, Y_tr_s, best_param, opts);
        
        X_te_s{1} = [X_te{t} Y_te{2} Y_te{3} Y_te{4} Y_te{5}];  Y_te_s{1} = Y_te{t};
        [fp, auc_vec_clinic(k,t)] = eval_func(Y_te_s, X_te_s, W, C);
        
        clear W, C;
        
     
        
   % end
end

keyboard


