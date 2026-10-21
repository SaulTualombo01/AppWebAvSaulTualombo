<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!--#include file="includes/db.asp"-->
<%
' Incrementa el contador de reproducciones (llamado por fetch desde el player)
Response.ContentType = "application/json"
Dim id : id = SafeInt(Request.QueryString("id"))
If id > 0 Then
    On Error Resume Next
    ExecDB "UPDATE TBL_SONG SET PLAYS = ISNULL(PLAYS,0) + 1 WHERE ID_SONG = " & id
    On Error GoTo 0
    Response.Write "{""ok"":true}"
Else
    Response.Write "{""ok"":false}"
End If
%>
