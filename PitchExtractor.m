classdef PitchExtractor
    
    properties (Access = private)
       sampleRate = 96000 
    end

    methods 
        function [f0, idx] = findPitch(obj, audio)
        
            winLength = round(0.04*obj.sampleRate);
            overlapLength = round(0.03*obj.sampleRate);
            [f0,idx] = pitch(audio,obj.sampleRate, ...
                'Method', 'PEF', ...
                'Range', [50, 400], ...
                'WindowLength',winLength, ...
                'OverlapLength',overlapLength, ...
                "MedianFilterLength",16);

            f0 =  smoothdata(f0,'gaussian',20);

           % tf0 = idx/fs;
        end
    end
end