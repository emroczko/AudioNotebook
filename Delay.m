classdef Delay < matlab.mixin.SetGet
    properties 
        combDelay = 5000;
        combGain = 0.6;
        wetGain = 1;
        dryGain  = 1;
        feedback = 6;
    end
    
    methods 
        function obj = Delay(varargin)
            setProperties(obj,varargin{:});
        end
        
        function set.combDelay(obj, combDelay)
            if combDelay > 0 && combDelay < 20000 && isnumeric(combDelay)
                obj.combDelay = combDelay;
            else
                error("Comb delay must be a double in range (0:20000)")
            end
        end
        
        function set.combGain(obj, combGain)
            if combGain > 0.3 && combGain < 0.7 && isnumeric(combGain)
                obj.combGain = combGain;
            else
                error("Comb gain must be a double in range (0.3:0.7)")
            end
        end
        
        function set.wetGain(obj, wetGain)
            if wetGain > 0 && wetGain < 1.5 && isnumeric(wetGain)
                obj.wetGain = wetGain;
            else
                error("Wet gain must be a double in range (0:1.5)")
            end
        end
        
        function set.dryGain(obj, dryGain)
            if dryGain > 0 && dryGain < 1 && isnumeric(dryGain)
                obj.dryGain = dryGain;
            else
                error("Dry gain must be a double in range (0:1)")
            end
        end
        
        function set.feedback(obj, feedback)
            if feedback > 0 && feedback < 12 && isnumeric(feedback)
                obj.feedback = feedback;
            else
                error("Feedback maximum level is 12")
            end
        end
        
        function output = doDelay(obj, signal)
           processedSignal = obj.combFilters(signal);
           output = obj.wetGain.*processedSignal + obj.dryGain.*signal;
        end
        
        
    end
    
    methods (Access = protected)
        function signalSum = combFilters(obj, signal)
            B = @(delay,gain) gain.*[1 zeros(1,floor(delay)-1) 0.7];

            shift = linspace(1,obj.feedback,3);
            %implementacja filtrów grzebieniowych
            signal1 = filter(B(obj.combDelay      ,obj.combGain),1,signal);
            signal2 = filter(B(obj.combDelay.*shift(1), obj.combGain.*0.99),1,signal);
            signal3 = filter(B(obj.combDelay.*shift(2), obj.combGain.*1.01),1,signal);
            signal4 = filter(B(obj.combDelay.*shift(3), obj.combGain),1,signal);

            %suma sygnałów z filtrów
            signalSum = signal1 + signal2 + signal3 + signal4;

            %zmniejszenie amplitudy sygnałów z filtrów
            signalSum = 0.5.*signalSum;
        end
        
        function setProperties( obj, varargin )
            %SETPROPERTIES Set user-specified chart properties safely.
            
            if ~isempty( varargin )
                try
                    set( obj, varargin{:} )
                catch e
                    % Destroy the chart object and throw the exception
                    % from the calling function.
                    obj.delete()
                    e.throwAsCaller()
                end % try/catch
            end % if
            
        end % setProperties
    end
        
end 