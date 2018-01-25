function [ peaks ] = detectTransientPeaks(dFF_input,timeV_input,samplingRate)
% dFF = fpObj.idvData(mouseNum).dFF;
% dFFtimes = fpObj.idvData(mouseNum).timeVectors;

dFF = dFF_input;
dFFtimes = timeV_input;
% 
% dFF = dFF_reshaped(1,:);
% dFFtimes = timesVectors_reshaped(1,:);


%Whether to plot event detection result
plotres=0;

samprate=samplingRate;
%256;


filterthresh=2; %in std's over mean
ampthresh=2; %in std's over mean

% design filters:
filter04 = designfilt('lowpassfir','PassbandFrequency',0.2, ...
    'StopbandFrequency',0.4,'PassbandRipple',0.5, ...
    'StopbandAttenuation',70,'DesignMethod','kaiserwin','SampleRate',samprate);


filter40 = designfilt('lowpassfir','PassbandFrequency',40, ...
    'StopbandFrequency',42,'PassbandRipple',0.5, ...
    'StopbandAttenuation',65,'DesignMethod','kaiserwin','SampleRate',samprate);


dFF04=filtfilt(filter04,dFF);
dFF40=filtfilt(filter40,dFF);


figure;
h1=subplot(2,1,1);
plot(dFFtimes,dFF,'k');hold on;plot(dFFtimes,dFF04,'r');plot(dFFtimes,dFF40,'g')
h2=subplot(2,1,2);
plot(dFFtimes(1:end-1),diff((dFF40-dFF04).^2),'k')
linkaxes([h1, h2],'x')

dd=diff((dFF40-dFF04).^2);
potential_peaks=find(dd>mean(dd)+filterthresh*std(dd));
pp=potential_peaks(diff(potential_peaks)>0);
pp2=pp(dFF(pp)>mean(dFF)+ampthresh*std(dFF));


% finding beginning and end of each transient, and taking the maximum point
% between them as the exact peak
start_of_transients=[pp2(1);pp2(1+find(pp2(2:end)-pp2(1:end-1)>samprate))'];
end_of_transients=[pp2(diff(pp2)>samprate)'; pp2(end)];
if length(start_of_transients)~=length(end_of_transients)
    'sizes dont match'
    keyboard
end

peaks=[];
numpeaks=length(start_of_transients);
for i=1:numpeaks
    aroundpeak=dFF(start_of_transients(i):end_of_transients(i));
    peakind=find(aroundpeak==max(aroundpeak),1)+start_of_transients(i);
    peaks=[peaks peakind];
    
end

% plot transient-detection end result
    figure('position',[100 100 1000 500]);
    plot(dFFtimes,dFF,'k');hold on;plot(dFFtimes(peaks),dFF(peaks),'ro')
    xlabel('Time (s)')
    ylabel('dFF')
% end

