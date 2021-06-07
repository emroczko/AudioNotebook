classdef PitchExtractor
   
    
    methods 
        
    end
    
    
    properties
        
        function findPitch(obj, audio)
        
            

            winLength = round(0.04*fs);
            overlapLength = round(0.03*fs);
            [f0,idx] = pitch(audio,fs, ...
                'Method', 'PEF', ...
                'Range', [50, 400], ...
                'WindowLength',winLength, ...
                'OverlapLength',overlapLength, ...
                "MedianFilterLength",16);

            f0 =  smoothdata(f0,'gaussian',20);

            tf0 = idx/fs;
        end
    end
end