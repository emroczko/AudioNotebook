classdef MidiHandler
    
    properties (Access = private)
        MidiFrequencies
        Track1MIDI
        Track2MIDI
        
    end
    
    methods
        function obj = MidiHandler()
            
        end
        
        function obj = freqToMidi(obj)
            obj.MidiFrequencies = round(((log(f*32/440)/log(2))*12)+9);
        end 
        
        function createMIDIMessages(obj)
            
        end
    end    
end