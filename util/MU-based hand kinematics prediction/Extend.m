function eS = Extend(S,extFact,bar);

[r,c] = size(S);
eS = zeros(r*extFact, c+extFact-1);

if nargin > 2
    h = waitbar(0/(r*extFact),'Extending signals...');
    for k = 1:r
        for m = 1:extFact
            eS((k-1)*extFact+m,:) = [zeros(1,m-1),S(k,:),zeros(1,extFact-m)];
        end
        waitbar((k*extFact)/(r*extFact));
    end
    close(h);
else
    for k = 1:r
        for m = 1:extFact
            eS((k-1)*extFact+m,:) = [zeros(1,m-1),S(k,:),zeros(1,extFact-m)];
            % extend the matrix S to K-1 delayed repetations 
        end
    end
end

