function [Nanostructure, imgradonall,imgradonwedge]=Spatial_pixel_expansion_algorithm(num2d);
    %clc;clear all;close all

    % x = rand(60,1);
    
    theta=-90:0.7032:90;
    thetaindex=[26,126,227];
    theta(thetaindex)=[-72.5,-2.2,68.6];
    imgradon=single(zeros(256,256,178));
    imgradonall=single(zeros(256,256,256));
    Vfinal=zeros(179,178,178);
for i=1:num2d
    % cube space
    V=zeros(178,178,178);
    a1=randi([20,90]);
    b1=randi([20,90]);
    c1=randi([20,90]);
    a2=a1+70;
    b2=b1+70;
    c2=c1+70;
    %point number
    n=randi([70,700]);
    x=randi([a1 a2],n,1);
    y=randi([b1 b2],n,1);
    z=randi([c1 c2],n,1);

    
    Vfiltreduce=randi([5,10])/1000;

    Vfilt2=zeros(178,178,178);
    if  randi(3)~=1
        Rradius=randi([20,35]);
        Vindex2=find((x-89).*(x-89)+(y-89).*(y-89)+(z-89).*(z-89)<Rradius*Rradius);
        x(Vindex2)=[];
        y(Vindex2)=[];
        z(Vindex2)=[];
        % core
        n1=randi([15,150]);
        x1=randi([89-Rradius,89+Rradius],n1,1);
        y1=randi([89-Rradius,89+Rradius],n1,1);     
        z1=randi([89-Rradius,89+Rradius],n1,1); 
        

        Vindex2=x1+(y1-1)*178+(z1-1)*178*178;
        V2=zeros(178,178,178);
        V2(Vindex2)=randi(255,n1,1);
        Vfilt2=imgaussfilt3(V2,randi([3,10])); 
        Vfilt2(Vfilt2< Vfiltreduce)=0; 
    end
    Rradius2=randi([50,70]);
    Rradius2=[Rradius2*Rradius2,90*90];
    Vindex3=find((x-89).*(x-89)+(y-89).*(y-89)+(z-89).*(z-89)>Rradius2(randi(2)));
    x(Vindex3)=[];
    y(Vindex3)=[];
    z(Vindex3)=[];
    Vindex=x+(y-1)*178+(z-1)*178*178;

    V(Vindex)=randi(255,size(x,1),1);
    Vfilt=imgaussfilt3(V,randi([3,10])); 
    Vfilt(Vfilt< Vfiltreduce)=0; 
    
    Vfinal(1:178,:,:)=(Vfilt+Vfilt2);
    

%     volshow(Vfinal)

    % Radon transform
    for j=1:178
        imgradon(1:255,:,j)=radon(Vfinal(:,:,j),theta);
    end
    Nanostructure{i}=Vfinal;
    imgradonall(:,:,(1+178*(i-1)):(178+178*(i-1)))=rescale(imgradon);

end
imgradonwedge=single(zeros(size(imgradonall)));
H = fspecial('disk',3);
img1radonwedge=imnoise(imgradonall,'poisson');
imn1gauss=imnoise(img1radonwedge,'gaussian',0,randi(100,1)/10000);
im1noise= imfilter(imn1gauss,H,'replicate');
imgradonwedge(:,thetaindex,:)=im1noise(:,thetaindex,:);

