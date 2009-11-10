function stim = centercolorcircle(centercolor,surroundcolor,patchsize,surroundsize,width,height)
% centercolorcircle(centercolor,surroundcolor,patchsize,surroundsize,width,height)
%
% centercolor   = the color we're fading out from
% surroundcolor = the color we're fading to
%   patchsize   = up to this distance from center is centercolor
% surroundsize  = if farther than patchsize+surroundsize, surroundcolor
%       width   = width of desired image
%       height  = height of desired image
%
% between patchsize and patchsize+surroundsize 
% do a gaussian fade from one color to the other
% 
% 2007 ddrucker@psych.upenn.edu

[x,y] = find(ones(width,height));
d = sqrt((x-width/2).^2 + (y-height/2).^2);
d = reshape(d,width,height);

dnorm = (d-patchsize)/surroundsize;
dnorm(find(dnorm<0))=0;
dnorm(find(dnorm>1))=1;
dnorm(find(dnorm>0)) = gaussmapper(dnorm(find(dnorm>0)));

stim = cat(3,(1-dnorm).*centercolor(1) + dnorm.*surroundcolor(1), ...
             (1-dnorm).*centercolor(2) + dnorm.*surroundcolor(2), ...
             (1-dnorm).*centercolor(3) + dnorm.*surroundcolor(3));

%stim = uint8(stim);

end