function [accuracy] = findaccuracy(strchk,strorg,spaces)
    count = 0;
    offseto =0;
    offsetc =0;
    i=1;
    strchk = strtrim(strchk);
    strorg = strtrim(strorg);
    while ((i+offseto<strlength(strorg)) && (i+offsetc<strlength(strchk)))
        if(strorg(i+offseto) == ' ' && strchk(i+offsetc) == ' ')
           count = count+1; 
        elseif(strorg(i+offseto) == ' ' && strchk(i+offsetc) ~= ' ')
           offseto = offseto + 1;
        elseif(strorg(i+offseto) ~= ' ' && strchk(i+offsetc) == ' ')
           offsetc = offsetc + 1;
        end
        i = i+1;
    end
    Truepositives = count;
    falsepositives = spaces-count;
    accuracy = count /spaces;
end