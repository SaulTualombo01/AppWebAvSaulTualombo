<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<%
Option Explicit
Response.CharSet = "UTF-8"
Dim PAGE_TITLE : PAGE_TITLE = "Playlist"
%>
<!--#include file="includes/header.asp"-->
<%
RequireNormalUser
Dim id, title, ptype, photo
id = SafeInt(Request.QueryString("id"))
title = "" : ptype = 0 : photo = "~/PlaylistImages/default.jpg"

If id > 0 Then
    ' Solo el propietario puede editar su playlist
    Dim rs : Set rs = QueryDB("SELECT * FROM TBL_PLAYLIST WHERE ID_PLAYLIST = " & id & _
                              " AND ID_USER = " & CurrentUserId())
    If Not rs.EOF Then
        title = rs("TITLE") : ptype = CInt(rs("TYPE")) : photo = rs("PHOTO") & ""
    Else
        Response.Redirect "playlists.asp"
    End If
    rs.Close
End If
%>

<div class="section-head">
    <h2><% If id > 0 Then %>Editar playlist #<%=id%><% Else %>Nueva playlist<% End If %></h2>
    <a href="playlists.asp" class="btn btn-ghost btn-sm">Volver</a>
</div>

<form class="form-card" method="post" action="playlist_action.asp">
    <input type="hidden" name="id" value="<%=id%>">
    <div class="form-group">
        <label>Titulo</label>
        <input class="form-control" type="text" name="title" value="<%=H(title)%>" maxlength="50" required>
    </div>
    <div class="form-group">
        <label>Tipo</label>
        <select class="form-control" name="type">
            <option value="0" <% If ptype = 0 Then %>selected<% End If %>>Publica</option>
            <option value="1" <% If ptype = 1 Then %>selected<% End If %>>Privada</option>
        </select>
    </div>
    <div class="form-group">
        <label>Ruta de la foto (ej. ~/PlaylistImages/playlist1.png)</label>
        <input class="form-control" type="text" name="photo" value="<%=H(photo)%>" maxlength="255">
    </div>
    <button type="submit" class="btn btn-primary">Guardar</button>
</form>

<!--#include file="includes/footer.asp"-->
