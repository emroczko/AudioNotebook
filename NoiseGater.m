classdef NoiseGater < handle
    
    properties
        inputSignal
        outputSignal
        sampleRate = 96000;
    end
    
    methods 
        
        function obj = NoiseGater(varargin)
            if (nargin == 1)
                obj.inputSignal = input;
                obj.outputSignal = zeros(length(obj.inputSignal),1);
            elseif (nargin == 0)
                obj.inputSignal = [];
                obj.outputSignal = [];
            else
                throw MException
            end
        end
        
        function obj = set.inputSignal(obj, input)
           
            if isnumeric(input)
                obj.inputSignal = input;
            else 
                
            end
            
        end
        
        function performNoiseGate(obj)
             
            obj.inputSignal = obj.inputSignal(:,1);
            mergeDist = round(0.6*obj.sampleRate);

            voiceIndices = detectSpeech(obj.inputSignal, obj.sampleRate, ...
                'Window',hann(512,'periodic'), 'OverlapLength',200, ...
                'MergeDistance', mergeDist);
            obj.outputSignal(1:voiceIndices(1,1),1) = 0;
            for ii = 1:size(voiceIndices,1)
                obj.outputSignal = [obj.outputSignal; obj.inputSignal(voiceIndices(ii,1):voiceIndices(ii,2))];
                if ii == size(voiceIndices,1)
                    obj.outputSignal(voiceIndices(ii,2)+1:size(obj.inputSignal),1) = 0;
                else
                    obj.outputSignal(voiceIndices(ii,2)+1:voiceIndices(ii+1,1)-1,1) = 0;
                end
            end 

            obj.filterSignal();
        end
        
        function updateAndPerformNoiseGate(obj, input)
            obj.inputSignal = input;
            obj.outputSignal = zeros(length(obj.inputSignal),1);
            obj.performNoiseGate();
        end
       
    end
    
    methods (Access = private)
        
        function obj = filterSignal(obj)
            coeffLength = obj.sampleRate/100;
            coeffs = ones(1, coeffLength)/coeffLength;

            obj.outputSignal = filter(coeffs, 1, obj.outputSignal);
        end

    end

end