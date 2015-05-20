function actrec = CreateBroBlock(obj, blkhdl, varargin)
% obj.CreateBroBlock(blkhdl) creates bro-block by default
% obj.CreateBroBlock(blkhdl, cnnttype) creates bro-block of specified type
% obj.CreateBroBlock(blkhdl, cnnttype, PROP1, VAL1, PROP2, VAL2, ...) using the prop-value pairs in when creating
% obj.CreateBroBlock(blkhdl, cnnttype, POSTFUN) suffix with the post-process function handle

actrec = saRecorder;
cr_pair_method = obj.CreateBroBlockMethod;

if isempty(obj.BroBlockType)
    return;
elseif isa(cr_pair_method, 'function_handle')
    nn = nargout(cr_pair_method);
    ni = nargin(cr_pair_method);
    varlist = [blkhdl, varargin];
    if nn~=0 %if mandatory output exist, must be saRecorder
        actrec.Merge(cr_pair_method(varlist{1:ni}));
    else
        cr_pair_method(varlist{1:ni});
    end
else
    % input parsing
    i_strarg = cellfun(@isstr, varargin);
    propvals = varargin(i_strarg);
    i_fh = cellfun(@(c) isa(c, 'function-handle'), varargin);
    postfun = varargin(i_fh);
    i_num = cellfun(@(c) isnumeric(c), varargin);
    cnnttype = varargin(i_num);
    [~, ~, optarg] = override_option(varargin, obj);
    optarg.Color = false;
    optarg.AutoSize = false;
    %use default creation method
    majorval=get_param(blkhdl,obj.GetMajorProperty);
    refpos=get_param(blkhdl,'Position');
    fcolor=get_param(blkhdl,'ForegroundColor');
    bcolor=get_param(blkhdl,'BackgroundColor');
    refsz = refpos(3:4) - refpos(1:2);
    xy0 = refpos(3:4) + ceil([refsz(1)/3, obj.LayoutSize.VerticalMargin]);
    if isempty(cnnttype)
        cnnttype = ~obj.ConnectPort;
    else
        cnnttype = cnnttype{1};
    end
    broblktyps = cellstr(obj.BroBlockType);
    for i=1:numel(broblktyps) % find the target BroBlockType
        brobtobj = obj.Console.MapTo(broblktyps{i});
        if ~any(xor(brobtobj.ConnectPort, cnnttype)) % if match
            actrec + brobtobj.AddBlock(xy0, refsz, optarg, ...
                obj.GetMajorProperty, majorval,...
                'ForegroundColor',fcolor,...
                'BackgroundColor',bcolor,...
                'Selected','on',...
                propvals{:},...
                postfun{:});
            break;
        end
    end
    set_param(blkhdl,'Selected','off');
end
end