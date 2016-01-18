function varargout = saFindSystem(rtsys, type, option, varargin)
if nargin<1 || isempty(rtsys)
    rtsys = gcs;
end
if nargin<2 || isempty(type)
    type = 'all';
end
if nargin<3 || isempty(option)
    option = {'SearchDepth',1,'FollowLinks','on','LookUnderMasks','on','FindAll','on'};
end

switch type
    case 'block'
        hdls=find_system(rtsys,option{:},'Type','block','Selected','on', varargin{:});
        hdls = setdiff(hdls,get_param(rtsys,'Handle'));
    case 'line'
        hdls=find_system(rtsys,option{:},'Type','line','Selected','on', varargin{:});
        hdls = saRemoveBranchLine(hdls);
    case 'block&line'
        lns = saFindSystem(rtsys, 'line');
        blks = saFindSystem(rtsys, 'block');
        hdls = [blks;lns];
    case 'line_unconnected'
        hdls=find_system(rtsys,option{:},'Type','line','Selected','on', 'Connected','off',varargin{:});
        hdls = saRemoveBranchLine(hdls);
    case 'line_nosrc'
        hdls=find_system(rtsys,option{:},'Type','line','Selected','on', 'SrcPortHandle',-1,varargin{:});
        hdls = saRemoveBranchLine(hdls);
    case 'line_nodst'
        hdls=find_system(rtsys,option{:},'Type','line','Selected','on', 'DstPortHandle',-1,varargin{:});
        hdls = saRemoveBranchLine(hdls);
    case 'port_unconnected'
        hdls=find_system(rtsys,option{:},'Type','port','Line',-1,varargin{:});
        hdls = port_filter_selected(hdls);
    case 'inport_unconnected'
        hdls=find_system(rtsys,option{:},'Type','port','Line',-1,'PortType','inport',varargin{:});
        hdls = port_filter_selected(hdls);
    case 'outport_unconnected'
        hdls=find_system(rtsys,option{:},'Type','port','Line',-1,'PortType','outport',varargin{:});
        hdls = port_filter_selected(hdls);
    case 'unconnected'
        hdls1 = saFindSystem(rtsys, 'line_unconncted', option, varargin{:});
        hdls2 = saFindSystem(rtsys, 'port_unconncted', option, varargin{:});
        hdls = [hdls1;hdls2];
    case 'line_receiver'
        uclns = saFindSystem(gcs, 'line_nosrc');
        ucpts = saFindSystem(gcs, 'inport_unconnected');
        hdls = [uclns; ucpts]; % target objects: unconnected ports/lines
    case 'line_sender'
        lns = saFindSystem(rtsys, 'line');
        ucpts = saFindSystem(rtsys, 'outport_unconnected');
        hdls = [lns; ucpts];
    case 'all'
        hdls=find_system(rtsys,'SearchDepth',1,'LookUnderMasks','on','FollowLinks','on','FindAll','on','Selected','on', varargin{:});
        hdls = setdiff(hdls,get_param(rtsys,'Handle'));
    otherwise
end
varargout{1} = hdls;
end


function hdls = port_filter_selected(hdls, rtsys)
%keep only parent block selected and not the current system
if nargin<2
    rtsys = gcs;
end
if isempty(hdls)
    hdls=[];return;
end
parblks = get_param(hdls,'Parent');
if iscell(parblks)
    f1 = strcmp(get_param(parblks,'Selected'),'on');
    f2 = cell2mat(get_param(parblks,'Handle'))~=get_param(rtsys,'Handle');
    hdls = hdls(f1 & f2);
else % only one
    if strcmp(get_param(parblks,'Selected'),'on') &&...
       (get_param(parblks,'Handle')~=get_param(rtsys,'Handle'))
    else
        hdls=[];
    end
end
end