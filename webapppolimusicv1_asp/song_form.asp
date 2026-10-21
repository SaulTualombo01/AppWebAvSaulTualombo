<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<%
Option Explicit
Response.CharSet = "UTF-8"
Dim PAGE_TITLE : PAGE_TITLE = "Cancion"
%>
<!--#include file="includes/header.asp"-->
<%
RequireAdmin
Dim id, name, path, plays
id = SafeInt(Request.QueryString("id"))
name = "" : path = "~/songFiles/" : plays = 0

If id > 0 Then
    Dim rs : Set rs = QueryDB("SELECT * FROM TBL_SONG WHERE ID_SONG = " & id)
    If Not rs.EOF Then
        name = rs("SONG_NAME") : path = rs("SONG_PATH") : plays = rs("PLAYS")
    Else
        Response.Redirect "songs.asp"
    End If
    rs.Close
End If
%>

<div class="section-head">
    <h2><% If id > 0 Then %>Editar cancion #<%=id%><% Else %>Nueva cancion<% End If %></h2>
    <a href="songs.asp" class="btn btn-ghost btn-sm">Volver</a>
</div>

<form class="form-card" method="post" action="song_action.asp">
    <input type="hidden" name="id" value="<%=id%>">
    <div class="form-group">
        <label>Nombre de la cancion</label>
        <input class="form-control" type="text" name="song_name" value="<%=H(name)%>" maxlength="50" required>
    </div>
    <div class="form-group">
        <label>Ruta del archivo (ej. ~/songFiles/bensound-adventure.mp3)</label>
        <input class="form-control" type="text" name="song_path" value="<%=H(path)%>" maxlength="255" required>
    </div>
    <div class="form-group">
        <label>Reproducciones</label>
        <input class="form-control" type="number" name="plays" value="<%=plays%>" min="0">
    </div>
    <button type="submit" class="btn btn-primary">Guardar</button>
</form>

<!--#include file="includes/footer.asp"-->
