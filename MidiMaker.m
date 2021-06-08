classdef MidiMaker < handle
    
    properties 
        MidiFrequencies
    end
    
    methods
        function obj = MidiMaker()
            
        end
        
        function obj = freqToMidi(obj, f)
            obj.MidiFrequencies = round(((log(f*32/440)/log(2))*12)+9);
        end 
        
        function msgs = createMIDIMessages(obj, f0, idx)
            
            obj.freqToMidi(f0); 
            
            iter = 1;
            channel = 1;
            velocity = 90;
            time = zeros(length(obj.MidiFrequencies));
            duration = zeros(length(obj.MidiFrequencies));
            
            for i = 2:length(obj.MidiFrequencies)
    
                if obj.MidiFrequencies(i) == obj.MidiFrequencies(i-1) 
                    continue;
                end

                time(iter, 1) = t(idx(i)); 
                velocity = 80;    
                duration(iter, 1) = time(iter, 1) - prevTime;
                msgs(:,iter) = [midimsg('Note',channel,obj.MidiFrequencies(i),...
                                velocity,duration(iter,1 ),time(iter, 1))];

                prevTime = time(iter, 1);

                iter = iter + 1;
            end

        end
    end    
end