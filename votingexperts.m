%% Discrete data voting experts
function [segregated] = votingexperts(input,checking,n,cutoff)
txt = char(lower(importdata(input)));
txtchk = char(lower(importdata(checking)));
ngramtree = buildngramtree(txt,n);
segregated = expertsvote(ngramtree,txt,n,cutoff)
txtchk
%ourput the result