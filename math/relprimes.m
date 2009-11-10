function relprimes = relprimes(n)
% relprimes = relprimes_dmd(n)
%
% gives the numbers<n which are relatively prime with respect to n

relprimes=[];
for i=2:n
    if gcd(i,n) == 1
        relprimes=[relprimes;i];
    end
end