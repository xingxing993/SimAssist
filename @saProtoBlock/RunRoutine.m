function [actrec, success, varargout] = RunRoutine(btobj, varargin)
console = btobj.Console;
if ismember(varargin{1}, {'nooptstr','value_only','value_num','multiprop','dynamicinport'})
    routine = varargin{1};
    varargin = varargin(2:end);
else
    if ~isempty(btobj.RoutineType)
        routine = btobj.RoutineType;
    else
        if isempty(btobj.MajorProperty)
            routine = 'nooptstr'
        else
            routine = 'value_only'; % default
        end
    end
end
switch routine
    case 'nooptstr'
        [actrec, success] = routine_nooptstr(btobj, varargin{:});
    case {'value_only','value_num'}
        % [optstr, (tgtprop_or_pvpair)] = varargin{1:2};
        [actrec, success] = routine_value_num(btobj, routine, varargin{:});
    case 'multiprop'
        % [optstr] = varargin{1};
        [actrec, success] = routine_multiprop(btobj, varargin{:});
    case 'dynamicinport'
        % [optstr, inportprop, pvpair] = varargin{1:3};
        [actrec, success] = routine_dynamicinport(btobj, varargin{:});
    otherwise
        actrec = saRecorder;
        success = false;
end
end


%%
function [actrec, success] = routine_nooptstr(btobj, pvpair)
actrec = saRecorder; success = false;
console = btobj.Console;
if nargin<2
    pvpair = {};
end
option = struct;
actrec + routine_generic_add(btobj, [], pvpair, option);
success = true;
end

%%
function [actrec, success] = routine_dynamicinport(btobj, optstr, inportprop, pvpair)
actrec = saRecorder; success = false;
if nargin<4
    pvpair = {};
end
console = btobj.Console;
optstr = strtrim(optstr);
if isempty(optstr)
    tgtobjs = saFindSystem(gcs,'line_sender');
    if isempty(tgtobjs)
        autoline = false;
    else
        numipt = int2str(numel(tgtobjs));
        pvpair = [pvpair, inportprop, numipt];
        autoline = true;
    end
    [actrec2, block] = btobj.AddBlock(pvpair{:});
    actrec + actrec2;
    if autoline
        actrec.MultiAutoLine(tgtobjs, block);
    end
    success = true;
else
    numipt=optstr;
    remstr = regexprep(numipt, '\d+', '');
    if ~isempty(remstr) % if optstr not all number characters
        success = false; return;
    end 
    actrec + btobj.AddBlock(pvpair{:}, inportprop, numipt);
    success = true;
end
end


%%
function [actrec, success] = routine_multiprop(btobj, optstr)
% btobj.MajorProperty = {'PROP1','_SUFFIX1'; 'PROP2','_SUFFIX2'; 'PROP3','_SUFFIX3'}
% note that _SUFFIXN can be a function handle takes the basic string as input
actrec = saRecorder; success = false;
console = btobj.Console;
propdef = btobj.MajorProperty;
vals = saParseOptionStr('values', optstr);
pvpair = {};option = struct;
if isempty(vals)
elseif numel(vals)==1
    for i=1:size(propdef,1)
        if isstr(propdef{i,2})
            pvpair = [pvpair, propdef{i,1}, strcat(vals{1}, propdef{i,2})];
        else
            fh = propdef{i,2};
            pvpair = [pvpair, propdef{i,1}, fh(vals{1})];
        end
    end
    option.PropagateString = false; % turn off propagate behaviour to avoid override
else
    for i=1:numel(vals)
        pvpair = [pvpair, propdef{i,1}, vals{i}];
    end
    option.PropagateString = false; % turn off propagate behaviour to avoid override
end
actrec + routine_generic_add(btobj, [], pvpair, option);
success = true;
end


%%
function [actrec, success] = routine_value_num(btobj, opttype, optstr, tgtprop_or_pvpair)
% optstr: option part of optstr
% opttype: see function saParseOptionStr
% tgtprop: target property to set the value, if not given, use major property
actrec = saRecorder; success = false;
majprop = btobj.GetMajorProperty;
console = btobj.Console;
if nargin<4
    tgtprop = majprop;
    pvpair = {};
else
    if iscell(tgtprop_or_pvpair)
        tgtprop = majprop;
        pvpair = tgtprop_or_pvpair;
    else
        tgtprop = tgtprop_or_pvpair;
        pvpair = {};
    end
end
[val, num] = saParseOptionStr(opttype, optstr);
if ~isempty(val) && ~isempty(tgtprop)
    pvpair = [pvpair, tgtprop, val];
    option.PropagateString = false; % turn off propagate behaviour to avoid override
else
    option = struct;
end
actrec + routine_generic_add(btobj, num, pvpair, option);
success = true;
end


%% BASIC SUB-FUNCTION
function actrec = routine_generic_add(btobj, blknum, pvpair, option)
% Batch function for block types that share the following inherent gene:
% - can be used as sink/source block
console = btobj.Console;
actrec = saRecorder;
if nargin<4
    option = struct;
end
if nargin<3
    pvpair = {};
end
if ~isempty(console) && isfield(console.SessionPara, 'ConnectSide')
    cnnt_type = [btobj.ConnectPort & fliplr(console.SessionPara.ConnectSide)];
else
    cnnt_type = btobj.ConnectPort;
end
% do the job
if ~isempty(blknum)
    actrec + btobj.AddBlockArray(option, blknum, pvpair{:});
else
    % prepare Selection info
    seladd = false;
    if cnnt_type(1) && cnnt_type(2)
        tgtlns = saFindSystem(gcs, 'line');
        tgtipts = saFindSystem(gcs, 'inport_unconnected');
        tgtopts = saFindSystem(gcs, 'outport_unconnected');
        if ~isempty(tgtlns)
            seladd = true;
            for k=1:numel(tgtlns)
                actrec + btobj.InsertBlockToLine(tgtlns(k),pvpair{:});
            end
        end
        if ~isempty(tgtopts)
            seladd = true;
            actrec + btobj.Terminates(tgtopts, option, pvpair{:});
        end
        if ~isempty(tgtipts)
            seladd = true;
            actrec + btobj.Grounds(tgtipts, option, pvpair{:});
        end
    elseif cnnt_type(1)
        tgtobjs_src = saFindSystem(gcs, 'line_sender');
        if ~isempty(tgtobjs_src)
            seladd = true;
            actrec + btobj.Terminates(tgtobjs_src, option, pvpair{:});
        end
    elseif cnnt_type(2)
        tgtobjs_recv = saFindSystem(gcs, 'line_receiver');
        if ~isempty(tgtobjs_recv)
            seladd = true;
            actrec + btobj.Grounds(tgtobjs_recv, option, pvpair{:});
        end
    end
    if ~seladd% if no selection, add single block
        actrec + btobj.AddBlock(option, pvpair{:});
    end
end
end