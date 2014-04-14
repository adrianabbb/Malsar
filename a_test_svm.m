

clear all;

readdata_28martie14();


for t = 1: length(X)
    X{t} = zscore(X{t}); % normalization
    X{t} = [X{t} ones(size(X{t}, 1), 1)]; % add bias.
end


nruns = 5;

for t = 1:length(Y);  cv{t} = cvpartition(Y{t},'kfold',nruns);  end


%% Stratified 5 folds cross-validation
for k = 1:nruns
    
    fprintf('Rulare: %d \n',k)
    
    for t = 1:length(Y)
        X_tr{t} = X{t}(cv{t}.training(k),:);
        Y_tr{t} = Y{t}(cv{t}.training(k));
        
        X_te{t} = X{t}(cv{t}.test(k),:);
        Y_te{t} = Y{t}(cv{t}.test(k));
    
    
    % Train the classifier
    SVMModel = svmtrain(X_tr{t},Y_tr{t});
    scores = svmclassify(SVMModel,X_te{t});
    
     [~,~,~,AUC(t)] = perfcurve(Y_te{t},scores,1);
     
     AUC
    
     end
end