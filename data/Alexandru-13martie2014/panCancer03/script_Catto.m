

clear all


rng('default'); % reset random generator.

[X,Y] = load_data1();%CattoBuffa_readdata('D:\SAIA\date\');


opts.init = 0; % compute start point from data.
opts.tFlag = 1; % terminate after relative objective
% value does not changes much.
opts.tol = 10^-5; % tolerance.
opts.maxIter = 100; % maximum iteration number of optimization.

opts = [];

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
param_range = [0.00001 0.0001 0.0008 0.0005 0.001 0.003 0.005 0.008 0.01 0.03 0.05 0.1];
%param_range = [ 0.001 0.003 0.005 0.008 0.01 0.03]


nruns = 5;
for k = 1:nruns
    
    fprintf('Rulare: %d \n',k)
    
    [X_tr, Y_tr, X_te, Y_te] = mtSplitPerc(X, Y, training_percent);
   
    
    for t = 1:length(X)
        
        X_tr_m{t} = X_tr{t}; Y_tr_m{t} = Y_tr{t};  X_te_m{t} = X_te{t}; Y_te_m{t} = Y_te{t};
        
        if t==1
            X_tr_m{2} = X{2};  Y_tr_m{2} = Y{2}; X_te_m{2} = X{2};  Y_te_m{2} = Y{2}; 
            X_tr_m{3} = X{3};  Y_tr_m{3} = Y{3}; X_te_m{3} = X{3};  Y_te_m{3} = Y{3};
        end
        
        if t==2
            X_tr_m{1} = X{1};  Y_tr_m{1} = Y{1};  X_te_m{1} = X{1};  Y_te_m{1} = Y{1};
            X_tr_m{3} = X{3};  Y_tr_m{3} = Y{3};  X_te_m{3} = X{3};  Y_te_m{3} = Y{3};    
        end
      
        if t==3
            X_tr_m{2} = X{2};  Y_tr_m{2} = Y{2};  X_te_m{2} = X{2};  Y_te_m{2} = Y{2};
            X_tr_m{1} = X{1};  Y_tr_m{1} = Y{1};  X_te_m{1} = X{1};  Y_te_m{1} = Y{1};
        end
        
        [best_param, perform_mat] = CrossValidation1Param_Logistic(X_tr_m, Y_tr_m, obj_func_str , opts, param_range, cv_fold, eval_func_str, higher_better);
        [W, C] = obj_func(X_tr_m, Y_tr_m, best_param, opts);
        [fp, aucm] = eval_func(Y_te_m, X_te_m, W, C);
        auc_vec(k,t) = aucm(t);
        
        clear W, C;
        
        X_tr_s{1} = X_tr{t};    Y_tr_s{1} = Y_tr{t};
        [best_param, perform_mat] = CrossValidation1Param_Logistic(X_tr_s, Y_tr_s, obj_func_str , opts, param_range, cv_fold, eval_func_str, higher_better);
        [W, C] = obj_func(X_tr_s, Y_tr_s, best_param, opts);
        X_te_s{1} = X_te{t};
        Y_te_s{1} = Y_te{t};
        [fp, auc_vec_single(k,t)] = eval_func(Y_te_s, X_te_s, W, C);
        
        clear W, C;
    end
end

keyboard


