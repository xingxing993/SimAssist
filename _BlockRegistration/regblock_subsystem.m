function sabt = regblock_subsystem
%REGBLK_SUBSYSTEM
% Registration of SubSystem block type in SimAssist

sabt = saBlock('SubSystem');
ssproto = regprotoblock_subsystem;
sabt.UseProto(ssproto);
end