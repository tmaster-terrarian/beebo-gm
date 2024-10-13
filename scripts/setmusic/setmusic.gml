function SetMusic(sound_id)
{
    with(gm)
    {
        if(audio_get_name(sound_id) != audio_get_name(current_bgm))
        {
            audio_stop_sound(current_bgm);
            current_bgm = audio_play_sound(sound_id, 100, true);
            return;
        }
        else return;
    }
}
function StopMusic()
{
    with(gm)
    {
        audio_stop_sound(current_bgm);
        return;
    }
}
