<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<% Option Explicit %>
<!--#include file="includes/db.asp"-->
<!--#include file="includes/auth.asp"-->
<%
Response.CharSet = "UTF-8"
RequireAdmin

Dim action : action = Request.QueryString("action")

If action = "delete" Then
    Dim delId : delId = SafeInt(Request.QueryString("id"))
    If delId > 0 Then
        On Error Resume Next
        ExecDB "DELETE FROM TBL_TRACKLIST WHERE ID_ALBUM = " & delId
        ExecDB "DELETE FROM TBL_ALBUM WHERE ID_ALBUM = " & delId
        On Error GoTo 0
    End If
    Response.Redirect "albums.asp?msg=" & Server.URLEncode("Album eliminado")
    Response.End
End If

Dim id, title, year, image
id = SafeInt(Request.Form("id"))
title = SafeStr(Trim(Request.Form("title_album")))
image = SafeStr(Trim(Request.Form("album_image_path")))

If Len(title) = 0 Then Response.Redirect "album_form.asp?id=" & id

Dim yearSql, imageSql
If IsNumeric(Request.Form("release_year")) And Len(Request.Form("release_year")) > 0 Then
    yearSql = CLng(Request.Form("release_year"))
Else
    yearSql = "NULL"
End If
If Len(image) = 0 Then imageSql = "NULL" Else imageSql = "'" & image & "'"

If id > 0 Then
    ExecDB "UPDATE TBL_ALBUM SET TITLE_ALBUM='" & title & "', RELEASE_YEAR=" & yearSql & _
           ", ALBUM_IMAGE_PATH=" & imageSql & " WHERE ID_ALBUM=" & id
    Response.Redirect "albums.asp?msg=" & Server.URLEncode("Album actualizado")
Else
    ExecDB "INSERT INTO TBL_ALBUM (TITLE_ALBUM, RELEASE_YEAR, ALBUM_IMAGE_PATH) VALUES('" & _
           title & "'," & yearSql & "," & imageSql & ")"
    Response.Redirect "albums.asp?msg=" & Server.URLEncode("Album creado")
End If
%>
