using System;
using System.Data;
using System.IO;

namespace WebAppPoliMusicV2.BLL
{
    public class Song
    {
        private readonly DAL.Song repository;

        public Song(string strConnString) { repository = new DAL.Song(strConnString); }
        public DataTable Read() { return repository.Read(); }

        public int Save(Entities.Song song)
        {
            Validate(song);
            return repository.Save(song);
        }

        public int Update(Entities.Song song)
        {
            Validate(song);
            ValidateId(song.ID);
            return repository.Update(song);
        }

        public int Delete(int id)
        {
            ValidateId(id);
            return repository.Delete(id);
        }

        public int RegisterPlay(int id)
        {
            ValidateId(id);
            return repository.RegisterPlay(id);
        }

        private static void ValidateId(int id)
        {
            if (id <= 0) throw new ArgumentException("El identificador debe ser mayor que cero.", "id");
        }

        private static void Validate(Entities.Song song)
        {
            if (song == null) throw new ArgumentNullException("song");
            if (song.SongName == null || song.SongName.Trim().Length == 0)
                throw new ArgumentException("Escribe el nombre de la canción.", "song");
            if (!IsValidSongPath(song.SongPath))
                throw new ArgumentException("Usa una ruta de audio dentro de ~/SongFiles/.", "song");
            if (song.Plays < 0) throw new ArgumentException("Las reproducciones no pueden ser negativas.", "song");
        }

        public static bool IsValidSongPath(string path)
        {
            if (String.IsNullOrEmpty(path) || !path.StartsWith("~/SongFiles/", StringComparison.OrdinalIgnoreCase))
                return false;
            string fileName = path.Substring("~/SongFiles/".Length);
            if (fileName.Length == 0 || fileName.IndexOfAny(new char[] { '/', '\\', ':', '?', '#', '%' }) >= 0
                || fileName.IndexOfAny(Path.GetInvalidFileNameChars()) >= 0) return false;
            string extension = Path.GetExtension(fileName).ToLowerInvariant();
            return extension == ".mp3" || extension == ".ogg" || extension == ".wav"
                || extension == ".m4a" || extension == ".aac";
        }
    }
}
