function [mse, acc, y_pred] = eval_MTL_Logistic_ACC(Y, X, W, C)
%% FUNCTION eval_MTL_mse
%   computation of ACC (accuracy) given a specific model.
%   the value is the higher the better.
%   
%% FORMULATION
%   [\sum_i sqrt(sum(X{t} * W(:, t) - Y{t}).^2) *
%   length(Y{t})]/\sum(length(Y{t}))
%
%% INPUT
%   X: {n * d} * t - input matrix
%   Y: {n * 1} * t - output matrix
%   percent: percentage of the splitting range (0, 1)
%

%%
task_num = length(X);

acc = zeros(1,task_num);
for t = 1: task_num
    y_pred{t} = 1./ ( 1+ exp(-(X{t}*W(:, t) + C(t)) ));
    if length(y_pred{t})==1
        acc(t) = y_pred{t};
    else
        confmat = confusionmat(Y{t}>0,y_pred{t}>0.5);
        acc(t) = sum(diag(confmat))/(sum(sum(confmat)));
    end
end
mse = sum(acc)/task_num;

end
