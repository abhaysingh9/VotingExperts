%% Build the n gram tree for the given sequence of text
function [ngtree] = buildngramtree(txt,n)
    ngtree = tree;
    for i = 1 : strlength(txt)
        flag = exists(txt(i),ngtree,1);
        if(~flag)
            node = [txt(i) , {count(txt,txt(i))},{1},{0}];
            ngtree = ngtree.addnode(1,node);
        end
        index = getindex(txt(i),ngtree,1);
        for j = 2 : min(n,strlength(txt)-i+1)
            flagsub = exists(txt(j+i-1),ngtree,index);
            if(~flagsub)
                node = [txt(i+j-1) , {count(txt,txt(i:i+j-1))},{j},{0}];
                ngtree = ngtree.addnode(index,node);
            end
            index = getindex(txt(i+j-1),ngtree, index);
        end
    end
    ngtree = entr(ngtree,n);
end


%% check if the current element exists on 1st level(child of root)
function [flag] = exists(check, ngtree,ind)
    children = ngtree.getchildren(ind);
    flag = false;
        for i = 1:length(children)
            child = ngtree.get(children(i));
            if(child{1} == check)
                flag = true;
            end
        end
end

%% the current element's index
function [index] = getindex(check,ngtree,ind)
    children = ngtree.getchildren(ind);
    index = false;
    for i = 1:length(children)
        child = ngtree.get(children(i));
        if(child{1} == check)
            index = children(i);
        end
    end
end

%% compute entropy
function [ngtre] = entr(ngtree,n)
    it = ngtree.breadthfirstiterator;    
    for i = length(it):-1:2
        current = ngtree.get(it(i));
        if(ngtree.getparent(it(i))~=1)
            parent = ngtree.get(ngtree.getparent(it(i)));
            parent{4} = parent{4} - log2(current{2}/parent{2})*current{2}/parent{2};
            ngtree = ngtree.set(ngtree.getparent(it(i)), parent);
        end
    end
    ngtre = standardize(ngtree,n);
end

%% standardize levelwise
function [ngt] = standardize(ngtree,n)
    children = ngtree.getchildren(1);
    meanvector = zeros(2,n);
    stdvector = zeros(2,n);
    for i = 1:n
        nextlayer = [];
        elements = zeros(2,length(children));
        for j = 1: length(children)
            current = ngtree.get(children(j));
            elements(1,j) = current{2};
            elements(2,j) = current{4};
            nextlayer = [nextlayer, ngtree.getchildren(children(j))];
        end
        meanvector(1,i) = mean(elements(1,:));
        stdvector(1,i) = std(elements(1,:));
        meanvector(2,i) = mean(elements(2,:));
        stdvector(2,i) = std(elements(2,:));
        children = nextlayer;
    end
    it = ngtree.breadthfirstiterator;    
    for i = it
        if(i~=1)
            current = ngtree.get(i);
            lvl = current{3};
            current{2} = abs(current{2} - meanvector(1,lvl))/stdvector(1,lvl);
            current{4} = abs(current{4} - meanvector(2,lvl))/stdvector(2,lvl);
            ngtree = ngtree.set(i,current);
        end
    end
    ngt = ngtree;
end