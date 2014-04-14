function [X,Y] = Catto_readdata()


[data, text] = xlsread('Bladder-cancer-MicroRNA-data.xls','DCT values','B5');

data(1:4,:) = [];
group = text(2,:);
group(1) = [];

u{1} = 'Normal urothelium';
u{2} = 'Normal urothelium (UCC Patient)';
u{3} = 'Cell line';
u{4} = 'Low grade NMI';
u{5} = 'High grade NMI';
u{6} = 'Muscle invasive';

normali = [find(strcmp(group,u{1})) find(strcmp(group,u{2}))];
lowgrade = find(strcmp(group, u{4}));
highgrade = find(strcmp(group, u{5}));
invasive =  find(strcmp(group, u{6}));


X{1} = transpose(knnimpute([data(:,normali) data(:,lowgrade)]));
Y{1} = [-1*ones(length(normali),1); 1*ones(length(lowgrade),1)];

X{2} = transpose(knnimpute([data(:,normali) data(:,highgrade)]));
Y{2} = [-1*ones(length(normali),1); 1*ones(length(highgrade),1)];

X{3} = transpose(knnimpute([data(:,normali) data(:,invasive)]));
Y{3} = [-1*ones(length(normali),1); 1*ones(length(invasive),1)];

% X{4} = transpose(knnimpute([data(:,normali) data(:,lowgrade)  data(:,highgrade) data(:,invasive) ]));
% Y{4} = [-1*ones(length(normali),1); 1*ones(length(lowgrade),1); 1*ones(length(highgrade),1); 1*ones(length(invasive),1)];

for k = 1:length(X)
    indx_perm = randperm(length(Y{k}));
    X_tmp = X{k};
    Y_tmp = Y{k};
    
    X{k} = X_tmp(indx_perm,:);
    Y{k} = Y_tmp(indx_perm);
end

% save([data_path 'Catto_readdata.mat'],'X','Y');
% load([data_path 'Catto_readdata.mat']);

