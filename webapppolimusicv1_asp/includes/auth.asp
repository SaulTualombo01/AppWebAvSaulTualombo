<%
' ============================================================
' auth.asp - Control de sesion y roles
' USER_TYPE: 0 = normal, 1 = admin
' ============================================================

Sub RequireLogin()
    If Session("ID_USER") = "" Or IsEmpty(Session("ID_USER")) Then
        Response.Redirect "login.asp?err=" & Server.URLEncode("Debes iniciar sesion")
        Response.End
    End If
End Sub

Sub RequireAdmin()
    RequireLogin
    If CStr(Session("USER_TYPE")) <> "1" Then
        Response.Redirect "default.asp?err=" & Server.URLEncode("Acceso solo para administradores")
        Response.End
    End If
End Sub

Sub RequireNormalUser()
    RequireLogin
    If CStr(Session("USER_TYPE")) <> "0" Then
        Response.Redirect "default.asp?err=" & Server.URLEncode("Esta seccion es solo para usuarios normales")
        Response.End
    End If
End Sub

Function IsAdmin()
    IsAdmin = (CStr(Session("USER_TYPE")) = "1")
End Function

Function CurrentUserId()
    CurrentUserId = SafeInt(Session("ID_USER"))
End Function
%>
