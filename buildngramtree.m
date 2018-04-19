%% Build the n gram tree for the given sequence of text
function [ngtree] = buildngramtree(txt,n)
    ngtree = tree;
    for i = 1 : strlength(txt)
        countfirst =  count(txt,txt(i));
        flag = exists(txt(i),ngtree,1);
        if(~flag)
            ent = count(txt,txt(i))/countfirst;
            
            node = [txt(i) , {count(txt,txt(i))} , {ent} ];
            ngtree = ngtree.addnode(1,node);
        end
        entnode = ngtree.get(getindex(txt(i),ngtree,1));
        ent = entnode{3};
        index = getindex(txt(i),ngtree,1);
        
        for j = 2 : min(n,strlength(txt)-i+1)
            flagsub = exists(txt(j+i-1),ngtree,index);
            if(~flagsub)
                ent = ent * count(txt,txt(i:i+j-1));
                node = [txt(i+j-1) , {count(txt,txt(i:i+j-1))}, {ent} ];
                ngtree = ngtree.addnode(index,node);
            end
            index = getindex(txt(i+j-1),ngtree, index);
        end
    end
    ngtree.tostring;
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