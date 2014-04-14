
% Acest fisier studiaza sparsitatea
%
%% OBJECTIVE
% argmin_W { sum_i^t (0.5 * norm (Y{i} - X{i}' * W(:, i))^2)
%            + rho1 * \|W\|_1 + opts.rho_L2 * \|W\|_F^2}
%
%% Related papers
%
% [1] Tibshirani, J. Regression shrinkage and selection via
% the Lasso, Journal of the Royal Statistical Society. Series B 1996
%
%%

clear all;

%rng('default');     % reset random generator. Available from Matlab 2011

[X,Y] = Catto_readdata();

for t = 1: length(X)
    X{t} = zscore(X{t}); % normalization
    %X{t} = [X{t} ones(size(X{t}, 1), 1)]; % add bias.
end

%lambda = [0.005 0.008 0.01 0.03 0.05 0.06 0.07 0.08 0.09 0.1 1 2 5];% 10 100 1000 10000 500000];% 10^6 2*10^6 5*10^6 8*10^6 10^7 2*10^7 3*10^7 4*10^7];

%lambda = [0.05 0.06 0.09 0.1 0.2 0.3 0.4 0.5 0.9 1];

lambda = [0.00001 0.0001 0.0008 0.0005 0.001 0.003 0.005 0.008 0.01 0.03 0.05 0.1 0.2 0.3 0.4];

%lambda = [0.02 0.03 0.04 0.05];  % for Lasso

opts.init = 0;      % guess start point from data.
opts.tFlag = 1;     % terminate after relative objective value does not changes much.
opts.tol = 10^-3;   % tolerance.
opts.maxIter = 500; % maximum iteration number of optimization.

sparsity = zeros(length(lambda), 1);
log_lam  = log(lambda);

for i = 1: length(lambda)
    [W funcVal] = Logistic_Lasso(X, Y, lambda(i), opts);
    opts.init = 1;    % set the solution as the next initial point. this gives better efficiency.
    opts.W0 = W;
    indx_nz_W_tmp = 1:size(W,1);
    for t = 1:size(W,2)
        nz_W(t) = nnz(W(:,t));
        indx_nz_W = find(W(:,t));
        indx_nz_W_tmp = intersect(indx_nz_W_tmp,indx_nz_W);
    end
    indx_nz_W_alltasks{i} = indx_nz_W_tmp;
    sparsity(i) = mean(nz_W);
    fprintf('For lambda=%f,  nnz elements in W=%f, nz elemnts in all tasks=%f \n',lambda(i),sparsity(i),length(indx_nz_W_tmp));
end


figure1 = figure;

 axes1 = axes('Parent',figure1,...
    'XTickLabel',lambda(3:end),...
    'XTick',[1 2 3 4 5 6 7 8 9 10 11]);

box(axes1,'on');
hold(axes1,'all');

plot(sparsity(5:end),'LineWidth',2)
xlabel('regularization parameter' ,'FontSize',12)
ylabel('number of features' ,'FontSize',12)
 

keyboard

%% Results for mRNA data
% lasso=[1739        2444        6366        7810        8282        8674  9882        9897       10952       11541       11681       13008 14298       15843       18603       21828];  
% l21 = [2258        4909        4919        5081        5619        9102 9103       12832       14041       14072       15705       17729 18457       21973];

