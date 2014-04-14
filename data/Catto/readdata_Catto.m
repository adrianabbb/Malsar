
%data_path = 'D:\SAIA\date\Catto\';
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

normali = find(strcmp(group,u{1})); 
normaliUCC = find(strcmp(group,u{2}));
lowgrade = find(strcmp(group, u{4}));
highgrade = find(strcmp(group, u{5}));
invasive =  find(strcmp(group, u{6}));

data = knnimpute(data);

X{1} = transpose([data(:,normali) data(:,lowgrade)]);
Y{1} = [-1*ones(length(normali),1); 1*ones(length(lowgrade),1)];

X{2} = transpose([data(:,normali) data(:,highgrade)]);
Y{2} = [-1*ones(length(normali),1); 1*ones(length(highgrade),1)];

X{3} = transpose([data(:,normali) data(:,invasive)]);
Y{3} = [-1*ones(length(normali),1); 1*ones(length(invasive),1)];

% X{4} = transpose([data(:,normaliUCC) data(:,invasive)]);
% Y{4} = [-1*ones(length(normaliUCC),1); 1*ones(length(invasive),1)];
% 
% X{5} = transpose([data(:,normaliUCC) data(:,highgrade)]);
% Y{5} = [-1*ones(length(normali),1); 1*ones(length(highgrade),1)];
% 
% X{6} = transpose([data(:,normaliUCC) data(:,invasive)]);
% Y{6} = [-1*ones(length(normali),1); 1*ones(length(invasive),1)];
% 
% X{7} = transpose([data(:,lowgrade) data(:,highgrade)]);
% Y{7} = [-1*ones(length(lowgrade),1); 1*ones(length(highgrade),1)];
% 
% X{8} = transpose([data(:,lowgrade) data(:,invasive)]);
% Y{8} = [-1*ones(length(lowgrade),1); 1*ones(length(invasive),1)];
% 
% X{9} = transpose([data(:,highgrade) data(:,invasive)]);
% Y{9} = [-1*ones(length(highgrade),1); 1*ones(length(invasive),1)];


