function X = MOONcalc(mysize)
% banana generator, modified by Daniel M. Drucker ddrucker@psych.upenn.edu 2007 to create arbitrary
% sizes. original by Arguin and Saumier 1999
% 

%% square space
%{
dv1 =  0.1875 + [1 2 3 4] * 0.0350;
dv2 = 90      + [1 2 4 9] * 5     ;
 
dimvalue=[];
for d=dv1
    for dd=dv2
        dimvalue = [dimvalue, [d ; dd]];
    end
end
%}

%% OCTAGON SPACE
dimvalue=[0.253253787975413 95;0.296746212024588 95;0.3275 106.715728752538;0.3275 123.284271247462;0.296746212024588 135;0.253253787975413 135;0.2225 123.284271247462;0.2225 106.715728752538;0.253253787975413 106.715728752538;0.275 103.284271247462;0.296746212024588 106.715728752538;0.305753787975413 115;0.296746212024588 123.284271247462;0.275 126.715728752538;0.253253787975413 123.284271247462;0.244246212024587 115]';

pp=progressbar();
Nstim=length(dimvalue);

scale=2;
length_long=175*scale;
side=mysize*scale;
fmin=.96;
fmax=1.04;
dimvalue(2,:)=dimvalue(2,:)*scale;

for stim=1:Nstim
    setStatus(pp,stim/Nstim)
    a=length_long/2;
    b=dimvalue(1,stim)*a;
    clear ellips;
    tel_ellips=0;
    for j=floor(1+side*1/5):floor(side*4/5)
        for i=floor(0.15*side):(side/2)
            f=(i-(side/2))^2/b^2 + (j-(side/2))^2/a^2;
            if (f>=fmin) && (f<=fmax)
                tel_ellips=tel_ellips+1;
                ellips(tel_ellips,1:2)=[i j];
            end
        end
    end
    for j=floor(1+side*1/5):floor(side*4/5)
        for i=floor(1+side/2):floor(0.85*side)
            f=(i-(side/2))^2/b^2 + ((side-j)-(side/2))^2/a^2;
            if (f>=fmin) && (f<=fmax)
                tel_ellips=tel_ellips+1;
                ellips(tel_ellips,1:2)=[i side-j];
            end
        end
    end

    compIm=zeros((side-1));
    clear ellips_curve;
    tel_ellipsnew=0;
    clear Xpoly;
    clear Ypoly;

    for j=1:size(ellips,1)
        tel_ellipsnew=tel_ellipsnew+1;
        cirkelplaats=sqrt(dimvalue(2,stim)^2 - abs((side/2)-ellips(j,2))^2) + (dimvalue(2,stim)+(side/2));
        hoek=atan(abs((side/2)-ellips(j,2))/abs(cirkelplaats-(dimvalue(2,stim)+(side/2))));
        ellips_curve(j,1)=round(ellips(j,1)+(1-cos(hoek))*dimvalue(2,stim));
        ellips_curve(j,2)=ellips(j,2);

        xbegin=ellips_curve(j,1);
        ybegin=ellips_curve(j,2);

        Xpoly(tel_ellipsnew)=ellips_curve(j,1);
        Ypoly(tel_ellipsnew)=ellips_curve(j,2);
    end

    Xpoly(tel_ellipsnew+1)=xbegin;
    Ypoly(tel_ellipsnew+1)=ybegin;
    
    % smooth
    windsize=scale*10;
    wind=ones(1,windsize);
    Xpoly=filtfilt(wind/windsize,1,Xpoly);
    Ypoly=filtfilt(wind/windsize,1,Ypoly);

    BW = roipoly(compIm,Xpoly,Ypoly);
    Im=zeros((side-1));
    telce=0;
    hulpcenter(1,1:2)=0;
    for px=1:(side-1),
        for py=1:(side-1),
            if BW(px,py)==1
                telce=telce+1;
                hulpcenter(telce,:)=[py px];
            end
        end
    end

    maxx=max(hulpcenter(:,2));
    minx=min(hulpcenter(:,2));
    hulpcenter(:,2)=hulpcenter(:,2) + round((side/2)-(maxx+minx)/2);
    maxy=max(hulpcenter(:,1));
    miny=min(hulpcenter(:,1));
    hulpcenter(:,1)=hulpcenter(:,1) + round((side/2)-(maxy+miny)/2);
    for t=1:telce,
        Im(hulpcenter(t,1),hulpcenter(t,2))=1;
    end
    X{stim}=Im;
end

