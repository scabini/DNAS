function [ features ] = getFeaturesR(pathOut, imgfile, img, rset, tset, featkind, measures, mode)
%Versão robusta para rodar de uma única vez varios raios e thresholds
%Retorna as features (featkind= 'degree', 'strength', 'clustering',
%'pagerank') da rede criada com R, G e B usando raio rset e threshold tset
     [~,nt]=size(tset);
     nr=length(rset);
     
    features =[];
    
     ALLfeatures = [];
     if strcmp(mode, 'IN+OUT')==1
            modo='IN';            
            file = [pathOut, '/img features/', imgfile, ' r_', num2str(rset), ' t_', num2str(tset), ' statistics_', measures, ' mode_', modo, '.mat'];
            if exist(file)==0            
                degreeF     = [];
                strengthF   = [];                    
                [k, str] = extractColors_FULL(img, rset, tset, 2); 

                [n,~]=size(k);
                for i=1:n                                       
                   %[k, str,cls,prank] = extractColors_FULL(R,G,B, rset(r), tset(r,t), 2);                       
                    degreeF     = [degreeF, getMeasures(k(i,:), measures)];
                    strengthF   = [strengthF, getMeasuresSTR(str(i,:), measures)]; 
                end

                ALLfeatures = [degreeF; strengthF];
                save(file, 'ALLfeatures');   
            else
                load(file, 'ALLfeatures');
            end                        
            
            ALLfeaturesI = ALLfeatures;
            ALLfeatures= [];

            modo='OUT';
            file = [pathOut, '/img features/', imgfile, ' r_', num2str(rset), ' t_', num2str(tset), ' statistics_', measures, ' mode_', modo, '.mat'];
            if exist(file)==0            
                degreeF     = [];
                strengthF   = [];                    
                [k, str] = extractColors_FULL(img, rset, tset, 3); 

                [n,~]=size(k);
                for i=1:n                                       
                   %[k, str,cls,prank] = extractColors_FULL(R,G,B, rset(r), tset(r,t), 2);                       
                    degreeF     = [degreeF, getMeasures(k(i,:), measures)];
                    strengthF   = [strengthF, getMeasuresSTR(str(i,:), measures)]; 
                end

                ALLfeatures = [degreeF; strengthF];
                save(file, 'ALLfeatures');   
            else
                load(file, 'ALLfeatures');
            end 
            ALLfeatures = [ALLfeaturesI, ALLfeatures];

     else

         switch mode
                case 'FULL'
                    file = [pathOut, '/img features/', imgfile, ' r_', num2str(rset), ' t_', num2str(tset), ' statistics_', measures, '.mat'];

                case 'IN'
                    file = [pathOut, '/img features/', imgfile, ' r_', num2str(rset), ' t_', num2str(tset), ' statistics_', measures, ' mode_', modo, '.mat'];

                case 'OUT'
                    file = [pathOut, '/img features/', imgfile, ' r_', num2str(rset), ' t_', num2str(tset), ' statistics_', measures, ' mode_', modo, '.mat'];              
         end  
           if exist(file)==0            
                degreeF     = [];
                strengthF   = [];
                for t=1:h
                    switch mode
                        case 'FULL'
                            [k, str] = extractColors_FULL(img, rset, tset, 1); 

                        case 'IN'
                            [k, str] = extractColors_FULL(img, rset, tset, 2); 

                        case 'OUT'
                            [k, str] = extractColors_FULL(img, rset, tset, 3);                       
                    end               

                    [n,~]=size(k);
                    for i=1:n                                       
                       %[k, str,cls,prank] = extractColors_FULL(R,G,B, rset(r), tset(r,t), 2);                       
                        degreeF     = [degreeF, getMeasures(k(i,:), measures)];
                        strengthF   = [strengthF, getMeasuresSTR(str(i,:), measures)]; 
                    end
                end
                ALLfeatures = [degreeF; strengthF];
                save(file, 'ALLfeatures');   
            else
               load(file, 'ALLfeatures');
            end
     end

        
        
       if strcmp(featkind, 'degree')==1
            features = [features, ALLfeatures(1,:)];
       else
            if strcmp(featkind, 'strength')==1
                features = [features, ALLfeatures(2,:)];
            else
               if strcmp(featkind, 'clustering')==1
                   if strcmp(mode, 'IN')==1 && rset(r)==1
                            %nao inclui o clustering quando mode=IN e r=1
                   else
                       if strcmp(mode, 'IN+OUT')==1 && rset(r)==1
                                    % nao inclui o clustering quando mode=IN e r=1
                           features = [features, ALLfeatures(3, length(ALLfeatures)/2 +1:length(ALLfeatures))];
                        else
                           features = [features];
                       end                       
                   end                    
               else
                   %quarto caso = pagerank
                   if strcmp(featkind, 'pagerank')==1
                        features = [features, ALLfeatures(4,:)];
                   else 
                       if strcmp(featkind, 'degree+strength+clustering')==1
                           if strcmp(mode, 'IN')==1 && rset(r)==1
                                %nao inclui o clustering quando mode=IN e r=1
                                features = [features, ALLfeatures(1,:), ALLfeatures(2,:)];
                           else
                               if strcmp(mode, 'IN+OUT')==1 && rset(r)==1
                                    % nao inclui o clustering quando mode=IN e r=1
                                   features = [features, ALLfeatures(1,:), ALLfeatures(2,:), ALLfeatures(3, length(ALLfeatures)/2 +1:length(ALLfeatures))];
                                else
                                   features = [features, ALLfeatures(1,:), ALLfeatures(2,:), ALLfeatures(3,:)];
                               end                               
                           end                            
                       else
                           if strcmp(featkind, 'degree+clustering')==1
                               if strcmp(mode, 'IN')==1 && rset(r)==1
                                %nao inclui o clustering quando mode=IN e r=1
                                    features = [features, ALLfeatures(1,:)];
                               else
                                    if strcmp(mode, 'IN+OUT')==1 && rset(r)==1
                                        % nao inclui o clustering quando mode=IN e r=1
                                       features = [features, ALLfeatures(1,:), ALLfeatures(3, length(ALLfeatures)/2 +1:length(ALLfeatures))];
                                    else
                                       features = [features, ALLfeatures(1,:), ALLfeatures(3,:)];
                                    end
                               end                                
                           else
                               if strcmp(featkind, 'degree+strength')==1
                                    features = [features, ALLfeatures(1,:), ALLfeatures(2,:)];
                               else
                                   if strcmp(featkind, 'strength+clustering')==1
                                       if strcmp(mode, 'IN')==1 && rset(r)==1
                                        %nao inclui o clustering quando mode=IN e r=1
                                            features = [features, ALLfeatures(2,:)];
                                       else
                                            if strcmp(mode, 'IN+OUT')==1 && rset(r)==1
                                                % nao inclui o clustering quando mode=IN e r=1
                                               features = [features, ALLfeatures(2,:), ALLfeatures(3, length(ALLfeatures)/2 +1:length(ALLfeatures))];
                                            else
                                               features = [features, ALLfeatures(2,:), ALLfeatures(3,:)];
                                            end                                            
                                       end 
                                        
                                   else
                                       if strcmp(featkind, 'degree+pagerank')==1
                                            features = [features, ALLfeatures(1,:), ALLfeatures(4,:)];
                                       else 
                                           if strcmp(featkind, 'strength+pagerank')==1
                                                features = [features, ALLfeatures(2,:), ALLfeatures(4,:)];
                                           else 
                                               if strcmp(featkind, 'clustering+pagerank')==1
                                                   if strcmp(mode, 'IN')==1 && rset(r)==1
                                                    %nao inclui o clustering quando mode=IN e r=1
                                                         features = [features, ALLfeatures(4,:)];
                                                   else
                                                       if strcmp(mode, 'IN+OUT')==1 && rset(r)==1
                                                            % nao inclui o clustering quando mode=IN e r=1
                                                           features = [features, ALLfeatures(3, length(ALLfeatures)/2 +1:length(ALLfeatures)), ALLfeatures(4,:)];
                                                        else
                                                           features = [features, ALLfeatures(3,:), ALLfeatures(4,:)];
                                                       end                                                        
                                                   end
                                                   
                                                    features = [features, ALLfeatures(3,:), ALLfeatures(4,:)];
                                               else %case = all -> pega todas as features de cada medida topologica e concatena
                                                   %disp('all');
                                                   if strcmp(mode, 'IN')==1 && rset(r)==1
                                                    %nao inclui o clustering quando mode=IN e r=1
                                                        features = [features, ALLfeatures(1,:), ALLfeatures(2,:), ALLfeatures(4,:)];
                                                   else
                                                       if strcmp(mode, 'IN+OUT')==1 && rset(r)==1
                                                            % nao inclui o clustering quando mode=IN e r=1
                                                           features = [features, ALLfeatures(1,:), ALLfeatures(2,:), ALLfeatures(3, length(ALLfeatures)/2 +1:length(ALLfeatures)), ALLfeatures(4,:)];
                                                        else
                                                           features = [features, ALLfeatures(1,:), ALLfeatures(2,:), ALLfeatures(3,:), ALLfeatures(4,:)];
                                                       end                                                        
                                                   end            
                                                   
                                               end
                                           end
                                       end
                                   end
                               end
                           end
                       end 
                   end
                end                    
            end
       end        
end