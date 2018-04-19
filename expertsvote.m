%% run votes
function [seq] = expertsvote(ngram, txt, n)
    len = strlength(txt);
    votingmat = zeros(1,len);
    for i = 1:len
        j = frequencyexp(ngram,txt,i,n);
        votingmat(j) = votingmat(j) +1;
        j = entropyexp(ngram,txt,i,n);
        votingmat(j) = votingmat(j) +1;
    end
    seq = segregate(txt,votingmat,n);
end

%% Frequency expert
function [index] = frequencyexp(ngram,txt,i,n)
    num = getnumbers(ngram,txt,i,n,2);
    num = abs(num - mean(num))/std(num);
    [~, index] = max(num);
    index = index + i -1;
end

%% Entropy exp
function [index] = entropyexp(ngram,txt,i,n)
    num = getnumbers(ngram,txt,i,n,3);
    num = abs(num - mean(num))/std(num);
    [~, index] = max(num);
    index = index + i -1;
end

%% Get the numbers to normalize
function [numb] = getnumbers(ngram,txt,i,n,fore)
    ind = 1;
    if(n+i-1 > strlength(txt))
       n = strlength(txt) - i + 1 ;
    end
    numb = zeros(n);
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
function [rettxt] = segregate(txt,votingmat,n)
    mat = [];
    for i = 1 : strlength(txt)
        [val, j] = max(votingmat( i : min(i+n-1, strlength(txt)-i+1)));
        if(val >= 3)
           mat = [mat, i+j-1];
        end
    end
    mat = unique(mat);
    rettxt=txt;
    for i = 1:length(mat)
       rettxt = insertAfter(rettxt,mat(i),' ');
       mat = mat + 1;
    end
end