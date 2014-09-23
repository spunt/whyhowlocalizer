function device = hid_get(usageName,product)

d=PsychHID('Devices');
u = cellfun(@mean,strfind({d.usageName},usageName));
p = cellfun(@mean,strfind({d.product},product));
device = find(~isnan(u) & ~isnan(p));
    
   