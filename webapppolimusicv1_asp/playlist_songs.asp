<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<%
Option Explicit
Response.CharSet = "UTF-8"
Dim PAGE_TITLE : PAGE_TITLE = "Playlist"
%>
<!--#include file="includes/header.asp"-->
<%
RequireNormalUser
Dim uid : uid = CurrentUserId()
Dim plId : plId = SafeInt(Request.QueryString("id"))
If plId = 0 Then Response.Redirect "playlists.asp"

' Verificar propiedad de la playlist
Dim rsP : Set rsP = QueryDB("SELECT * FROM TBL_PLAYLIST WHERE ID_PLAYLIST=" & plId & " AND ID_USER=" & uid)
If rsP.EOF Then Response.Redirect "playlists.asp"

' Acciones sobre las canciones de la playlist
Dim act : act = Request.QueryString("action")
If act = "add" Then
    Dim addSong : addSong = SafeInt(Request.Form("song_id"))
    If addSong > 0 Then
        On Error Resume Next
        ExecDB "IF NOT EXISTS (SELECT 1 FROM TBL_PLAYLIST_SONG WHERE ID_PLAYLIST=" & plId & _
               " AND ID_SONG=" & addSong & ") INSERT INTO TBL_PLAYLIST_SONG (ID_PLAYLIST, ID_SONG) VALUES(" & _
               plId & "," & addSong & ")"
        On Error GoTo 0
    End If
    Response.Redirect "playlist_songs.asp?id=" & plId
    Response.End
ElseIf act = "remove" Then
    Dim remSong : remSong = SafeInt(Request.QueryString("song"))
    ExecDB "DELETE FROM TBL_PLAYLIST_SONG WHERE ID_PLAYLIST=" & plId & " AND ID_SONG=" & remSong
    Response.Redirect "playlist_songs.asp?id=" & plId
    Response.End
End If

Dim rsSongs, rsAll
Set rsSongs = QueryDB("SELECT S.ID_SONG, S.SONG_NAME, S.SONG_PATH, S.PLAYS FROM TBL_PLAYLIST_SONG PS " & _
    "JOIN TBL_SONG S ON S.ID_SONG = PS.ID_SONG WHERE PS.ID_PLAYLIST = " & plId & " ORDER BY S.SONG_NAME")
Set rsAll = QueryDB("SELECT ID_SONG, SONG_NAME FROM TBL_SONG WHERE ID_SONG NOT IN " & _
    "(SELECT ID_SONG FROM TBL_PLAYLIST_SONG WHERE ID_PLAYLIST = " & plId & ") ORDER BY SONG_NAME")
%>

<div class="section-head">
    <h2>Playlist: <%=H(rsP("TITLE"))%></h2>
    <a href="playlists.asp" class="btn btn-ghost btn-sm">Volver</a>
</div>

<form class="form-card" method="post" action="playlist_songs.asp?id=<%=plId%>&action=add" style="margin-bottom:24px;">
    <div class="form-group">
        <label>Agregar cancion a la playlist</label>
        <select class="form-control" name="song_id">
            <% Do While Not rsAll.EOF %>
                <option value="<%=rsAll("ID_SONG")%>"><%=H(rsAll("SONG_NAME"))%></option>
            <%
                rsAll.MoveNext
            Loop
            rsAll.Close
            %>
        </select>
    </div>
    <button type="submit" class="btn btn-primary">Agregar</button>
</form>

<div class="table-wrap">
<table class="data">
    <thead><tr><th>ID</th><th>Cancion</th><th>Plays</th><th>Acciones</th></tr></thead>
    <tbody>
    <%
    If rsSongs.EOF Then
        Response.Write "<tr><td colspan=""4"">Playlist vacia. Agrega canciones arriba.</td></tr>"
    End If
    Do While Not rsSongs.EOF
    %>
        <tr>
            <td><%=rsSongs("ID_SONG")%></td>
            <td><%=H(rsSongs("SONG_NAME"))%></td>
            <td><%=rsSongs("PLAYS")%></td>
            <td class="actions">
                <button class="btn btn-lav btn-sm"
                    onclick="playSong(<%=rsSongs("ID_SONG")%>, '<%=Replace(H(rsSongs("SONG_NAME")),"'","\'")%>', '', '<%=WebPath(rsSongs("SONG_PATH"))%>')">&#9654;</button>
                <a class="btn btn-danger btn-sm" href="playlist_songs.asp?id=<%=plId%>&action=remove&song=<%=rsSongs("ID_SONG")%>"
                   onclick="return confirm('Quitar de la playlist?');">Quitar</a>
            </td>
        </tr>
    <%
        rsSongs.MoveNext
    Loop
    rsSongs.Close
    rsP.Close
    %>
    </tbody>
</table>
</div>

<!--#include file="includes/footer.asp"-->
