function varargout = GUI_thesis(varargin)
% GUI_THESIS MATLAB code for GUI_thesis.fig
%      GUI_THESIS, by itself, creates a new GUI_THESIS or raises the existing
%      singleton*.
%
%      H = GUI_THESIS returns the handle to a new GUI_THESIS or the handle to
%      the existing singleton*.
%
%      GUI_THESIS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_THESIS.M with the given input arguments.
%
%      GUI_THESIS('Property','Value',...) creates a new GUI_THESIS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_thesis_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_thesis_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI_thesis

% Last Modified by GUIDE v2.5 29-Dec-2016 16:05:09

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_thesis_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_thesis_OutputFcn, ...
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


% --- Executes just before GUI_thesis is made visible.
function GUI_thesis_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI_thesis (see VARARGIN)

% Choose default command line output for GUI_thesis
handles.output = hObject;



% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUI_thesis wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GUI_thesis_OutputFcn(hObject, eventdata, handles) 
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
global numchan numtrail hbo hb label i
% numchan:      number of channel
% numtrail:     number of trail
% hbo:          data oxygenated hemoglobin
% hb:           data deoxygenated hemoglobin
%label:         data label of trail
% i:            show number of trail is plotted now (default = 1)

i = 0;

%% ============================= load file ================================
[filename pathname] = uigetfile({'*.mat'},'File Selector');
fullfilename= strcat(pathname, filename);
loadvar = load(fullfilename);                           
set(handles.browserfile_edit,'String',fullfilename);    %show link of data file

%% ======================= get number of channel ==========================
hbo = loadvar.hbo;                      %file data contain variable hbo, hb, label
hb = loadvar.hb;
label = loadvar.label;
numchan = length(hbo(1,1,2:end));
numtrail = length(hbo(1,:,1));

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



function browserfile_edit_Callback(hObject, eventdata, handles)
% hObject    handle to browserfile_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

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

%% ========================= Declare variable =============================
global numchan hb hbo label i

i = i - 1;                                      %back 1 trail

%% ============================ Start plotting ============================
if i <= 0;          %check value of i, if i <= 0 disp error, else plotting
    disp('error');
else
    set(handles.trail_edit,'String',num2str(i));    %display number of current trail
    set(handles.label_edit,'String',label(i));      %display label of trail

    for j = 1:numchan
    %% declare global axes
        public_ha_before = sprintf('global ha%d',j);
        eval(public_ha_before);
        public_ha_after = sprintf('global ha%d',j+numchan);
        eval(public_ha_after);
        
    %% reset axes
        eval(sprintf('hcp%d = cla(ha%d,''reset'');',j,j));
        eval(sprintf('hcp%d = cla(ha%d,''reset'');',j+numchan,j+numchan));
        
    %% start plot
        %plot all data in channel %d of variable hbo and hb in trail i 
        %and hanled them by hp%d (%d = 1 2 3 4 5 6 7)
        a = sprintf('hp%d = plot(ha%d,hbo(:,%d,%d));hold(ha%d,''on'');', j,j,i,j+1,j);
        b = sprintf('hp%d = plot(ha%d,hb(:,%d,%d));', j,j,i,j+1); 
        eval(a);
        eval(b);

        %plot all data in channel (%d+7) of variable hbo and hb in trail i 
        %and hanled them by hp(%d+7) (%d+7 = 8 9 10 11 12 13 14)
        c = sprintf('hp%d = plot(ha%d,hbo(:,%d,%d));hold(ha%d,''on'');', j+numchan,j+numchan,i,j+1,j+numchan);
        d = sprintf('hp%d = plot(ha%d,hb(:,%d,%d));', j+numchan,j+numchan,i,j+1);
        eval(c);
        eval(d);
        
    end
end

% --- Executes on button press in next_button.
function next_button_Callback(hObject, eventdata, handles)
% hObject    handle to next_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%% ========================= Declare variable =============================
global numchan numtrail hb hbo label i

i = i + 1;                                      %next 1 trail

%% ============================ Start plotting ============================
if i >= numtrail;       %check value of i, if i >= numtrail disp error, else plotting
    disp('error');
else
    set(handles.trail_edit,'String',num2str(i));    %display number of current trail
    set(handles.label_edit,'String',label(i));      %display label of trail

    for j = 1:numchan
    %% declare global axes
        public_ha_before = sprintf('global ha%d',j);
        eval(public_ha_before);
        public_ha_after = sprintf('global ha%d',j+numchan);
        eval(public_ha_after);
        
    %% reset axes
        eval(sprintf('hcp%d = cla(ha%d,''reset'');',j,j));
        eval(sprintf('hcp%d = cla(ha%d,''reset'');',j+numchan,j+numchan));
        
    %% start plot
        %plot all data in channel %d of variable hbo and hb in trail i 
        %and hanled them by hp%d (%d = 1 2 3 4 5 6 7)
        a = sprintf('hp%d = plot(ha%d,hbo(:,%d,%d));hold(ha%d,''on'');', j,j,i,j+1,j);
        b = sprintf('hp%d = plot(ha%d,hb(:,%d,%d));', j,j,i,j+1); 
        eval(a);
        eval(b);

        %plot all data in channel (%d+7) of variable hbo and hb in trail i 
        %and hanled them by hp(%d+7) (%d+7 = 8 9 10 11 12 13 14)
        c = sprintf('hp%d = plot(ha%d,hbo(:,%d,%d));hold(ha%d,''on'');', j+numchan,j+numchan,i,j+1,j+numchan);
        d = sprintf('hp%d = plot(ha%d,hb(:,%d,%d));', j+numchan,j+numchan,i,j+1);
        eval(c);
        eval(d);
        
    end
end


function trail_edit_Callback(hObject, eventdata, handles)
% hObject    handle to trail_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of trail_edit as text
%        str2double(get(hObject,'String')) returns contents of trail_edit as a double


% --- Executes during object creation, after setting all properties.
function trail_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to trail_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function label_edit_Callback(hObject, eventdata, handles)
% hObject    handle to label_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of label_edit as text
%        str2double(get(hObject,'String')) returns contents of label_edit as a double


% --- Executes during object creation, after setting all properties.
function label_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to label_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
