classdef NoiseGater
    
    properties
        inputSignal
        outputSignal
    end
    
    methods 
        function performNoiseGate(obj)
            
        end
    end
    [audioorg,fs] = audioread('audio.wav');
 
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

end