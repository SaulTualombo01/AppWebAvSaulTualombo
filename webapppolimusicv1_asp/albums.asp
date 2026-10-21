<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<%
Option Explicit
Response.CharSet = "UTF-8"
Dim PAGE_TITLE : PAGE_TITLE = "Albums"
%>
<!--#include file="includes/header.asp"-->
<%
RequireAdmin
Dim msg : msg = Request.QueryString("msg")
Dim rs : Set rs = QueryDB("SELECT A.ID_ALBUM, A.TITLE_ALBUM, A.RELEASE_YEAR, A.ALBUM_IMAGE_PATH, " & _
    "(SELECT COUNT(*) FROM TBL_TRACKLIST T WHERE T.ID_ALBUM = A.ID_ALBUM) AS SONGS " & _
    "FROM TBL_ALBUM A ORDER BY A.TITLE_ALBUM")
%>

<% If Len(msg) > 0 Then %><div class="alert alert-ok"><%=H(msg)%></div><% End If %>

<div class="section-head">
    <h2>Albumes (CRUD)</h2>
    <a href="album_form.asp" class="btn btn-primary">+ Nuevo album</a>
</div>

<div class="table-wrap">
<table class="data">
    <thead>
        <tr><th>ID</th><th>Portada</th><th>Titulo</th><th>Ano</th><th>Canciones</th><th>Acciones</th></tr>
    </thead>
    <tbody>
    <% Do While Not rs.EOF %>
        <tr>
            <td><%=rs("ID_ALBUM")%></td>
            <td><img class="thumb" src="<%=ImgPath(rs("ALBUM_IMAGE_PATH"))%>" alt=""></td>
            <td><%=H(rs("TITLE_ALBUM"))%></td>
            <td><%=rs("RELEASE_YEAR")%></td>
            <td><%=rs("SONGS")%></td>
            <td class="actions">
                <a class="btn btn-lav btn-sm" href="album_songs.asp?id=<%=rs("ID_ALBUM")%>">Tracklist</a>
                <a class="btn btn-ghost btn-sm" href="album_form.asp?id=<%=rs("ID_ALBUM")%>">Editar</a>
                <a class="btn btn-danger btn-sm" href="album_action.asp?action=delete&id=<%=rs("ID_ALBUM")%>"
                   onclick="return confirm('Eliminar este album?');">Eliminar</a>
            </td>
        </tr>
    <%
        rs.MoveNext
    Loop
    rs.Close
    %>
    </tbody>
</table>
</div>

<!--#include file="includes/footer.asp"-->
