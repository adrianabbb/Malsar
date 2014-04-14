

for k = 1:15
    fisX = ['set',num2str(k),'_X.csv'];
    fisY = ['set',num2str(k),'_Y.csv'];
    X{k} = importdata(fisX);
    Y{k} = importdata(fisY);
end
