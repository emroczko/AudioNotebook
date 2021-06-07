classdef Synth
i = 1;

signalProper = [];
ksum = [];
phaseOffset = 0;
shift = 0;
out = [];
WaveOut = [];
Nsum = 0;
out = zeros(msgs(1,1).Timestamp*fs,1);
for i = 1:length(msgs)
    msg = msgs(1,i);
    if i == length(msgs)
        msgnext = msgs(1, i);
    else
        msgnext = msgs(1, i+1);
    end
    
    N = floor((msgnext.Timestamp-msg.Timestamp)*fs);
    freq = 440 * 2^((msg.Note-69)/12);
    shift =  2*pi*mod(shift + dur(i)/fs*freq,1);
    Nsum = Nsum + N;
    k=0:N-1;

    if msg.Note < 50
        amplitude = 0;
    else
        amplitude = msg.Velocity/127;
    end

    WaveOut = amplitude .* sin(2 * pi * k * freq/fs + shift);
     y = WaveOut;
    if ((msgnext.Timestamp-msg.Timestamp) > .01)
    L = 2*fix(.01*fs)-1;  % L odd
    ramp = bartlett(L)';  % odd length
    L = ceil(L/2);
    y(1:L) = y(1:L) .* ramp(1:L);
    y(end-L+1:end) = y(end-L+1:end) .* ramp(end-L+1:end);
    end

     ksum = [ksum; k.'];
     out = [out; y.'];
   
end



    
end
