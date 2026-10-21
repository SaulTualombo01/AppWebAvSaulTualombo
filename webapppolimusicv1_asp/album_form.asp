<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<%
Option Explicit
Response.CharSet = "UTF-8"
Dim PAGE_TITLE : PAGE_TITLE = "Album"
%>
<!--#include file="includes/header.asp"-->
<%
RequireAdmin
Dim id, title, year, image
id = SafeInt(Request.QueryString("id"))
title = "" : year = "" : image = "~/albumImages/"

If id > 0 Then
    Dim rs : Set rs = QueryDB("SELECT * FROM TBL_ALBUM WHERE ID_ALBUM = " & id)
    If Not rs.EOF Then
        title = rs("TITLE_ALBUM") : year = rs("RELEASE_YEAR") & "" : image = rs("ALBUM_IMAGE_PATH") & ""
    Else
        Response.Redirect "albums.asp"
    End If
    rs.Close
End If
%>

<div class="section-head">
    <h2><% If id > 0 Then %>Editar album #<%=id%><% Else %>Nuevo album<% End If %></h2>
    <a href="albums.asp" class="btn btn-ghost btn-sm">Volver</a>
</div>

<form class="form-card" method="post" action="album_action.asp">
    <input type="hidden" name="id" value="<%=id%>">
    <div class="form-group">
        <label>Titulo del album</label>
        <input class="form-control" type="text" name="title_album" value="<%=H(title)%>" maxlength="50" required>
    </div>
    <div class="form-group">
        <label>Ano de lanzamiento</label>
        <input class="form-control" type="number" name="release_year" value="<%=H(year)%>" min="1900" max="2100">
    </div>
    <div class="form-group">
        <label>Ruta de la portada (ej. ~/albumImages/album1.png)</label>
        <input class="form-control" type="text" name="album_image_path" value="<%=H(image)%>" maxlength="255">
    </div>
    <button type="submit" class="btn btn-primary">Guardar</button>
</form>

<!--#include file="includes/footer.asp"-->
