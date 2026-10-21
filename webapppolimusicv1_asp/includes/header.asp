<!--#include file="db.asp"-->
<!--#include file="auth.asp"-->
<%
' Header comun: requiere sesion y dibuja la barra de navegacion
RequireLogin
Dim pageTitle
If IsEmpty(PAGE_TITLE) Or Len(PAGE_TITLE & "") = 0 Then pageTitle = "PoliMusic" Else pageTitle = PAGE_TITLE
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%=H(pageTitle)%> | PoliMusic</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
<header class="topbar">
    <a class="brand" href="default.asp">
        <span class="brand-note">&#9835;</span> PoliMusic
    </a>
    <nav class="nav">
        <a href="default.asp" class="nav-link">Home</a>
        <% If IsAdmin() Then %>
            <a href="songs.asp" class="nav-link">Songs</a>
            <a href="artists.asp" class="nav-link">Artists</a>
            <a href="albums.asp" class="nav-link">Albums</a>
        <% Else %>
            <a href="playlists.asp" class="nav-link">My Playlists</a>
        <% End If %>
    </nav>
    <div class="user-chip">
        <img src="<%=ImgPath(Session("USER_PHOTO"))%>" alt="user" class="user-avatar">
        <span class="user-name"><%=H(Session("USERNAME"))%></span>
        <span class="user-role"><% If IsAdmin() Then %>ADMIN<% Else %>USER<% End If %></span>
        <a href="logout.asp" class="btn btn-ghost btn-sm">Logout</a>
    </div>
</header>
<main class="content">
