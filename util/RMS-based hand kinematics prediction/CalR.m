function fR = CalR(vData_1,vData_2)

    vR = corrcoef(vData_1,vData_2); 
    fR = vR(1,2);
    
end