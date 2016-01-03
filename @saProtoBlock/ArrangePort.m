function actrec = ArrangePort(obj, blkhdl, varargin)
actrec = saRecorder;
if ~(iscell(obj.ArrangePortMethod) && numel(obj.ArrangePortMethod)==2)
    return;
end
if ~isempty(obj.Console)
    side = obj.Console.SessionPara.ConnectSide;
else
    side = [true, true];
end
if side(1)
    actrec + arrange_inport(obj, blkhdl, varargin{:});
end
if side(2)
    actrec + arrange_outport(obj, blkhdl, varargin{:});
end
end

% sub-function inport
function actrec = arrange_inport(obj, blkhdl, varargin)
actrec = saRecorder;
arrangemethod = obj.ArrangePortMethod{1}; 
if isempty(arrangemethod)
    return;
else
    if isequal(arrangemethod, 1)
        actrec + arrange_even_inports(blkhdl);
    elseif isa(arrangemethod, 'function_handle')
        nn = nargout(arrangemethod);
        ni = nargin(arrangemethod);
        argsin = {blkhdl, varargin{:}};
        if nn~=0 %if mandatory output exist, must be saRecorder
            actrec.Merge(arrangemethod(argsin{1:ni}));
        else
            arrangemethod(argsin{1:ni});
        end
    else
    end
end
end

% sub-function outport
function actrec = arrange_outport(obj, blkhdl, varargin)
actrec = saRecorder;
arrangemethod = obj.ArrangePortMethod{2}; 
if isempty(arrangemethod)
    return;
else
    if isequal(arrangemethod, 1)
    elseif isa(arrangemethod, 'function_handle')
        nn = nargout(arrangemethod);
        ni = nargin(arrangemethod);
        argsin = {blkhdl, varargin{:}};
        if nn~=0 %if mandatory output exist, must be saRecorder
            actrec.Merge(arrangemethod(argsin{1:ni}));
        else
            arrangemethod(argsin{1:ni});
        end
    else
    end
end
end

%% PREDIFINED PORT ARRANGE FUNCTIONS
% ## Predefined inport arrange method #1: even inports
function actrec = arrange_even_inports(blkhdl)
actrec = saRecorder;
rtsys = get_param(blkhdl,'Parent');
pthdls=get_param(blkhdl,'PortHandles');
lnhdls=get_param(blkhdl,'LineHandles');lnhdls = lnhdls.Inport;
reroutelines = [];
for l=1:numel(lnhdls)
    if lnhdls(l)<0
        continue;
    elseif get_param(lnhdls(l), 'SrcPortHandle')<0
        actrec.DeleteLine(lnhdls(l));
    else
        tmpline.Handle = lnhdls(l);
        tmpline.SrcPortHandle = get_param(lnhdls(l), 'SrcPortHandle');
        tmpline.Name = get_param(lnhdls(l), 'Name');
        tmpline.SrcPoint = get_param(tmpline.SrcPortHandle, 'Position');
        reroutelines = [reroutelines; tmpline];
        actrec.DeleteLine(lnhdls(l));
    end
end
% sort by start point position
if ~isempty(reroutelines)
    y_srcpt = [reroutelines.SrcPoint];
    y_srcpt = y_srcpt(2:2:end);
    [tmp, iorder] = sort(y_srcpt);
    reroutelines = reroutelines(iorder);
    for l=1:numel(reroutelines)
        actrec.AddLine(rtsys, reroutelines(l).SrcPortHandle, pthdls.Inport(l),reroutelines(l).Name);
    end
end
end