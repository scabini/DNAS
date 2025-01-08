function [ vector ] = getMeasuresSTR( data, measures)
%UNTITLED Summary of this function goes here
%Retorna as medidas (measures) referentes a distribuição de entrada (data)
%   Detailed explanation goes here

format long;

media = mean(data);
energia = var(data);
entropia= wentropy(data,'shannon');
desvio = std(data);

vector = [];

if strcmp(measures, 'mean')==1
    vector =[media];
else
    if strcmp(measures, 'std')==1
        vector =[desvio];
    else
       if strcmp(measures, 'energy')==1
            vector =[energia];
       else    
           if strcmp(measures, 'entropy')==1
                vector =[entropia];
           else
               if strcmp(measures, 'all')==1%case = all -> usa todas as medidas estatisticas como feature
                    vector =[media, desvio, energia, entropia];
               else
                   vector = [];
               end
           end
        end                    
    end
end   

%vector =[media, desvio];
%vector =[media, desvio, entropia];
%vector =[media];
%vector =[entropia, desvio, contraste, homogeneidade, energia];
%vector =[media, desvio, energia, entropia];
end