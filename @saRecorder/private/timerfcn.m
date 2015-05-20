function timerfcn(src,eventdata,hblk,oldcolor,oldannotation)
set_param(hblk,'ForegroundColor',oldcolor);
set_param(hblk,'AttributesFormatString',oldannotation);
stop(src);
delete(src);
end