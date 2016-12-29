%VISUALIZE_SIGNAL_RAW Inspect primary trends in hemologin changes
%   in *subjectName_label.TXT files. Aside from label file, the script requires
%   a *subjectName_deoHb.TXT and a *subjectName_oxyHb.TXT to run properly.
%   
%   There are 2 main plots are produced: raw signals and folded average.
%
% Depedencies:
%   ./visualization/plot_avg.m

% Script file: visualize_signal_raw.m
% 
% Purpose:
%% ============= LOAD DATA ========================
close all, clear all;
addpath ../../functions/visualization

% ------------------------- Configuration (enter by user ) ----------------
subject = 'Thuong_';
% Time
rest1 = 0;             % seconds
task = 120;
rest2 = 30;
ts = 0.055;

% Experiment
allsessions = {1:8, 9:16};  
% allsessions = {1:16};     % plot all sessions
numsess = size(allsessions, 2);
numchan = 7;
class1_label = '1'; % Low MWL                       % Selected by users
class2_label = '3'; % High MWL                      % Selected by users

% Visualization
y_limit = [-0.015 0.015];

% ------------------------- Load labels -------------------------
fprintf('+++ Loading data .....');
fileID = fopen(strcat(subject, 'label.TXT'));    
label_temp = textscan(fileID,'%s');     % temp = temporary variable
label = label_temp{1};                  % labels of each observation
numtrial = length(label);               % # of trials
fclose(fileID);                         % always close file before proceed

% ------------------------- Load oxy-Hb -------------------------
hbtype = 'deoHb';                                   % Selected by user
hbo_temp_all = dlmread(strcat(subject, hbtype,'.TXT'), ' ');                      % First colum = period marker: 0 = rest1, 1 = task, 2 = rest2       
% hbo_temp = hbo_temp_all(hbo_temp_all(:,1)==1 , 2:end);                          % task only
% hbo_temp = hbo_temp_all(hbo_temp_all(:,1)==1 | hbo_temp_all(:,1)==2 , 2:end); % task and post-task
hbo_temp = hbo_temp_all(:, 2:end);                                            % all
numsamp  = size(hbo_temp,1)/numtrial;   % # of samples in 1 trial
hboAll = reshape(hbo_temp, [numsamp, numtrial, size(hbo_temp,2)]);

%% Print info to user for double check
fprintf('\n\tSubject  \t  \t  \t  \t:%s\n', subject);
fprintf('\tHb type  \t  \t  \t  \t:%s\n', hbtype);
fprintf('\tNumber of sessions   \t:%d\n', numsess);
fprintf('\tNumber of channels   \t:%d\n', numchan);
fprintf('\tNumber of trials \t  \t:%d\n', numtrial);
fprintf('\tClass 1  \t  \t  \t  \t:%s\n', class1_label);
fprintf('\tClass 2  \t  \t  \t  \t:%s\n', class2_label);
fprintf('\tRest 1   \t  \t  \t  \t:%ds\n', rest1);
fprintf('\tTask     \t  \t  \t  \t:%ds\n', task);
fprintf('\tRest 2   \t  \t  \t  \t:%ds\n', rest2);
fprintf('\tts   \t  \t  \t  \t  \t:%.3f\n', ts);
fprintf('Done\n');

%% ========= Plot ====
fprintf('+++ Plotting raw data ...');
time = [1:numsamp]*ts;
count = 1;
if rest1 ~= 0
    rest2task = time(round(rest1/ts));     % comment when not whole data is used
end
task2rest = time(round((rest1+task)/ts));     % comment when not whole data is used

hf_raw = figure('Name', [subject, hbtype, '_RAW']);

cur_sess = 0;       % Index on session being processed, just to control some visualization
for chunk = allsessions
    %figure;
    label_chunk = label(chunk{1});
    hboAll_chunk = hboAll(:, chunk{1}, :);
    
    %% ============= LOAD DATA ========================
    class1 = hboAll_chunk(:, cell2mat(label_chunk) == class1_label, :);
    class2 = hboAll_chunk(:, cell2mat(label_chunk) == class2_label, :);
    
    %% =========== Update things ======================
    cur_sess = cur_sess + 1;
    
for ch = 1:numchan
    class1_ch = class1(:,:,ch);
    class2_ch = class2(:,:,ch);
    
    class1_shift0 = bsxfun(@minus, class1_ch', class1_ch(1,:)')';
    class2_shift0 = bsxfun(@minus, class2_ch', class2_ch(1,:)')';
    
    subplot(numsess, numchan, count); 
    hold on; 
    meanclass2 = mean(class2_shift0');
    meanclass1 = mean(class1_shift0');
    
    plot(time, class2_shift0, 'Color', [1 0.5 0.5]);  plot(time, meanclass2, 'r-', 'LineWidth',2); 
    plot(time, class1_shift0, 'Color', [0.5 0.5 1]);  plot(time, meanclass1, 'b-', 'LineWidth',2);
    if exist('rest2task', 'var')
        line([rest2task rest2task], y_limit, 'Color', [0 0.8 0], 'LineStyle', '--', 'LineWidth', 2);  % comment when not whole data is used
    end
    line([task2rest task2rest], y_limit, 'Color', [0 0.8 0], 'LineStyle', '--', 'LineWidth', 2);  % comment when not whole data is used
    xlim([0, time(end)]), ylim(y_limit); set(gca, 'Ygrid', 'on');
    hold off; 
    
%     if count == ((cur_sess - 1)*numchan + 1)
%        ylabel('Hb Change (\muM)', 'FontSize', 14);
%     end
    if count == ((cur_sess - 1)*numchan + 1)
        ylabel(strcat('SS', num2str(cur_sess)), 'FontSize', 14);
    end
    count = count + 1;
end
end
fprintf('Done\n');

%% ============== PLOT MEAN ===================================
fprintf('+++ Plotting folding average ...');
count = 1;      % reset count
hf_mean = figure('Name', [subject, hbtype, '_MEAN']);
cur_sess = 0;       % Index on session being processed, just to control some visualization
for chunk = allsessions
    %figure;
    label_chunk = label(chunk{1});
    hboAll_chunk = hboAll(:, chunk{1}, :);
    
    %% ============= LOAD DATA ========================
    class1 = hboAll_chunk(:, cell2mat(label_chunk) == class1_label, :);
    class2 = hboAll_chunk(:, cell2mat(label_chunk) == class2_label, :);
    
    %% =========== Update things ======================
    cur_sess = cur_sess + 1;
    
for ch = 1:numchan
    class1_ch = class1(:,:,ch);
    class2_ch = class2(:,:,ch);
    
    class1_shift0 = bsxfun(@minus, class1_ch', class1_ch(1,:)')';
    class2_shift0 = bsxfun(@minus, class2_ch', class2_ch(1,:)')';
    
    subplot(numsess,numchan,count); 
    
    % Plot average
    plot_avg(class2_shift0', ts, 1); hold on;
    plot_avg(class1_shift0', ts, 2);
    
    % Decoration
    if exist('rest2task', 'var')
        line([rest2task rest2task], y_limit, 'Color', [0 0.8 0], 'LineStyle', '--', 'LineWidth', 2);  % comment when not whole data is used
    end
    line([task2rest task2rest], y_limit, 'Color', [0 0.8 0], 'LineStyle', '--', 'LineWidth', 2);  % comment when not whole data is used
    xlim([0, time(end)]), ylim(y_limit); set(gca, 'Ygrid', 'on');
    hold off; 
    
    if count == ((cur_sess - 1)*numchan + 1)
        ylabel(strcat('SS', num2str(cur_sess)), 'FontSize', 14);
    end
    count = count + 1;
end       
end
fprintf('Done\n');

    
