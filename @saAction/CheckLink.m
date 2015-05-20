function CheckLink(obj)
% CURRENTLY NOT USED

tmp_h=get_param(obj.Handle,'Parent');
%If in a library link, first disable it
if strcmpi(get_param(tmp_h,'Type'),'block')&&strcmpi(get_param(tmp_h,'LinkStatus'),'resolved')%
    set_param(tmp_h,'LinkStatus','inactive');
    warndlg(['Caution! Modifying inside a library link.',char(10),'Link disabled.']);
elseif strcmpi(get_param(tmp_h,'Type'),'block')&&strcmpi(get_param(tmp_h,'LinkStatus'),'implicit')%
    while strcmpi(get_param(tmp_h,'LinkStatus'),'implicit')
        tmp_h=get_param(tmp_h,'Parent');
        if strcmpi(get_param(tmp_h,'LinkStatus'),'resolved')
            set_param(tmp_h,'LinkStatus','inactive');
            warndlg(['Caution! Modifying inside a library link.',char(10),'Link disabled.']);
        end
    end
else
end
end