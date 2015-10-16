function actrec = RunCommand(obj, rawcmdstr)

actrec = saRecorder;
cmdstr = rawcmdstr;
if isempty(rawcmdstr)
    return;
end

%% PRE-PROCESS OF COMMAND STRING
% initialize session parameters
obj.SessionPara = struct;
% Some commonly used options for command execution
% ######SESSION PARAMETER, EFFCTIVE ONLY IN CURRET SESSION #################
% >> test Color option
testpattern = '(?!^)\s*([+-])c\s*';
regtmp = regexp(cmdstr, testpattern, 'tokens', 'once');
if ~isempty(regtmp)
    if regtmp{1} == '+'
        obj.SessionPara.Color = true;
    else
        obj.SessionPara.Color = false;
    end
    cmdstr = regexprep(cmdstr, testpattern, '', 'once');
end

% >> test Annotation option
testpattern = '(?!^)\s*([+-])a\s*';
regtmp = regexp(cmdstr, testpattern, 'tokens', 'once');
if ~isempty(regtmp)
    if regtmp{1} == '+'
        obj.SessionPara.Annotation = true;
    else
        obj.SessionPara.Annotation = false;
    end
    cmdstr = regexprep(cmdstr, testpattern, '', 'once');
end

% >> test AutoDataType option
testpattern = '(?!^)\s*([+-])dt\s*';
regtmp = regexp(cmdstr, testpattern, 'tokens', 'once');
if ~isempty(regtmp)
    if regtmp{1} == '+'
        obj.SessionPara.AutoDataType = true;
    else
        obj.SessionPara.AutoDataType = false;
    end
    cmdstr = regexprep(cmdstr, testpattern, '', 'once');
end

% >> test explicit data type :datatypestr
testpattern  = '\s*:(\w*)\s*';
%(single|sgl|double|dbl|boolean|bool|uint8|u8|uint16|u16|uint32|u32|int8|i8|int16|i16|int32|i32)
regtmp = regexp(cmdstr, testpattern, 'tokens','once');
if ~isempty(regtmp)
    session_dt = saStandardDataTypeStr(regtmp{1});% convert to standard string
    obj.SessionPara.DataType = session_dt;
    cmdstr = regexprep(cmdstr, testpattern, '', 'once');
end

% >> test Inport/Outport side specification ([])
cnnt_side = [true, true];
[obj.SessionPara.ConnectSide, cmdstr] = determine_cnnt_side(cnnt_side, cmdstr);

% >> test suffix with *N
testpattern  = '\*\s*(\d+)$';
regtmp = regexp(cmdstr, testpattern, 'tokens','once');
if ~isempty(regtmp)
    nmulti = str2double(regtmp{1});
    obj.SessionPara.MultiSuffix = nmulti;
    tmpcmdstr = regexprep(cmdstr, testpattern, '', 'once');
    if isempty(tmpcmdstr) % if given only *N form, shall not be recognized as cmdstr*N pattern
        nmulti = 1;
    else
        cmdstr = tmpcmdstr;
    end
else
    nmulti = 1;
end

% ###### PERSISTENT SESSION PARAMETER SHALL BE STORED INTO RUNOPTION #################
flds = fieldnames(obj.RunOption);
for i=1:numel(flds)
    if isfield(obj.SessionPara, flds{i})
        obj.RunOption.(flds{i}) = obj.SessionPara.(flds{i});
    end
end


%% RUN
for i=1:nmulti
    obj.SessionPara.IndexOfMulti = i;
    if isempty(strtrim(cmdstr))
        return;
    else
        % replace '#clipboard, #cp keyword'
        cmdstr = regexprep(cmdstr, '#(clip|clipboard|cb)', get_clipboard);
    end
    submacros = obj.Macros.MatchPattern(cmdstr);
    if numel(submacros)>0
        [actrec, success] = submacros.Run(cmdstr);
    else
        success = false;
    end
    if ~success
        [actrec, success] = Routines.majorprop_value(obj.MapTo('Constant'), cmdstr, '');
        return;
    end
end
end



%%  ########## BEGIN OF SUB-FUNCTIONS
function [cnnt_side, cmdstr] = determine_cnnt_side(cnnt_side, cmdstr)
b1 = any(cmdstr=='[');
b2 = any(cmdstr==']');
if b1 && ~b2
    cnnt_side(2) = false;
elseif b2 && ~b1
    cnnt_side(1) = false;
else
end
cmdstr = regexprep(cmdstr, '\[|\]', '');
end

function str = get_clipboard
rawstr = clipboard('paste');
if isempty(rawstr)
    str='';return;
end
str = regexprep(rawstr, '\n+', ',');
if str(end)==','
    str(end)=[];
end
end