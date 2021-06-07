classdef AudioPlayer < handle
   
    properties (Dependent)
        AudioSum
    end
    properties (Access = public)
        Player
        Track1Volume = 1
        Track2Volume = 1
        Track1Audio
        Track2Audio
    end
    
    methods 
       function obj = AudioPlayer()
            
       end
       
       function play(obj, axes1, axes2)
            obj.Player = audioplayer(obj.AudioSum, 96000);
            play(obj.Player);
            ax1 = xline(axes1, 0);
            ax2 = xline(axes2, 0);
            while(obj.Player.Running)
                ax1.Value = obj.Player.currentSample;
                ax2.Value = obj.Player.currentSample;
                drawnow;
            end
        end
        
        function stop(obj)
            stop(obj.Player)
        end 
        
        function sum = get.AudioSum(obj)
                maxlen = max(length(obj.Track1Audio), length(obj.Track2Audio));
                obj.Track1Audio(end+1:maxlen,1) = 0;
                obj.Track2Audio(end+1:maxlen,1) = 0;
                sum = obj.Track1Volume.*obj.Track1Audio + obj.Track2Volume.*obj.Track2Audio;  
        end
        
        function set.Track1Volume(obj, volume)
            obj.Track1Volume = volume;
        end
        
        function set.Track2Volume(obj, volume)
            obj.Track2Volume = volume;
        end
   
                
        function obj = changeVolumeOfTrack(obj, volume, track)
            switch track
                case 1
                   obj.Track1Volume = volume;
                case 2
                   obj.Track2Volume = volume;
            end        
        end
        
        function set.Track1Audio(obj, audio)
            obj.Track1Audio = audio;
        end
        
        function set.Track2Audio(obj, audio)
            obj.Track2Audio = audio;
        end
        
        function obj = updateTracks(obj, audio, track)
            switch track
                case 1
                   obj.Track1Audio = audio;
                case 2
                   obj.Track2Audio = audio;
            end  
        end
        
    end
    
    
end