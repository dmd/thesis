function X = RFCcalc(par,mysize,stimtype,pointslist)
% modified from Hans Op de Beeck 
% 2006-9 ddrucker@psych.upenn.edu
w = par.w; 
A = par.A;
P = par.P;
step = par.step;

if strcmp(stimtype,'grid')
    pointslist=points(0,4)+2.5;
end
klein=mysize/299; %original parameters calculated for larger stimulus size (299x299 instead of 256x256 as generated now)
A=A.*klein;
step=step.*klein;
%new_step=5*step./(sqrt(length(pointslist))-1); % we REALLY want length(pointslist) to be 16 though
new_step=5*step./(sqrt(16)-1); % we REALLY want length(pointslist) to be 16 though

%names=char(65:65+length(pointslist)-1);


% smallest distance between adjacent stimuli becomes (5*step)/(Ndim-1)
%     the original step was calculated for 6 values/dimension instead of 3
% step is not necessarily equal for each manipulated dimension (maximum = 6)
%		because it was originally calibrated to generate
%     equal stimulus differences in pixel space

%number of pixels on circle outline
%amplitude expressed in radials is a function of the ratio of A to r
r=round(70*klein);

%omtrek=2*pi*r;
npixel=round(2*pi*r);


for pointnum=1:size(pointslist,1)
    dim1val = pointslist(pointnum,1);
    dim2val = pointslist(pointnum,2);


    compIm=zeros(mysize);
    nloop=0;
%    xsprong=0;
%    ysprong=0;

    %if some frequencies are not integer,
    %the begin and endpoint of the series will not have the same position (no closed contour)
    %here this potential difference is calculated for later use
    xb=0;
    yb=129 + A(1)*sin(w(1)*xb+P(1)) + (A(2)+new_step(2)*(dim1val-1))*sin(w(2)*xb+P(2)) + A(3)*sin(w(3)*xb+P(3)) + A(4)*sin(w(4)*xb+P(4)) +  + (A(5)+new_step(5)*(dim2val-1))*sin(w(5)*xb+P(5)) + A(6)*sin(w(6)*xb+P(6))+ A(7)*sin(w(7)*xb+P(7));
    xe=2*pi;
    ye=129 + A(1)*sin(w(1)*xe+P(1)) + (A(2)+new_step(2)*(dim1val-1))*sin(w(2)*xe+P(2)) + A(3)*sin(w(3)*xe+P(3)) + A(4)*sin(w(4)*xe+P(4)) +  + (A(5)+new_step(5)*(dim2val-1))*sin(w(5)*xe+P(5))+ A(6)*sin(w(6)*xe+P(6))+ A(7)*sin(w(7)*xe+P(7));
    d_1e=sign(yb-ye)*(yb-ye);

    for xi=(mysize-round(npixel/2)+1):(mysize+round(npixel/2)+1)

        %modulation by fourier components is calculated for each point on the curve
        x=((xi-(mysize-round(npixel/2)+1))/npixel)*2*pi;
        y=round((mysize/2) + A(1)*sin(w(1)*x+P(1)) + (A(2)+new_step(2)*(dim1val-1))*sin(w(2)*x+P(2)) + A(3)*sin(w(3)*x+P(3)) + A(4)*sin(w(4)*x+P(4)) +  + (A(5)+new_step(5)*(dim2val-1))*sin(w(5)*x+P(5)) + A(6)*sin(w(6)*x+P(6))+ A(7)*sin(w(7)*x+P(7)));

        %now this modulation is put on a circle
        %potential correction (see above) is applied to get a closed contour
        xnummer=round(xi)-(mysize-round(npixel/2)+1);
        hoek=(xnummer/npixel)*2*pi + pi/2;
        xcirkel=mysize + r*cos(hoek);
        ycirkel=(mysize/2)+r + r*sin(hoek);
        xcurve=round(xcirkel + (y-(mysize/2))*cos(hoek));
        ycurve=round(ycirkel + (y-(mysize/2))*sin(hoek));
        ycurve=round(ycurve + cos((hoek-pi/2)/2)*d_1e/2*sign(ye-yb));
        compIm(xcurve-(mysize/2),ycurve-r)=1;

        %at points with high modulation rate, gaps will occur in the contour
        %so we linearly interpolate between all explicitly computed points
        if nloop==0
            xbegin=xcurve-(mysize/2);
            ybegin=ycurve-r;
        elseif nloop>0
            x1=xcurveold;
            x2=xcurve-(mysize/2);
            y1=ycurveold;
            y2=ycurve-r;

            dx = abs(x2 - x1);
            dy = abs(y2 - y1);

            flip = 0;
            if (dx>1) || (dy>1)
                if (dx >= dy)
                    if (x1 > x2)
                        % Always "draw" from left to right.
                        t = x1; x1 = x2; x2 = t;
                        t = y1; y1 = y2; y2 = t;
                        flip = 1;
                    end
                    m = (y2 - y1)/(x2 - x1);
                    xl = (x1:x2).';
                    yl = round(y1 + m*(xl - x1));
                else
                    if (y1 > y2)
                        % Always "draw" from bottom to top.
                        t = x1; x1 = x2; x2 = t;
                        t = y1; y1 = y2; y2 = t;
                        flip = 1;
                    end
                    m = (x2 - x1)/(y2 - y1);
                    yl = (y1:y2).';
                    xl = round(x1 + m*(yl - y1));
                end

                if (flip)
                    xl = flipud(xl);
                    yl = flipud(yl);
                end

                for p=1:size(xl),
                    compIm(xl(p),yl(p))=1;
                end
            end

        end
        % X,Ypoly are the curves that define the shape.
        % if you plot(Xpoly,Ypoly) you see the shape outline
        Xpoly(xnummer+1)=xcurve-(mysize/2);
        Ypoly(xnummer+1)=ycurve-r;

        xcurveold=xcurve-(mysize/2);
        ycurveold=ycurve-r;
        nloop=nloop+1;

    end

    Xpoly(xnummer+2)=xbegin;
    Ypoly(xnummer+2)=ybegin;

    %line between begin and endpoint
    x1=xbegin;
    x2=xcurveold;
    y1=ybegin;
    y2=ycurveold;

    dx = abs(x2 - x1);
    dy = abs(y2 - y1);

    flip = 0;
    if (dx>1) || (dy>1)
        if (dx >= dy)
            if (x1 > x2)
                % Always "draw" from left to right.
                t = x1; x1 = x2; x2 = t;
                t = y1; y1 = y2; y2 = t;
                flip = 1;
            end
            m = (y2 - y1)/(x2 - x1);
            xl = (x1:x2).';
            yl = round(y1 + m*(xl - x1));
        else
            if (y1 > y2)
                % Always "draw" from bottom to top.
                t = x1; x1 = x2; x2 = t;
                t = y1; y1 = y2; y2 = t;
                flip = 1;
            end
            m = (x2 - x1)/(y2 - y1);
            yl = (y1:y2).';
            xl = round(x1 + m*(yl - y1));
        end

        if (flip)
            xl = flipud(xl);
            yl = flipud(yl);
        end

        for p=1:size(xl),
            compIm(xl(p),yl(p))=1;
        end
    end

    % smooth that sucker a bit
    windsize = floor(5.84*klein);
    wind = ones(1,windsize);
    Xpoly = filtfilt(wind/windsize,1,Xpoly);
    Ypoly = filtfilt(wind/windsize,1,Ypoly);
    

    %an extra image is made containing a filled contour
    %the linear interpolation above can be deleted if one works with filled contours
    BW = roipoly(compIm,Xpoly,Ypoly);
    Im=zeros(mysize);
    for px=1:mysize,
        for py=1:mysize,
            if BW(px,py)==1
                Im(py,px)=1;
            end
        end
    end

    X{pointnum}=Im;

end
