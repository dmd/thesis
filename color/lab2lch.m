function lch=lab2lch(lab)
% LCH = LAB2LCH(LAB)
% Equivalent to applycform(lab,makecform('lab2lch'))
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


lch = applycform(lab,makecform('lab2lch'));