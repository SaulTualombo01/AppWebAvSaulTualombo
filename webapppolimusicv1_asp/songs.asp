<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<%
Option Explicit
Response.CharSet = "UTF-8"
Dim PAGE_TITLE : PAGE_TITLE = "Songs"
%>
<!--#include file="includes/header.asp"-->
<%
RequireAdmin
Dim msg : msg = Request.QueryString("msg")
Dim rs : Set rs = QueryDB("SELECT ID_SONG, SONG_NAME, SONG_PATH, PLAYS FROM TBL_SONG ORDER BY SONG_NAME")
%>

<% If Len(msg) > 0 Then %><div class="alert alert-ok"><%=H(msg)%></div><% End If %>

<div class="section-head">
    <h2>Canciones (CRUD)</h2>
    <a href="song_form.asp" class="btn btn-primary">+ Nueva cancion</a>
</div>

<div class="table-wrap">
<table class="data">
    <thead>
        <tr><th>ID</th><th>Nombre</th><th>Archivo</th><th>Plays</th><th>Acciones</th></tr>
    </thead>
    <tbody>
    <% Do While Not rs.EOF %>
        <tr>
            <td><%=rs("ID_SONG")%></td>
            <td><%=H(rs("SONG_NAME"))%></td>
            <td><%=H(rs("SONG_PATH"))%></td>
            <td><%=rs("PLAYS")%></td>
            <td class="actions">
                <button class="btn btn-lav btn-sm"
                    onclick="playSong(<%=rs("ID_SONG")%>, '<%=Replace(H(rs("SONG_NAME")),"'","\'")%>', '', '<%=WebPath(rs("SONG_PATH"))%>')">&#9654;</button>
                <a class="btn btn-ghost btn-sm" href="song_form.asp?id=<%=rs("ID_SONG")%>">Editar</a>
                <a class="btn btn-danger btn-sm" href="song_action.asp?action=delete&id=<%=rs("ID_SONG")%>"
                   onclick="return confirm('Eliminar esta cancion?');">Eliminar</a>
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
