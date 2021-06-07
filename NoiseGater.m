classdef NoiseGater
    
    properties
        inputSignal
        outputSignal
        sampleRate
    end
    
    methods 
        
        function obj = NoiseGater(input)
            obj.signalInitializer(input);
        end
        
        function obj = set.inputSignal(obj, input)
           
            if isnumeric(input)
                obj.inputSignal = input;
            else 
                
            end
            
        end
        
        function performNoiseGate(obj)
             
            obj.inputSignal = obj.inputSignal(:,1);
            mergeDist = round(0.6*fs);

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
        
        function updateAndPerformNoiseGate(obj, audio)
            obj.signalInitializer(audio);
            obj.performNoiseGate();
        end
       
    end
    
    methods (Access = private)
        
        function obj = filterSignal()
            hoursPerDay = fs/100;
            coeff24hMA = ones(1, hoursPerDay)/hoursPerDay;

            audio = filter(coeff24hMA, 1, audio);
        end
        function obj = signalInitializer(obj, input)
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
    end

end