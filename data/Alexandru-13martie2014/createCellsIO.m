% % % createCellsIO; cod Puiu.
% % % Warning: unbalanced data, at least for FEBIT 6 cancers data. Balance
% data!
% Cred ca se poate scrie cod mai elegant care sa permita efectuarea mai
% simpla a experimentelor, decit modificarea manuala a indexilor.
% Experimente:
% 1. Table_1 contine toate datele din celalalte tabele si iese prost.
% Practic, punind toate task-urile in afara de prima, ar putea fi OK. Ae
% mai ramine cuplarea unor tasks ce sunt pe acelasi cancer.

clear all;

fis{1} = 'BLC_S6.csv';
fis{2} = 'BrC_S2.csv';
fis{3} = 'BrC_S4.csv';
fis{4} = 'BrC_S5.csv';
fis{5} = 'CrC_S3.csv';
fis{6} = 'GaC_S1.csv';
fis{7} = 'LuC_S1.csv';
fis{8} = 'LuC_S8.csv';
fis{9} = 'MeC_S1.csv';
fis{10} = 'NfC_S7.csv';
fis{11} = 'OvC_S1.csv';
fis{12} = 'PaC_S1.csv';
fis{13} = 'PrC_S1.csv';
fis{14} = 'allcancers.csv';
fis{15} = 'AllBrC.csv';
fis{16} = 'AllLuC.csv';

k = 0;
for t = 1:length(fis)
    
    if ~isempty(fis{t})
        k = k +1;
        Table = importdata(fis{t});
        X{k}=Table(:,1:end-1);
        Y{k}=Table(:, end);
        clear Table;
    end
    
end

%keyboard

% dd = [];
% for t = 2:4
%    d = importdata(fis{t});
%    dd = [dd; d];
% end
% csvwrite('AllBrC.csv',dd);
% 
% 
% d7 = importdata(fis{7});
% d8 = importdata(fis{8});
% d78 = [d7; d8];
% csvwrite('AllLuC.csv',d78);


