classdef MidiHandler 
   
    properties (Access = private)
        noiseGater
        pitchExtractor
        midiMaker
    end
    
    methods
        function obj = MidiHandler()
            obj.noiseGater = NoiseGater();
            obj.pitchExtractor = PitchExtractor();
        end
        function convertAudioToMidi(obj, audio)
            obj.noiseGater.updateAndPerformNoiseGate(audio);
            obj.pitchExtractor.findPitch(obj.noiseGater.outputSignal);
            
        end
        
    end
    
end