%% file example_rMTFL.m
% this file shows the usage of Least_rMTFL.m function 
% and study how to detect outlier tasks. 
%
%% OBJECTIVE
%  argmin_W ||X(P+Q) - Y||_F^2 + lambda1*||P||_{1,2} + lambda2*||Q^T||_{1,2}
%   s.t. W = P + Q
%
%% Copyright (C) 2012 Jiayu Zhou, and Jieping Ye
%
% You are suggested to first read the Manual.
% For any problem, please contact with Jiayu Zhou via jiayu.zhou@asu.edu
%
% Last modified on April 16, 2012.
%
%% Related papers
%
% [1] Gong, P. and Ye, J. and Zhang, C. Robust Multi-Task Feature Learning,
% Submitted, 2012
%

% clear;
% clc;
% close all;

% addpath('../MALSAR/functions/rMTFL/'); % load function 
% addpath('../MALSAR/utils/'); % load utilities

%rng('default');     % reset random generator. Available from Matlab 2011.

addpath('../MALSAR/data/'); % load data


% %generate synthetic data.
% d = 200;
% n = 20;
% m = 30;
% X = cell(m ,1);
% Y = cell(m ,1);
% for t = 1:m
%     X{t} = 25*randn(n,d);
%     X{t} = zscore(X{t});
% end
% 
% L = 64*randn(d, m);
% S = 64*randn(d, m);
% 
% L(1:160,:) = 0;
% 
% S(:,1:20) = 0; % primele 20 taskuri sunt related, ultimele 10 sunt outliers
% 
% for t = 1:m
%     Y{t} = (X{t})*(L(:,t)+S(:,t)) + randn;
% end


clear all;
readdata_7apr2014();


m = length(X);
d = size(X{1},2);
n = 20;

opts.init = 0;      % guess start point from data. 
opts.tFlag = 1;     % terminate after relative objective value does not changes much.
opts.tol = 10^-5;   % tolerance. 
opts.maxIter = 500; % maximum iteration number of optimization.

t = 10^-10;
rho_1 = 2*sqrt(d*m+t)/m*n;%   rho1: P
rho_2 = 6*sqrt(d*m+t)/m*n; %   rho2: Q

[W funcVal Lhat Shat] = Least_RMTL(X, Y, rho_1, rho_2, opts);

 for k = 1:m; is_outlier(k) = nnz(Shat(:,k)); end
 for k = 1:d; b(k) = nnz(Lhat(k,:)); end
 

%%% ar trebui sa fie primele 20 zeros si ultimele 10 non-zero
disp(is_outlier)
keyboard
%disp(b)


