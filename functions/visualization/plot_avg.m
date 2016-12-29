function plot_avg(data,dt,color_n)
% PLOT_AVG plots mean of data and its variance
% 
% In:
%   data <nxm>: m-sample signals with n variations
%   dt        : duration between 2 adjacent time point, i.e. 1/Fs
%   color_n   : from 1 to 8 as following
%               1: red, 2: blue, 3: green, 4: magenta, 5:black, 6:yellow,
%               7: orange, 8: azure
%   
% Example:
%   % Plot random data. The signal has 100 samples with 10 variations
%   plot(rand(10,100), 0.055, 1);      
%   
%   % In a more practical setting, it might be like:
%   plot(hbo(T==0), :, ch), ts, 8);
%
% See also: .\example\plotMean.m
%

% Define color
colors = [1 0 0;    % red
        0 0 1;      % blue
        0 1 0;      % green
        1 0 1;      % magenta
        0 0 0;      % black
        1 1 0;      % yellow
        1 0.5 0;    % orange
        0 0.5 1];   % azure

l = size(data,2);       % length of the signal
time = dt*(0:(l-1));       % Create time series
x = data;
m = mean(x);   
s = std(x)/sqrt(size(x,1));

% Plot the variance
upper = m+s;            % Upper envelope
lower = m-s;            % Lower envelope
filled=[upper, fliplr(lower)];  % Y of the polygon
xpoints = time;       
xpoints = [xpoints, fliplr(xpoints)];   % X of the polygon
fillhandle = fill(xpoints, filled, colors(color_n,:));  % plot the data
set(fillhandle,'EdgeColor',[1 1 1],'FaceAlpha',0.4,'EdgeAlpha',0);  % set edge color
hold on

% Plot the averaged signal
plot(time, m, 'color', colors(color_n,:), 'linewidth', 2);
    
end