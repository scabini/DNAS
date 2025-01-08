function [percent, stds, cfMat] = classifySVMLOVO(data, classes, pfig)
    pfig = sp_progress_bar('Building BOVW');
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
    C      = 100;
    tutor  = smosvctutor;   % this means we use the SMO training algorithm
    net    = dagsvm;        % this means we use the DAG-SVM algortihm to combine
                        % the outputs of a number of 2-class networks
       
    indices = 1:length(classes);
    cfMat = zeros(k, k);
    errorsIndex = [];
    errorsClasses = [];
    for p = 1:length(classes)
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
        
        sp_progress_bar(pfig, 4, 4, p, length(classes), 'Executando o SVM');
        
        cfMat = cfMat + confusion_matrix;
        pp(p) = (trace(confusion_matrix) / size(ytest, 1)) * 100;
        disp(pp(p));
    end
    
    percent = (trace(cfMat) / size(y,1)) * 100;
    stds = std(pp);
    %stds = std(diag(cfMat) ./ sum(cfMat,2));
    close(pfig);
end