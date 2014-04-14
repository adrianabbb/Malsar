function [mse, AUC, y_pred] = eval_MTL_Logistic_AUC(Y, X, W, C)
%% 
%   computation of AUC given a specific model.
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

AUC = zeros(1,length(X));
for t = 1:length(X)
    y_pred{t} = 1./ ( 1+ exp(- (X{t}*W(:, t) + C(t)) ));
    % y_pred{t} = sign(X{t}*W(:, t)+C(t)); 
    
    if (length(unique(Y{t}))==1)
         AUC(t) = 1;
    else
        [~,~,~,AUC(t)] = perfcurve(Y{t},y_pred{t},1);
    %[~,~,~,AUC1(t)] = perfcurve(Y{t},y_pred1{t},'1')
    end
end
mse = mean(AUC);

