function [actrec, blkhdl] = AddBlock(obj, varargin)
% [actrec, blkhdl] = obj.AddBlock % add block to current system using default name (block type)
% [actrec, blkhdl] = obj.AddBlock('blkname') % add block to current system use defaults
% [actrec, blkhdl] = obj.AddBlock('blkname', [W,H]) % add to current system with given Width and Height at mouse position 
% [actrec, blkhdl] = obj.AddBlock('blkname', xy0, [W,H]) % add to current system with given Width and Height at specified left-top position xy0
% [actrec, blkhdl] = obj.AddBlock('system/blkname', [W,H]) % manually specifies block path instead of current system
% [actrec, blkhdl] = obj.AddBlock(PROP1, VAL1, PROP2, VAL2, ...) %overrides default parameters
% [actrec, blkhdl] = obj.AddBlock('blkname', PROP1, VAL1, PROP2, VAL2, ...) %overrides default parameters
% [actrec, blkhdl] = obj.AddBlock('blkname', [W,H], PROP1, VAL1, PROP2, VAL2, ...) %overrides default parameters
% [actrec, blkhdl] = obj.AddBlock('blkname', [L,T,R,B], PROP1, VAL1, PROP2, VAL2, ...) % manually specify block position instead of mouse position
% [actrec, blkhdl] = obj.AddBlock('blkname', PROP1, VAL1, ... PROPN, VALN, POSTFUN) % specifies post function instead of the default
% [actrec, blkhdl] = obj.AddBlock('blkname',OPTSTRUCT, PROP1, VAL1, ... ) %
% uses customized options to control: AutoSize/Color/Refine, etc. 
% order of different types of input arguments is generally insignificant,
% but argumetns with same type shall be guaranteed


actrec = saRecorder;
if isempty(obj.SourcePath)
    return;
end
% Input parameter parsing
%  - If second argument given with block size (numeric or function handle), the it will overrides
% the defaults
%  - The last parameter can be a function handle that overrides the default one
i_strarg = cellfun(@isstr, varargin);
argstr = varargin(i_strarg);
argnstr = varargin(~i_strarg);

if logical(rem(numel(argstr),2)) %odd number of string input, shall be "blkname +2*{PROP,VAL} pair form"
    dst = argstr{1};
    ovrdprops = argstr(2:end);
else
    dst = get_param(obj.GetSourcePath, 'Name');
    ovrdprops = argstr;
end

argnumeric = argnstr(cellfun(@isnumeric, argnstr));
if isempty(argnumeric)
    xy0 = saGetMousePosition;
    blksize = obj.GetBlockSize;
    pos = [xy0, xy0+blksize];
elseif numel(argnumeric)==1
    if numel(argnumeric{1})==4 % given [L T R B] form 
        pos = argnumeric{1};
        blksize = pos(3:4)-pos(1:2);
    else % given only size [W, H]
        xy0 = saGetMousePosition;
        blksize = argnumeric{1};
        pos = [xy0, xy0+blksize];
    end
else
    xy0 = argnumeric{1};
    blksize = argnumeric{2};
    pos = [xy0, xy0+blksize];
end

% in case of multi-execution, add offset
if ~isempty(obj.Console) && isfield(obj.Console.SessionPara, 'IndexOfMulti')
    imulti = obj.Console.SessionPara.IndexOfMulti;
else
    imulti = 1;
end
offset = (imulti-1)*[0, (blksize(2)+obj.LayoutSize.VerticalMargin)];
pos = pos + [offset, offset];


argfh = argnstr(cellfun(@(c)isa(c, 'function_handle'), argnstr));
if isempty(argfh)
    postfun = obj.PostAddMethod;
else
    postfun = argfh{1};
end

% if dst given with no Simulink path seperator "/", shall be added to current system
if isempty(strfind(dst, '/'))
    dst = [gcs, '/', dst];
end
% if src given with no Simulink path seperator "/", shall be the built-in
src = obj.GetSourcePath;


sa = saAction('add_block', src, dst,...
    'Position', pos,...
    'ShowName',obj.BlockPreferOption.ShowName,'Selected',obj.BlockPreferOption.Selected,...
    obj.DefaultParameters{:},...
    ovrdprops{:});

actrec.PushItem(sa);
blkhdl = sa.Handle;

if ~isempty(postfun)
    if nargout(postfun)>0
        actrec.Merge(postfun(blkhdl));
    else
        postfun(blkhdl);
    end
end

% other subsequent operations
% get option parameter
option = override_option(argnstr, obj);
actrec + obj.Adapt(blkhdl, option);
end

