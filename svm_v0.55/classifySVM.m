function [percent, stds, cfMat] = classifySVM(data, classes, foldindex)
%Usage: foldindex= randX > performs random crossvalidation with X folds,
%where X is an integer [1, length(data)]. foldindex also can be a vector
%length(data)-by-1 indicating the fold of each sample by an integer.
    s = RandStream('mt19937ar','seed', 0);
    RandStream.setGlobalStream(s);
    
    unique_classes = unique(classes);
    k = length(unique_classes);
    y = ones(length(classes), k) .* -1;
    for i=1:k
        indexes = find(strcmp(classes, unique_classes{i}));
        y(indexes, i) = 1;
    end
    
    kernel = hist_isect();
    %kernel = rbf();
    kfold='?'; %defined latter
    
    C      = 100;
    tutor  = smosvctutor;   % this means we use the SMO training algorithm
    net    = dagsvm;        % this means we use the DAG-SVM algortihm to combine
                        % the outputs of a number of 2-class networks
       
    if strcmp(foldindex(1:4), 'rand')==1
        kfold  = str2num(foldindex(5:length(foldindex)));
        if kfold == length(classes)
            kfold = round(length(classes)/k);
            indices = crossvalind('Kfold', classes, kfold);
            %disp(indices);
        else
            indices = crossvalind('Kfold', classes, kfold);
        end        
    else
       folds = unique(foldindex);
       kfold  = length(folds);
       indices=foldindex;
    end
    
    
    
    cfMat = zeros(k, k);
    errorsIndex = [];
    errorsClasses = [];
    for p = 1:kfold
        test_index = (indices == p); train_index = ~test_index;
        xtrain = data(train_index,:);
        ytrain = y(train_index,:);
        xtest = data(test_index,:);
        ytest = y(test_index,:);
        
        net = train(net, tutor, xtrain, ytrain, C, kernel);
        
        confusion_matrix = zeros(k);

        o = fwd(net, xtest);

        [~,Y] = max(ytest');
        [~,O] = max(o');
 
        for i=1:k
            for j=1:k
                confusion_matrix(i,j) = length(find(Y == i & O == j));
            end
        end
        
        ti = find(test_index);
        errorsIndex = [errorsIndex ti(find(Y ~= O))'];
        errorsClasses = [errorsClasses; O(find(Y ~= O))'];
      
        cfMat = cfMat + confusion_matrix;
        pp(p) = (trace(confusion_matrix) / size(ytest, 1)) * 100;
        %disp(pp(p));
    end
    
    percent = (trace(cfMat) / size(y,1)) * 100;
    stds = std(pp);
end