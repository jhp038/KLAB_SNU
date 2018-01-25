%% New method with peak finding code
clearvars -except fpObj
Fs = fpObj(1).samplingRate;
Fn = Fs/2;
num = 1;
X = fpObj.idvData(num).dFF;%(fpObj.idvData(num).TTLOnIdx{1}:fpObj.idvData(num).TTLOffIdx{1});%(1:end/2);
timeV =  fpObj.idvData(num).timeVectors;%(fpObj.idvData(num).TTLOnIdx{1}:fpObj.idvData(num).TTLOffIdx{1});
X = movmean(X,round(Fs));
threshold =2.91*mad(X,1);% mean_X +2*std_X;
[pks,locs] = findpeaks(X,'MinPeakHeight',threshold,'Annotate','extents');
%Plotting peaks w/o threshold
figure
plot(X,'b');hold on;plot(locs,pks,'o','Color','r')
% %% 
% % TempData = fpObj.idvData(num).TempData;
% % TempTimeStamp =  fpObj.idvData(num).TempTimeStamp;
% %X = X + abs(min(X));
% %X = X(1:end/2);
% Fs = fpObj(1).samplingRate;
% X = movmean(X,round(Fs));
% 
% n = 1;
% Fn = Fs/2;
% ftype = 'low'
% % %% Band pass filter
% % [c,d] = butter(2,[4/Fn 40/Fn],'bandpass');
% % out0 = filtfilt(c,d,X);
% % figure;plot(out0)
% % plot(difference)
% % %%
% Wn_1 = 40; %cut off frequency, 40 Hz
% [b,a]=butter(n, Wn_1/Fn, ftype);
% out1=filtfilt(b,a,X);
% % plot(out1)
% 
% Wn_2 =4; %cut off frequency, 4 Hz
% [b,a]=butter(n, Wn_2/Fn, ftype);
% out2=filtfilt(b,a,X);
% % plot(out2)
% 
% difference = out1 - out2;
% 
% squared_diff = (difference).^2;
% squared_diff_derivative = diff(squared_diff)./(diff(timeV));
% 
% plot(squared_diff)
% 
% 
% x=[0:.01:500]'; y=x.*sin(x.^2).^2; tic; 
% P=findpeaksx(x,y,0,0,3,3); toc; NumPeaks=length(P)
%
% plot(P)
%
%

