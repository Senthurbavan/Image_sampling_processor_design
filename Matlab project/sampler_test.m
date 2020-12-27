ip = randi(8,8)

k = 3;
l = 3;

img_sampled = zeros(k,l);

for i=1:k
    for j=1:l
        img_sampled(i,j) = floor((1/16)*(1*ip(2*i-1,2*j-1)+ 2*ip(2*i-1,2*j)+ 1*ip(2*i-1,2*j+1)+... gaussian filter
                                         2*ip(2*i,2*j-1)+ 4*ip(2*i,2*j)+ 2*ip(2*i,2*j+1)+...
                                         1*ip(2*i+1,2*j-1)+ 2*ip(2*i+1,2*j)+ 1*ip(2*i+1,2*j+1)));
    end
end

img_sampled