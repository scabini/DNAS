
r=1;
parameters.r=double(r); 
featkind='degree+strength'; measures='all';
parameters.measures=measures;
parameters.z = 32;

for i=1:10
    img = zeros(2048,2048,32);
    tic();
    [full] = CNdirected_hyperspectral_noborder(img, double(r));            
           

    degree= [getMeasures(full(1,:), parameters); getMeasures(full(2,:), parameters)];

    strength = [getMeasures(full(3,:), parameters); getMeasures(full(4,:), parameters)];  
    toc();
end

