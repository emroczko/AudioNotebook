classdef AudioRecorder < handle
    properties (Access = public)
        Recorder
        Track1Audio
        Track2Audio 
    end
    methods 
        
        function obj = AudioRecorder()
            obj.Recorder = audiorecorder(96000, 24, 1);
        end
       
        function obj = record(obj, axes, track)
            record(obj.Recorder);
            while obj.Recorder.isrecording()
                pause(1);
                plot(axes, obj.Recorder.getaudiodata());
                drawnow();
            end
            switch (track)
                case 1
                obj.Track1Audio = obj.Recorder.getaudiodata();
                case 2
                obj.Track2Audio = obj.Recorder.getaudiodata();
            end
        end
        
        function obj = stopRecording(obj)
            stop(obj.Recorder);
        end
        
        function set.Track1Audio(obj, audio)
            obj.Track1Audio = audio;
        end
        
        function set.Track2Audio(obj, audio)
            obj.Track2Audio = audio;
        end
        
        function audio = getTrack1Audio(obj)
            audio = obj.Track1Audio; 
        end
        function audio = getTrack2Audio(obj)
            audio = obj.Track2Audio; 
        end
        
    end
end

