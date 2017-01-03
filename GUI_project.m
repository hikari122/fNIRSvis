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

% Last Modified by GUIDE v2.5 03-Jan-2017 22:55:52

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
global numchan numtrial hbo hb label i
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
global numchan numtrial hb hbo label
% =========================================================================

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
            eval(sprintf('hb_cur = hb(:,%d,%d);', i, j+1));
            eval(sprintf('hbo_cur = hbo(:,%d,%d);', i, j+1));
            a = sprintf('hp%d = plot(ha%d, hb_cur); hold(ha%d, ''on'');', j,j,j);
            b = sprintf('hp%d = plot(ha%d, hbo_cur, ''r-'');', j,j);
            eval(a);
            eval(b);
            
            %% ======================== PROCESS DATA =====================
            hb_filt = signal_processing(handles, hb_cur);
            hbo_filt = signal_processing(handles, hbo_cur);
            
            hb_shift2zero = bsxfun(@minus, hb_filt', hb_filt(1))';
            hbo_shift2zero = bsxfun(@minus, hbo_filt', hbo_filt(1))';
            
            % ======================= plot PROCESSED data ================
            % all data in channel (%d+numchan) of variable hbo and hb in trial i
            %and hanled them by hp(%d+numchan)
            c = sprintf('hp%d = plot(ha%d, hb_shift2zero); hold(ha%d, ''on'');', j+numchan,j+numchan,j+numchan);
            d = sprintf('hp%d = plot(ha%d, hbo_shift2zero, ''r-'');', j+numchan,j+numchan);
            eval(c);
            eval(d);
            
        end
    end
end

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
y = smooth(x, span);


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
