classdef MidiMaker < handle
    
    properties 
        MidiFrequencies
        sampleRate = 96000;
    end
    
    properties
       velocity = 90;
       channel = 1;
    end
    
    methods
        function obj = MidiMaker()
            
        end
        
        function obj = freqToMidi(obj, f)
            obj.MidiFrequencies = round(((log(f*32/440)/log(2))*12)+9);
        end 
        
        function msgs = createMIDIMessages(obj, f0, idx, audio)
            
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