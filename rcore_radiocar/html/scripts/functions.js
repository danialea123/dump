function isReady(divId, isAudioElement){
    if (isAudioElement) {
        for (var soundName in soundList) {
            var sound = soundList[soundName];
            if (sound.loaded() == false) {

                sound.setLoaded(true);

                var time = 0;
                if (sound.audioElement) {
                    time = sound.audioElement.duration;
                }
                if (sound.isDynamic()) sound.setVolume(0);
                if (!sound.isDynamic()) sound.setVolume(sound.getVolume());

                $.post('https://rcore_radiocar/data_status', JSON.stringify({
                    time: time,
                    type: "maxDuration",
                    id: sound.getName(),
                }));

                $.post('https://rcore_radiocar/events', JSON.stringify({
                    type: "onPlay",
                    id: sound.getName(),
                }));

                addToCache();
                updateVolumeSounds();
                break;
            }
        }
        return;
    }

	for (var soundName in soundList)
	{
		var sound = soundList[soundName];
        if(sound.getDivId() === divId){
            var time = 0;
            if(sound.getYoutubePlayer() != null){time = sound.getYoutubePlayer().getDuration();}
			if(sound.isDynamic()) sound.setVolume(0);
            sound.setLoaded(true);

            $.post('https://rcore_radiocar/data_status', JSON.stringify(
            {
                time: time,
                type: "maxDuration",
                id: sound.getName(),
            }));

            $.post('https://rcore_radiocar/events', JSON.stringify(
            {
                type: "onPlay",
                id: sound.getName(),
            }));

            sound.isYoutubeReady(true);

	        addToCache();
	        updateVolumeSounds();

            if(!sound.isDynamic()) sound.setVolume(sound.getVolume());
            break;
        }
	}
}

function isLooped(divId){
	for (var soundName in soundList)
	{
		var sound = soundList[soundName];
        if(sound.getDivId() === divId && sound.isLoop()){
            sound.setTimeStamp(0);
            sound.play();

            $.post('https://rcore_radiocar/data_status', JSON.stringify({ type: "finished",id: soundName }));
            $.post('https://rcore_radiocar/events', JSON.stringify(
            {
                type: "onEnd",
                id: sound.getName(),
            }));

            var time = 0;
            if(sound.getAudioPlayer() != null){time = sound.getAudioPlayer()._duration;}
            if(sound.getYoutubePlayer() != null){time = sound.getYoutubePlayer().getDuration();}
            $.post('https://rcore_radiocar/events', JSON.stringify(
            {
                type: "resetTimeStamp",
                id: sound.getName(),
                time: time,
            }));
            break;
        }
    }
}

function ended(divId){
    if(divId == null)
    {
    	for (var soundName in soundList)
    	{
            var sound = soundList[soundName];
            if(!sound.isPlaying())
            {
                $.post('https://rcore_radiocar/data_status', JSON.stringify({ type: "finished",id: soundName }));
                $.post('https://rcore_radiocar/events', JSON.stringify(
                {
                    type: "onEnd",
                    id: sound.getName(),
                }));
                if(sound.isLoop()){
                    var time = 0;
                    if(sound.getAudioPlayer() != null){time = sound.getAudioPlayer()._duration;}
                    if(sound.getYoutubePlayer() != null){time = sound.getYoutubePlayer().getDuration();}
                    $.post('https://rcore_radiocar/events', JSON.stringify(
                    {
                        type: "resetTimeStamp",
                        id: sound.getName(),
                        time: time,
                    }));

                    sound.setTimeStamp(0);
                    sound.play();
                }
                break;
            }
    	}
    }
    else
    {
    	for (var soundName in soundList)
    	{
            var sound = soundList[soundName];
            if(sound.getDivId() === divId && !sound.isLoop()){
                $.post('https://rcore_radiocar/data_status', JSON.stringify({ type: "finished",id: soundName }));
                $.post('https://rcore_radiocar/events', JSON.stringify(
                {
                    type: "onEnd",
                    id: sound.getName(),
                }));
                break;
            }
        }
    }
}