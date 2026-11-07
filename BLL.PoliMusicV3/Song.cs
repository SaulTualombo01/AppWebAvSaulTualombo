using System;
using System.Data;
using System.IO;

namespace BLL.PoliMusicV3
{
    public class Song
    {
        private readonly DAL.PoliMusicV3.Song repository;

        public Song(string strConnString) { repository = new DAL.PoliMusicV3.Song(strConnString); }
        public DataTable Read() { return repository.Read(); }

        public int RegisterPlay(int id)
        {
            ValidateId(id);
            return repository.RegisterPlay(id);
        }

        private static void ValidateId(int id)
        {
            if (id <= 0) throw new ArgumentException("El identificador debe ser mayor que cero.", "id");
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

