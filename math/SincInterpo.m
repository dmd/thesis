function NewSignal = SincInterpo(Signal,ExpansionFactor)
% signal: one dimensional array of floating values
% expansion_factor: determines how many times the original sampling
% interval is divided 
% returned vector is of length (original length*expansion factor)
%
% 2007 ddrucker@psych.upenn.edu adapted from gka and Eric Zarahn

NewSignal=zeros(floor(length(Signal)*ExpansionFactor),1,'single');
Length=floor(length(Signal));

if (ExpansionFactor < 1)
    NewSignal = interp1(0:1:Length-1,Signal,(0.0:1.0:(Length*ExpansionFactor-1))*(1/ExpansionFactor));
    return;
end

% Check passed signal

if length(Signal) < 2
    NewSignal = -1;
    return;
end

% Even number of values

if mod(Length,2) == 0
    for i = 0:ExpansionFactor-1
        TimeShift=i/ExpansionFactor;
        Phi=zeros(Length,1,'single');
        for f=2:Length/2+1
            Phi(f)=TimeShift*pi*2/(Length/(f-1));
        end
        Phi(floor(Length/2)+2:Length)=-flipud(Phi(2:floor(Length/2)));
        Shifter=complex(cos(Phi),sin(Phi));
        ShiftedSignal=real(fft(ifft(Signal).*Shifter));
        for j=1:Length
            NewSignal(j*ExpansionFactor+i)=ShiftedSignal(j);
        end
    end
    return
    
    % odd number of values
else
    for i = 0:ExpansionFactor-1
        TimeShift=i/ExpansionFactor;
        Phi=zeros(Length,1,'single');
        for f=2:Length/2+1
            Phi(f)=TimeShift*pi*2/(Length/(f-1));
        end
        Phi(floor(Length/2)+2:Length)=-flipud(Phi(2:floor(Length/2)+1));
        Shifter=complex(cos(Phi),sin(Phi));
        ShiftedSignal=real(fft(ifft(Signal).*Shifter'));
       
        for j=1:Length
            NewSignal(j*ExpansionFactor+i)=ShiftedSignal(j);
        end
    end
    return
end
end

        
