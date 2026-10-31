using System;
using System.Data;
using System.Data.SqlClient;

namespace WebAppPoliMusicV2.DAL
{
    public class Song
    {
        private readonly string connectionString;

        public Song(string strConnString) { connectionString = strConnString; }

        public DataTable Read()
        {
            using (SqlConnection connection = new SqlConnection(connectionString))
            using (SqlCommand command = new SqlCommand(
                "SELECT [ID_SONG], [SONG_NAME], [SONG_PATH], ISNULL([PLAYS], 0) AS [PLAYS] " +
                "FROM [dbo].[TBL_SONG] ORDER BY [SONG_NAME], [ID_SONG]", connection))
            using (SqlDataAdapter adapter = new SqlDataAdapter(command))
            {
                DataTable songs = new DataTable();
                adapter.Fill(songs);
                return songs;
            }
        }

        public int Save(Entities.Song song)
        {
            return ExecuteSong("INSERT INTO [dbo].[TBL_SONG] ([SONG_NAME], [SONG_PATH], [PLAYS]) " +
                "VALUES (@NAME, @PATH, @PLAYS)", song, false);
        }

        public int Update(Entities.Song song)
        {
            return ExecuteSong("UPDATE [dbo].[TBL_SONG] SET [SONG_NAME] = @NAME, " +
                "[SONG_PATH] = @PATH, [PLAYS] = @PLAYS WHERE [ID_SONG] = @ID", song, true);
        }

        private int ExecuteSong(string sql, Entities.Song song, bool includeId)
        {
            using (SqlConnection connection = new SqlConnection(connectionString))
            using (SqlCommand command = new SqlCommand(sql, connection))
            {
                command.Parameters.Add("@NAME", SqlDbType.NVarChar, -1).Value = song.SongName;
                command.Parameters.Add("@PATH", SqlDbType.NVarChar, -1).Value = song.SongPath;
                command.Parameters.Add("@PLAYS", SqlDbType.Int).Value = song.Plays;
                if (includeId) command.Parameters.Add("@ID", SqlDbType.Int).Value = song.ID;
                connection.Open();
                return command.ExecuteNonQuery();
            }
        }

        public int Delete(int id)
        {
            using (SqlConnection connection = new SqlConnection(connectionString))
            using (SqlCommand command = new SqlCommand(
                "DELETE FROM [dbo].[TBL_SONG] WHERE [ID_SONG] = @ID", connection))
            {
                command.Parameters.Add("@ID", SqlDbType.Int).Value = id;
                connection.Open();
                return command.ExecuteNonQuery();
            }
        }

        // Incremento atómico para no perder reproducciones simultáneas.
        public int RegisterPlay(int id)
        {
            using (SqlConnection connection = new SqlConnection(connectionString))
            using (SqlCommand command = new SqlCommand(
                "UPDATE [dbo].[TBL_SONG] SET [PLAYS] = ISNULL([PLAYS], 0) + 1 " +
                "OUTPUT INSERTED.[PLAYS] WHERE [ID_SONG] = @ID", connection))
            {
                command.Parameters.Add("@ID", SqlDbType.Int).Value = id;
                connection.Open();
                object result = command.ExecuteScalar();
                return result == null || result == DBNull.Value ? -1 : Convert.ToInt32(result);
            }
        }
    }
}
