<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<%
' Cierra la sesion y regresa al login
Session.Abandon
Response.Redirect "login.asp"
%>
