classdef PitchExtractor
    % Klasa PitchExtractor znajdująca wektor częstotliwości z danego pliku
    % audio oraz "wygładzająca" go. 
    
    properties (Access = private)
       sampleRate = 96000 
       windowLength
       
    end

    methods 
        function obj = PitchExtractor()
            
        end
        
        function [frequencies, idx] = findPitch(obj, audio)
        
            winLength = round(0.04*obj.sampleRate);
            overlapLength = round(0.03*obj.sampleRate);
            [frequencies,idx] = pitch(audio,obj.sampleRate, ...
                'Method', 'PEF', ...
                'Range', [50, 700], ...
                'WindowLength',winLength, ...
                'OverlapLength',overlapLength, ...
                "MedianFilterLength",16);

            frequencies =  smoothdata(frequencies,'gaussian',20);
        end
    end
end