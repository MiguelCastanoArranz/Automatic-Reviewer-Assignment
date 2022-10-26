% Code to run the case study in [1]
%
% This code is divided in the following sections: 
%   1.- Reviewer Information Retrieval (IR). Obtain the data needed to 
%  resolve the assignment. (See Section 4 in [1])
%   2.- Calling to the Convex Expertise Matching (ConvEM) which assigns 
%  reviewers to papers. (See Section 6 in [1]).
%   3.- Calling to the function which reports the results in a text file
%
%  v3.1  October 2022. Miguel Castano Arranz, castano.arranz@gmail.com
%                 Division of Operation and Maintenance, 
%                 Lulea University of Technology, Sweden 
%
% [1]: "Convex Optimization for Reviewer Assignment in Conference",
% subbmitted to Neurocomputing 


%% 1.- Reviewer Information Retrieval (IR) 
% Obtain the data needed to resolve the assignment. 
% 1.a) Infomration Gathering. Call to the script InfoGatheringDC2019 which
% parses the program from the conference CDC 2019 in order to perform 
% Information Gathering as described in Section 4.1 in [1]. After executing 
% InfoGatheringDC2019, the following variables are obtained:
%   - authorSet: cell array with the names of all the authors
%   - paperSet: cell array with the ID of each paper
%   - kwSet: cell array with all the keywords
%   - W: Authorship matrix. If author{j} is an author of paper{i}, then
%       W(i,j)=1. Otherwise W(i,j)=0. 
%   - P: Paper/Keyword Matrix. Binary matrix such that P(i,j)= 1 if 
%       keyword{j} is present in paper{i}. P(i,j)=0 otherwise.
InfoGatheringCDC2019;

% 1.b) Information Inference. The gathered information from CDC2019 is now 
% processed in order to obtain the information needed to resolve the 
% Reviewer Assignment Problem (RAP). This is done as described in 
% Section 4.2 in [1]. 
%
% The Veto Matrix is initialized in such way that 
% authors cannot review their own paper neither papers of their co-authors
% see [1].
V=W*(W'*W)==0; 
%
% Pre-processing of the data as desctried in Section 4.3 in [1].
% Remove inexpert authors 
[W,V,authorSet]=removeinexpert(W,P,V,authorSet);
% Remove isolated papers 
[W,P,V,paperSet]=removeisolated(W,P,V,paperSet);
% 
% Keyword Expertise Matrix
K=P'*W;
%
% Paper Expertise Matrix
E=P*K;

%% 3.- Runs an optimization scheme to assign reviewers
% Call to the function which runs ConvEM
[PaperOrder,Q,Qhist]=ConvEM(E,V);
% Alternatively you can use the greedy Expertise Matching (GEM) as baseline
%[PaperOrder,Q,Qhist]=GEM(E,V);

% If you want to assign more than one paper to each reviewer, you can call
% the ConvEM function with an extra input argument, e.g.: 
%[PaperOrder,Q,Qhist]=ConvEM(E,V,2); % to assign 2 papers per reviewer
%[PaperOrder,Q,Qhist]=ConvEM(E,V,3); % to assign 3 papers per reviewer



%% 
% 4.-Call to the function for printing the result in a text file
printAssignment(authorSet,paperSet,kwSEet,W,P,PaperOrder,...
'AssignmentResult.txt');
