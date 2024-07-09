function fRMSE = CalRMSE(vData_1,vData_2)

    fRMSE = sqrt(mean((vData_1-vData_2).^2)); 

end