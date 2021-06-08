classdef MidiHandler < handle
   
    properties
        noiseGater
        pitchExtractor
        midiMaker
        Track1Midi
        Track2Midi
    end
    
    methods
        function obj = MidiHandler()
            obj.noiseGater = NoiseGater();
            obj.pitchExtractor = PitchExtractor();
            obj.midiMaker = MidiMaker();
        end
        function obj = convertAudioToMidi(obj, audio, track)
            obj.noiseGater.updateAndPerformNoiseGate(audio);
            [f, id] = obj.pitchExtractor.findPitch(obj.noiseGater.outputSignal);
            midi = obj.midiMaker.createMIDIMessages(f, id);
            
            switch track
                case 1
                    obj.Track1Midi = midi;
                case 2
                    obj.Track2Midi = midi;
            end
        end
        
    end
    
end