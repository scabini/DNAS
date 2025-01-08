function [data, classes] = run(base, rset, imgsizes)

%  imgsizes = 224;
method='DNAS';
%rset=1:3;

featkind='degree+strength'; measures='all';
% disp([method, '  ', base, '  ', colorspace]);
%%% Bibliotecas necess�rias para usar o weka no m
%         classifiers= '/hd2/Dropbox/Mestrado e Doutorado/IFSC/Mestrado/SourceForge/Classifiers/';
%         addpath(classifiers);

        addpath('/home/scabini/Dropbox/Mestrado e Doutorado/IFSC/Mestrado/SourceForge/Classifiers/');
%         addpath(classifiers);
%         addpath('E:/Clouds/Dropbox/Mestrado e Doutorado\IFSC/Mestrado/SourceForge/Classifiers/');

        javaaddpath('weka.jar');
%         addpath([classifiers, 'svm_v0.55/']);
        import java.util.LinkedList;  
        format long;
%         addpath(genpath('/home/scabini/Dropbox/Mestrado and Beyond/IFSC/SourceForge/pca toolbox/drtoolbox')); %PCA toolbox
%         addpath(genpath('/home/scabini/Dropbox/Mestrado and Beyond/IFSC/SourceForge/pca toolbox/drtoolbox/*'));
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% disp(['Running ', method, ', base ', base, ', colorspace ', colorspace, ',']);

% path=['/hd2/Experiments/datasets/', base, '/'];
% path=['/hd2/Experiments/datasets/', base, '/'];
path = ['/home/scabini/Experiments/datasets/', base, '/'];

pathOut=['/home/scabini/Experiments/results/', method, '/', base, '/'];
% pathOut=['E:/Clouds/Experiments/datasets/results/Doutorado/JacarandaPaper/',   method, '/', base, '/'];
% pathOut=['/hd2/Experiments/results/Hyperspectral/', method, '/', base, '/'];

if exist(pathOut, 'dir')
    %se existe nao faz nada ne pora
    
else
    mkdir(pathOut);
    mkdir([pathOut, 'img features/']);
    mkdir([pathOut, 'results/']);
end
       
    arq1 = dir([path, '*.jpg']); 
    arq2 = dir([path, '*.png']);
    arq3 = dir([path, '*.lsm']);
    
    arq = [arq1; arq2; arq3];        
    results = [pathOut, method,'_dim', num2str(imgsizes),  '_R_', num2str(rset),' feature_matrix.mat'];
    
        if exist(results)==0                     

            disp('Getting image features...');
            data = [];
            classes={};
            mtime=0;
            foldindex = zeros(length(arq),1);
            disp(length(arq));
            parfor j=1 : length(arq) 
                tic();
                 path2= strcat(path, arq(j).name);%                 
                
                
                features = getFeatures(pathOut, arq(j).name, imgsizes, path2, rset, featkind, measures);                

                data = [data; features];
                
               
                [classe, fold] = strtok(arq(j).name, '_');                
                classes{j} = classe;
                                
                
                tnow = toc();
                mtime = mtime + tnow;
                disp([method, ':"', arq(j).name, '";class "', classe,'";time: ', num2str(tnow)  ';processed: ', num2str(round((100*j)/length(arq),2)), '% of the dataset;estimed time: ', num2str(((tnow*(length(arq)-j))/60)/60), 'h']);    
            end
           %save([pathOut, 'cross-validation-indices.mat'], 'foldindex');
           
           
           save(results, 'data', 'classes', '-v7');
           
           disp(['Process ended, mean time per file= ', num2str(mtime/length(arq)), 's ; total time spent= ', num2str(mtime), 's']);
        else
%             disp('maoe');
           load(results, 'data', 'classes');
           
           %load([pathOut, 'cross-validation-indices.mat'], 'foldindex');
           %vistex=0, usptex=91.5, outex13 79.7, mbt 98.4
        end
    
    disp(size(data));
    acc = [pathOut, 'results/', method, '_dim', num2str(imgsizes), '_R_', num2str(rset), ' WITH-CONF accs.mat'];
    
    if exist(acc)==0  
        disp('Classifying...');
        tic();
        caminho = [acc, '___data.arff'];
        createArff(caminho, data, classes);

        dataset = loadARFF(caminho);
        [mdata,featureNames,targetNDX,stringVals,relationName]=weka2matlab(dataset);

        %disp(classes);
        accKNN10f=[];
        for ite=1:10
            accKNN10f= [accKNN10f, classifyKNN(dataset, 10, ite)];%%CLASSIFICANDO COM KNN 10-FOLD
        end
        
        stdKNN = round(std(accKNN10f),1);
        accKNN10f = mean(accKNN10f);
        
        n= length(classes);
        accKNNl1o= classifyKNN(dataset, length(arq), 1);%%CLASSIFICANDO COM KNN LEAVE-1-OUT
        disp(['accuracy KNN leave-one-out: ', num2str(accKNNl1o)]);
        disp(['accuracy KNN 10-fold:       ', num2str(accKNN10f), '(+-', num2str(stdKNN), ')']);
    %     disp(accKNN10f);
        try%%CLASSIFICANDO COM LDA LEAVE-1-OUT
            [samples, feats] = size(mdata);
             newClasses = (mdata(1:samples, feats))+1;
             %disp(newClasses)
             [f, c, post] = lda(data, newClasses);

             [accLDAl1o, conf] = accLDA(newClasses, c);
    %          disp('accuracy LDA:');
    %          disp(accLDA10f);
        catch exception
           warning('Problema ao classificar com LDA');
           error = exception.getReport(); 
           disp(error);
           accLDAl1o=0;
        end
        
%         disp(accLDAl1o);
        
%         try%%CLASSIFICANDO COM LDA LEAVE-ONE-OUT MANUAL
%                 scheme = ['rand', num2str(n)];
%                 [samples, feats] = size(mdata);
%                  newClasses = (mdata(1:samples, feats))+1;
%                 [accLDAl1o, ~, ~] = classifyLDA(data, classes, scheme, 1);
% %                 [accLDAl1o, ~, ~] = classifyLDA(data, classes, scheme, 1);
%                 
%         catch exception
%             warning('Problema ao classificar com LDA');
%             error = exception.getReport(); 
%             disp(error);
%             accLDAl1o=0;
%         end
        
        disp(['accuracy LDA leave-one-out: ', num2str(accLDAl1o)]);

        try%%CLASSIFICANDO COM LDA 10-FOLD
            accLDA10f=[];
            for ite=1:10
%                 [ac, ~, ~] = classifyLDA(data, classes, 'rand10', ite);
%                 accLDA10f = [accLDA10f, ac];
            end
            stdLDA = round(std(accLDA10f), 1);
            accLDA10f = mean(accLDA10f);
        catch exception
           warning('Problema ao classificar com LDA');
           error = exception.getReport(); 
           %disp(error);
           accLDA10f=0;
           stdLDA=0;
        end
       disp(['accuracy LDA 10-fold:       ', num2str(accLDA10f), '(+-', num2str(stdLDA), ')']);
       
      
%        accRFl1o= classifyRForest(data, classes, length(data), 1);%%CLASSIFICANDO COM Random Forests
%        disp(['accuracy RF leave-one-out:  ', num2str(accRFl1o)]);
       

        [accSVMl1o, ~, ~] = classifySVM(data, classes, length(arq), 1);
        disp(['accuracy SVM leave-one-out: ', num2str(accSVMl1o)]);
        
        accSVM10f=[];
        for ite=1:10
            accSVM10f= [accSVM10f, classifySVM(data, classes, 10, ite)];%%CLASSIFICANDO COM KNN 10-FOLD
        end
        
        stdSVM= round(std(accSVM10f),1);
        accSVM10f = mean(accSVM10f);
    %     
          disp(['accuracy SVM 10-fold:       ', num2str(accSVM10f), '(+-', num2str(stdSVM), ')']);
    %     disp(accuracySVM);

        accRFl1o= classifyRForestWeka(dataset, length(arq), 1);
        %[accRFl1o, ~, ~] = classifyRForest(data, classes, length(arq), 1);
        disp(['accuracy RF leave-one-out:  ', num2str(accRFl1o)]);
        
        accRF10f=[];
        for ite=1:10
            accRF10f= [accRF10f, classifyRForestWeka(dataset, 10, ite)];%%CLASSIFICANDO COM KNN 10-FOLD
        end
        
        stdRF =round(std(accRF10f),1);
        accRF10f = mean(accRF10f);
        
        disp(['accuracy RF 10-fold:        ', num2str(accRF10f), '(+-', num2str(stdRF), ')']);
    

        fclose('all'); 
        disp('done!');
       
        save(acc, 'accKNN10f', 'stdKNN', 'accKNNl1o', 'accLDA10f', 'stdLDA', 'accLDAl1o', 'conf');
         toc();
    else
%         caminho = [pathOut, base, '_rset=', num2str(r), ' method_', featkind, ' mode_', mode, '_directed-singleParameter.arff'];
%         dataset = loadARFF(caminho);
%         [mdata,featureNames,targetNDX,stringVals,relationName]=weka2matlab(dataset);
%         
        load(acc, 'accKNN10f', 'stdKNN', 'accKNNl1o', 'accLDA10f', 'stdLDA', 'accLDAl1o', 'conf');
        disp(['accuracy KNN leave-one-out: ', num2str(accKNNl1o)]);
        disp(['accuracy KNN 10-fold:       ', num2str(accKNN10f), '(+-', num2str(stdKNN), ')']);        
        disp(['accuracy LDA leave-one-out: ', num2str(accLDAl1o)]);
        disp(['accuracy LDA 10-fold:       ', num2str(accLDA10f), '(+-', num2str(stdLDA), ')']);
%                
%     end
%     rrrr= round([accKNNl1o, accKNN10f, stdKNN, accLDAl1o, accLDA10f, stdLDA],1);
%     rrrr = ['&', method, '&', num2str(rrrr(1)), '&',num2str(rrrr(2)) ,'($\pm',num2str(rrrr(3)),'$)&',num2str(rrrr(4)), '&', num2str(rrrr(5)), '($\pm', num2str(rrrr(6)), '$)\\'];
%     disp(rrrr);
    %     disp(round(mean(rrrr),1));
%     disp(round(std(rrrr),1));
    end
end
