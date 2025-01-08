function [mean, std] = evaluateBase(path, radius)
%Calcula os limiares automaticos usando uma porcentagem aleatorio das
%imagens no caminho 'path', usando 'radius'
    
        format long;
        sizeTraining=0.04; %porcentagem da base que ser� usada para estimar os limiares
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
        
    arq = dir([path, '*.lsm']); 
    
    nTraining = floor(length(arq)*sizeTraining);
    p = randperm(length(arq));
    arq = arq(p(1 : nTraining)); %escolhendo aleatoriamente 75% da base para treino
        
    histogram= zeros(1, 65537);
   
    n = 0;
    
    for i=1 : length(arq)
        disp([arq(i).name, ' thresholds-> ', num2str(i), ' of ', num2str(length(arq)) , ' r= ', num2str(radius)]);
        path2= strcat(path, arq(i).name);
        img=imread(path2);          
        vet = evaluateColors(double(img), radius);
        n = n + vet(1);
        %disp(n);
        %extractHistogram, na primira posi��o, retorna a quantidade de arestas
        %disp(size(vet));        
        histogram = histogram + vet(2:length(vet));
        %disp(sum(histogram));
    end
    mean=0;
    figure;
    plot(histogram/n);
    
    for i=1 : 65537
        mean = mean + (histogram(i) * (i-1));
    end
    
    mean = mean/n;
    std=0;
    for i=1 : 65537
        std = std + (((i-1 - mean)*(i-1 - mean))* histogram(i));
    end
    
    std = sqrt(std/(n-1));
    
    mean = mean/65536;
    std = std/65536;
    
%     li = max(mean - (3*std),(3/(256*sqrt(radius))));
%     lf = min(mean + (3*std),1);
end
    