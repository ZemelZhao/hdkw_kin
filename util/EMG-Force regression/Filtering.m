function vEMG = Filtering(vEMG_Raw,bIfBandPassFilter,vFilterParameter_BandPass,bIfCombFilter,vFilterParameter_Comb,bIfSpaceFilter,vFilterParameter_Space,fSamp)

if(bIfBandPassFilter==true)
    vEMG = Filtering_BandPass(vEMG_Raw, vFilterParameter_BandPass.iButterOrder, vFilterParameter_BandPass.vFrequencyInterval, fSamp);
end

if(bIfCombFilter==true)
    vEMG = Filtering_Comb(vEMG, vFilterParameter_Comb.vFrequencyList, vFilterParameter_Comb.fFilterQ, fSamp);
end

if(bIfSpaceFilter==true)
    vEMG = Filtering_Space(vEMG, vFilterParameter_Space.vFilter, vFilterParameter_Space.vStep); 
end

end