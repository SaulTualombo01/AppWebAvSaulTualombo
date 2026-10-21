<%
' ============================================================
' db.asp - Conexion a SQL Server (BDD_PoliMusic) + helpers
' ============================================================
Const DB_CONN_STRING = "Provider=SQLOLEDB;Data Source=localhost;Initial Catalog=BDD_PoliMusic;User Id=usr_polimusic;Password=Politecnica1;"

Function GetConnection()
    Dim cn
    Set cn = Server.CreateObject("ADODB.Connection")
    cn.Open DB_CONN_STRING
    Set GetConnection = cn
End Function

' Ejecuta un SELECT y devuelve un Recordset (cursor estatico)
Function QueryDB(sql)
    Dim cn, rs
    Set cn = GetConnection()
    Set rs = Server.CreateObject("ADODB.Recordset")
    rs.CursorLocation = 3 ' adUseClient
    rs.Open sql, cn, 1, 1 ' adOpenKeyset, adLockReadOnly
    Set rs.ActiveConnection = Nothing
    cn.Close
    Set cn = Nothing
    Set QueryDB = rs
End Function

' Ejecuta INSERT/UPDATE/DELETE
Sub ExecDB(sql)
    Dim cn
    Set cn = GetConnection()
    cn.Execute sql
    cn.Close
    Set cn = Nothing
End Sub

' Escapa comillas simples para evitar SQL injection basico
Function SafeStr(s)
    If IsNull(s) Then s = ""
    SafeStr = Replace(CStr(s), "'", "''")
End Function

' Entero seguro (0 si no es numerico)
Function SafeInt(v)
    If IsNumeric(v) Then
        SafeInt = CLng(v)
    Else
        SafeInt = 0
    End If
End Function

' Convierte la ruta "~/carpeta/archivo" de la BDD a ruta web relativa
Function WebPath(p)
    If IsNull(p) Or Len(p & "") = 0 Then
        WebPath = ""
    ElseIf Left(p, 2) = "~/" Then
        WebPath = Mid(p, 3)
    Else
        WebPath = p
    End If
End Function

' Ruta de imagen con fallback a placeholder si el archivo no existe
Function ImgPath(p)
    Dim wp
    wp = WebPath(p)
    If Len(wp) = 0 Then
        ImgPath = "images/no-cover.svg"
        Exit Function
    End If
    On Error Resume Next
    Dim fso
    Set fso = Server.CreateObject("Scripting.FileSystemObject")
    If fso.FileExists(Server.MapPath(wp)) Then
        ImgPath = wp
    Else
        ImgPath = "images/no-cover.svg"
    End If
    Set fso = Nothing
    On Error GoTo 0
End Function

' Escapa texto para HTML
Function H(s)
    H = Server.HTMLEncode(s & "")
End Function
%>
