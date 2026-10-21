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
        ExecDB "DELETE FROM TBL_PLAYER WHERE ID_ARTIST = " & delId
        ExecDB "DELETE FROM TBL_ARTIST WHERE ID_ARTIST = " & delId
        On Error GoTo 0
    End If
    Response.Redirect "artists.asp?msg=" & Server.URLEncode("Artista eliminado")
    Response.End
End If

Dim id, name, lastname, image
id = SafeInt(Request.Form("id"))
name = SafeStr(Trim(Request.Form("artist_name")))
lastname = SafeStr(Trim(Request.Form("artist_lastname")))
image = SafeStr(Trim(Request.Form("artist_image")))

If Len(name) = 0 Then Response.Redirect "artist_form.asp?id=" & id

Dim lastnameSql, imageSql
If Len(lastname) = 0 Then lastnameSql = "NULL" Else lastnameSql = "'" & lastname & "'"
If Len(image) = 0 Then imageSql = "NULL" Else imageSql = "'" & image & "'"

If id > 0 Then
    ExecDB "UPDATE TBL_ARTIST SET ARTIST_NAME='" & name & "', ARTIST_LASTNAME=" & lastnameSql & _
           ", ARTIST_IMAGE=" & imageSql & " WHERE ID_ARTIST=" & id
    Response.Redirect "artists.asp?msg=" & Server.URLEncode("Artista actualizado")
Else
    ExecDB "INSERT INTO TBL_ARTIST (ARTIST_NAME, ARTIST_LASTNAME, ARTIST_IMAGE) VALUES('" & _
           name & "'," & lastnameSql & "," & imageSql & ")"
    Response.Redirect "artists.asp?msg=" & Server.URLEncode("Artista creado")
End If
%>
