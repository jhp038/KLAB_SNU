fpObj.idvData.dFF

windowWidth1 = 40; 
kernel1 = ones(windowWidth1,1) / windowWidth1;
out1 = filter(kernel1, 1, fpObj.idvData.dFF);

windowWidth2 = 4000; 
kernel2 = ones(windowWidth2,1) / windowWidth2;
out2 = filter(kernel2, 1, fpObj.idvData.dFF);

squared_diff = (out1-out2).^2
sqaured_diff_derivative = diff(squared_diff)

figure()
subplot(5,1,1)
plot(fpObj.idvData.dFF)
subplot(5,1,2)
plot(out1)
subplot(5,1,3)
plot(out2)
subplot(5,1,4)
plot(squared_diff)
subplot(5,1,5)
plot(squared_diff_derivative)

%%
h = fdesign.lowpass('N,Fc',1,4);
d = design(h);
out1 = filter(d,fpObj.idvData.dFF);


d =  fdesign.lowpass('Fp,Fst,Ap,Ast',40,42,0.5,40,fpObj.samplingRate);
designmethods(d);
Hd = design(d,'equiripple');


%%

% figure(1)
% plot(fpObj.idvData.dFF);
% title('raw dF/F, sampling rate =  1.0173e+03')

Fs = fpObj.samplingRate;
Fn = fpObj.samplingRate/2;
ftype = 'low';

n = 7

Wn = 40; %cut off frequency, 40 Hz
[b,a]=butter(n, Wn/Fn, ftype);
out1=filter(b,a,fpObj.idvData.dFF);

Wn = 0.4; %cut off frequency, 0.4 Hz
[b,a]=butter(n, Wn/Fn, ftype);
out2=filter(b,a,fpObj.idvData.dFF);

squared_diff = (out1-out2).^2;
squared_diff_derivative = diff(squared_diff);
peak = squared_diff_derivative >= 2*std(squared_diff_derivative);

figure()
subplot(3,2,1);
plot(fpObj.idvData.dFF);
title('raw dF/F');

subplot(3,2,3);
plot(out1);
title('lowpass filtered, 40Hz, order = 7');

subplot(3,2,5);
plot(out2);
title('lowpass filtered, 0.4Hz, order = 7');

subplot(3,2,2);
plot(out1-out2);
title('difference');

subplot(3,2,4);
plot(squared_diff);
title('squared diffrence');

subplot(3,2,6);
hold on
plot(squared_diff_derivative);
title('derivative');
plot(fpObj.idvData.timeVectors, 2*std(squared_diff_derivative))

peak_crossing = diff(peak);
peak_ON_index = find(peak_crossing ==1);
peak_ON_time = fpObj.idvData.timeVectors(peak_ON_index);
peak_ON_dFF = fpObj.idvData.dFF(peak_ON_index);
peak_OFF_index = find(peak_crossing ==-1);
peak_OFF_time = fpObj.idvData.timeVectors(peak_OFF_index);
peak_OFF_dFF = fpObj.idvData.dFF(peak_OFF_index);

peak_ON_num = length(peak_ON_index);
peak_OFF_num = length(peak_OFF_index);

peak_width = peak_OFF_index - peak_ON_index;
peak_middle_index = floor( peak_ON_index + peak_width/2);
peak_middle_time = fpObj.idvData.timeVectors(peak_middle_index);
peak_middle_dFF = fpObj.idvData.dFF(peak_middle_index);


            
figure()
hold on
plot(fpObj.idvData.timeVectors, fpObj.idvData.dFF);
plot(peak_middle_time, peak_middle_dFF,'o')

        