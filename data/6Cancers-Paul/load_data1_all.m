function [X,Y] = load_data1_all()

selectie{1} = 'lung cancer';
selectie{2} = 'melanoma';
selectie{3} = 'ovarian cancer';
selectie{4} = 'pancreatic cancer ductal';
selectie{5} = 'prostate cancer';
selectie{6} = 'tumor of stomach';
selectie{7} = 'toate';

for i = 1:length(selectie)
    numefis = [selectie{i},'.csv'];
    d = csvread(numefis);
    [nrow,ncol] = size(d);
    
    indx_perm = randperm(nrow);
    
    X{i} = d(indx_perm,1:ncol-1);
    Y{i} = d(indx_perm,ncol);
   
end