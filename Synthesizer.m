classdef Synthesizer
    
    properties
        sampleRate = 96000;
        currentSynth = "Sine";
        
    end
    
    methods
        function obj = set.currentSynth(obj, synth)
            if ischar(synth)
                obj.currentSynth = synth;
            else
               error("Synth type must be a string"); 
            end
        end
        
        function out = createAudio(obj, msgs)
           
            shift = 0;
            out = [];
            
            for i = 1:length(msgs)
                msg = msgs(1,i);
                if i == 1
                    msgprev = midimsg('Note',1,31,80,0,0);
                    msgprev = msgprev(1,1);
                else
                    msgprev = msgs(1, i-1);
                end
    
                N = (msg.Timestamp-msgprev.Timestamp).*obj.sampleRate;
                freq = 440 * 2^((msgprev.Note-69)/12);
                shift =  2*pi*mod(shift + (msg.Timestamp-msgprev.Timestamp)/obj.sampleRate*freq,1);
                k=0:N;

                if msg.Note < 50
                    amplitude = 0;
                else
                    amplitude = msg.Velocity/127;
                end
            
                y = obj.synthesize(amplitude, k, shift, freq);
                
                if ((msg.Timestamp-msgprev.Timestamp) > .01)
                    y = obj.smoothOutput(y);
                end

                out = [out; y.'];
            end
        end
    
    end
    
    methods (Access = private)
        
        function y = synthesize(obj, amplitude, k, shift, freq)
            switch obj.currentSynth
                
                case "Sine"
                    y = amplitude .* sin(2 .* pi .* k .* freq/obj.sampleRate + shift);
                case "Square"
                    y = amplitude .* square(2 .* pi .* k .* freq/obj.sampleRate + shift);
                case "Sawtooth"
                    y = amplitude .* sawtooth(2 .* pi .* k .* freq/obj.sampleRate + shift);
                otherwise
                    y = amplitude .* sin(2 .* pi .* k .* freq/obj.sampleRate + shift);
            end
        end
        
        function y = smoothOutput(obj, y)            
               L = 2*fix(.01*obj.sampleRate)-1; 
                ramp = bartlett(L)';  
                L = ceil(L/2);
                y(1:L) = y(1:L) .* ramp(1:L);
                y(end-L+1:end) = y(end-L+1:end) .* ramp(end-L+1:end);
        end
    end
end
