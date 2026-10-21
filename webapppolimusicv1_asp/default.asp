<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<%
Option Explicit
Response.CharSet = "UTF-8"
Dim PAGE_TITLE : PAGE_TITLE = "Home"
%>
<!--#include file="includes/header.asp"-->
<%
Dim errMsg : errMsg = Request.QueryString("err")

' Listado de canciones con sus artistas (TBL_PLAYER) y album (TBL_TRACKLIST)
Dim sql, rs
sql = "SELECT s.ID_SONG, s.SONG_NAME, s.SONG_PATH, s.PLAYS, " & _
      "STUFF((SELECT ', ' + a.ARTIST_NAME + ' ' + ISNULL(a.ARTIST_LASTNAME,'') " & _
      "       FROM TBL_PLAYER p JOIN TBL_ARTIST a ON a.ID_ARTIST = p.ID_ARTIST " & _
      "       WHERE p.ID_SONG = s.ID_SONG FOR XML PATH('')), 1, 2, '') AS ARTISTS, " & _
      "(SELECT TOP 1 al.ALBUM_IMAGE_PATH FROM TBL_TRACKLIST t " & _
      " JOIN TBL_ALBUM al ON al.ID_ALBUM = t.ID_ALBUM " & _
      " WHERE t.ID_SONG = s.ID_SONG) AS COVER " & _
      "FROM TBL_SONG s ORDER BY s.PLAYS DESC, s.SONG_NAME"
Set rs = QueryDB(sql)
%>

<% If Len(errMsg) > 0 Then %>
    <div class="alert alert-err"><%=H(errMsg)%></div>
<% End If %>

<!-- Bienvenida con el nombre del usuario leido de la variable de sesion -->
<section class="hero">
    <h1>Bienvenido, <span class="accent"><%=H(Session("USERNAME"))%></span> &#9835;</h1>
    <p>Nos alegra verte de nuevo en PoliMusic. Dale play a tus canciones favoritas.</p>
</section>

<div class="section-head">
    <h2>Song List</h2>
    <span class="plays-badge">A continuacion se presenta el listado de canciones</span>
</div>

<div class="song-grid">
<%
If rs.EOF Then
    Response.Write "<p>No hay canciones registradas.</p>"
End If
Do While Not rs.EOF
    Dim coverPath, artistTxt
    coverPath = rs("COVER") & ""
    If Len(coverPath) = 0 Then coverPath = "~/PlaylistImages/default.jpg"
    artistTxt = rs("ARTISTS") & ""
%>
    <div class="song-card" id="song-<%=rs("ID_SONG")%>">
        <img class="song-cover" src="<%=ImgPath(coverPath)%>" alt="<%=H(rs("SONG_NAME"))%>">
        <div class="song-title"><%=H(rs("SONG_NAME"))%></div>
        <div class="song-artist"><%=H(artistTxt)%></div>
        <div class="song-meta">
            <span class="plays-badge">&#9654; <%=rs("PLAYS")%> plays</span>
            <button class="play-btn" title="Reproducir"
                onclick="playSong(<%=rs("ID_SONG")%>, '<%=Replace(H(rs("SONG_NAME")),"'","\'")%>', '<%=Replace(H(artistTxt),"'","\'")%>', '<%=WebPath(rs("SONG_PATH"))%>')">&#9654;</button>
        </div>
    </div>
<%
    rs.MoveNext
Loop
rs.Close
%>
</div>

<!--#include file="includes/footer.asp"-->
