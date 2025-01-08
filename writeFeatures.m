function writeFeatures(nr)
path='/home/scabini/Experiments/datasets/DTD/';
pathOut='/home/scabini/Experiments/results/m1/DTD/'; base='DTD';

featkind = 'degree';
measures= 'all';
nt=10;
alpha=3;
base='kthtips';

    radius = [1, 4, 9, 16, 25, 36, 49, 64];
    nr = str2num(nr);
    r = radius(nr);
    
    disp('Radiuset:');
    disp(sqrt(r));
    nr=1;    
    
    arq1 = dir([path, '*.jpg']); 
    arq2 = dir([path, '*.png']);
    arq3 = dir([path, '*.bmp']); 
    arq = [arq1; arq2; arq3];
  
    %threshold =[3, 3, 3, 3, 3, 3];
    
    
            disp('Getting thresholds...');

            tset = zeros(nr, nt);
            mean=0; std=0;
            for i=1:nr
                file = [pathOut, 'thresholds_r=', num2str(sqrt(r(i))) , ' alpha_', num2str(alpha), '.mat'];
                if exist(file)== 0                
                    [mean, std] = evaluateBase(path, r(i));
                    save(file, 'mean', 'std');                    
                else
                   load(file, 'mean', 'std');            
                end
                initial = max(mean - (alpha*std),(3/(256*sqrt(r(i)))));
                final = min(mean + (alpha*std),1);
                
                delta = (final - initial)/(nt-1);
                tset(i, :) = [initial:delta:final];
            end 
    
            disp('done! tset:');
            disp(tset);


            disp('Processando...');
            data = [];
            classes={};
            mtime=0;
            for j=1 : length(arq) 
                tic();
                path2= strcat(path, arq(j).name);
                img=imread(path2);               
                img = im2uint8(img);
                if size(img,3) < 3
                  R = img;
                  G = img;
                  B = img;
 
               else
                 R = img(:,:,1);
                 G = img(:,:,2);
                 B = img(:,:,3);

               end 

                features=getFeatures(pathOut, arq(j).name, double(R), double(G), double(B), double(r), double(tset), featkind, measures);

                data = [data; features];
                classe = strtok(arq(j).name, '_');       
                classes{j} = classe;
                tnow = toc();
                mtime = mtime + tnow;
                disp(['got features ', arq(j).name, ', processing time: ', num2str(tnow), ', processed ', num2str(round((100*j)/length(arq))), '% of the dataset so far.']);
            end
          
           
           disp(['Process ended, mean time per file= ', num2str(mtime/length(arq)), 's ; total time spent= ', num2str(mtime), 's']);
        
         
    
end
