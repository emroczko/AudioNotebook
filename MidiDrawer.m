classdef MidiDrawer
   
    properties
        sampleRate = 96000;
    end
    methods
        function drawMidiPlot(obj, msgs, axes)
            midi = obj.makeMidiFrequenciesVector(msgs);
            plot(axes, midi, 'Color',[0.4660 0.6740 0.1880], 'LineWidth', 1);
        end
         
    end
    methods (Access = private)
        function out = makeMidiFrequenciesVector(obj, msgs)
            iteratorBegin = 1;
            iteratorEnd = 0;
            out = floor(msgs(2, length(msgs)).Timestamp*obj.sampleRate);
            for i = 1:length(msgs)
                msg = msgs(1,i);
                if i == 1
                    msgprev = midimsg('Note',1,31,80,0,0);
                    msgprev = msgprev(1,1);
                else
                    msgprev = msgs(1, i-1);
                end
    
                N = (msg.Timestamp-msgprev.Timestamp).*obj.sampleRate;
                
                iteratorEnd = iteratorEnd+floor(N);
                out(iteratorBegin:iteratorEnd) = msgprev.Note;
                iteratorBegin = iteratorEnd+1;
            end
            out;
        end
    end
end