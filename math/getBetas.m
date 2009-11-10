function [Betas,ErrorSq,Residuals] = getBetas(G,Vec)
% [Betas,ErrorSq,Residuals] = getBetas(G,Vec)
% 
% given a G matrix and a vector, gives the betas
% fitting the G matrix to that vector, and the errorsq
%
% 2007 ddrucker@psych.upenn.edu adapted from gka


OrderG=length(Vec);

Fac1 = (inv(G'*G)*G');
Betas = Fac1*Vec;
R=(-1).*(G*Fac1);
R((([1:OrderG]-1)*(OrderG+1))+1)=1+R((([1:OrderG]-1)*(OrderG+1))+1);  %matlab starts indexing at 1
Residuals=R*Vec;
ErrorSq=(Residuals'*Residuals);
