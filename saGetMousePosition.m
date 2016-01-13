function pos = saGetMousePosition
mousePosition = get(0,'PointerLocation');
locationBase = get_param(gcs,'Location'); % Screen Left-Top [0 0], and always gets valid value on different screens
scrollOffset = get_param(gcs,'ScrollbarOffset');
screenSize   = get(0,'ScreenSize');
zoomFactor = str2double(get_param(gcs, 'ZoomFactor'))/100;
% Calculate new position
p_X = ceil((mousePosition(1) - locationBase(1) + scrollOffset(1))/zoomFactor);
p_Y = ceil((screenSize(4) - mousePosition(2) - locationBase(2) + scrollOffset(2))/zoomFactor);
pos = [p_X, p_Y];
end