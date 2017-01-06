function varargout = Conversion(varargin)
% CONVERSION MATLAB code for Conversion.fig
%      CONVERSION, by itself, creates a new CONVERSION or raises the existing
%      singleton*.
%
%      H = CONVERSION returns the handle to a new CONVERSION or the handle to
%      the existing singleton*.
%
%      CONVERSION('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CONVERSION.M with the given input arguments.
%
%      CONVERSION('Property','Value',...) creates a new CONVERSION or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Conversion_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Conversion_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Conversion

% Last Modified by GUIDE v2.5 05-Jan-2017 23:37:31

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Conversion_OpeningFcn, ...
                   'gui_OutputFcn',  @Conversion_OutputFcn, ...
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


% --- Executes just before Conversion is made visible.
function Conversion_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Conversion (see VARARGIN)

% Choose default command line output for Conversion
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Conversion wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Conversion_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function subject_name_edit_Callback(hObject, eventdata, handles)
% hObject    handle to subject_name_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of subject_name_edit as text
%        str2double(get(hObject,'String')) returns contents of subject_name_edit as a double

% --- Executes during object creation, after setting all properties.
function subject_name_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to subject_name_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in hbo_bf_button.
function hbo_bf_button_Callback(hObject, eventdata, handles)
% hObject    handle to hbo_bf_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%% ========================= Declare variable =============================
global folderaddress filehbo
% folderaddress:    contain the address of the TXT file and save into file
%                   mat in this address
% filehbo:          name of file deoxy-Hb in the folder

%% ====================== Open file subject's hbo =========================
%find file deo-Hb
foldername = dir(folderaddress);        %make the folder current is folderaddress
subject = get(handles.subject_name_edit,'String');
subject = [subject '_deoHb'];           %take target file name
foldername = {foldername(:).name};      %find all file in folder current
filehbo = foldername(~cellfun('isempty',strfind(foldername,subject)));
                                        %find target file name in folder current 
%check is a row vector to show in listbox
if isrow(filehbo) == 0
    filehbo = filehbo';
end

%% ========================== Display file ================================
set(handles.listbox_hbo,'String',filehbo);


% --- Executes during object creation, after setting all properties.
function hbo_filename_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to hbo_filename_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function hb_filename_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to hb_filename_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function label_filename_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to label_filename_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in hb_bf_button.
function hb_bf_button_Callback(hObject, eventdata, handles)
% hObject    handle to hb_bf_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%% ========================= Declare variable =============================
global folderaddress filehb
% folderaddress:    contain the address of the TXT file and save into file
%                   mat in this address
% filehb:          name of file oxy-Hb in the folder

%% ======================= Open file subject's hb =========================
%find file oxy-Hb
foldername = dir(folderaddress);        %make the folder current is folderaddress
subject = get(handles.subject_name_edit,'String');
subject = [subject '_oxyHb'];           %take target file name
foldername = {foldername(:).name};      %find all file in folder current
filehbo = foldername(~cellfun('isempty',strfind(foldername,subject)));
                                        %find target file name in folder current 

%check is a row vector to show in listbox
if isrow(filehb) == 0
    filehb = filehb';
end

%% ========================== Display file ================================
set(handles.listbox_hb,'String',filehb);


% --- Executes on button press in label_bf_button.
function label_bf_button_Callback(hObject, eventdata, handles)
% hObject    handle to label_bf_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%% ========================= Declare variable =============================
global folderaddress filelabel
% folderaddress:    contain the address of the TXT file and save into file
%                   mat in this address
% filelabel:        name of file label in the folder

%% ======================= Open file subject's hb =========================
%find file label
foldername = dir(folderaddress);        %make the folder current is folderaddress
subject = get(handles.subject_name_edit,'String');
subject = [subject '_label'];           %take target file name
foldername = {foldername(:).name};      %find all file in folder current
filehbo = foldername(~cellfun('isempty',strfind(foldername,subject)));
                                        %find target file name in folder current 

%check is a row vector to show in listbox
if isrow(filelabel) == 0
    filelabel = filelabel';
end

%% ========================== Display file ================================
set(handles.listbox_label,'String',filelabel);


% --- Executes on button press in convert_button.
function convert_button_Callback(hObject, eventdata, handles)
% hObject    handle to convert_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%% ======================== Declare variable ==============================
global folderaddress filehbo filehb filelabel
% folderaddress:    contain the address of the TXT file and save into file
%                   mat in this address
% filehbo:          name of file deo-Hb in the folder
% filehb:           name of file oxy-Hb in the folder
% filelabel:        name of file label in the folder
subject = get(handles.subject_name_edit,'String');

%% ======================== Load label file ===============================
for i = 1:length(filelabel)
    fileID = fopen(sprintf('%s%s',folderaddress,filelabel{1}));             % Open each file label                                            
    label_temp = textscan(fileID,'%s');     % temp = temporary variable
    label = label_temp{1};                  % labels of each observation
    fclose(fileID); 
end

%% =========================== Load oxy-Hb ================================
for i = 1:length(filehb)
    hbo_temp_all = dlmread(sprintf('%s%s',folderaddress,filehb{i}), ' ');   % Open each file oxy-Hb                                         
    hbo = hbo_temp_all(:, 2:end);           % First colum = period marker: 0 = rest1, 1 = task, 2 = rest2
end

%% =========================== Load deo-Hb ================================
for i = 1:length(filehbo)
    hb_temp_all = dlmread(sprintf('%s%s',folderaddress,filehbo{i}), ' ');   % Open each fild deo-Hb   
    hb = hbo_temp_all(:, 2:end);            % First colum = period marker: 0 = rest1, 1 = task, 2 = rest2
end

%% ============================ SAVE DATA =================================
save(sprintf('%s%s_all.mat', folderaddress,subject), 'hb', 'hbo', 'label');


% --- Executes on selection change in listbox_hbo.
function listbox_hbo_Callback(hObject, eventdata, handles)
% hObject    handle to listbox_hbo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox_hbo contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox_hbo


% --- Executes during object creation, after setting all properties.
function listbox_hbo_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox_hbo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in listbox_label.
function listbox_label_Callback(hObject, eventdata, handles)
% hObject    handle to listbox_label (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox_label contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox_label


% --- Executes during object creation, after setting all properties.
function listbox_label_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox_label (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in listbox_hb.
function listbox_hb_Callback(hObject, eventdata, handles)
% hObject    handle to listbox_hb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% Hints: contents = cellstr(get(hObject,'String')) returns listbox_hb contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox_hb


% --- Executes during object creation, after setting all properties.
function listbox_hb_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox_hb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in folder_bf_button.
function folder_bf_button_Callback(hObject, eventdata, handles)
% hObject    handle to folder_bf_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global folderaddress

%% ========================== Browse folder ===============================
folderaddress = uigetdir;
folderaddress = [folderaddress '\'];
set(handles.folder_bf_edit,'String',folderaddress);


function folder_bf_edit_Callback(hObject, eventdata, handles)
% hObject    handle to folder_bf_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of folder_bf_edit as text
%        str2double(get(hObject,'String')) returns contents of folder_bf_edit as a double


% --- Executes during object creation, after setting all properties.
function folder_bf_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to folder_bf_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
