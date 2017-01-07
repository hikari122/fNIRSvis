function [y_sgolay_diff] = SGfilter(y, Time_sgolay, order)
% SGFILTER perfomes Savitzky-Golay Filter
%
% In:
%   y:          input signal
%   Time_sgolay:frame size, must be odd
%   order:      polynomial order
%
% Out:
%   y_sgolay_diff: 
%   

y_sgolay = [];
y_sgolay_diff=[];

[b,g] = sgolay(order,Time_sgolay);
HalfWin = ((Time_sgolay+1)/2) -1;
for n = (Time_sgolay+1)/2:length(y)-(Time_sgolay+1)/2
    y_sgolay(n) =   dot(g(:,1), y(n - HalfWin: n + HalfWin));
    y_sgolay_diff(n) =   dot(g(:,2), y(n - HalfWin: n + HalfWin));
    y_sgolay_diff2(n) =   dot(g(:,3), y(n - HalfWin: n + HalfWin));
end

t_seg = 1:(Time_sgolay+1)/2-1;
y_sgolay(t_seg) = 0;
y_sgolay_diff(t_seg)=0;
y_sgolay_diff2(t_seg)=0;

t_seg = (length(y)-(Time_sgolay+1)/2)+1:length(y);
y_sgolay(t_seg) = 0;
y_sgolay_diff(t_seg)=0;
y_sgolay_diff2(t_seg)=0;    
end

