function actrec = Color(obj, blkhdl, colorspec)
% Depends on ColorMethod of saBlock
% ColorMethod can be the following types:
%  2-element cell array: {1}: ForegroundColor, {2}:BackgroundColor
% if not cell, then by default indicates the foreground color:
% -1 : use random color
% [R G B]: numeric 3-element array
% 'string' : e.g., 'red', 'blue', '[0.6 0.3 0.9]'
% @function_handle : customize way of coloring the block
actrec = saRecorder;
if nargin<3
    color_method = obj.ColorMethod;
else
    color_method = colorspec;
end
if isempty(color_method)
    return;
else
    if iscell(color_method)
        actrec + set_color(color_method{1}, blkhdl, 'ForegroundColor');
        actrec + set_color(color_method{2}, blkhdl, 'BackgroundColor');
    else
        actrec + set_color(color_method, blkhdl, 'ForegroundColor');
    end
end

end


function actrec = set_color(colorspec, blkhdl, fbprop)
if nargin<3
    fbprop = 'ForegroundColor';
end
actrec = saRecorder;
if isempty(colorspec) || (isscalar(colorspec)&&~colorspec)
    return;
elseif isstr(colorspec)
    actrec.SetParam(blkhdl, fbprop, colorspec);
else
    if isnumeric(colorspec)
        if numel(colorspec)==3
            actrec.SetParam(blkhdl, fbprop, mat2str(colorspec));
        elseif colorspec < 0
            actrec.SetParam(blkhdl, fbprop, mat2str(rand(1,3)));
        else
        end
    elseif isa(colorspec, 'function_handle')
        nn = nargout(colorspec);
        if nn~=0 %if mandatory output exist, must be saRecorder
            actrec.Merge(colorspec(blkhdl));
        else
            colorspec(blkhdl);
        end
    else
    end
end
end