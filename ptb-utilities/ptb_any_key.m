function ptb_any_key(resp_device)
if nargin<1, resp_device = -1; end
oldkey = RestrictKeysForKbCheck([]);
KbPressWait(resp_device); 
RestrictKeysForKbCheck(oldkey);
end