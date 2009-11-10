function theta = modanglebetween(p,q,modulo)
% THETA = MODANGLEBETWEEN(P,Q,MODULO)
% returns the angle between 2 points, MODULO degrees, in degrees
%
% 2007 ddrucker@psych.upenn.edu

if nargin == 2
    modulo = 45;
end

point = p-q;
thetaraw = mod(cart2pol(point(:,1),point(:,2)),modulo*2*pi/180)*180/pi;

theta = min(mod(thetaraw,modulo*2),modulo*2-mod(thetaraw,modulo*2));
