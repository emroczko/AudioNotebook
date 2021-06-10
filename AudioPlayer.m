classdef AudioPlayer < handle
    % Klasa AudioPlayer umożliwiająca odtworzenie dwóch ścieżek mono
    % jednocześnie, z określoną głośnością każdej ze ścieżek. Ta klasa
    % również przechowuje ścieżki audio, potrzebne do ewentualnej konwersji
    % do midi.
   
    properties (Dependent)
        AudioSum
    end
    
    properties 
        Track1Volume = 1
        Track2Volume = 1
        Track1Audio
        Track2Audio
    end
    
    properties (Access = private)
        player
        sampleRate
    end
    
    methods 
        function obj = AudioPlayer(sampleRate)
            if nargin == 0
                obj.sampleRate = 96000;
            elseif nargin == 1
                obj.sampleRate = sampleRate;
            else
               error("AudioPlayer can be initialized only with sample rate") 
            end
                
        end
       % Setters 
       
       function set.Track1Volume(obj, volume)
            if isnumeric(volume) && volume >= 0
                obj.Track1Volume = volume;
            else
                error("Volume must be numeric and more than 0")
            end
        end
        
        function set.Track2Volume(obj, volume)
            if isnumeric(volume) && volume >= 0
                obj.Track2Volume = volume;
            else
                error("Volume must be numeric and more than 0")
            end
        end
        
        function set.Track1Audio(obj, audio)
            if ((isequal(size(audio,2), 2) || isequal(size(audio,2), 1)) ...
                    && isnumeric(audio)) || isempty(audio)
                obj.Track1Audio = audio;
            else
                error("Audio must be a vector and must be a type of double, but can be also an empty vector")
            end
        end
        
        function set.Track2Audio(obj, audio)
            if ((isequal(size(audio,2), 2) || isequal(size(audio,2), 1)) ...
                    && isnumeric(audio)) || isempty(audio)
                obj.Track2Audio = audio;
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
        
        % Getters 
        
        function sum = get.AudioSum(obj)
                maxlen = max(length(obj.Track1Audio), length(obj.Track2Audio));
                obj.Track1Audio(end+1:maxlen,1) = 0;
                obj.Track2Audio(end+1:maxlen,1) = 0;
                sum = obj.Track1Volume.*obj.Track1Audio + obj.Track2Volume.*obj.Track2Audio;  
        end
       
        % Public methods
       
       function empty = isEmpty(obj)
           if (isempty(obj.Track1Audio) || all(obj.Track1Audio == 0)) ...
                   && (isempty(obj.Track2Audio)|| all(obj.Track2Audio == 0))
               empty = true;
           else
               empty = false;
           end 
       end
       
       function play(obj, axes1, axes2)
           if ~isempty(obj.AudioSum)
                obj.player = audioplayer(obj.AudioSum, obj.sampleRate);
                try
                    play(obj.player);
                    ax1 = xline(axes1, 0);
                    ax2 = xline(axes2, 0);
                    while(isplaying(obj.player))
                        ax1.Value = obj.player.currentSample;
                        ax2.Value = obj.player.currentSample;
                        drawnow;
                    end
                    delete(ax1);
                    delete(ax2);
                catch
                    obj.stop()
                    warning("Audioplayer error")
                end
           else
               error("There is no signal to play")
           end
           
        end
        
        function stop(obj)
            stop(obj.player)
        end 
        
    end
    
end