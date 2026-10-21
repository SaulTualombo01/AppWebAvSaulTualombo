<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<%
Option Explicit
Response.CharSet = "UTF-8"
Dim PAGE_TITLE : PAGE_TITLE = "Artists"
%>
<!--#include file="includes/header.asp"-->
<%
RequireAdmin
Dim msg : msg = Request.QueryString("msg")
Dim rs : Set rs = QueryDB("SELECT ID_ARTIST, ARTIST_NAME, ARTIST_LASTNAME, ARTIST_IMAGE FROM TBL_ARTIST ORDER BY ARTIST_NAME")
%>

<% If Len(msg) > 0 Then %><div class="alert alert-ok"><%=H(msg)%></div><% End If %>

<div class="section-head">
    <h2>Artistas (CRUD)</h2>
    <a href="artist_form.asp" class="btn btn-primary">+ Nuevo artista</a>
</div>

<div class="table-wrap">
<table class="data">
    <thead>
        <tr><th>ID</th><th>Foto</th><th>Nombre</th><th>Apellido</th><th>Acciones</th></tr>
    </thead>
    <tbody>
    <% Do While Not rs.EOF %>
        <tr>
            <td><%=rs("ID_ARTIST")%></td>
            <td><img class="thumb" src="<%=ImgPath(rs("ARTIST_IMAGE"))%>" alt=""></td>
            <td><%=H(rs("ARTIST_NAME"))%></td>
            <td><%=H(rs("ARTIST_LASTNAME"))%></td>
            <td class="actions">
                <a class="btn btn-ghost btn-sm" href="artist_form.asp?id=<%=rs("ID_ARTIST")%>">Editar</a>
                <a class="btn btn-danger btn-sm" href="artist_action.asp?action=delete&id=<%=rs("ID_ARTIST")%>"
                   onclick="return confirm('Eliminar este artista?');">Eliminar</a>
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
