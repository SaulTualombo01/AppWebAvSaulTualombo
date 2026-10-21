<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<%
Option Explicit
Response.CharSet = "UTF-8"
Dim PAGE_TITLE : PAGE_TITLE = "Tracklist"
%>
<!--#include file="includes/header.asp"-->
<%
RequireAdmin
Dim albumId : albumId = SafeInt(Request.QueryString("id"))
If albumId = 0 Then Response.Redirect "albums.asp"

' Acciones del tracklist
Dim act : act = Request.QueryString("action")
If act = "add" Then
    Dim addSong : addSong = SafeInt(Request.Form("song_id"))
    If addSong > 0 Then
        On Error Resume Next
        ExecDB "IF NOT EXISTS (SELECT 1 FROM TBL_TRACKLIST WHERE ID_ALBUM=" & albumId & _
               " AND ID_SONG=" & addSong & ") INSERT INTO TBL_TRACKLIST (ID_ALBUM, ID_SONG) VALUES(" & _
               albumId & "," & addSong & ")"
        On Error GoTo 0
    End If
    Response.Redirect "album_songs.asp?id=" & albumId
    Response.End
ElseIf act = "remove" Then
    Dim remSong : remSong = SafeInt(Request.QueryString("song"))
    ExecDB "DELETE FROM TBL_TRACKLIST WHERE ID_ALBUM=" & albumId & " AND ID_SONG=" & remSong
    Response.Redirect "album_songs.asp?id=" & albumId
    Response.End
End If

Dim rsA : Set rsA = QueryDB("SELECT * FROM TBL_ALBUM WHERE ID_ALBUM = " & albumId)
If rsA.EOF Then Response.Redirect "albums.asp"

Dim rsSongs, rsAll
Set rsSongs = QueryDB("SELECT S.ID_SONG, S.SONG_NAME, S.SONG_PATH FROM TBL_TRACKLIST T " & _
    "JOIN TBL_SONG S ON S.ID_SONG = T.ID_SONG WHERE T.ID_ALBUM = " & albumId & " ORDER BY S.SONG_NAME")
Set rsAll = QueryDB("SELECT ID_SONG, SONG_NAME FROM TBL_SONG WHERE ID_SONG NOT IN " & _
    "(SELECT ID_SONG FROM TBL_TRACKLIST WHERE ID_ALBUM = " & albumId & ") ORDER BY SONG_NAME")
%>

<div class="section-head">
    <h2>Tracklist: <%=H(rsA("TITLE_ALBUM"))%></h2>
    <a href="albums.asp" class="btn btn-ghost btn-sm">Volver</a>
</div>

<form class="form-card" method="post" action="album_songs.asp?id=<%=albumId%>&action=add" style="margin-bottom:24px;">
    <div class="form-group">
        <label>Agregar cancion al album</label>
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
    <thead><tr><th>ID</th><th>Cancion</th><th>Archivo</th><th>Acciones</th></tr></thead>
    <tbody>
    <% Do While Not rsSongs.EOF %>
        <tr>
            <td><%=rsSongs("ID_SONG")%></td>
            <td><%=H(rsSongs("SONG_NAME"))%></td>
            <td><%=H(rsSongs("SONG_PATH"))%></td>
            <td class="actions">
                <button class="btn btn-lav btn-sm"
                    onclick="playSong(<%=rsSongs("ID_SONG")%>, '<%=Replace(H(rsSongs("SONG_NAME")),"'","\'")%>', '', '<%=WebPath(rsSongs("SONG_PATH"))%>')">&#9654;</button>
                <a class="btn btn-danger btn-sm" href="album_songs.asp?id=<%=albumId%>&action=remove&song=<%=rsSongs("ID_SONG")%>"
                   onclick="return confirm('Quitar del album?');">Quitar</a>
            </td>
        </tr>
    <%
        rsSongs.MoveNext
    Loop
    rsSongs.Close
    rsA.Close
    %>
    </tbody>
</table>
</div>

<!--#include file="includes/footer.asp"-->
