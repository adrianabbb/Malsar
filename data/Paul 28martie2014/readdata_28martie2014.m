

fis{1} = 'GSE22981_2_classes.csv';
fis{2} = 'GSE31309_2_classes.csv';
fis{3} = 'GSE41526_2_classes.csv';
fis{4} = 'GSE44281_2_classes.csv';

for k = 1:length(fis)
    Table = importdata(fis{k});
    X{k}=Table(:,1:end-1);
    Y{k}=Table(:, end);
    clear Table;
end