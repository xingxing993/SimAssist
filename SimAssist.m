function varargout = SimAssist(varargin)
% SIMASSIST M-file for SimAssist.fig
%      Author: Jiang Xin
%
%      SIMASSIST, by itself, creates a new SIMASSIST or raises the existing
%      singleton*.
%
%      H = SIMASSIST returns the handle to a new SIMASSIST or the handle to
%      the existing singleton*.
%
%      SIMASSIST('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SIMASSIST.M with the given input arguments.
%
%      SIMASSIST('Property','Value',...) creates a new SIMASSIST or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before SimAssist_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to SimAssist_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help SimAssist

% Last Modified by GUIDE v2.5 04-Jan-2016 22:34:43

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @SimAssist_OpeningFcn, ...
                   'gui_OutputFcn',  @SimAssist_OutputFcn, ...
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
end

% --- Executes just before SimAssist is made visible.
function SimAssist_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to SimAssist (see VARARGIN)

% Choose default command line output for SimAssist

if isfield(handles,'GUIOpen') && handles.GUIOpen
    uicontrol(handles.edit_cmdstr);
    set(handles.edit_cmdstr, 'String', '');
    return;
end
handles.output = hObject;


%%%%%%%%%%%%% Licensing Code Begin %%%%%%%%%%%%%%%%%%%%%%%%%
lval = true; % actual
lvalcd = true;
LIC_CHK.Enable = true;
LIC_CHK.CheckUser = false;
LIC_CHK.CheckDomain = false;
LIC_CHK.CheckDate = true;
if lval
    %-----------------------------------------------
    validusers={'ahlmq','iexsk','galfd','cnhfe','jiangxin'};
    validdomains = {'kslegion'};
    expire_date = [2016,03,31];
    %------------------------------------------------
    [tmp, sysuser] = system('echo %username%');
    [tmp, sysdomain] = system('echo %userdomain%');
    [tmp, sysdatestr] = system('echo %date%');
    datepattern = {'%u-%u-%u','%u/%u/%u'};
    for i=1:numel(datepattern)
        sysdate=sscanf(sysdatestr, datepattern{i});
        if size(sysdate,1)>size(sysdate,2)
            sysdate = sysdate';
        end
        if numel(sysdate)==3 break; end
    end
    % user check
    if LIC_CHK.CheckUser && ~any(strcmpi(strtrim(sysuser), validusers)) % if matches with any valid users
        warndlg('SimAssist : Invalid user');
        close(hObject);
        return;
    end
    %domain check
    if LIC_CHK.CheckDomain && ~any(strcmpi(strtrim(sysdomain), validdomains)) % if matches with any valid users
        warndlg('SimAssist : Invalid domain');
        close(hObject);
        return;
    end
    % date check
    if ispref('SimAssist_Pref','DateExpire')
        prefexpdate = getpref('SimAssist_Pref','DateExpire');
        if all(prefexpdate==expire_date)
            if ispref('SimAssist_Pref','DateValid')
                if ~getpref('SimAssist_Pref','DateValid') && lvalcd
                    tmpd=false;
                    errordlg('SimAssist : Time expired for usage, contact jiangxinauto@163.com for information');
                    close(hObject);
                    return;
                end
            end
        else
            setpref('SimAssist_Pref','DateExpire',expire_date);
        end
    else
       setpref('SimAssist_Pref','DateExpire',expire_date);
    end
    tmpd = sign(expire_date-sysdate) * [1; 0.1; 0.01] >= 0; %check date then
    if ~tmpd && lvalcd
        errordlg('SimAssist : Time expired for usage, contact jiangxinauto@163.com for information');
        setpref('SimAssist_Pref', 'DateValid',false);
        close(hObject);
        return;
    else
        setpref('SimAssist_Pref', 'DateValid',true);
    end
end
%%%%%%%%%%%%% Licensing Code End %%%%%%%%%%%%%%%%%%%%%%%%%


handles.GUIOpen = true;
set(handles.btnUndo,'Enable','off');
set(handles.btnRedo,'Enable','off');
uicontrol(handles.edit_cmdstr);
handles.hispointer=0;

handles.ExtraDlgParas={'AttributesFormatString';};

% BEGIN TO BUILD DATABASE
current_sys = gcs;
if isempty(current_sys)
    open_system(new_system);
    current_sys = gcs;
end
sapath = fileparts(mfilename('fullpath'));
addpath(fullfile(sapath, '_BlockRegistration'));
addpath(fullfile(sapath, '_MacroRegistration'));
addpath(fullfile(sapath, 'Dialogs'));
if exist(fullfile(sapath, 'SimAssistBuffer.mat'))==2
    load SimAssistBuffer.mat Console
    handles.Console = Console;
else
    handles.Console = saConsole;
    handles.Console.BuildMap;
    handles.Console.BuildMacros;
end
open_system(current_sys); % restore current system because it might have been changed by load_system
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes SimAssist wait for user response (see UIRESUME)
% uiwait(handles.SimAssist);
end

% --- Outputs from this function are returned to the command line.
function varargout = SimAssist_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = hObject;
end


% --- Executes when user attempts to close SimAssist.
function SimAssist_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to SimAssist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
try
    if ~isempty(handles.Console.Newer)
        sapath = fileparts(mfilename('fullpath'));
        buffile = fullfile(sapath, ['_BlockRegistration\regblock_custom', datestr(now, 'yyyymmddHHMMSS')]);
        newer = handles.Console.Newer;
        save(buffile, 'newer');
    end
    
    SAVEONCLOSE = false;
    if isfield(handles, 'Console') && SAVEONCLOSE
        sapath = fileparts(mfilename('fullpath'));
        buffile = fullfile(sapath, 'SimAssistBuffer.mat');
        save(buffile, '-struct', 'handles', 'Console');
    end
    delete(hObject);
catch
    delete(hObject);
end
end

% --- Executes on button press in SrcPropagate.
function SrcPropagate_Callback(hObject, eventdata, handles)
% hObject    handle to SrcPropagate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
actrec=saRecorder;
objs=saFindSystem;
if isempty(objs)
    return;
end
objs = saRemoveBranchLine(objs);
for i=1:numel(objs)
    sabt = handles.Console.MapTo(objs(i));
    if ~isempty(sabt)
        actrec.Merge(sabt.PropagateUpstreamString(objs(i)));
        if sabt.isa('block') && ~any(xor(sabt.ConnectPort, [0,1]))
            actrec.Merge(sabt.CreateBroBlock(objs(i)));
        end
    else
        continue;
    end
end
savehistory(handles,actrec);
end

% --- Executes on button press in DstPropagate.
function DstPropagate_Callback(hObject, eventdata, handles)
% hObject    handle to DstPropagate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
actrec=saRecorder;
objs=saFindSystem;
if isempty(objs)
    return;
end
objs = saRemoveBranchLine(objs);
for i=1:numel(objs)
    sabt = handles.Console.MapTo(objs(i));
    if ~isempty(sabt)
        actrec.Merge(sabt.PropagateDownstreamString(objs(i)));
        if sabt.isa('block') && ~any(xor(sabt.ConnectPort, [1,0]))
            actrec.Merge(sabt.CreateBroBlock(objs(i)));
        end
    else
        continue;
    end
end
savehistory(handles,actrec);
end


%------'savehistory'----------
function savehistory(handles,actrec)
hisdata=get(handles.SimAssist,'UserData');
if handles.hispointer>=1
    hisdata=hisdata(1:handles.hispointer);
else
    hisdata=[];
end %Cut off
hisdata=[hisdata;actrec];
handles.hispointer=handles.hispointer+1;
set(handles.SimAssist,'UserData',hisdata);
set(handles.btnUndo,'Enable','on');
set(handles.btnRedo,'Enable','off');
guidata(handles.SimAssist,handles);%Update history pointer
end



% --- Executes on button press in hidename.
function hidename_Callback(hObject, eventdata, handles)
% hObject    handle to hidename (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
actrec=saRecorder;
blks=find_system(gcs,'SearchDepth',1,'LookUnderMasks','on','FollowLinks','on','Selected','on');
if isempty(blks)
    return
end
for i=1:numel(blks)
    if ~strcmpi(blks{i},gcs)
        objhdl=get_param(blks{i},'Handle');
        property='ShowName';
        oldval = get_param(objhdl,property);
        if strcmp(oldval,'off');
            newval='on';
        else
            newval='off';
        end
        actrec.SetParam(objhdl,property,newval);
    end
end
savehistory(handles,actrec);
end

% --- Executes on button press in AutoAct.
function AutoAct_Callback(hObject, eventdata, handles)
% hObject    handle to AutoAct (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
actrec=saRecorder;
blks=saFindSystem(gcs,'block');
if isempty(blks)
    return
end
for i=1:numel(blks)
    sabt = handles.Console.MapTo(blks(i));
    if ~isempty(sabt.RollPropertyMethod)
        actrec.Merge(sabt.RollProperty(blks(i)));
    end
    if ~isempty(sabt.AnnotationMethod)
        actrec.Merge(sabt.Annotate(blks(i)));
    end
    if ~isempty(sabt.RefineMethod)
        actrec.Merge(sabt.Refine(blks(i)));
    end
    if ~isempty(sabt.AutoSizeMethod)
        actrec.Merge(sabt.AutoSize(blks(i)));
    end
end
savehistory(handles,actrec);
end



% --------------------------------------------------------------------
function PinOnTop_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to PinOnTop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tmp=get(hObject,'CData');
set(hObject,'CData',get(hObject,'UserData'));
set(hObject,'UserData',tmp);
% Get JavaFrame of Figure.
warning('off','MATLAB:HandleGraphics:ObsoletedProperty:JavaFrame');
fJFrame = get(handles.SimAssist,'JavaFrame');
verinfo=ver('MATLAB');
vernum=verinfo.Version;
currver=regexp(vernum,'^(?<major>\d+)\.(?<middle>\d+)','names');
if str2num(currver.major)>7
    figclient='fHG1Client';
else
    if str2num(currver.middle)>10
        figclient='fHG1Client';
    else
        figclient='fFigureClient';
    end
end
% Set JavaFrame Always-On-Top-Setting.
if strcmpi(get(hObject,'State'),'on')
    fJFrame.(figclient).getWindow.setAlwaysOnTop(1);
else
    fJFrame.(figclient).getWindow.setAlwaysOnTop(0);
end
warning('on','MATLAB:HandleGraphics:ObsoletedProperty:JavaFrame');
end


% --------------------------------------------------------------------
function btnUndo_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to btnUndo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
hisdata=get(handles.SimAssist,'UserData');
actrec=hisdata(handles.hispointer);
actrec.Undo;
handles.hispointer=handles.hispointer-1;
set(handles.btnRedo,'Enable','on');
if handles.hispointer==0
    set(hObject,'Enable','off');
end
guidata(handles.SimAssist,handles);%Update history pointer
end

% --------------------------------------------------------------------
function btnRedo_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to btnRedo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
hisdata=get(handles.SimAssist,'UserData');
handles.hispointer=handles.hispointer+1;
actrec=hisdata(handles.hispointer);
actrec.Redo;
set(handles.btnUndo,'Enable','on');
if handles.hispointer==numel(hisdata)
    set(hObject,'Enable','off');
end
guidata(handles.SimAssist,handles);%Update history pointer
set(handles.SimAssist,'UserData',hisdata); %Update hisdata. (In case add block happend)
end


% --- Executes on button press in ExpandBtn.
function ExpandBtn_Callback(hObject, eventdata, handles)
% hObject    handle to ExpandBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
pospanel = get(handles.uipanel3, 'Position');
posbtn = get(hObject, 'Position');

if strcmpi(get(hObject,'String'),'>')
    figpos=get(handles.SimAssist,'Position');
    figpos(3)=pospanel(1)+pospanel(3)+5;
    set(handles.SimAssist,'Position',figpos);
    set(hObject,'String','<');
elseif strcmpi(get(hObject,'String'),'<')
    figpos=get(handles.SimAssist,'Position');
    figpos(3)=posbtn(1)+posbtn(3)+5;
    set(handles.SimAssist,'Position',figpos);
    set(hObject,'String','>');
end
end


% --- Executes on selection change in popmenu_blk.
function popmenu_blk_Callback(hObject, eventdata, handles)
% hObject    handle to popmenu_blk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popmenu_blk contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popmenu_blk
alldlgparas={};
blktypestr = get(hObject,'String');
propstr = get(handles.popmenu_prop,'String');
if ~isempty(propstr)
    oldprop=propstr{get(handles.popmenu_prop,'Value')};
else
    oldprop='';
end
blks=find_system(gcs,'SearchDepth',1,'LookUnderMasks','on','FollowLinks','on','Selected','on');
if numel(blks)==0
    return;
end
if strcmp(blks{1},gcs)% Discard parent subsystem
    blks=blks(2:numel(blks));
end
if isempty(blktypestr{get(hObject,'Value')})
    return;
elseif strcmp(blktypestr{get(hObject,'Value')},'ALL')
    for i=1:numel(blks) %The first item is defined as 'All'
        try
            dlgparas=[fieldnames(get_param(blks{i},'DialogParameters'));handles.ExtraDlgParas];
            alldlgparas=[alldlgparas;dlgparas];
        end
    end
else
    for i=1:numel(blks)
        if strcmpi(get_param(blks{i},'BlockType'),blktypestr{get(hObject,'Value')})
            try
                alldlgparas=[fieldnames(get_param(blks{i},'DialogParameters'));handles.ExtraDlgParas];
            end
            break;
        end
    end
end
alldlgparas=unique(alldlgparas);
if isempty(alldlgparas)
    alldlgparas={'---'};
    set(handles.popmenu_prop,'String',alldlgparas,'Value',1);
elseif ~isempty(oldprop)&&~isempty(strmatch(oldprop,alldlgparas))
    set(handles.popmenu_prop,'String',alldlgparas);
    set(handles.popmenu_prop,'Value',strmatch(oldprop,alldlgparas)); % Resume old property
else
    set(handles.popmenu_prop,'String',alldlgparas,'Value',1);
end

% Find all the parameter values and initialize popmenu
paravals={};
if strcmp(blktypestr{get(hObject,'Value')},'ALL')
    filtblks=blks;
else
    filtblks=find_system(blks,'BlockType',blktypestr{get(hObject,'Value')});
end
for i=1:numel(filtblks)
    try
        blkval=get_param(filtblks{i},alldlgparas{get(handles.popmenu_prop,'Value')});
        paravals=[paravals;blkval];
    end
end
paravals=unique(paravals);
if isempty(paravals)
    paravals={'---'};
end
set(handles.popmenu_val,'String',paravals,'Value',1);
end

% --- Executes during object creation, after setting all properties.
function popmenu_blk_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popmenu_blk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes on selection change in popmenu_prop.
function popmenu_prop_Callback(hObject, eventdata, handles)
% hObject    handle to popmenu_prop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popmenu_prop contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popmenu_prop
paravals={};
propstr = get(hObject,'String');
blktypestr = get(handles.popmenu_blk,'String');
blks=find_system(gcs,'SearchDepth',1,'LookUnderMasks','on','FollowLinks','on','Selected','on');
if numel(blks)==0
    return;
end
if strcmp(blks{1},gcs)% Discard parent subsystem
    blks=blks(2:numel(blks));
end
if isempty(propstr)
    return;
elseif strcmpi(propstr{get(hObject,'Value')},'---')
    return;
else
    if strcmp(blktypestr{get(handles.popmenu_blk,'Value')},'ALL')
        filtblks=blks;
    else
        filtblks=find_system(blks,'BlockType',blktypestr{get(handles.popmenu_blk,'Value')});
    end
    for i=1:numel(filtblks)
        try
            blkval=get_param(filtblks{i},propstr{get(hObject,'Value')});
            paravals=[paravals;blkval];
        end
    end
    paravals=unique(paravals);
    if isempty(paravals)
        paravals={'---'};
    end
    set(handles.popmenu_val,'String',paravals,'Value',1);
end
end


% --- Executes during object creation, after setting all properties.
function popmenu_prop_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popmenu_prop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes on selection change in popmenu_val.
function popmenu_val_Callback(hObject, eventdata, handles)
% hObject    handle to popmenu_val (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popmenu_val contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popmenu_val
end

% --- Executes during object creation, after setting all properties.
function popmenu_val_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popmenu_val (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes on button press in btnSearch.
function btnSearch_Callback(hObject, eventdata, handles)
% hObject    handle to btnSearch (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
blks=find_system(gcs,'SearchDepth',1,'LookUnderMasks','on','FollowLinks','on','Selected','on');
if isempty(blks)
    return;
end
if strcmp(blks{1},gcs)% Discard parent subsystem
    blks=blks(2:numel(blks));
end
% Initialize blocktype popmenu
blktypes=unique(get_param(blks,'BlockType'));
blktypes=[{'ALL'};blktypes];
set(handles.popmenu_blk,'String',blktypes,'Value',1);
% Find all the dialog parameters and initialize popmenu
propstr=get(handles.popmenu_prop,'String');
if ~isempty(propstr)
    oldprop=propstr{get(handles.popmenu_prop,'Value')};
else
    oldprop='';
end
alldlgparas={};
for i=1:numel(blks)
    try
        dlgparas=[fieldnames(get_param(blks{i},'DialogParameters'));handles.ExtraDlgParas];
        alldlgparas=[alldlgparas;dlgparas];
    end
end
alldlgparas=unique(alldlgparas);
if isempty(alldlgparas)
    alldlgparas={'---'};
    set(handles.popmenu_prop,'String',alldlgparas,'Value',1);
elseif ~isempty(oldprop)&&~isempty(strmatch(oldprop,alldlgparas))
    set(handles.popmenu_prop,'String',alldlgparas,'Value',strmatch(oldprop,alldlgparas, 'exact'));
else
    set(handles.popmenu_prop,'String',alldlgparas,'Value',1);
end

set(handles.popmenu_prop,'String',alldlgparas);
% Find all the parameter values and initialize popmenu
paravals={};
for i=1:numel(blks)
    try
        blkval=get_param(blks{i},alldlgparas{get(handles.popmenu_prop,'Value')});
        paravals=[paravals;blkval];
    end
end
paravals=unique(paravals);
if isempty(paravals)
    paravals={'---'};
end
set(handles.popmenu_val,'String',paravals,'Value',1);
end

% --- Executes on button press in btnApplyPropChg.
function btnApplyPropChg_Callback(hObject, eventdata, handles)
% hObject    handle to btnApplyPropChg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
actrec=saRecorder;
blks=find_system(gcs,'SearchDepth',1,'LookUnderMasks','on','FollowLinks','on','Selected','on');
if isempty(blks)
    return;
end
if strcmp(blks{1},gcs)% Discard parent subsystem
    blks=blks(2:numel(blks));
end
blktypestr=get(handles.popmenu_blk,'String');
propstr=get(handles.popmenu_prop,'String');
valstr=get(handles.popmenu_val,'String');
try
    %Blocks
    if strcmp(blktypestr{get(handles.popmenu_blk,'Value')},'ALL')
        filtblks=blks;
    else
        filtblks=find_system(blks,'BlockType',blktypestr{get(handles.popmenu_blk,'Value')});
    end
    %Property
    prop=propstr{get(handles.popmenu_prop,'Value')};
    %Value
    if ~isempty(get(handles.edit_paraval,'String'))
        val=get(handles.edit_paraval,'String');
    else
        val=valstr{get(handles.popmenu_val,'Value')};
    end
catch
    return;
end
for i=1:numel(filtblks)
    objhdl=get_param(filtblks{i},'Handle');
    property=prop;
    newval=val;
    try
    	actrec.SetParamHighlight(objhdl,property,newval);
    catch
    	continue;
    end
end
savehistory(handles,actrec);
end


function edit_paraval_Callback(hObject, eventdata, handles)
% hObject    handle to edit_paraval (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_paraval as text
%        str2double(get(hObject,'String')) returns contents of edit_paraval as a double
end

% --- Executes during object creation, after setting all properties.
function edit_paraval_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_paraval (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --------------------------------------------------------------------
function runsimreplace_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to runsimreplace (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
run SimReplace
end

% --------------------------------------------------------------------
function mi_fb_specify_Callback(hObject, eventdata, handles)
% hObject    handle to mi_fb_specify (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ud=get(handles.btn_fmtbrush,'UserData');
if isfield(ud, 'MultiValues')&&~isempty(ud.MultiValues) % this menu doesn't work in multi brush mode
    return;
end
if isfield(ud, 'Handle')&&~isempty(ud.Handle)
    liststr = fieldnames(get_param(ud.Handle,'DialogParameters'));
    if isempty(ud.Properties)
        initval = {};
    else
        [props, ia] = intersect(liststr, ud.Properties);
        initval = {'InitialValue',ia};
    end
    [sel,ok] = listdlg('PromptString','Select format brush parameters:',...
                      'ListString',liststr, initval{:});
    if ok
        ud.Properties=liststr(sel);
        set(handles.btn_fmtbrush,'UserData',ud);
    end        
end
end

% --- Executes on button press in btn_mpt.
function btn_mpt_Callback(hObject, eventdata, handles)
% hObject    handle to btn_mpt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

actrec=saRecorder;
objs=find_system(gcs,'SearchDepth',1,'FindAll','on','LookUnderMasks','on','FollowLinks','on','Selected','on');
if isempty(objs)
    return;
end
for i=1:numel(objs)
    if objs(i)~=get_param(gcs,'Handle'); %If the object is the current system, do nothing
        if strcmpi(get_param(objs(i),'Type'),'line')%If a line
            mptsig=mpt.Signal;
            nam=get_param(objs(i),'Name');
            nam=strrep(nam,'<','');
            nam=strrep(nam,'>','');
            if isempty(nam)
                return;
            end
            srcpt=get_param(objs(i),'SrcPortHandle');
            oldstatus=get_param(srcpt,'MustResolveToSignalObject');
            if strcmpi(oldstatus,'off')
                actrec.SetParam(srcpt, 'MustResolveToSignalObject', 'on');
            else
                actrec.SetParam(srcpt, 'MustResolveToSignalObject', 'off');
            end
        end
    end
end
savehistory(handles,actrec);
end

% --- Executes on button press in btn_refine_name.
function btn_refine_name_Callback(hObject, eventdata, handles)
% hObject    handle to btn_refine_name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
actrec=saRecorder;
if strcmp(get(handles.mi_dictrename_sf, 'Checked'), 'on')
    dict = handles.Console.MapTo('Stateflow').Dictionary;
    sfobjs = sfgco;
    renameprops = {'Name', 'LabelString'};
    for i=1:numel(sfobjs)
        for k=1:numel(renameprops)
            if sfobjs(i).isprop(renameprops{k})
                newvalstr=saDictRenameString(sfobjs(i).(renameprops{k}),dict);
                actrec.StateflowSetParam(sfobjs(i), renameprops{k}, newvalstr);
            end
        end
    end
else
    objs=saFindSystem(gcs,'block');
    for i=1:numel(objs)
        sabt = handles.Console.MapTo(objs(i));
        if ~isempty(sabt.DictRenameMethod)
            actrec.Merge(sabt.DictRename(objs(i)));
        end
    end
    lns = saFindSystem(gcs,'line');
    saln = handles.Console.MapTo('line');
    for i=1:numel(lns)
        actrec.Merge(saln.DictRename(lns(i)));
    end
end
savehistory(handles,actrec);
end



% --------------------------------------------------------------------
function menu_fmtbrush_Callback(hObject, eventdata, handles)
% hObject    handle to menu_fmtbrush (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end


% --- Executes on button press in btn_align.
function btn_align_Callback(hObject, eventdata, handles)
% hObject    handle to btn_align (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
actrec=saRecorder;
blks=saFindSystem(gcs,'block');
lns=saFindSystem(gcs,'line');
if numel(blks)==1
    actrec.LayoutAroundBlock(blks);
else
    bg=saBlockGroup(blks);
    subbgs=bg.SplitToIntactBGs;
    actrec.Merge(bg.AlignPortsInside);
    actrec.Merge(bg.StraightenLinesInside);
    if ~isempty(subbgs)
        actrec.Merge(subbgs.AlignPortsOutside);
    end
    actrec.Merge(bg.VerticalAlign);
end
for i=1:numel(lns)
    actrec.NeatenLine(lns(i), 'auto');
end
savehistory(handles,actrec);
end


% --- Executes on button press in btn_brklnk.
function btn_brklnk_Callback(hObject, eventdata, handles)
% hObject    handle to btn_brklnk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

end


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over btn_align.
function btn_align_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to btn_align (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Resize BusCreator/BusSelector/SubSystem to proper size
actrec=saRecorder;
objs=saFindSystem(gcs,'block');
for i=1:numel(objs)
    actrec.FitSize(objs(i));
    actrec.LayoutAroundBlock(objs(i));
end
savehistory(handles,actrec);
end





function edit_cmdstr_Callback(hObject, eventdata, handles)
% hObject    handle to edit_cmdstr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_cmdstr as text
%        str2double(get(hObject,'String')) returns contents of edit_cmdstr as a double

end


% --- Executes during object creation, after setting all properties.
function edit_cmdstr_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_cmdstr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


% --- Executes on key press with focus on edit_cmdstr and none of its controls.
function edit_cmdstr_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to edit_cmdstr (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
% disp('keypress');
actrec=saRecorder;
prompton = strcmp(get(handles.promptlistbox, 'Visible'), 'on');
ud = get(hObject,'UserData');
% if prompt listbox is shown, key press shall be dispathed for listbox
if prompton
    if strcmp(eventdata.Key, 'return')
        contents = get(handles.promptlistbox, 'String');
        index = get(handles.promptlistbox, 'Value');
        set(handles.edit_cmdstr, 'String', contents{index});
        set(handles.promptlistbox, 'Visible', 'off');
    elseif strcmp(eventdata.Key, 'escape')
        set(handles.promptlistbox, 'Visible', 'off');
    elseif strcmp(eventdata.Key, 'downarrow')
        contents = get(handles.promptlistbox, 'String');
        index = get(handles.promptlistbox, 'Value');
        set(handles.promptlistbox, 'Value', min(numel(contents), index+1));
    elseif strcmp(eventdata.Key, 'uparrow')
        contents = get(handles.promptlistbox, 'String');
        index = get(handles.promptlistbox, 'Value');
        set(handles.promptlistbox, 'Value', max(1, index-1));
    elseif numel(eventdata.Character)==1
        jEditbox = findjobj(hObject); % get java object
        partstr = char(jEditbox.getText); % attention
        if isempty(partstr)
            set(handles.promptlistbox, 'Visible', 'off');
        else
            liststr = handles.Console.UIGetPromptList(partstr);
            if ~isempty(liststr)&&strcmp(liststr{1},partstr)
                set(handles.promptlistbox, 'Visible', 'off');
            else
                show_promptlist(handles.promptlistbox, liststr);
            end
        end
    end
else
    if strcmp(eventdata.Key, 'return')
        % COMMAND STRING IS ACTUALLY RUN HERE
        cmdstr_return_callback(hObject, handles); 
    elseif strcmp(eventdata.Key, 'escape')
        set(hObject, 'String', '');
        uicontrol(hObject);
    elseif isequal(eventdata.Modifier, {'alt'})
        switch eventdata.Key
            case 'downarrow'
                actrec.Merge(handles.Console.RunCommand('shorter'));
                set(handles.edit_cmdstr, 'String', 'shorter');
            case 'uparrow'
                actrec.Merge(handles.Console.RunCommand('longer'));
                set(handles.edit_cmdstr, 'String', 'longer');
            case 'leftarrow'
                actrec.Merge(handles.Console.RunCommand('narrower'));
                set(handles.edit_cmdstr, 'String', 'narrower');
            case 'rightarrow'
                actrec.Merge(handles.Console.RunCommand('wider'));
                set(handles.edit_cmdstr, 'String', 'wider');
            otherwise
        end
        savehistory(handles,actrec);
    elseif isequal(eventdata.Modifier, {'control'})
        actrec.Merge(handles.Console.RunCommand('line'));
    elseif isequal(eventdata.Key, 'f1')
        jEditbox = findjobj(hObject); % get java object
        partstr = char(jEditbox.getText); % attention
        liststr = handles.Console.UIGetPromptList(partstr); % show all
        show_promptlist(handles.promptlistbox, liststr);
    elseif ismember(eventdata.Key, {'downarrow','pagedown','uparrow','pageup'})% History command
        % eventdata
        if ~isempty(ud) && isfield(ud, 'History')
            itemcnt = numel(ud.History);
        else
            return;
        end
        switch eventdata.Key
            case {'downarrow','pagedown'}
                ud.Pointer = max(ud.Pointer-1,1);
                set(hObject,'String',ud.History{ud.Pointer});
            case {'uparrow','pageup'}
                ud.Pointer = min(ud.Pointer+1,itemcnt);
                set(hObject,'String',ud.History{ud.Pointer});
        end
        set(hObject,'UserData',ud);
    elseif numel(eventdata.Character)==1 && strcmp(get(handles.menu_showprompt, 'Checked'), 'on')
        jEditbox = findjobj(hObject); % get java object
        partstr = char(jEditbox.getText); % attention
        if isempty(partstr)
            set(handles.promptlistbox, 'Visible', 'off');
        else
            liststr = handles.Console.UIGetPromptList(partstr);
            if ~isempty(liststr)&&strcmp(liststr{1},partstr)
            else
                show_promptlist(handles.promptlistbox, liststr);
            end
        end
    else
    end
end
end

function cmdstr_return_callback(hObject, handles)
actrec=saRecorder;
jEditbox = findjobj(hObject); % get java object
cmdstr = char(jEditbox.getText);
prompton = strcmp(get(handles.promptlistbox, 'Visible'), 'on');
if isempty(cmdstr) || prompton
    return;
end
actrec = handles.Console.RunCommand(cmdstr);
savehistory(handles,actrec);
% add to command string history
ud = get(hObject, 'UserData');
if isempty(ud) || ~isfield(ud, 'History')
    ud.History={};
    ud.Pointer = 0;
elseif numel(ud.History)>=400 % allow maximum 400 history items
    ud.History(end)=[];
else
end
if ~isempty(ud.History)&&strcmp(cmdstr, ud.History{1})
    % If the command is the same as the first history item, do not append
else
    ud.History=[cmdstr;ud.History];
    ud.Pointer = 1;
    set(hObject, 'UserData', ud);
end
end


function show_promptlist(hObject, liststr)
if ~isempty(liststr)
    pos = get(hObject, 'Position');
    hfig = get(hObject,'Parent');
    figpos = get(hfig,'Position');
    pos(4) = min((numel(liststr)+1)*10, figpos(4)-30);
    oldval = get(hObject, 'Value');
    set(hObject, 'Value', min(oldval, numel(liststr)), 'String', liststr, 'Position', pos, 'Visible', 'on');
else
    set(hObject, 'Visible', 'off', 'Value', 1, 'String', {'#None#'});
end
end


% --- Executes on selection change in promptlistbox.
function promptlistbox_Callback(hObject, eventdata, handles)
% hObject    handle to promptlistbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns promptlistbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from
%        promptlistbox
end

% --- Executes during object creation, after setting all properties.
function promptlistbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to promptlistbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


% --- Executes on key press with focus on promptlistbox and none of its controls.
function promptlistbox_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to promptlistbox (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
if strcmp(eventdata.Key, 'return')
    contents = get(hObject, 'String');
    index = get(hObject, 'Value');
    set(handles.edit_cmdstr, 'String', contents{index});
    set(hObject, 'Visible', 'off', 'Value', 1, 'String', {'#None#'});
elseif strcmp(eventdata.Key, 'escape')
    set(hObject, 'Visible', 'off', 'Value', 1, 'String', {'#None#'});
    uicontrol(handles.edit_cmdstr);
end
end


% --------------------------------------------------------------------
function menu_editcmd_Callback(hObject, eventdata, handles)
% hObject    handle to menu_editcmd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end

% --------------------------------------------------------------------
function menu_showprompt_Callback(hObject, eventdata, handles)
% hObject    handle to menu_showprompt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if strcmp(get(hObject, 'Checked'), 'on')
    set(hObject, 'Checked', 'off');
else
    set(hObject, 'Checked', 'on');
end
end


% --- Executes on button press in btn_fmtbrush.
function btn_fmtbrush_Callback(hObject, eventdata, handles)
% hObject    handle to btn_fmtbrush (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ud = get(hObject, 'UserData');
if (isfield(ud, 'Handle') && ~isempty(ud.Handle)) || (isfield(ud, 'MultiValues') && ~isempty(ud.MultiValues))
    if (isfield(ud, 'Handle') && ~isempty(ud.Handle))
        actrec = fmtbrush_brush(hObject, handles);
    else
        actrec = fmtbrush_multibrush(hObject, handles);
    end
    savehistory(handles,actrec);
    % restore state
    if strcmp(get(handles.mi_fmtbrushlock, 'Checked'), 'off')
        ud.Handle = [];
        ud.Properties = {};
        ud.MultiValues = {}; % multi mode
        %Change icon
        set(hObject,'CData',ud.CData);
        set(hObject,'TooltipString','No template block');
        set(hObject,'UserData',ud);
        set(hObject, 'String', ''); % multi mode
    end
else
    fmtbrush_buffer(hObject, handles);
end
end


function fmtbrush_buffer(hObject, handles)
ud = get(hObject, 'UserData');
fmtblk = saFindSystem(gcs,'block');
fmtlns = saFindSystem(gcs,'line');
if numel(fmtblk)>1 || numel(fmtlns)>0 % multi mode
    %Change icon and ID
    set(hObject,'CData',ud.CData2);
    set(hObject,'TooltipString','Multi mode');
    srcobjs = [fmtblk; fmtlns];
    for i=1:numel(srcobjs)
        btobj = handles.Console.MapTo(srcobjs(i));
        ud.MultiValues{i} = get_param(srcobjs(i), btobj.GetMajorProperty);
    end
elseif numel(fmtblk)==0
else
    ud.Handle = fmtblk;
    ud.Properties = {};
    %Change icon
    set(hObject,'CData',ud.CData1);
    set(hObject,'TooltipString',['Template block: ',getfullname(fmtblk)]);
end
set(hObject,'UserData',ud);
end

function actrec = fmtbrush_brush(hObject, handles)
actrec=saRecorder;
ud = get(hObject, 'UserData');
tgtblks=saFindSystem(gcs,'block');
f_getparas = @(blkhdl)fieldnames(get_param(blkhdl,'DialogParameters'));
if strcmp(get(handles.mi_fmt_dlgpara, 'Checked'), 'on')
    if isempty(ud.Properties)
        tgtparas = f_getparas(ud.Handle);
    else
        tgtparas = ud.Properties;
    end
    for i=1:numel(tgtblks)
        thisparas=f_getparas(tgtblks(i));
        sameparas=intersect(thisparas,tgtparas);
        sameparavals = cell(1,numel(sameparas));
        for j=1:numel(sameparas)
            sameparavals{j}=get_param(ud.Handle, sameparas{j});
        end
        tmppairs = [sameparas, sameparavals']'; % must be [2, N] in size
        try
            actrec.SetParamHighlight(tgtblks(i),tmppairs{:});
        end
    end
end
if strcmp(get(handles.mi_fmt_color, 'Checked'), 'on')
    for i=1:numel(tgtblks)
        actrec.SetParam(tgtblks(i), ...
            'ForegroundColor', get_param(ud.Handle, 'ForegroundColor'), ...
            'BackgroundColor', get_param(ud.Handle, 'BackgroundColor'));
    end
end
if strcmp(get(handles.mi_fmt_size, 'Checked'), 'on')
    refpos = get_param(ud.Handle, 'Position');
    WH = refpos(3:4) - refpos(1:2);
    for i=1:numel(tgtblks)
        tmppos = get_param(tgtblks(i), 'Position');
        newpos = [tmppos(1:2), tmppos(1:2)+WH];
        actrec.SetParam(tgtblks(i), 'Position',newpos);
    end
end
if strcmp(get(handles.mi_fmt_anno, 'Checked'), 'on')
    for i=1:numel(tgtblks)
        actrec.SetParam(tgtblks(i), ...
            'AttributesFormatString', get_param(ud.Handle, 'AttributesFormatString'));
    end
end
end

function actrec = fmtbrush_multibrush(hObject, handles)
actrec=saRecorder;
ud = get(hObject, 'UserData');
tgtblks = saFindSystem(gcs,'block');
tgtlns = saFindSystem(gcs,'line');
tgtobjs = [tgtblks; tgtlns];
for i=1:numel(tgtobjs)
    btobj = handles.Console.MapTo(tgtobjs(i));
    majprop = btobj.GetMajorProperty;
    if ~isempty(majprop)
        actrec.SetParamHighlight(tgtobjs(i), majprop, ud.MultiValues{min(i,end)});
    end
end
end


% --------------------------------------------------------------------
function mi_fmtbrushlock_Callback(hObject, eventdata, handles)
% hObject    handle to mi_fmtbrushlock (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tmp={'on','off'};
chk=setdiff(tmp,get(hObject,'Checked'));
set(hObject,'Checked',chk{1});
end


% --------------------------------------------------------------------
function mi_dictrename_sf_Callback(hObject, eventdata, handles)
% hObject    handle to mi_dictrename_sf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if strcmp(get(hObject,'Checked'), 'on')
    set(hObject,'Checked','off');
    set(handles.btn_refine_name, 'String','A-A''');
else
    set(hObject,'Checked','on');
    set(handles.btn_refine_name, 'String','S-S''');
end
end

% --------------------------------------------------------------------
function menu_dictrename_Callback(hObject, eventdata, handles)
% hObject    handle to menu_dictrename (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end


% --------------------------------------------------------------------
function mi_checkstatus_Callback(hObject, eventdata, handles)
% hObject    handle to mi_fmt_dlgpara (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if strcmp(get(hObject, 'Checked'), 'off')
    set(hObject, 'Checked', 'on');
else
    set(hObject, 'Checked', 'off');
end
end
