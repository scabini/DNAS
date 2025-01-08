function  createArff(path, data, classes)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
import java.util.LinkedList;

fileID = fopen(path, 'w');

     fprintf(fileID, '@RELATION knn\r\n\r\n');    

     
     [n, m] = size(data);
     
     
     for i=1 : m
         fprintf(fileID, '@ATTRIBUTE measure%1d REAL\r\n', i);
     end
     
     list = LinkedList();
     fprintf(fileID, '@ATTRIBUTE class {');
     for i=1 : numel(classes)
         if(~(list.contains(classes{i})))
            fprintf(fileID, '%s', classes{i});
            list.add(classes{i});
         
             if i < numel(classes)
                 fprintf(fileID, ', ');
             end
         end
     end
     
     fprintf(fileID, '}\r\n\r\n@DATA\r\n');
     
     for i=1 : n
        for j=1:m
            fprintf(fileID, '%f, ', data(i,j));
        end
        fprintf(fileID, '%s\r\n', classes{i});
     end
     fclose(fileID);
end

