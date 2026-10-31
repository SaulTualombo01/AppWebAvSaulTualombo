namespace WebAppPoliMusicV2.Entities
{
    public class Song
    {
        public Song() { }

        public Song(int id, string songName, string songPath, int plays)
        {
            ID = id;
            SongName = songName;
            SongPath = songPath;
            Plays = plays;
        }

        // Correspondencia: ID_SONG, SONG_NAME, SONG_PATH y PLAYS.
        public int ID { get; set; }
        public string SongName { get; set; }
        public string SongPath { get; set; }
        public int Plays { get; set; }
    }
}
