function [X,Y] = load_data1_7()

selectie{1} = 'toate';

for i = 1:length(selectie)
    numefis = [selectie{i},'.csv'];
    d = csvread(numefis);
    [nrow,ncol] = size(d);
    
    indx_perm = randperm(nrow);
    
    X{i} = d(indx_perm,1:ncol-1);
    Y{i} = d(indx_perm,ncol);
   
end