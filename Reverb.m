classdef Reverb < Delay
   properties
      allPassDelay = [3000; 2000; 2000];
      allPassGain = [0.7; 0.6; 0.3];
   end
    
   methods
       function obj = Reverb()
           obj = obj@Delay('combDelay', 3000, 'feedback', 3);
           
       end
       
       function set.allPassDelay(obj, allPassDelay)
            if isnumeric(allPassDelay) && length(allPassDelay) <= 3 && ...
                    max(allPassDelay) < 20000 && min(allPassDelay) > 0
                obj.allPassDelay = allPassDelay;
            else
                error("Allpass delay must be a vector of maximum value less than 20000 and bigger than 0")
            end
        end
        
        function set.allPassGain(obj, allPassGain)
            if isnumeric(allPassGain) && length(allPassGain) <= 3 && ...
                    max(allPassGain) < 20000 && min(allPassGain) > 0
                obj.allPassGain = allPassGain;
            else
                error("All pass gain must be a double vector of minimum value more than 0.3 and maximum less than 0.7)")
            end
        end
       
        function output = doReverb(obj, signal)
            processedSignal = obj.combFilters(signal);
            for n = 1:3   
                processedSignal = obj.allPFilters(processedSignal,obj.allPassGain(n), floor(obj.allPassDelay(n)));
            end
            
            output = obj.wetGain.*processedSignal + obj.dryGain.*signal;
           
       end
   end
   
   methods (Access = private)
           
       function filteredSignal = allPFilters(signal, gain, delay)
            b = [gain zeros(1,delay-1) 1];
            a = [1 zeros(1,delay-1) gain];

            filteredSignal = filter(b, a, signal);
       end
   end
    
end