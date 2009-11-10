function c = mncn(m)
% c = mncn(m)
% mean center matrix
%
% 2007 ddrucker@psych.upenn.edu


c = m-sum(m(:))/numel(m);

