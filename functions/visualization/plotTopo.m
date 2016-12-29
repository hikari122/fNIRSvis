function plotTopo( data, colorbarrange )
% PLOTOPO visualize topography of t scores, commonly for HbO and Hb.
% 
% In: 
%   data <n,1>  : column vector whose values are t scores of n channels. 
%                 The number of channels set in this function is 7
%   colorbarrange <2,1>     : color bar range 
% 
% Example:
%   t_hb =  [-0.8950   -0.1358   -2.4395   -0.2233   -0.3610   -1.1456 -0.9446]'; % t score of Hb of 7 channels.
%   plotTopo(t_hb, [-3 3]);
%
% Read more:
%   ..\..\example\plotMean.m
i = 1;
hb_map = data';   
interpMethod = 'spline';
onlyPlotMap = 1;
channelPos = [];
[x,y]     = meshgrid(1:1:7, 1:1:5);
[xi,yi]   = meshgrid(1:0.1:7, 1:0.1:5);

  channelPos = [2 3;
                2 5;
                3 2;
                3 4;
                3 6;
                4 3;
                4 5;
                ];
    %******* It turns around the watch at 45??and interpolates. ******* 
    m(2,3) = hb_map(i,1);
    m(2,5) = hb_map(i,2);
    m(3,2) = hb_map(i,3);
    m(3,4) = hb_map(i,4);
    m(3,6) = hb_map(i,5);
    m(4,3) = hb_map(i,6);
    m(4,5) = hb_map(i,7);

    m(1,4) = 1/8*(hb_map(i,1)+hb_map(i,2));
    m(2,2) = 1/4*(hb_map(i,1)+hb_map(i,3));
    m(2,4) = 1/2*(hb_map(i,1)+hb_map(i,2));
    m(2,6) = 1/4*(hb_map(i,2)+hb_map(i,5));
    m(3,1) = 1/2*hb_map(i,3);
    m(3,3) = 1/4*(hb_map(i,1)+hb_map(i,3)+hb_map(i,4)+hb_map(i,6));
    m(3,5) = 1/4*(hb_map(i,2)+hb_map(i,4)+hb_map(i,5)+hb_map(i,7));
    m(3,7) = 1/2*hb_map(i,5);
    m(4,2) = 1/4*(hb_map(i,3)+hb_map(i,6)); 
    m(4,4) = 1/3*(hb_map(i,4)+hb_map(i,6)+hb_map(i,7));
    m(4,6) = 1/4*(hb_map(i,5)+hb_map(i,7));
    m(5,4) = 1/8*(hb_map(i,6)+hb_map(i,7));
    
pol = interp2(x,y,m,xi,yi,interpMethod);
f = gcf;%figure('name','topo plot (Xu Cui)', 'color','w');

if ~onlyPlotMap
    pcolor(pol);
else
    imagesc(pol)
end

%% temporally disabled by xu cui
tx = (channelPos(:,2)-1)*10+1;
ty = (channelPos(:,1)-1)*10+1;
for ii=1:size(channelPos,1)
    channelText(ii,:) = sprintf('%d', ii);
end
th = text(tx,ty,channelText,'color','k');
data = guidata(f);
data.th = th;
guidata(f,data);    


hold on;
axis square;
axis ij;
axis off;
shading interp;

if(exist('colorbarrange'))
    caxis([colorbarrange(1), colorbarrange(2)])
end


if ~onlyPlotMap
view(-45+90*3,90);    
colorbar


% temporally disabled by xu cui 
uicontrol('Parent',f,...
            'Units','normalized',...
            'Position',[0 0 0.1 0.05],...
            'String','rotate',...
            'Style','push',...
            'Visible','on',...
            'Callback','d = get(gca, ''view'');view(d(1)+90,90)');

uicontrol('Parent',f,...
            'Units','normalized',...
            'Position',[0.1 0.0 0.2 0.05],...
            'String','channel #',...
            'Style','check',...
            'value', 1,...
            'Visible','on',...
            'Callback','data = guidata(gco); th=data.th; v=get(gco, ''value''); if v; set(th, ''visible'', ''on''); else;set(th, ''visible'', ''off'');end');
end
end

