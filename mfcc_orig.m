% MFCC implement with Matlab % 原始信号 
[x fs]=audioread('C:\Users\lifangzu\Desktop\car crash\play(4).mp3');  %读取音频信号 x为信号样本，fs信号采样频率
bank=melbankm(24,1024,fs,0,0.4,'t'); %Mel滤波器的阶数为24，FFT变换的长度为256，采样频率为fs  
%归一化Mel滤波器组系数  
bank=full(bank); %将稀疏矩阵转化为完全矩阵
bank=bank/max(bank(:));  %滤波器组归一化
for k=1:12  
    n=0:23;  
    dctcoef(k,:)=cos((2*n+1)*k*pi/(2*24));  
end  
w=1+6*sin(pi*[1:12]./12);%归一化倒谱提升窗口  
w=w/max(w);%预加重滤波器  
xx=double(x);  
xx=filter([1-0.9375],1,xx);%预加重处理
%语音信号分帧  
xx=enframe(xx,1024,512);%对xx1024点分为一帧  
%计算每帧的MFCC参数  
for i=1:size(xx,1)  
    y=xx(i,:);  
    s=y'.*hamming(1024);  
    t=abs(fft(s));%FFT快速傅里叶变换  
    t=t.^2;  
    c1=dctcoef*log(bank*t(1:513));  
    c2=c1.*w';  
    m(i,:)=c2;  
end  
%求一阶差分系数  
dtm=zeros(size(m));  
for i=3:size(m,1)-2  
    dtm(i,:)=-2*m(i-2,:)-m(i-1,:)+m(i+1,:)+2*m(i+2,:);  
end  
dtm=dtm/3;  
%求取二阶差分系数  
dtmm=zeros(size(dtm));  
for i=3:size(dtm,1)-2  
    dtmm(i,:)=-2*dtm(i-2,:)-dtm(i-1,:)+dtm(i+1,:)+2*dtm(i+2,:);  
end  
dtmm=dtmm/3;  
%合并mfcc参数和一阶差分mfcc参数  
ccc=[m dtm dtmm];  
%去除首尾两帧，以为这两帧的一阶差分参数为0  
ccc=ccc(3:size(m,1)-2,:);  
ccc;  
subplot(2,1,1);  
ccc_1=ccc(:,1);  
plot(ccc_1);title('MFCC');ylabel('幅值');  
[h,w]=size(ccc);  
A=size(ccc);  
subplot(2,1,2);  
plot([1,w],A);  
xlabel('维数');ylabel('幅值');  
title('维数与幅值的关系');  