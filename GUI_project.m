function varargout = GUI_project(varargin)
% GUI_PROJECT MATLAB code for GUI_project.fig
%      GUI_PROJECT, by itself, creates a new GUI_PROJECT or raises the existing
%      singleton*.
%
%      H = GUI_PROJECT returns the handle to a new GUI_PROJECT or the handle to
%      the existing singleton*.
%
%      GUI_PROJECT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_PROJECT.M with the given input arguments.
%
%      GUI_PROJECT('Property','Value',...) creates a new GUI_PROJECT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_project_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_project_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI_project

% Last Modified by GUIDE v2.5 10-Jan-2017 16:22:42

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_project_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_project_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before GUI_project is made visible.
function GUI_project_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI_project (see VARARGIN)

% Choose default command line output for GUI_project
handles.output = hObject;
handles.params.ts = 0.055;  % TODO: load param from file
handles.params.Fs = 1/handles.params.ts;
handles.ylim_interval = str2num(get(handles.edit_ylim, 'String'));


% ================= add depedencies ==============================
path_vis = './functions/visualization';
path_gui = './functions/guifunc';
disp('+++ Add path +++');
fprintf('+ GUI: %s\n', path_gui);           addpath(path_gui);
fprintf('+ Visualization: %s\n', path_vis); addpath(path_vis);
disp('+++ Done +++++++');
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUI_project wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GUI_project_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --------------------------------------------------------------------
function file_menu_Callback(hObject, eventdata, handles)
% hObject    handle to file_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function browser_file_Callback(hObject, eventdata, handles)
% hObject    handle to browser_file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%% ========================= declare variable =============================
global numchan numtrial hbo hb label i numsamp
% numchan:      number of channel
% numtrial:     number of trial
% hbo:          data oxygenated hemoglobin
% hb:           data deoxygenated hemoglobin
%label:         data label of trial
% i:            show number of trial is plotted now (default = 1)

i = 0;

%% ============================= load file ================================
[filename pathname] = uigetfile({'*.mat'},'File Selector');
fullfilename = strcat(pathname, filename);
if isempty(fullfilename) ==1
    set(handles.message_text,'String','No file chosen');
else
    set(handles.message_text,'String','');
    loadvar = load(fullfilename);                           
    set(handles.browserfile_edit,'String',fullfilename);    %show link of data file

%% ======================= Experiment info ==========================
    % General
    hbo = loadvar.hbo;                      %file data contain variable hbo, hb, label
    hb = loadvar.hb;
    label = loadvar.label;
    numchan = size(hbo, 3);
    numtrial = size(hbo, 2);
    numsamp = size(hbo, 1);
    filenamesplit = strsplit(filename, '_');
    handles.params.subjectName = filenamesplit{1};
    
    % Time
    rest1time = str2double(get(handles.edit_rest1, 'String'));
    tasktime = str2double(get(handles.edit_task, 'String'));
    ts = handles.params.ts;
    time = [1:numsamp]*ts;
    handles.params.time = time;
    try
        handles.params.rest2task = time(ceil(rest1time/ts));
    catch ME
        if strcmp(ME.identifier, 'MATLAB:badsubscript')
            warning('The rest1''s time is zero');
            handles.params.rest2task = [];
        end
%         rethrow(ME);
    end
    handles.params.task2rest = time(ceil((rest1time + tasktime)/ts));
    
%% =========================== Update GUI =================================
    % Numtrial
    set(handles.numtrial_text,'String',num2str(numtrial));
    
    % Listboxes
    list_labels = unique(cellstr(label));
    set(handles.lb_label1,'String', list_labels);
    set(handles.lb_label2,'String', list_labels);
    
    % Update handles structure
    handles.list_labels = list_labels;
    guidata(hObject, handles);
    

%% =============== Create all axes (= number of channel) ==================
    hpanelvis = uipanel('Title','Signal','Position',[0.16 0.01 0.83 0.97]);

    % ha%d (%d = 1 2 3 4 5 6 7):            is handles of axes of before fitler
    % ha(%d+7) (%d+7 = 8 9 10 11 12 13 14): is handles of axes of after fitler

    % [x y w h]
    % x:    0.03 is the distance between 2 axes, 1/numchan is the area of 1 axe
    % y:    0.05 is the location of after fitler, 0.54 is the location of
    %       before filter
    % w:    0.05 is the distance between the last axe and the panel. 
    %       (1-0.05)/numchan - distance between 2 axes, we will get the weight
    %       of axes
    % h:    0.45 is the height of all axes

    for j = 1:numchan
        %axes for before filter
        before = sprintf('ha%d = axes(''Parent'',hpanelvis, ''Units'',''Normalized'',''Position'', [0.03*%d+(1/%d-0.03)*(%d-1) 0.54 (0.95/%d-0.03) 0.45]);',j,j,numchan,j,numchan);
        public_ha_before = sprintf('global ha%d',j);
        eval(public_ha_before);
        eval(before);

        %axes for after filter
        after = sprintf('ha%d = axes(''Parent'',hpanelvis, ''Units'',''Normalized'',''Position'', [0.03*%d+(1/%d-0.03)*(%d-1) 0.05 (0.95/%d-0.03) 0.45]);',j+numchan,j,numchan,j,numchan);
        public_ha_after = sprintf('global ha%d',j+numchan);
        eval(public_ha_after);
        eval(after);
    end
end



function browserfile_edit_Callback(hObject, eventdata, handles)
% hObject    handle to browserfile_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%% ========================= declare variable =============================
global numchan numtrial hbo hb label i
% numchan:      number of channel
% numtrial:     number of trial
% hbo:          data oxygenated hemoglobin
% hb:           data deoxygenated hemoglobin
%label:         data label of trial
% i:            show number of trial is plotted now (default = 1)

i = 0;

%% ============================= load file ================================
fullfilename = get(handles.browserfile_edit,'String');
if exist(fullfilename,'file') ~= 2
    set(handles.message_text,'String','file does not exist!');
elseif exist(fullfilename,'file') == 2;
    loadvar = load(fullfilename);                           
    set(handles.message_text,'String','');
%% ======================= get number of channel ==========================
    hbo = loadvar.hbo;                      %file data contain variable hbo, hb, label
    hb = loadvar.hb;
    label = loadvar.label;
    numchan = length(hbo(1,1,2:end));
    numtrial = length(hbo(1,:,1));

    set(handles.numtrial_text,'String',num2str(numtrial));

%% =============== create all axes (= number of channel) ==================
    hpanelvis = uipanel('Title','Signal','Position',[0.16 0.01 0.83 0.97]);

    % ha%d (%d = 1 2 3 4 5 6 7):            is handles of axes of before fitler
    % ha(%d+7) (%d+7 = 8 9 10 11 12 13 14): is handles of axes of after fitler

    % [x y w h]
    % x:    0.03 is the distance between 2 axes, 1/numchan is the area of 1 axe
    % y:    0.05 is the location of after fitler, 0.54 is the location of
    %       before filter
    % w:    0.05 is the distance between the last axe and the panel. 
    %       (1-0.05)/numchan - distance between 2 axes, we will get the weight
    %       of axes
    % h:    0.45 is the height of all axes

    for j = 1:numchan
        %axes for before filter
        before = sprintf('ha%d = axes(''Parent'',hpanelvis, ''Units'',''Normalized'',''Position'', [0.03*%d+(1/%d-0.03)*(%d-1) 0.54 (0.95/%d-0.03) 0.45]);',j,j,numchan,j,numchan);
        public_ha_before = sprintf('global ha%d',j);
        eval(public_ha_before);
        eval(before);

        %axes for after filter
        after = sprintf('ha%d = axes(''Parent'',hpanelvis, ''Units'',''Normalized'',''Position'', [0.03*%d+(1/%d-0.03)*(%d-1) 0.05 (0.95/%d-0.03) 0.45]);',j+numchan,j,numchan,j,numchan);
        public_ha_after = sprintf('global ha%d',j+numchan);
        eval(public_ha_after);
        eval(after);
    end
end

% Hints: get(hObject,'String') returns contents of browserfile_edit as text
%        str2double(get(hObject,'String')) returns contents of browserfile_edit as a double


% --- Executes during object creation, after setting all properties.
function browserfile_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to browserfile_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in back_button.
function back_button_Callback(hObject, eventdata, handles)
% hObject    handle to back_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global i
i = i - 1;                                      %next 1 trail
plot_raw_signal(handles, i)

% --- Executes on button press in next_button.
function next_button_Callback(hObject, eventdata, handles)
% hObject    handle to next_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global i
i = i + 1;                                      %next 1 trail
plot_raw_signal(handles, i)

function plot_raw_signal(handles, i)
% ===============================================-=========================
global numchan numtrial hb hbo label numsamp

% =========================================================================
ylim_interval = handles.ylim_interval;

%% ======================== checking choosen file =========================
getfile = get(handles.browserfile_edit,'String');
%get state of browser file
if isempty(getfile) == 1
    set(handles.message_text,'String','No file chosen');
else
    %% ============================ Start plotting ============================
    set(handles.message_text,'String','');
    
    if i > numtrial;       %check value of i, if i >= numtrial disp error, else plotting
        set(handles.message_text,'String','No more trail to plot');
        i = numtrial;
    elseif i <= 0
        set(handles.message_text,'String','plotting first trail');
        i = 1;
    else
        set(handles.trial_text,'String',num2str(i));    %display number of current trail
        set(handles.label_text,'String',label(i));      %display label of trail
        
        for j = 1:numchan
            %% declare global axes
            public_ha_before = sprintf('global ha%d',j);
            eval(public_ha_before);
            public_ha_after = sprintf('global ha%d',j+numchan);
            eval(public_ha_after);
            
            %% reset axes
            eval(sprintf('hcp%d = cla(ha%d,''reset'');',j,j));
            eval(sprintf('hcp%d = cla(ha%d,''reset'');',j+numchan,j+numchan));
            
            % ======================== plot RAW data =====================
            % all data in channel %d of variable hbo and hb in trial i
            %and hanled them by hp%d
            eval(sprintf('hb_cur = hb(:,%d,%d);', i, j));
            eval(sprintf('hbo_cur = hbo(:,%d,%d);', i, j));
            a = sprintf('hp%d = plot(ha%d, hb_cur); hold(ha%d, ''on'');', j,j,j);
            b = sprintf('hp%d = plot(ha%d, hbo_cur, ''r-''); xlim(ha%d, [0 numsamp]); ylim(ha%d, ylim_interval);', j,j,j,j);
            eval(a);
            eval(b);
            
            %% ======================== PROCESS DATA =====================
            hb_filt = signal_processing(handles, hb_cur);
            hbo_filt = signal_processing(handles, hbo_cur);
         
            % ======================= plot PROCESSED data ================
            % all data in channel (%d+numchan) of variable hbo and hb in trial i
            %and hanled them by hp(%d+numchan)
            c = sprintf('hp%d = plot(ha%d, hb_filt); hold(ha%d, ''on'');', j+numchan,j+numchan,j+numchan);
            d = sprintf('hp%d = plot(ha%d, hbo_filt, ''r-''); xlim(ha%d, [0 numsamp]); ylim(ha%d, ylim_interval);', j+numchan,j+numchan, j+numchan, j+numchan);
            eval(c);
            eval(d);
            
        end
    end
end


% --- Executes during object creation, after setting all properties.
function label_text_CreateFcn(hObject, eventdata, handles)
% hObject    handle to label_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function trial_text_CreateFcn(hObject, eventdata, handles)
% hObject    handle to trial_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function numtrial_text_CreateFcn(hObject, eventdata, handles)
% hObject    handle to numtrial_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function message_text_CreateFcn(hObject, eventdata, handles)
% hObject    handle to message_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


function edit_bandpassFc_Callback(hObject, eventdata, handles)
% hObject    handle to edit_bandpassFc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_bandpassFc as text
%        str2double(get(hObject,'String')) returns contents of edit_bandpassFc as a double


% --- Executes during object creation, after setting all properties.
function edit_bandpassFc_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_bandpassFc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_mva_val_Callback(hObject, eventdata, handles)
% hObject    handle to edit_mva_val (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_mva_val as text
%        str2double(get(hObject,'String')) returns contents of edit_mva_val as a double


% --- Executes during object creation, after setting all properties.
function edit_mva_val_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_mva_val (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit6_Callback(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit6 as text
%        str2double(get(hObject,'String')) returns contents of edit6 as a double


% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_span_Callback(hObject, eventdata, handles)
% hObject    handle to edit_span (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_span as text
%        str2double(get(hObject,'String')) returns contents of edit_span as a double


% --- Executes during object creation, after setting all properties.
function edit_span_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_span (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in lb_label1.
function lb_label1_Callback(hObject, eventdata, handles)
% hObject    handle to lb_label1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns lb_label1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from lb_label1


% --- Executes during object creation, after setting all properties.
function lb_label1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lb_label1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pb_plot_mean.
function pb_plot_mean_Callback(hObject, eventdata, handles)
% hObject    handle to pb_plot_mean (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global label numchan numtrial

task2rest = handles.params.task2rest;
ylim_interval = handles.ylim_interval;

trials_interval = zeros(numtrial, 1);
trials_interval(str2num(get(handles.edit_trials, 'String'))) = 1;

time = handles.params.time;

isplotfill = get(handles.cb_fill_variance, 'Value');


%% ======================== PROCESS DATA =====================
[hb_filt_all, hbo_filt_all] = signalprocessing_all(handles);

disp('+++ Start ploting folded average +++');
all_labels = handles.list_labels;
slc_label1 = all_labels(get(handles.lb_label1, 'Value'));
slc_label2 = all_labels(get(handles.lb_label2, 'Value'));

hfig = figure('Name', 'Folded average', 'Color', [1 1 1]);
hpanel = uipanel('Title','','Position',[0.01 0.01 0.97 0.9], ...
                'BackgroundColor', [1 1 1], 'BorderType', 'none', 'Parent', hfig);
            
% Select datatype to plot
slc_datatype = get(handles.pnl_datatype, 'SelectedObject');

for ch = 1:numchan   
    % Axes for oxyHb
    ax_hbo = sprintf('ha%d = axes(''Parent'',hpanel, ''Units'',''Normalized'',''Position'', [0.03*%d+(1/%d-0.03)*(%d-1) 0.54 (0.95/%d-0.03) 0.45]);',ch,ch,numchan,ch,numchan);
    eval(ax_hbo);
    
    % Plot according to data type selection
    hbo_slc1 = hbo_filt_all(:, ismember(label, slc_label1) & trials_interval, ch);
    hbo_slc2 = hbo_filt_all(:, ismember(label, slc_label2) & trials_interval, ch);
    hb_slc1 = hb_filt_all(:, ismember(label, slc_label1) & trials_interval, ch);
    hb_slc2 = hb_filt_all(:, ismember(label, slc_label2) & trials_interval, ch);
    slc_string = get(slc_datatype, 'String');
    switch slc_string
        case 'oxyHb'
            if isplotfill
                plot_avg(hbo_slc1', handles.params.ts, 2); hold on;
                plot_avg(hbo_slc2', handles.params.ts, 1); hold off;
            else
                mean_slc1 = mean(hbo_slc1');
                mean_slc2 = mean(hbo_slc2');
                hold on;
                plot(time, hbo_slc1, 'Color', [0.5 0.5 1]);  plot(time, mean_slc1, 'b-', 'LineWidth',2);
                plot(time, hbo_slc2, 'Color', [1 0.5 0.5]);  plot(time, mean_slc2, 'r-', 'LineWidth',2);
                hold off;
            end
        case 'deoHb'
            if isplotfill
                plot_avg(hb_slc1', handles.params.ts, 2); hold on;
                plot_avg(hb_slc2', handles.params.ts, 1); hold off;
            else
                hold on;
                mean_slc1 = mean(hb_slc1');
                mean_slc2 = mean(hb_slc2');
                plot(time, hb_slc1, 'Color', [0.5 0.5 1]);  plot(time, mean_slc1, 'b-', 'LineWidth',2);
                plot(time, hb_slc2, 'Color', [1 0.5 0.5]);  plot(time, mean_slc2, 'r-', 'LineWidth',2);
                hold off;
            end
        case 'Blood Oxy'
            oxy_slc1 = hbo_slc1 - hb_slc1;
            oxy_slc2 = hbo_slc2 - hb_slc2;
            if isplotfill
                plot_avg(oxy_slc1', handles.params.ts, 2); hold on;
                plot_avg(oxy_slc2', handles.params.ts, 1); hold off;
            else
                hold on;
                mean_slc1 = mean(oxy_slc1');
                mean_slc2 = mean(oxy_slc2');
                plot(time, oxy_slc1, 'Color', [0.5 0.5 1]);  plot(time, mean_slc1, 'b-', 'LineWidth',2);
                plot(time, oxy_slc2, 'Color', [1 0.5 0.5]);  plot(time, mean_slc2, 'r-', 'LineWidth',2);
                hold off;
            end
    end
    
    % Decoration
    if ~isempty(handles.params.rest2task)
        rest2task = handles.params.rest2task;
        line([rest2task rest2task], [-0.05, 0.06], 'Color', [0 0.8 0], 'LineStyle', '--', 'LineWidth', 2);  % comment when not whole data is used
    end
    line([task2rest task2rest], [-0.05, 0.06], 'Color', [0 0.8 0], 'LineStyle', '--', 'LineWidth', 2);  % comment when not whole data is used
    xlim([0, handles.params.time(end)]), ylim(ylim_interval);
    set(gca, 'Ygrid', 'on');
end

htext = uicontrol('Style', 'text', 'Units', 'normalized', 'Position', [0.2, 0.92, 0.6, 0.05], 'Parent', hfig, ...
                  'String', sprintf('Subject: %s | Labels: %s (blue) & %s (red) | Trials: %s | Type: %s', ...
                  handles.params.subjectName, slc_label1{:}, slc_label2{:}, get(handles.edit_trials, 'String'), slc_string), ...
                  'FontSize', 12, 'FontWeight', 'bold', 'BackgroundColor', [1 1 1]);
disp('+++ Done +++');

function [hb_filt_all, hbo_filt_all] = signalprocessing_all(handles)
global numchan numtrial hbo hb

% Initialize outputs
hb_filt_all = zeros(size(hb));
hbo_filt_all = zeros(size(hbo));

fprintf('Processing all hemoglobin data...');
for tr = 1:numtrial
    for ch = 1:numchan
        % Splitting
        hb_cur = hb(:, tr, ch);
        hbo_cur = hbo(:, tr, ch);
        
        % Process signals
        hb_filt = signal_processing(handles, hb_cur);
        hbo_filt = signal_processing(handles, hbo_cur);
        
        % Merging
        hb_filt_all(:, tr, ch) = hb_filt;
        hbo_filt_all(:, tr, ch) = hbo_filt;
    end
end
fprintf('Done\n');

function y = signal_processing(handles, x)
% parameters
Fs = handles.params.Fs;
bandpassFc = str2num(get(handles.edit_bandpassFc, 'String'));   % [highpassFc lowpassFc]
mva_val = str2double(get(handles.edit_mva_val, 'String'));         % moving average
span = str2double(get(handles.edit_span, 'String'));

% Bandpass filter
[b, a] = ellip(4, 0.1, 40, bandpassFc*2/Fs);   % This set of parameter is optimized for our study by trial-and-error, don't ask!
x = filtfilt(b, a, x);

% Moving average
a = 1;
b(1:ceil(Fs*mva_val)) = 1 / (Fs*mva_val);
x = filtfilt(b, a, x);

% Smoothing
x = smooth(x, span);

% Zero shifting
y = bsxfun(@minus, x', x(1))';

% ======================= For DEBUGGING ==================================
% Plot hbo and hb of one (trial, channel)
function plot_single(hbdata, hbodata, trial, channel)
figure;
plot(hbdata(:, trial, channel)); hold on;
plot(hbodata(:, trial, channel), 'r-'); hold off;


% --- Executes on selection change in lb_label2.
function lb_label2_Callback(hObject, eventdata, handles)
% hObject    handle to lb_label2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns lb_label2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from lb_label2


% --- Executes during object creation, after setting all properties.
function lb_label2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lb_label2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in lb_hbtype.
function lb_hbtype_Callback(hObject, eventdata, handles)
% hObject    handle to lb_hbtype (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns lb_hbtype contents as cell array
%        contents{get(hObject,'Value')} returns selected item from lb_hbtype


% --- Executes during object creation, after setting all properties.
function lb_hbtype_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lb_hbtype (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in lb_sessions.
function lb_sessions_Callback(hObject, eventdata, handles)
% hObject    handle to lb_sessions (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns lb_sessions contents as cell array
%        contents{get(hObject,'Value')} returns selected item from lb_sessions


% --- Executes during object creation, after setting all properties.
function lb_sessions_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lb_sessions (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_ylim_Callback(hObject, eventdata, handles)
% hObject    handle to edit_ylim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_ylim as text
%        str2double(get(hObject,'String')) returns contents of edit_ylim as a double
handles.ylim_interval = str2num(get(handles.edit_ylim, 'String'));
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function edit_ylim_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_ylim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_trials_Callback(hObject, eventdata, handles)
% hObject    handle to edit_trials (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_trials as text
%        str2double(get(hObject,'String')) returns contents of edit_trials as a double


% --- Executes during object creation, after setting all properties.
function edit_trials_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_trials (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_rest1_Callback(hObject, eventdata, handles)
% hObject    handle to edit_rest1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_rest1 as text
%        str2double(get(hObject,'String')) returns contents of edit_rest1 as a double


% --- Executes during object creation, after setting all properties.
function edit_rest1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_rest1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_task_Callback(hObject, eventdata, handles)
% hObject    handle to edit_task (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_task as text
%        str2double(get(hObject,'String')) returns contents of edit_task as a double


% --- Executes during object creation, after setting all properties.
function edit_task_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_task (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_rest2_Callback(hObject, eventdata, handles)
% hObject    handle to edit_rest2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_rest2 as text
%        str2double(get(hObject,'String')) returns contents of edit_rest2 as a double


% --- Executes during object creation, after setting all properties.
function edit_rest2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_rest2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in cb_fill_variance.
function cb_fill_variance_Callback(hObject, eventdata, handles)
% hObject    handle to cb_fill_variance (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_fill_variance
cb_fill_val = get(hObject, 'Value');
% disp(cb_fill_val);


% --------------------------------------------------------------------
function convert_file_Callback(hObject, eventdata, handles)
% hObject    handle to convert_file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
run Conversion.m


% --------------------------------------------------------------------
function tools_menu_Callback(hObject, eventdata, handles)
% hObject    handle to tools_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function bloodOxygen_menu_Callback(hObject, eventdata, handles)
% hObject    handle to bloodOxygen_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global label numchan hb hbo

% Filter signals
[hb_filt_all, hbo_filt_all] = signalprocessing_all(handles);

% Calc. Blood oxygenation
oxy_all = hbo_filt_all - hb_filt_all;

% Averaging across all labels (classess)
list_labels = handles.list_labels;
numlabels = length(list_labels);
oxy_avg = zeros(numchan, numlabels);    % Initialize ouput
for i = 1:numlabels
    cur_label = list_labels(i);                             % select each label one by one
    oxy_label = oxy_all(:, ismember(label, cur_label), :);  % extract oxygenation data accordingly
    oxy_avg(:,i) =  permute(mean(mean(oxy_label,2)), [3 2 1]);
end
% varname = strcat(handles.params.subjectName, '_oxy_avg');
% assignin ('base', varname, oxy_avg)

% Save to xlsx file
% fprintf('Save result to xlsx file ...');
% xlswrite(strcat(varname, '.xlsx'), oxy_avg);
% fprintf('Done\n');

% Bring raw hemoglobin data to workspace
rawoxy_all = hbo - hb;
varname = strcat(handles.params.subjectName, '_oxy_raw');
assignin ('base', varname, rawoxy_all)
