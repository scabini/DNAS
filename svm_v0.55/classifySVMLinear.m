function [percent, stds] = classifySVMLinear(data, classes, pfig)
    
    s = RandStream('mt19937ar','seed', 0);
    RandStream.setGlobalStream(s);    
    conf.svm.C = 10;
    conf.numTrain = 30;
    conf.svm.solver = 'sdca';
    conf.svm.biasMultiplier = 1;
    uclasses = sort(unique(classes));
    
    hom.kernel = 'KChi2';
    hom.order = 2;
    %data = vl_svmdataset(data', 'homkermap', hom);
    data = vl_homkermap(data', 1, 'kchi2', 'gamma', .5);
     
    p = [];
    for j=1:10
        train = [];
        test = [];
        classesTrain = [];
        classesTest = [];
        for i=1:length(uclasses)
            npc = find(strcmp(uclasses{i},classes));
            pos = randperm(length(npc));
            posTrain = npc(pos(1:conf.numTrain));
            posTest = npc(pos(conf.numTrain+1:end));

            train = [train data(:,posTrain)];
            test = [test data(:,posTest)];
            classesTrain = [classesTrain; classes(posTrain,:)];
            classesTest = [classesTest; classes(posTest,:)];
        end

        lambda = 1 / (conf.svm.C *  size(train,2)) ;
        w = [] ;
        b = [];
        for ci = 1:length(uclasses)
            fprintf('Training model for class %s (%d/%d)\n', uclasses{ci}, ci, length(uclasses)) ;
            y = 2 * (strcmp(classesTrain, uclasses{ci})) - 1;
            [w(:,ci), b(ci), info] = vl_svmtrain(train, y, lambda, ...
              'Solver', conf.svm.solver, ...
              'MaxNumIterations', 50/lambda, ...
              'BiasMultiplier', conf.svm.biasMultiplier, ...
              'Epsilon', 1e-3);
        end
        
        model.b = conf.svm.biasMultiplier * b ;
        model.w = w ;
        
        scores = model.w' * test + model.b' * ones(1,size(test,2)) ;
        [~, imageEstClass] = max(scores, [], 1) ;
        ct = uclasses(imageEstClass);
        p(j) = sum(strcmp(classesTest,ct)) / length(classesTest) * 100;
        sp_progress_bar(pfig, 4, 4, j, 10, 'Executando o SVM Linear');
        disp(p(j));
    end
    
    percent = mean(p);
    stds = std(p);
    
end