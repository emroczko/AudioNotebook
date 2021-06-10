classdef MidiMaker < handle
    % Klasa MidiMaker tworząca 
    
    properties 
        MidiFrequencies
    end
    
    properties (Access = private)
       velocity = 70;
       channel = 1;
       sampleRate = 96000;
    end
    
    methods

        function obj = freqToMidi(obj, f)
            obj.MidiFrequencies = round(((log(f*32/440)/log(2))*12)+9);
        end 
        
        function msgs = createMIDIMessages(obj, f0, idx, audio)
            
            obj.MidiFrequencies = zeros(length(f0),1);
            
            obj.freqToMidi(f0); 
            
            t = (0:size(audio,1)-1)/obj.sampleRate;
            
            
            prevTime = 0;
            
            iter = 1;
            time = zeros(length(obj.MidiFrequencies));
            duration = zeros(length(obj.MidiFrequencies));
            
            for i = 2:length(obj.MidiFrequencies)
    
                if obj.MidiFrequencies(i) == obj.MidiFrequencies(i-1) 
                    continue;
                end

                time(iter, 1) = t(idx(i)); 
                obj.velocity = 80;    
                duration(iter, 1) = time(iter, 1) - prevTime;
                msgs(:,iter) = [midimsg('Note',obj.channel,obj.MidiFrequencies(i),...
                                obj.velocity,duration(iter,1 ),time(iter, 1))];

                prevTime = time(iter, 1);

                iter = iter + 1;
            end

        end
    end    
end