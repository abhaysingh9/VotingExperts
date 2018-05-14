%% run votes
function [seq , num] = expertsvote(ngram, txt, n,cutoff)
    len = strlength(txt);
    votingmat = zeros(1,len);
    for i = 1:len
        j = frequencyexp(ngram,txt,i,n);
        votingmat(j) = votingmat(j) +1;
        j = entropyexp(ngram,txt,i,n);
        votingmat(j) = votingmat(j) +1;
    end
    [seq,num] = segregate(txt,votingmat,n,cutoff);
end

%% Frequency expert
function [index] = frequencyexp(ngram,txt,i,n)
    [~, index] = max(getnumbers(ngram,txt,i,n,2));
    index = index + i -1;
end

%% Entropy exp
function [index] = entropyexp(ngram,txt,i,n)
    [~, index] = max(getnumbers(ngram,txt,i,n,4));
    index = index + i -1;
end

%% Get the numbers to normalize
function [numb] = getnumbers(ngram,txt,i,n,fore)
    ind = 1;
    if(n+i-1 > strlength(txt))
       n = strlength(txt) - i + 1 ;
    end
    numb = zeros(1,n);
    for j = 1:n
        childind = ngram.getchildren(ind);
        for k = 1:length(childind)
            child = ngram.get(childind(k));
            if(child{1} == txt(i+j-1))
                ind = childind(k);
                temp = ngram.get(ind);
                numb(j) = temp{fore};
            end
        end
    end
end

%% Insert Spaces
function [rettxt, num] = segregate(txt,votingmat,n,cutoff)
    mat = [];
    for i = 1 : strlength(txt)
        offset = 0;
        if( i+n-1 > strlength(txt) )
            offset = i+n-strlength(txt);
        end
        [val, j] = max(votingmat( i : i + n - 1 - offset));
        if(val >= cutoff)
           mat = [mat, i+j-1];
        end
    end
    mat = unique(mat);
    rettxt=txt;
    for i = 1:length(mat)
       rettxt = insertAfter(rettxt,mat(i),' ');
       mat = mat + 1;
    end
    num = length(mat);
end