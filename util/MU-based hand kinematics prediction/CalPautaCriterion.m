function fPautaCriterion=CalPautaCriterion(vData)

fMean = mean(abs(vData));
fStd = std(abs(vData));

fPautaCriterion = length(find(vData>=fMean-3*fStd & vData<=fMean+3*fStd))/length(vData);

end