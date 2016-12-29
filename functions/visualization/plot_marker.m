function varargout = plot_marker(ts, sig, marker, level)
% PLOT_MARKER plots given signal along with the mental workload level onset
%
% In:
%   ts:     time sampling (distance between 2 adjacent samples in time)
%   sig <numsample x numchannel>: signal, may include mutiple channels
%   marker: vector that stores event onset, usually info.mark.
%   level:  mental workload levels (0: low, 1: high)
%
% Example:
%   % For subject
%   link =strcat('..\..\data\Thao_rubic\Subject1');
%   linkdata = strcat(link,'\data\data1.mat');
%   load(linkdata);     % This would release 'testdata' variable <16837x263>
%   [info, ad_data] = load_ad(linkdata);    
% 
%   % For data 1
%   linklevel = strcat(link, '\color\color1.mat');
%   load(linklevel);    % This would release 'color_data' variable (2,4,4,...)
%   level(color_data==2) = 0;
%   level(color_data==4) = 1;
%   [info, ad_data] = load_ad(linkdata);
% 
%   figure
%   plot_marker(info.ts, ad_data.raw, info.mark, level)

% Make sure the dimension of sig is legitimate
if size(sig,1) < size(sig,2)
    sig = sig';
end

% Prepare time series
time = (0:size(sig,1)-1)*ts;

% Plot signals
hplot = plot(time, sig);

% Work with marker
ylimit = get(gca, 'ylim');

% Convert marker to time
mark = [];
for t=1:9
    mark = [mark; marker(t)];
    temp = marker(t+1:end);
    mark = [mark; round((temp(1)+mark(end))/2)];    
end
mark = [mark; marker(end)];
mark = round(mark.*ts);

% Start ploting
hold on
ix = 0;
for i=1:2:length(mark)-2
    ix = ix + 1;
    A = mark(i):mark(i+1);
    harea = area(A, ones(size(A))*ylimit(2), 'BaseValue', ylimit(1));
    if level(ix)
        set(harea, 'FaceColor','y','EdgeColor','None')  % yellow if high mental workload
    else
        set(harea, 'FaceColor','g','EdgeColor','None')  % otherwise, green
    end
    alpha(0.2) % Transparency
end

% For the last portion of the signal
A = mark(end)-1:round(size(sig,1)*ts);
harea = area(A, ones(size(A))*ylimit(2), 'BaseValue', ylimit(1));
if level(end)
    set(harea, 'FaceColor','y','EdgeColor','None')  % yellow if high mental workload
else
    set(harea, 'FaceColor','g','EdgeColor','None')  % otherwise, green
end
alpha(0.2) % Transparency

if nargout > 1
    error('Number of output cannot be greater than 1');
elseif nargout == 1
    varargout{1} = hplot;
else
    return
end
