function [ features ] = getFeatures(pathOut, imgfile, imgsizes, path2, rset, featkind, measures)
   
%     imgsizes = 224;   
    features =[];
    
    parameters.measures=measures;
    
%     path2=img;
     flag = true;
     img = [];
    features=[];
    for r=1:length(rset)
        file = [pathOut, '/img features/', imgfile, 'dim', num2str(imgsizes), '_r', num2str(rset(r)), '.mat'];
        if exist(file)==0
            
%             img=double(imread(path2));
            
            if flag 
                 img=imread(path2);  
                 img=imresize(img, [imgsizes,imgsizes]);
                 
                 [w,h,z] = size(img); 
                 parameters.z=z;
                  flag = false;
                  img = double(img);
            end

            [full] = CNdirected_hyperspectral_noborder(img, rset(r));            
            parameters.r=rset(r);        
            
            degree= [getMeasures(full(1,:), parameters); getMeasures(full(2,:), parameters)];
          
            strength = [getMeasures(full(3,:), parameters); getMeasures(full(4,:), parameters)];
            
            ALLfeatures = [degree;strength];
            
            save(file, 'ALLfeatures', '-v7');   
        else        
            
            load(file, 'ALLfeatures');            
        end
        
        degreeALLfeatures =ALLfeatures (1:2,:);
        strengthALLfeatures = ALLfeatures (3:4,:);
        
        [~, featSize] = size(degreeALLfeatures);
        
        
        degreeALLfeatures = degreeALLfeatures(1, :);
        strengthALLfeatures = reshape(strengthALLfeatures(1:2, :), [1, featSize*2]);  
%         strengthALLfeatures = strengthALLfeatures(1, :);           
        
        
        switch featkind
            case 'degree'                
                features = [features, degreeALLfeatures];
            case 'strength'
                features = [features, strengthALLfeatures];
            case 'degree+strength'
                features = [features, degreeALLfeatures, strengthALLfeatures];
        end
    end
end


