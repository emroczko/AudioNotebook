classdef Synthesizer < handle
    
    properties
        sampleRate = 96000;
    end
    
    
    methods
        function out = createAudio(obj, msgs)
           
            shift = 0;
 

            out = zeros(msgs(1,1).Timestamp*obj.sampleRate,1);
            
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
            
                y = amplitude .* sin(2 .* pi .* k .* freq/obj.sampleRate + shift);


                if ((msg.Timestamp-msgprev.Timestamp) > .01)
                    y = obj.smoothOutput(y);
                end

                out = [out; y.'];
            end
        end
    
    end
    
    methods (Access = private)
        
        function y = smoothOutput(obj, y)            
               L = 2*fix(.01*obj.sampleRate)-1; 
                ramp = bartlett(L)';  
                L = ceil(L/2);
                y(1:L) = y(1:L) .* ramp(1:L);
                y(end-L+1:end) = y(end-L+1:end) .* ramp(end-L+1:end);
 
        end
    end
end
