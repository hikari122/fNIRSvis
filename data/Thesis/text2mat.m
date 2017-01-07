%TEXT2MAT converts 3 data text files to mat file used by the GUI program
% 

%% ============= LOAD DATA ========================
close all, clear all;

% ------------------------- Configuration (enter by user ) ----------------
subject = 'Thuong_';

% ------------------------- Load labels -------------------------
fprintf('+++ Loading data .....');
fileID = fopen(strcat(subject, 'label.TXT'));    
label_temp = textscan(fileID,'%s');     % temp = temporary variable
label = label_temp{1};                  % labels of each observation
numtrial = length(label);               % # of trials
fclose(fileID);                         % always close file before proceed

% ------------------------- Load oxy-Hb -------------------------
hbtype = 'oxyHb';                                   % Selected by user
hbo_temp_all = dlmread(strcat(subject, hbtype,'.TXT'), ' ');                      % First colum = period marker: 0 = rest1, 1 = task, 2 = rest2       
% hbo_temp = hbo_temp_all(hbo_temp_all(:,1)==1 , 2:end);                          % task only
% hbo_temp = hbo_temp_all(hbo_temp_all(:,1)==1 | hbo_temp_all(:,1)==2 , 2:end); % task and post-task
hbo_temp = hbo_temp_all(:, 2:end);                                            % all
numsamp  = size(hbo_temp,1)/numtrial;   % # of samples in 1 trial
hbo = reshape(hbo_temp, [numsamp, numtrial, size(hbo_temp,2)]);

% ------------------------- Load deo-Hb -------------------------
hbtype = 'deoHb';                                   % Selected by user
hb_temp_all = dlmread(strcat(subject, hbtype,'.TXT'), ' ');                      % First colum = period marker: 0 = rest1, 1 = task, 2 = rest2       
% hbo_temp = hbo_temp_all(hbo_temp_all(:,1)==1 , 2:end);                          % task only
% hbo_temp = hbo_temp_all(hbo_temp_all(:,1)==1 | hbo_temp_all(:,1)==2 , 2:end); % task and post-task
hb_temp = hb_temp_all(:, 2:end);                                            % all
numsamp  = size(hb_temp,1)/numtrial;   % # of samples in 1 trial
hb = reshape(hb_temp, [numsamp, numtrial, size(hb_temp,2)]);

%% ============= SAVE DATA ========================
save(sprintf('%sall.mat', subject), 'hb', 'hbo', 'label');