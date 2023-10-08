
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
% Pre-process input and select appropriate filter.  
function B = bfilter2(A,w,sigma)  
% Apply either grayscale or color bilateral filtering.  
if size(A,3) == 1  
   B = bfltGray(A,w,sigma(1),sigma(2));  %作用于灰度图像
else  
   B = bfltColor(A,w,sigma(1),sigma(2));  %作用于RGB彩色图像
end  
  