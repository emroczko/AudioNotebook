classdef PitchExtractor
    % Klasa PitchExtractor znajdująca wektor częstotliwości z danego pliku
    % audio oraz "wygładzająca" go. 
    
    methods (Static) 
        function [frequencies, idx] = findPitch(audio)
            
            sampleRate = 96000;
            winLength = round(0.04*sampleRate);
            overlapLength = round(0.03*sampleRate);
            [frequencies,idx] = pitch(audio, sampleRate, ...
                'Method', 'PEF', ...
                'Range', [50, 700], ...
                'WindowLength',winLength, ...
                'OverlapLength',overlapLength, ...
                "MedianFilterLength",16);

            frequencies =  smoothdata(frequencies,'gaussian',20);
        end
    end
end