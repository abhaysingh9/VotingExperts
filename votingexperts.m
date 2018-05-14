%% Discrete data voting experts
function [segregated] = votingexperts(input,checking,n,cutoff)
txt = char(lower(importdata(input)));
txtchk = char(lower(importdata(checking)));
ngramtree = buildngramtree(txt,n);
[segregated,num] = expertsvote(ngramtree,txt,n,cutoff);
segregated
txtchk
accuracy = findaccuracy(segregated,txtchk,num)
%ourput the result