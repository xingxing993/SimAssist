function varargout = saDlg_AddNewBlock(varargin)
% SADLG_ADDNEWBLOCK MATLAB code for saDlg_AddNewBlock.fig
%      SADLG_ADDNEWBLOCK, by itself, creates a new SADLG_ADDNEWBLOCK or raises the existing
%      singleton*.
%
%      H = SADLG_ADDNEWBLOCK returns the handle to a new SADLG_ADDNEWBLOCK or the handle to
%      the existing singleton*.
%
%      SADLG_ADDNEWBLOCK('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SADLG_ADDNEWBLOCK.M with the given input arguments.
%
%      SADLG_ADDNEWBLOCK('Property','Value',...) creates a new SADLG_ADDNEWBLOCK or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before saDlg_AddNewBlock_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to saDlg_AddNewBlock_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help saDlg_AddNewBlock

% Last Modified by GUIDE v2.5 09-Jul-2015 23:55:38

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @saDlg_AddNewBlock_OpeningFcn, ...
                   'gui_OutputFcn',  @saDlg_AddNewBlock_OutputFcn, ...
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


% --- Executes just before saDlg_AddNewBlock is made visible.
function saDlg_AddNewBlock_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to saDlg_AddNewBlock (see VARARGIN)

% Choose default command line output for saDlg_AddNewBlock
% initialzie pop menu
dd = dir('.\+Routines');
routinenames = regexprep({dd(~[dd.isdir]).name}', '\..*', '');
set(handles.pop_routine, 'String', routinenames, 'Value', strmatch('majorprop_value',routinenames,'exact'));
if nargin>3
    initialize_uicontrols(handles, varargin{1});
end
handles.Cancel = true;
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes saDlg_AddNewBlock wait for user response (see UIRESUME)
uiwait(handles.sadlg_addnewblock);

function initialize_uicontrols(handles, info)
if isobject(info)
    
elseif isstruct(info)
    set(handles.edit_patternstr, 'String', safe_get(info, 'RoutinePattern'));
    set(handles.edit_priority, 'String', num2str(safe_get(info,'RoutinePriority')));
%     set(handles.pop_routine, );
elseif ischar(info)||isnumeric(info) %given only block handle or path
    newbt = saBlock(info);
    set(handles.blockpath, 'String', newbt.GetSourcePath);
end

function val = safe_get(h, prop)
val = '';
if isobject(h)
    if isprop(h, prop)
        val = h.(prop);
    end
else
    if isfield(h, prop)
        val = h.(prop);
    end
end

% --- Outputs from this function are returned to the command line.
function varargout = saDlg_AddNewBlock_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
if ~isempty(handles)
    if ~handles.Cancel
        info = collect_info(handles);
        % RoutinePara
        varargout{1} = info;
    else
        varargout{1} = [];
    end
    close(handles.sadlg_addnewblock);
else
    varargout{1} = [];
end

function info = collect_info(handles)
info.RoutinePattern = get(handles.edit_patternstr, 'String');
info.RoutinePriority = str2double(get(handles.edit_priority, 'String'));
contents = cellstr(get(handles.pop_routine,'String'));
info.RoutineMethod = contents{get(handles.pop_routine,'Value')};
rttbldata = get(handles.tbl_routinepara, 'Data');
for i=1:size(rttbldata, 1)
    if ~isempty(rttbldata{i,1}) && ischar(rttbldata{i,1})
        info.RoutinePara.(rttbldata{i,1}) = rttbldata{i,2};
    end
end
majprop = get(handles.edit_majorprop, 'String');
if ~isempty(majprop)
    info.MajorProperty = get(handles.edit_majorprop, 'String');
end
info.BlockPreferOption.ShowName = num2onoff(get(handles.chk_showname, 'Value'));
info.BlockPreferOption.Selected = num2onoff(get(handles.chk_select, 'Value'));


function out = num2onoff(in)
if ~ischar(in)
    if in
        out = 'on';
    else
        out = 'off';
    end
else
    out = in;
end


function edit_patternstr_Callback(hObject, eventdata, handles)
% hObject    handle to edit_patternstr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_patternstr as text
%        str2double(get(hObject,'String')) returns contents of edit_patternstr as a double


% --- Executes during object creation, after setting all properties.
function edit_patternstr_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_patternstr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_priority_Callback(hObject, eventdata, handles)
% hObject    handle to edit_priority (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_priority as text
%        str2double(get(hObject,'String')) returns contents of edit_priority as a double


% --- Executes during object creation, after setting all properties.
function edit_priority_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_priority (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in pop_routine.
function pop_routine_Callback(hObject, eventdata, handles)
% hObject    handle to pop_routine (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pop_routine contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pop_routine


% --- Executes during object creation, after setting all properties.
function pop_routine_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pop_routine (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in chk_showname.
function chk_showname_Callback(hObject, eventdata, handles)
% hObject    handle to chk_showname (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chk_showname


% --- Executes on button press in chk_select.
function chk_select_Callback(hObject, eventdata, handles)
% hObject    handle to chk_select (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chk_select


% --- Executes on button press in btn_ok.
function btn_ok_Callback(hObject, eventdata, handles)
% hObject    handle to btn_ok (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
uiresume(handles.sadlg_addnewblock);
handles.Cancel = false;
guidata(hObject, handles);

% --- Executes on button press in btn_cancel.
function btn_cancel_Callback(hObject, eventdata, handles)
% hObject    handle to btn_cancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
uiresume(handles.sadlg_addnewblock);
handles.Cancel = true;
guidata(hObject, handles);


% --- Executes on button press in btn_tom.
function btn_tom_Callback(hObject, eventdata, handles)
% hObject    handle to btn_tom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
newbt = saBlock(gcbh);
info = collect_info(handles);
if ~isempty(info) && ~isempty(info.RoutinePattern)
    flds = fieldnames(info);
    for i=1:numel(flds)
        newbt.(flds{i}) = info.(flds{i});
    end
end
newbt.CreateMFile;

function edit_majorprop_Callback(hObject, eventdata, handles)
% hObject    handle to edit_majorprop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_majorprop as text
%        str2double(get(hObject,'String')) returns contents of edit_majorprop as a double


% --- Executes during object creation, after setting all properties.
function edit_majorprop_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_majorprop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
