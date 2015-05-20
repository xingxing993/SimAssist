function unlock_library(objhdl)
bd=bdroot(objhdl);
if strcmp(get_param(bd,'Lock'),'on')
    set_param(bd,'Lock','off');
    warndlg(['Caution! Modifying a locked library link.',char(10),'Library unlocked.']);
end
end