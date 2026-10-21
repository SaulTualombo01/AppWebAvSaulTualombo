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
        ExecDB "DELETE FROM TBL_PLAYLIST_SONG WHERE ID_SONG = " & delId
        ExecDB "DELETE FROM TBL_TRACKLIST WHERE ID_SONG = " & delId
        ExecDB "DELETE FROM TBL_PLAYER WHERE ID_SONG = " & delId
        ExecDB "DELETE FROM TBL_SONG WHERE ID_SONG = " & delId
        On Error GoTo 0
    End If
    Response.Redirect "songs.asp?msg=" & Server.URLEncode("Cancion eliminada")
    Response.End
End If

' Guardar (insert / update)
Dim id, name, path, plays
id = SafeInt(Request.Form("id"))
name = SafeStr(Trim(Request.Form("song_name")))
path = SafeStr(Trim(Request.Form("song_path")))
plays = SafeInt(Request.Form("plays"))

If Len(name) = 0 Or Len(path) = 0 Then
    Response.Redirect "song_form.asp?id=" & id
End If

If id > 0 Then
    ExecDB "UPDATE TBL_SONG SET SONG_NAME='" & name & "', SONG_PATH='" & path & _
           "', PLAYS=" & plays & " WHERE ID_SONG=" & id
    Response.Redirect "songs.asp?msg=" & Server.URLEncode("Cancion actualizada")
Else
    ExecDB "INSERT INTO TBL_SONG (SONG_NAME, SONG_PATH, PLAYS) VALUES('" & _
           name & "','" & path & "'," & plays & ")"
    Response.Redirect "songs.asp?msg=" & Server.URLEncode("Cancion creada")
End If
%>
