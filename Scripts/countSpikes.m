subj = [2000, 2001, 2002, 2003, 2004, 2005];

spikeCount = zeros(9,6);

for jj = 1:length(subj)
    for ii = 1:9
        currText = textread(['Z:\MA-MRI\MAMRI',int2str(subj(jj)),'\MAMRI_func\Run0',int2str(ii),'\MAMRI', int2str(subj(jj)), '_MAMRI_Run0', int2str(ii),'_spikes.txt']);
        spikeCount(ii, jj) = size(currText,2) - 1;
        
    end
    spikeCount(10, jj) = mean(spikeCount(1:9,jj));
end


