function [mdex ] = MainDirec(a)
% function: the main direction of the image
% description: the direction edge is [0,180],and the direction are divided
%              to 18 part by 10,
% output: the index of the direction ,form 1 to 18;where 1 is defined as the
% direction belong to[0,18],the rest can be done in the same manner,18
% derecting to [170,180]
% last modification:Dec.19,2011 by Lucifer.jia

if(size(a,3)~=1)
    a=rgb2gray(a);
end
[w,h]=size(a);
edge_a=edge(a,'canny');

fedge_a=fftshift(fft2(edge_a));
%power of fft
realf=real(fedge_a);
imagf=imag(fedge_a);
pfa=sqrt(realf.^2+imagf.^2);

% theat=atan2(imagf,realf);
% normalization theat to [0,pi]
dhist=zeros(1,180);
%round dot of the pol
x0=w/2; y0=h/2;
for i=1:w
    for j=1:h
        temp=atan2(j-y0,i-x0);
        if(temp<0)
            temp=temp+pi;
        end
        
        temp=mod(round(temp*180/pi),180);
        
        dhist(temp+1)=dhist(temp+1)+pfa(i,j);
    end
end

dsp=[0:5:170;10:5:180];
hist=zeros(1,36);
for i=1:180
    for k=1:35
        if(i>dsp(1,k) && i<=dsp(2,k))
            hist(k)=hist(k)+dhist(i);
        end
    end
end
[mhist,mdex]=max(hist);

end
