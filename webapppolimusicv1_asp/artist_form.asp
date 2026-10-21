<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<%
Option Explicit
Response.CharSet = "UTF-8"
Dim PAGE_TITLE : PAGE_TITLE = "Artista"
%>
<!--#include file="includes/header.asp"-->
<%
RequireAdmin
Dim id, name, lastname, image
id = SafeInt(Request.QueryString("id"))
name = "" : lastname = "" : image = "~/ArtistImages/"

If id > 0 Then
    Dim rs : Set rs = QueryDB("SELECT * FROM TBL_ARTIST WHERE ID_ARTIST = " & id)
    If Not rs.EOF Then
        name = rs("ARTIST_NAME") : lastname = rs("ARTIST_LASTNAME") & "" : image = rs("ARTIST_IMAGE") & ""
    Else
        Response.Redirect "artists.asp"
    End If
    rs.Close
End If
%>

<div class="section-head">
    <h2><% If id > 0 Then %>Editar artista #<%=id%><% Else %>Nuevo artista<% End If %></h2>
    <a href="artists.asp" class="btn btn-ghost btn-sm">Volver</a>
</div>

<form class="form-card" method="post" action="artist_action.asp">
    <input type="hidden" name="id" value="<%=id%>">
    <div class="form-group">
        <label>Nombre</label>
        <input class="form-control" type="text" name="artist_name" value="<%=H(name)%>" maxlength="100" required>
    </div>
    <div class="form-group">
        <label>Apellido</label>
        <input class="form-control" type="text" name="artist_lastname" value="<%=H(lastname)%>" maxlength="100">
    </div>
    <div class="form-group">
        <label>Ruta de la imagen (ej. ~/ArtistImages/artist1.jpg)</label>
        <input class="form-control" type="text" name="artist_image" value="<%=H(image)%>" maxlength="255">
    </div>
    <button type="submit" class="btn btn-primary">Guardar</button>
</form>

<!--#include file="includes/footer.asp"-->
