using System;
using System.Data;
using System.Data.SqlClient;

namespace DAL.PoliMusicV3
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

