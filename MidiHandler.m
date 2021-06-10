classdef MidiHandler < handle
    % Klasa MidiHandler obsługująca konwertowanie ścieżki audio do
    % komunikatów midi. Inicjuje potrzebne obiekty i przeprowadza
    % konwersję. 
   
    properties 
        track1Midi
        track2Midi 
    end
    properties (Access = private)
        noiseGater
        pitchExtractor
        midiMaker
        midiDrawer
    end
    
    methods
        
        function set.track1Midi(obj, midi)
            if isa(midi, 'midimsg')
                obj.track1Midi = midi;
            else
                error("Midi vector must be a midimsg type")
            end
        end
        
        function set.track2Midi(obj, midi)
            if isa(midi, 'midimsg')
                obj.track2Midi = midi;
            else
                error("Midi vector must be a midimsg type")
            end
        end
        
        function obj = MidiHandler()
            obj.noiseGater = NoiseGater();
            obj.pitchExtractor = PitchExtractor();
            obj.midiMaker = MidiMaker();
            obj.midiDrawer = MidiDrawer();
        end
        
        function obj = convertAudioToMidi(obj, audio, track)
            obj.noiseGater.updateAndPerformNoiseGate(audio);
            [f, id] = obj.pitchExtractor.findPitch(obj.noiseGater.outputSignal);
            midi = obj.midiMaker.createMIDIMessages(f, id, audio);
            
            switch (track)
                case 1
                    obj.track1Midi = midi;
                case 2
                    obj.track2Midi = midi;
            end
        end
        
        function obj = drawMidiPlot(obj, axes, track)
            switch (track)
                case 1
                    obj.midiDrawer.drawMidiPlot(obj.track1Midi, axes);
                case 2
                    obj.midiDrawer.drawMidiPlot(obj.track2Midi, axes);
            end
        end
        
    end
    
end