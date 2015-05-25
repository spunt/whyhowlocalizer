load design.mat
load german_cues.mat
ref = english2german;
ref.preblockcues = strtrim(ref.preblockcues); 
ref.isicues = strtrim(ref.isicues); 
for i = 1:length(alldesign)
   d = alldesign{i};
   for s = 1:size(d.preblockcues, 1)
        idx                 = find(strcmpi(ref.preblockcues(:,1), d.preblockcues{s})); 
        idx2                = find(strcmpi(d.qim(:,1), d.preblockcues{s}));         
        d.preblockcues{s}   = ref.preblockcues{idx, 2};
        d.isicues{s}        = ref.isicues{idx, 2};
        d.qim(idx2, 1)      = ref.preblockcues(idx, 2); 
   end
   alldesign{i} = d;
   clear d; 
end
save german_design.mat alldesign