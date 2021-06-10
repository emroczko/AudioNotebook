classdef AudioRecorder < handle
    % Klasa AudioRecorder pozwalająca na nagrywanie dźwięku i wyrysowanie
    % go na wykresie w głównym oknie aplikacji. Przechowuje również surowe
    % nagranie sygnału.
      
    properties 
        rawTrack1Audio
        rawTrack2Audio
    end
    properties (Access = private)
        recorder
        sampleRate
    end
    methods 
        function obj = AudioRecorder(sampleRate)
        
            if nargin == 0 
                obj.sampleRate = 96000;
            elseif nargin == 1
                obj.sampleRate = sampleRate;    
            else
                error("AudioRecorder can be initialized only with sample rate") 
            end
    
            obj.recorder = audiorecorder(obj.sampleRate, 24, 1);
        end
        
        function set.rawTrack1Audio(obj, audio)
            if ((isequal(size(audio,2), 2) || isequal(size(audio,2), 1)) ...
                    && isnumeric(audio)) || isempty(audio)
                obj.rawTrack1Audio = audio;
            else
                error("Audio must be a vector and must be a type of double, but can be also an empty vector")
            end
        end
        
        function set.rawTrack2Audio(obj, audio)
            if ((isequal(size(audio,2), 2) || isequal(size(audio,2), 1)) ...
                    && isnumeric(audio)) || isempty(audio)
                obj.rawTrack2Audio = audio;
            else
                error("Audio must be a vector and must be a type of double, but can be also an empty vector")
            end
        end
       
        function set.sampleRate(obj, sampleRate)
            if isnumeric(sampleRate) && sampleRate > 80 && sampleRate < 1000000 
               obj.sampleRate = sampleRate; 
            else
                error("Sample rate must be a positive number between 80 and 1000000")
            end
        end
        
        function obj = record(obj, axes, track)
            record(obj.recorder);
                while obj.recorder.isrecording() && ~obj.isdeleted(obj.recorder)
                    pause(1);
                    plot(axes, obj.recorder.getaudiodata());
                    drawnow();
                end
            switch (track)
                case 1
                obj.rawTrack1Audio = obj.recorder.getaudiodata();
                case 2
                obj.rawTrack2Audio = obj.recorder.getaudiodata();
            end
        end
        
        function obj = stopRecording(obj)
            stop(obj.recorder);
        end
        
        
    end
    
    methods (Access = private)
        function tf=isdeleted(obj, h)
            tf=false;
            try
                get(h);
            catch ME
                if strcmp(ME.identifier,'MATLAB:class:InvalidHandle')
                    tf=true;
                end
            end
        end 
    end
end

