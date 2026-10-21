<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<% Option Explicit %>
<!--#include file="includes/db.asp"-->
<%
Response.CharSet = "UTF-8"

' Si ya hay sesion activa, ir al home
If Len(Session("ID_USER") & "") > 0 Then Response.Redirect "default.asp"

Dim msg, errMsg
msg = ""
errMsg = Request.QueryString("err")

If Request.ServerVariables("REQUEST_METHOD") = "POST" Then
    Dim usr, pwd, sql, rs
    usr = SafeStr(Trim(Request.Form("username")))
    pwd = Trim(Request.Form("password"))

    If Len(usr) = 0 Or Len(pwd) = 0 Then
        msg = "Ingresa usuario y contrasena."
    Else
        ' Soporta password en texto plano y en SHA1 mayusculas (como el seed de la BDD)
        sql = "SELECT ID_USER, USERNAME, USER_PHOTO, USER_TYPE " & _
              "FROM TBL_USER WHERE USERNAME = '" & usr & "' AND (" & _
              "PASSWORD = '" & SafeStr(pwd) & "' OR " & _
              "PASSWORD = CONVERT(VARCHAR(50), HASHBYTES('SHA1','" & SafeStr(pwd) & "'), 2))"
        Set rs = QueryDB(sql)
        If Not rs.EOF Then
            ' Variables de sesion del usuario logueado
            Session("ID_USER") = rs("ID_USER")
            Session("USERNAME") = rs("USERNAME")
            Session("USER_PHOTO") = rs("USER_PHOTO") & ""
            Session("USER_TYPE") = rs("USER_TYPE")
            rs.Close
            Set rs = Nothing
            Response.Redirect "default.asp"
            Response.End
        Else
            rs.Close
            Set rs = Nothing
            msg = "Credenciales incorrectas. Intenta de nuevo."
        End If
    End If
End If
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login | PoliMusic</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
<div class="login-wrap">
    <form class="login-card" method="post" action="login.asp">
        <div class="login-logo">&#9835; Poli<span>Music</span></div>
        <div class="login-sub">Tu musica, tu ritmo. Inicia sesion para continuar.</div>

        <% If Len(errMsg) > 0 Then %>
            <div class="alert alert-err"><%=H(errMsg)%></div>
        <% End If %>
        <% If Len(msg) > 0 Then %>
            <div class="alert alert-err"><%=H(msg)%></div>
        <% End If %>

        <div class="form-group">
            <label for="username">Usuario</label>
            <input class="form-control" type="text" id="username" name="username" required autofocus>
        </div>
        <div class="form-group">
            <label for="password">Contrasena</label>
            <input class="form-control" type="password" id="password" name="password" required>
        </div>
        <button type="submit" class="btn btn-primary">Ingresar</button>
    </form>
</div>
</body>
</html>
