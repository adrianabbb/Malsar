%% file example_Lasso.m
% this file shows the usage of Least_Lasso.m function 
% and study the sparsity patterns. 
%
%% OBJECTIVE
% argmin_W { sum_i^t (0.5 * norm (Y{i} - X{i}' * W(:, i))^2) 
%            + rho1 * \|W\|_1 + opts.rho_L2 * \|W\|_F^2}
%
%% LICENSE
%   This program is free software: you can redistribute it and/or modify
%   it under the terms of the GNU General Public License as published by
%   the Free Software Foundation, either version 3 of the License, or
%   (at your option) any later version.
%
%   This program is distributed in the hope that it will be useful,
%   but WITHOUT ANY WARRANTY; without even the implied warranty of
%   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%   GNU General Public License for more details.
%
%   You should have received a copy of the GNU General Public License
%   along with this program.  If not, see <http://www.gnu.org/licenses/>.
%
%   Copyright (C) 2011 - 2012 Jiayu Zhou and Jieping Ye 
%
%   You are suggested to first read the Manual.
%   For any problem, please contact with Jiayu Zhou via jiayu.zhou@asu.edu
%
%   Last modified on June 3, 2012.
%
%% Related papers
%
% [1] Tibshirani, J. Regression shrinkage and selection via
% the Lasso, Journal of the Royal Statistical Society. Series B 1996
%

% clear;
% clc;
% close;

% addpath('../MALSAR/functions/Lasso/'); % load function
% addpath('../MALSAR/utils/'); % load utilities
%
 %load('school.mat'); % load sample data.
[X,Y] = load_data1();


for t = 1: length(X)
X{t} = zscore(X{t}); % normalization
X{t} = [X{t} ones(size(X{t}, 1), 1)]; % add bias.
end

lambda = [0.00001 0.0001 0.0008 0.0005 0.001 0.003 0.005 0.008 0.01 0.03 0.05 0.1];% 1 2 5];% 10 100 1000 10000 500000];% 10^6 2*10^6 5*10^6 8*10^6 10^7 2*10^7 3*10^7 4*10^7];

%lambda = [1 10 100 200 500 1000 2000];

%rng('default');     % reset random generator. Available from Matlab 2011.
opts.init = 0;      % guess start point from data. 
opts.tFlag = 1;     % terminate after relative objective value does not changes much.
opts.tol = 10^-5;   % tolerance. 
opts.maxIter = 1500; % maximum iteration number of optimization.

sparsity = zeros(length(lambda), 1);
log_lam  = log(lambda);

for i = 1: length(lambda)
    %[W funcVal] = Least_Lasso(X, Y, lambda(i), opts);
    [W funcVal] = Logistic_Lasso(X, Y, lambda(i), opts);
    % set the solution as the next initial point. 
    % this gives better efficiency. 
    opts.init = 1;
    opts.W0 = W;
    sparsity(i) = nnz(W)
    W(1:6,1:6)
end

% draw figure
% h = figure;
% plot(log_lam, sparsity);
% xlabel('log(\rho_1)')
% ylabel('Sparsity of Model (Non-Zero Elements in W)')
% title('Sparsity of Predictive Model when Changing Regularization Parameter');
% set(gca,'FontSize',12);
% print('-dpdf', '-r100', 'LeastLassoExp');
