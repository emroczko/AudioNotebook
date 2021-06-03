clear
% [audioorg, fs] = detectVoiced('audio.wav',1);

[audioorg,fs] = audioread('audio.wav');
 tic 
audioorg = audioorg(:,1);
mergeDist = round(0.6*fs);

speechIndices = detectSpeech(audioorg,fs, 'Window',hann(512,'periodic'),'OverlapLength',200, ...
    'MergeDistance', mergeDist);
audio = [];
audio(1:speechIndices(1,1),1) = 0;
for ii = 1:size(speechIndices,1)
    audio = [audio;audioorg(speechIndices(ii,1):speechIndices(ii,2))];
    if ii == size(speechIndices,1)
        audio(speechIndices(ii,2)+1:size(audioorg),1) = 0;
    else
        audio(speechIndices(ii,2)+1:speechIndices(ii+1,1)-1,1) = 0;
    end
end

% audio = audioorg.';
t = (0:size(audio,1)-1)/fs;

hoursPerDay = fs/100;
coeff24hMA = ones(1, hoursPerDay)/hoursPerDay;

audio = filter(coeff24hMA, 1, audio);

winLength = round(0.04*fs);
overlapLength = round(0.03*fs);
[f0,idx] = pitch(audio,fs, ...
    'Method', 'PEF', ...
    'Range', [50, 400], ...
    'WindowLength',winLength, ...
    'OverlapLength',overlapLength, ...
    "MedianFilterLength",16);

f0 =  smoothdata(f0,'gaussian',20);

tf0 = idx/fs;

figure
plot(tf0,f0)

xlabel('Time (s)')
ylabel('Pitch (Hz)')
title('Pitch Estimations')
axis tight

midi = round(((log(f0*32/440)/log(2))*12)+9);

figure;

plot(midi(:,1))
hold on;
findpeaks(midi(:,1))
hold off;
channel = 1;
deviceWriter = audioDeviceWriter('SampleRate',48000);

msgs = [midimsg('Note',channel,31,110,0.01,0)];  
iter = 1; 
prevTime = 0;

 
 time = zeros(length(midi));
 dur = zeros(length(midi));

for i = 2:length(midi)
        
    if midi(i) == midi(i-1) 
        continue;
    end
    
    time(iter) = t(idx(i)); 
    vel = 80;    
    dur(iter) = time(iter) - prevTime;
    msgs(:,iter) = [midimsg('Note',channel,midi(i),vel,dur(iter),time(iter))];
    
    prevTime = time(iter);
    
    iter = iter + 1;
    
 end

%eventTimes = [msgs.Timestamp];

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

toc 
i = 1;
recorded = zeros(length(audioorg),1);
    %signalProper = [signalProper; osc()];
    osc = audioOscillator('SignalType','sine', ...
   'PhaseOffset',phaseOffset, 'SampleRate',fs); 
   tic 
playaudio = audioplayer(1.5.*audioorg, fs) ;
%play(playaudio);

while toc < msgs(1,length(msgs)).Timestamp
    if toc > msgs(1,i).Timestamp
        msg = msgs(1,i);
        i = i+1;
        
        if msg.Velocity ~= 0
            
            freq = 440 * 2^((msg.Note-69)/12);
            osc.Frequency = freq;
            if msg.Note < 50
                osc.Amplitude = 0;
            else
                osc.Amplitude = msg.Velocity/127;
            end
%             phaseOffset = mod(phaseOffset + dur(i-1)/fs*freq,1);

        else
            osc.Amplitude = 0; 
        end
%         signalProper = [signalProper; osc()];
        
    end
    %recorded = [recorded; osc()];
    deviceWriter(osc());
    
   % 
end
toc
%release(deviceWriter)
% sound(signalProper, fs)