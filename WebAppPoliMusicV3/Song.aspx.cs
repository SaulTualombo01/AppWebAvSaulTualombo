using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using System.IO;
using System.Web;
using System.Web.Security;

namespace WebAppPoliMusicV3
{
    public partial class Song : System.Web.UI.Page
    {
        protected string PlayToken { get; private set; }
        protected string PhotoUrl { get; private set; }
        protected string DisplayName { get; private set; }
        protected int SongCount { get; private set; }
        protected string TotalPlays { get; private set; }

        protected void Page_Load(object sender, EventArgs e)
        {
            Response.Cache.SetCacheability(HttpCacheability.NoCache);
            Response.Cache.SetNoStore();
            EntityLayer.PoliMusicV3.User user = Session[EntityLayer.PoliMusicV3.Util.Constants.USER] as EntityLayer.PoliMusicV3.User;
            bool playRequest = Request.HttpMethod == "POST" && Request.Form["action"] == "play";
            if (!Request.IsAuthenticated || user == null)
            {
                if (playRequest) { WritePlayResponse(403, "{\"error\":\"session\"}"); return; }
                jsonResponse = true;
                FormsAuthentication.SignOut();
                Response.Redirect("~/Login.aspx?ReturnUrl=" + HttpUtility.UrlEncode(ResolveUrl("~/Song.aspx")), false);
                Context.ApplicationInstance.CompleteRequest();
                return;
            }

            if (Session["SongPlayToken"] == null) Session["SongPlayToken"] = Guid.NewGuid().ToString("N");
            PlayToken = (string)Session["SongPlayToken"];
            DisplayName = user.UserName;
            PhotoUrl = ResolveUrl("~/UserImages/default.jpg");
            string photo = user.Photo;
            if (!String.IsNullOrEmpty(photo) && photo.StartsWith("~/UserImages/", StringComparison.OrdinalIgnoreCase)
                && photo.Substring(13).IndexOfAny(new[] { (char)47, (char)92, (char)58, (char)37 }) < 0
                && File.Exists(Server.MapPath(photo))) PhotoUrl = ResolveUrl(photo);
            if (playRequest) { RegisterPlay(); return; }
            if (!IsPostBack) LoadSongs();
        }

        private BLL.PoliMusicV3.Song CreateService()
        {
            return new BLL.PoliMusicV3.Song(ConfigurationManager.ConnectionStrings["BDD_PoliMusicConnectionString"].ConnectionString);
        }

        private void LoadSongs()
        {
            try
            {
                DataTable songs = CreateService().Read();
                songs.Columns.Add("AUDIO_URL", typeof(string));
                songs.Columns.Add("AVAILABLE", typeof(bool));
                long plays = 0;
                foreach (DataRow row in songs.Rows)
                {
                    string path = Convert.ToString(row["SONG_PATH"]);
                    bool available = BLL.PoliMusicV3.Song.IsValidSongPath(path) && File.Exists(Server.MapPath(path));
                    row["AVAILABLE"] = available;
                    row["AUDIO_URL"] = available ? ResolveUrl(path) : String.Empty;
                    plays += Convert.ToInt32(row["PLAYS"]);
                }
                SongCount = songs.Rows.Count;
                TotalPlays = plays.ToString("N0", CultureInfo.GetCultureInfo("es-EC"));
                songList.DataSource = songs;
                songList.DataBind();
                emptyState.Visible = SongCount == 0;
                songTable.Visible = SongCount > 0;
            }
            catch (SqlException exception)
            {
                Trace.Warn("Song", "No se pudo consultar el catálogo.", exception);
                loadError.Visible = true;
                songTable.Visible = false;
                TotalPlays = "—";
            }
        }

        private void RegisterPlay()
        {
            int id;
            if (Request.Form["token"] != PlayToken || !Int32.TryParse(Request.Form["id"], out id) || id <= 0)
            {
                WritePlayResponse(400, "{\"error\":\"request\"}");
                return;
            }
            try
            {
                int plays = CreateService().RegisterPlay(id);
                WritePlayResponse(plays < 0 ? 404 : 200, "{\"plays\":" + plays.ToString(CultureInfo.InvariantCulture) + "}");
            }
            catch (SqlException exception)
            {
                Trace.Warn("Song", "No se pudo registrar la reproducción.", exception);
                WritePlayResponse(503, "{\"error\":\"database\"}");
            }
        }

        private bool jsonResponse;
        private void WritePlayResponse(int status, string json)
        {
            jsonResponse = true;
            Response.Clear();
            Response.StatusCode = status;
            Response.ContentType = "application/json";
            Response.TrySkipIisCustomErrors = true;
            Response.SuppressFormsAuthenticationRedirect = true;
            Response.Write(json);
            Context.ApplicationInstance.CompleteRequest();
        }

        protected override void Render(System.Web.UI.HtmlTextWriter writer)
        {
            if (!jsonResponse) base.Render(writer);
        }

        protected string Encode(object value) { return HttpUtility.HtmlEncode(Convert.ToString(value)); }
    }
}

