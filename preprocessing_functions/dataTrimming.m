function fpObj = dataTrimming(fpObj,mode,sessionLength)
% samplingRate = 1017.253;
totalfpObjNum = size(fpObj,2);
%%
for fpObjNum = 1:totalfpObjNum
    
    totalMouseNum = fpObj(fpObjNum).totalMouseNum;
    % Determine trimming range only trimming range doesn't exist at metadata
    for mouseNum = 1:totalMouseNum
        
        RawData_cut = fpObj(fpObjNum).idvData(mouseNum).RawData;
        
        if isnan(fpObj(fpObjNum).idvData(mouseNum).trimmingRange(2)) == 1 || fpObj(fpObjNum).idvData(mouseNum).trimmingRange(2) > length(RawData_cut)
            figure('Units','Inches', 'Position', [1, 1, 13, 8]);
            %get starting point and end point. only need two x values to cut.
            x = zeros(2,1);
            
            %plot of raw 473 and 405
            hold on;
            plot(RawData_cut(:,2),'r')
            plot(RawData_cut(:,3),'b')
            plot(RawData_cut(:,4:end)*50,'g')   %syk
            legend('473','405','event')
            set(gca,'xlim',[0 size(RawData_cut,1)]);
            %axis, divided by 1017, second
            
            legend('473','405','event')
            title(['Please select starting and ending point of' fpObj(fpObjNum).idvData(mouseNum).Description]);
            
            %%
%             button = uicontrol('Style','pushbutton','String','Discard',...
%                 'Position',[20 20 100 50],'callback',@button_callback);
%             choice = button.UserData;
%             pause(1)
%             close
%             if choice == 1
%                 fpObj(fpObjNum).idvData(mouseNum).trimmedRawData = 0;
%                 return
%             else
%                 
                startWaveIdx=find(strcmp(fpObj(fpObjNum).waveMode,'start'));
                if strcmp(mode,'auto')
                    disp('Starting point is selected from the TTL pulse');
                    if isempty(startWaveIdx)
                        error('There is no start wave');
                    end
                    if strcmp(fpObj(fpObjNum).TTLAlign,'on')
                        x(1) = fpObj(fpObjNum).idvData(mouseNum).TTLOnIdx{1,1}(1,1);
                        x(2) = x(1)+round(sessionLength*fpObj(fpObjNum).samplingRate);
                    else
                        x(1) = fpObj(fpObjNum).idvData(mouseNum).TTLOnIdx{1,1}(1,1);
                        x(2) = x(1)+round(sessionLength*fpObj(fpObjNum).samplingRate);
                    end
                    
                    %check if x(2) is bigger than actual data's length
                    if x(2) > size(fpObj(fpObjNum).idvData(mouseNum).RawData,1)
                        x(2) = size(fpObj(fpObjNum).idvData(mouseNum).RawData,1);
                    end
                    
                    
                    plot([x(1) x(1)],ylim,'black');
                    plot([x(2) x(2)],ylim,'black');
%                     pause;
                    disp('Trimming completed. You may close this plot');
                else
                    %get inputs to obtain x coordinate values
                    [x(1,1),~] = ginput(1);
                    disp(['Selected starting point: ' num2str(round(x(1,1))) ...
                        ' Selected ending point: ' num2str(round(x(2,1)))]);
                    plot([x(1) x(1)],ylim,'black');
                    [x(2,1),~] = ginput(1);
                    
                    disp(['Selected starting point: ' num2str(round(x(1,1))) ...
                        ' Selected ending point: ' num2str(round(x(2,1)))]);
                    round(x); %round up to nearest integer
                    plot([x(2) x(2)],ylim,'black');
                end
                pause(1);
                close;
                
                fpObj(fpObjNum).idvData(mouseNum).trimmingRange = round(x);
                fpObj(fpObjNum).trimmingRange{mouseNum,1} = round(x(1));
                fpObj(fpObjNum).trimmingRange{mouseNum,2} = round(x(2));
                
            end
            
            fpObj(fpObjNum).idvData(mouseNum).trimmedRawData = ...
                RawData_cut(fpObj(fpObjNum).idvData(mouseNum).trimmingRange(1):fpObj(fpObjNum).idvData(mouseNum).trimmingRange(2),:);
            
        end
        
        fpObj(fpObjNum).metaData(3:end,4:5) = fpObj(fpObjNum).trimmingRange;
%         xlswrite(fpObj(fpObjNum).metaDataFile,fpObj(fpObjNum).metaData);
        
    end
    
end
% end
