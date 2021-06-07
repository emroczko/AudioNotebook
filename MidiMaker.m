classdef MidiMaker
    
    properties (Access = private)
        MidiFrequencies
        Track1MIDI
        Track2MIDI
        
    end
    
    methods
        function obj = MidiMaker()
            
        end
        
        function obj = freqToMidi(obj)
            obj.MidiFrequencies = round(((log(f*32/440)/log(2))*12)+9);
        end 
        
        function createMIDIMessages(obj, idx)
            
            freqToMidi();
            
            iter = 1;
            channel = 1;
            velocity = 90;
            time = zeros(length(obj.MidiFrequencies, 1));
            duration = zeros(length(obj.MidiFrequencies, 1));
            
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