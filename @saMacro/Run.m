function [actrec, success] = Run(objarr, cmdstr)
% Try run each macro script until successed
% Note that in macro definition, number of input and output arguments among
% the related functions (GetOptionMethod, ParseOptionMethod, Callback) must
% coordinate
if nargin<2
    cmdstr = '';
end
console = objarr(1).Console;
for i=1:numel(objarr)
    theobj = objarr(i);
    ni = nargin(theobj.Callback);
    if ni>2
        [args{1:ni-2}] = theobj.Parse(cmdstr, console);
    else
        args={};
    end
    arglist = {cmdstr, console, args{:}};
    [actrec, success] = theobj.Callback(arglist{1:ni});
    if success
        break;
    end
end

end