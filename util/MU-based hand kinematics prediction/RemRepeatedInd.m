function NewPulseInd = RemRepeatedInd(PulseSeq,PulseInd,limit)

r = length(PulseInd);
PulseInd = sort(PulseInd);
tmp = zeros(1,length(PulseInd));
NewPulseInd = tmp;
pulse_step = 1;
NewPulseInd(1) = -inf;

if (r<2)
    NewPulseInd = PulseInd;
    return 
end 

k = 1;
while k < r
    while (k<r && (PulseInd(k)-NewPulseInd(pulse_step))<limit)    % find the first position
        k = k+1;
    end 
    first = k;
    tmp_step = 1;
    tmp(tmp_step) = PulseSeq(PulseInd(k));
    while (k<r && (PulseInd(k+1)-PulseInd(first))<limit)
        tmp_step = tmp_step+1;
        tmp(tmp_step) = PulseSeq(PulseInd(k+1));
        k = k+1;
    end 
    [~,i] = max(tmp(1:tmp_step));
    pulse_step = pulse_step+1;
    NewPulseInd(pulse_step) = PulseInd(first-1+i);
    k = k+1;
end 

if (PulseInd(end)-PulseInd(end-1)>limit)
    pulse_step = pulse_step+1;
    NewPulseInd(pulse_step) = PulseInd(end);
end 
NewPulseInd = NewPulseInd(2:pulse_step);  % the index is the array number