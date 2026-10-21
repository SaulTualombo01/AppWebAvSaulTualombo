<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<%
Option Explicit
Response.CharSet = "UTF-8"
Dim PAGE_TITLE : PAGE_TITLE = "My Playlists"
%>
<!--#include file="includes/header.asp"-->
<%
RequireNormalUser
Dim msg : msg = Request.QueryString("msg")
Dim rs : Set rs = QueryDB("SELECT P.ID_PLAYLIST, P.TITLE, P.CREATION_DATE, P.TYPE, P.PHOTO, " & _
    "(SELECT COUNT(*) FROM TBL_PLAYLIST_SONG PS WHERE PS.ID_PLAYLIST = P.ID_PLAYLIST) AS SONGS " & _
    "FROM TBL_PLAYLIST P WHERE P.ID_USER = " & CurrentUserId() & " ORDER BY P.CREATION_DATE DESC")
%>

<% If Len(msg) > 0 Then %><div class="alert alert-ok"><%=H(msg)%></div><% End If %>

<div class="section-head">
    <h2>Mis Playlists (CRUD)</h2>
    <a href="playlist_form.asp" class="btn btn-primary">+ Nueva playlist</a>
</div>

<div class="playlist-grid">
<%
If rs.EOF Then Response.Write "<p>Aun no tienes playlists. Crea la primera.</p>"
Do While Not rs.EOF
%>
    <div class="playlist-card">
        <img src="<%=ImgPath(rs("PHOTO"))%>" alt="<%=H(rs("TITLE"))%>">
        <div class="pc-body">
            <div class="pc-title"><%=H(rs("TITLE"))%></div>
            <div class="pc-meta">
                <%=rs("SONGS")%> canciones &middot; <%=FormatDateTime(rs("CREATION_DATE"), 2)%> &middot;
                <% If CInt(rs("TYPE")) = 0 Then %>
                    <span class="tag tag-public">Publica</span>
                <% Else %>
                    <span class="tag tag-private">Privada</span>
                <% End If %>
            </div>
            <div class="actions">
                <a class="btn btn-lav btn-sm" href="playlist_songs.asp?id=<%=rs("ID_PLAYLIST")%>">Canciones</a>
                <a class="btn btn-ghost btn-sm" href="playlist_form.asp?id=<%=rs("ID_PLAYLIST")%>">Editar</a>
                <a class="btn btn-danger btn-sm" href="playlist_action.asp?action=delete&id=<%=rs("ID_PLAYLIST")%>"
                   onclick="return confirm('Eliminar esta playlist?');">Eliminar</a>
            </div>
        </div>
    </div>
<%
    rs.MoveNext
Loop
rs.Close
%>
</div>

<!--#include file="includes/footer.asp"-->
