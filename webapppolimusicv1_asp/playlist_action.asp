<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<% Option Explicit %>
<!--#include file="includes/db.asp"-->
<!--#include file="includes/auth.asp"-->
<%
Response.CharSet = "UTF-8"
RequireNormalUser

Dim uid : uid = CurrentUserId()
Dim action : action = Request.QueryString("action")

If action = "delete" Then
    Dim delId : delId = SafeInt(Request.QueryString("id"))
    If delId > 0 Then
        On Error Resume Next
        ExecDB "DELETE FROM TBL_PLAYLIST_SONG WHERE ID_PLAYLIST IN " & _
               "(SELECT ID_PLAYLIST FROM TBL_PLAYLIST WHERE ID_PLAYLIST=" & delId & " AND ID_USER=" & uid & ")"
        ExecDB "DELETE FROM TBL_PLAYLIST WHERE ID_PLAYLIST=" & delId & " AND ID_USER=" & uid
        On Error GoTo 0
    End If
    Response.Redirect "playlists.asp?msg=" & Server.URLEncode("Playlist eliminada")
    Response.End
End If

Dim id, title, ptype, photo
id = SafeInt(Request.Form("id"))
title = SafeStr(Trim(Request.Form("title")))
ptype = SafeInt(Request.Form("type"))
photo = SafeStr(Trim(Request.Form("photo")))

If Len(title) = 0 Then Response.Redirect "playlist_form.asp?id=" & id

Dim photoSql
If Len(photo) = 0 Then photoSql = "NULL" Else photoSql = "'" & photo & "'"

If id > 0 Then
    ExecDB "UPDATE TBL_PLAYLIST SET TITLE='" & title & "', TYPE=" & ptype & _
           ", PHOTO=" & photoSql & " WHERE ID_PLAYLIST=" & id & " AND ID_USER=" & uid
    Response.Redirect "playlists.asp?msg=" & Server.URLEncode("Playlist actualizada")
Else
    ExecDB "INSERT INTO TBL_PLAYLIST (ID_USER, TITLE, CREATION_DATE, TYPE, PHOTO) VALUES(" & _
           uid & ",'" & title & "', GETDATE()," & ptype & "," & photoSql & ")"
    Response.Redirect "playlists.asp?msg=" & Server.URLEncode("Playlist creada")
End If
%>
