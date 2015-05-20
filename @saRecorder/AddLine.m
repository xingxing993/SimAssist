function lnhdl = AddLine(obj, sys, varargin)
% #1: obj.AddLine(sys, points, name);
% #2: obj.AddLine(sys, srcblock, dstblock, name, port_spec);
% #3: obj.AddLine(sys, srcport, dstport, name);
% #4: obj.AddLine(sys, srcport, dstpos, name);
% #5: obj.AddLine(sys, srcpos, dstport, name);
if isempty(sys)
    sys = gcs;
end
arg1sz = size(varargin{1});
if arg1sz(2)==2 && arg1sz(1)>1 %given points format
    sa = saAction('add_line', sys, varargin{:});
else
    [arg1, arg2] = varargin{1:2};
    % given both handle, auto routing mode
    if numel(varargin)>2
        name = varargin{3};
    else
        name='';
    end
    if numel(varargin)>3 %it is possible to specify the port number of connection
        tmp = varargin{4};n1 = tmp(1);n2 = tmp(2);
    else
        n1=1;n2=1;
    end
    mode = 'auto';
    if numel(arg1)==1
        if strcmp(get_param(arg1, 'type'), 'block')
            pts = get_param(arg1, 'PortHandles'); pt1 = pts.Outport(n1);
        else
            pt1 = arg1;
        end
        pos1 = get_param(pt1, 'Position');
    else
        mode = 'points';
        pos1 = arg1;
    end
    if numel(arg2)==1
        if strcmp(get_param(arg2, 'type'), 'block')
            pts = get_param(arg2, 'PortHandles'); pt2 = pts.Inport(n2);
        else
            pt2 = arg2;
        end
        pos2 = get_param(pt2, 'Position');
    else
        mode = 'points';
        pos2 = arg2;
    end
    if strcmp(mode, 'auto')
        %varargin = {sys, pt1, pt2, name*}
        sa = saAction('add_line', sys, pt1, pt2, name);
    else
        if pos1(2)==pos2(2)
            lnpos = [pos1; pos2];
        else
            xmid = ceil((pos1(1)+pos2(1))/2);
            lnpos = [pos1; [xmid, pos1(2)]; [xmid, pos2(2)]; pos2];
        end
        sa = saAction('add_line', sys, lnpos, name);
    end
end
lnhdl = sa.Handle;
obj.PushItem(sa);
end