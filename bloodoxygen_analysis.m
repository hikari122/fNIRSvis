is_oxy_avg = 1;
is_oxy_raw = 0;
%%
if is_oxy_avg
load 'All_oxy_avg'

numchan = 7;
numlabel = 3;
% subjects = {'Dang', 'Ngoc', 'Son', 'Thinh', 'Thuong'};
% subjects = {'Dang', 'Ngoc', 'Thinh', 'Thuong'};
subjects = {'Dang', 'Thinh', 'Thuong'};

numsub = length(subjects);

all_oxy = zeros(numchan, numlabel, numsub);

% Concatenate data
for sub = 1:numsub
    eval(sprintf('all_oxy(:, :, sub) = %s_oxy_avg;', subjects{sub}))
end

%% Start plotting results
oxymeanch = permute(mean(all_oxy, 1), [3 2 1]);
figure;
subplot(1,2,1);
boxplot(oxymeanch); title('Overal Blood oxygenation of 3 lvls');
subplot(1,2,2);
plot(oxymeanch'); 
legend(subjects)

%% by channels
figure;
for ch = 1:numchan
    subplot(1, numchan, ch);
    oxych = permute(all_oxy(ch,:,:), [3 2 1]);
    boxplot(oxych); title(sprintf('Ch %s', num2str(ch)));
end

end

%%
if is_oxy_raw
    
load All_oxy_raw

numlabel = 3;
subjects = {'Dang', 'Ngoc', 'Son', 'Thinh', 'Thuong'};
% subjects = {'Dang', 'Ngoc', 'Thinh', 'Thuong'};
% subjects = {'Dang', 'Thinh', 'Thuong'};
numsub = length(subjects);

std_all = zeros(numsub, 7);
snr_all = zeros(numsub, 7);

for sub = 1:numsub
    eval(sprintf('oxy_raw = %s_oxy_raw;', subjects{sub}))
    fprintf('++++++ %s ++++++\n', subjects{sub});
    eval(sprintf('[numsamp, numtrial, numchan] = size(%s_oxy_raw);', subjects{sub}));
    oxy_raw_rshp = reshape(oxy_raw, [numsamp*numtrial, numchan]);
    meanoxy = mean(oxy_raw_rshp, 1);
    stdoxy = std(oxy_raw_rshp, 1)
    snr = abs(meanoxy./stdoxy)
    
    snr_all(sub,:) = snr;
    std_all(sub,:) = stdoxy;
    disp('+++++++++++++++++++++++');
end

% Save to xlsx file
fprintf('Save result to xlsx file ...');
xlswrite('snr_data.xlsx', snr_all);
xlswrite('std_data.xlsx', std_all);
fprintf('Done\n');

end