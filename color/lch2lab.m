function lab=lch2lab(lch)
% LAB = LCH2LAB(LCH)
% Equivalent to applycform(lch,makecform('lch2lab'))
%
%           90H 0A C*B
%               |
%  180H         |H        0H
%  -C*A  -------|------  C*A
%    0B         |         0B
%               |
%          270H 0A -C*B
%
% 2007 ddrucker@psych.upenn.edu

lab = applycform(lch,makecform('lch2lab'));