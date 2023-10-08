clear all;
close all;
im1=imread('3%.jpg');
im=rgb2gray(im1)

im=imadjust (im);
figure
imshow(im)
 
 
 
ff = im; 
size1 = size(ff);  
 
% block processing
blocknum =16;    % number of blocks
length = size1(1);  
height = size1(2);  
lengthSide = floor(length/blocknum);  % length of each block
heightSide = floor(height/blocknum);  % height of each block

for k = 1:blocknum
    for n = 1:blocknum
        block = zeros(size(ff)); 
        lini = 1 + lengthSide * (n - 1);
        hini = 1 + heightSide * (k - 1);   
        x = lini:(lini + lengthSide - 1);
        y = hini:(hini + heightSide - 1);   
        block(x, y) = 1; 
        
        ff = double(ff);  
        block = block .* ff;  
        block = block(x, y);  
        
        %%%%%%%%%%%%%%%%%% segmentation %%%%%%%%%%%%%%%%%%%%%
        
        block=double(block)/255;  
        w = 2;       % bilateral filter half-width  
        sigma = [3 0.1]; % bilateral filter standard deviations  
        block=bfilter2(block,w,sigma);  
        block=im2uint8(block);
        block=double(block);
 
        z=3; % Gradient threshold, determines the target width
        [mdex ] = MainDirec(block);
        [a,b]=gradient(block);
        G=block;
        if 9<=mdex&&mdex<=27
            G(a>=z)=255;  
            G(a<z)=0;
        else
            G(b>=z)=255;  
            G(b<z)=0;
        end
        bw=G;
        [m,n] = size(bw);
        for i = 2:m-1
        for j = 2:n-1   
            if(bw(i,j)~=bw(i+1,j) && bw(i,j)~=bw(i-1,j))
                bw(i,j) = 1;
            elseif(bw(i,j)~=bw(i,j+1) && bw(i,j)~=bw(i,j-1))
                bw(i,j) = 1;
            elseif(bw(i,j)~=bw(i+1,j+1) && bw(i,j)~=bw(i-1,j-1))
                bw(i,j) = 1;
            elseif(bw(i,j)~=bw(i-1,j+1) && bw(i,j)~=bw(i+1,j-1))
                bw(i,j) = 1;
            end
        end
        end
        bw=bwareaopen(bw,200)
 
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       
        % Splicing
        ff(x,y) =bw;
    end
end
ff=bwareaopen(ff,200)
figure
 imshow(ff)
 
 S=numel(ff);
s=sum(sum(ff));
ratio=s/S;  % area ratio
 
 
 
 
 
 [m,n]=size(ff);
image(:,:,3)=zeros(m,n);
image(:,:,2)=zeros(m,n);
image(:,:,1)=ff.*255;
figure
imshow(image)
 
im1=double(im1);
image=double(image);
c=imadd(im1,image);
c=uint8(c)
figure
imshow(c)
imwrite(c,'55.jpg')