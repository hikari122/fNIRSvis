function hb_data = calc_cont(hb_data, info, para)
% CALC_CONT makes continuous Hb data function
% 
% In:
%   info <struct> : defines experiment information
%   hb_data <struct>: all hemoglobin data whose fiels are hemo values
%   across different cortex. Each field is a structure ifself that contains
%   HbO, Hb, and totalHb across all channels, raw and filtered as well. for
%   example:
%       hb_data.frontal.raw : raw data whose dimension is <3 x numsample x numchannel>/
%                             First row = HbO, second = Hb, third = total.
%       hb_data.frontal.fil : filtered data
%   para <struct> : defines filters' parameters
% Out:
%   hb_data <struct>: continuous Hb data


%Bandpass filter
Fs = 1/info.ts;
[b,a]=ellip(4,0.1,40,[para.high_val para.low_val]*2/Fs);
% [H,w]=freqz(b,a,512);
    
cortices = fieldnames(hb_data);
for i=1:info.ad_ch_max/2;
    for ct = 1:length(cortices)
        if ~eval(strcat('isa(hb_data.', cortices{ct},', ''struct'')')) % if the field being considered is structure, pass it
            continue;
        end
        for hm = 1:3    % 3 types of hemoglobin
            expression = strcat('hb_data.', cortices{ct}, '.fil(', num2str(hm),',:,i) = filtfilt(b,a,hb_data.', cortices{ct},'.raw(', num2str(hm),',:,i));');
            eval(expression);
        end
    end
end

%Moving average
a = 1;
b(1:ceil(Fs*para.mov_val))=1/(Fs*para.mov_val);
for i=1:info.ad_ch_max/2;
     for ct = 1:length(cortices)
        if ~eval(strcat('isa(hb_data.', cortices{ct},', ''struct'')')) % if the field being considered is structure, pass it
            continue;
        end
        for hm = 1:3    % 3 types of hemoglobin
            expression = strcat('hb_data.', cortices{ct}, '.fil(', num2str(hm),',:,i) = filtfilt(b,a,hb_data.', cortices{ct},'.fil(', num2str(hm),',:,i));');
            eval(expression);
        end
     end
end

% hb_data.all.fil = cat(3, hb_data.frontal.fil, hb_data.visual.fil);    
end

