function saLoadLib(libname)
if ~bdIsLoaded(libname)
    bkcs = gcs;
    load_system(libname);
    load_system(bkcs); % restore current system
end
end