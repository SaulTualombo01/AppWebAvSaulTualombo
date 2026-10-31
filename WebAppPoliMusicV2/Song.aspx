<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Song.aspx.cs" Inherits="WebAppPoliMusicV2.Song" ResponseEncoding="utf-8" %>
<!DOCTYPE html>
<html lang="es">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <meta name="theme-color" content="#101010" />
    <title>Tu música · PoliMusic</title>
    <link href="Content/song.css" rel="stylesheet" />
    <script src="Scripts/song.js" charset="utf-8" defer="defer"></script>
</head>
<body>
    <a class="skip-link" href="#library">Saltar a las canciones</a>
    <form id="form1" runat="server" novalidate="novalidate">
        <div id="musicApp" class="app-shell" data-token="<%= Encode(PlayToken) %>" data-endpoint="<%= ResolveUrl("~/Song.aspx") %>">
            <aside class="sidebar" aria-label="Navegación principal">
                <a class="brand" href="Song.aspx" aria-label="PoliMusic, inicio"><span class="brand-mark" aria-hidden="true">≋</span> PoliMusic<span class="brand-dot">®</span></a>
                <nav>
                    <a class="nav-link active" href="#library" aria-current="page"><span aria-hidden="true">♫</span> Tu biblioteca</a>
                    <a class="nav-link" href="#searchInput" id="searchLink"><span aria-hidden="true">⌕</span> Buscar canciones</a>
                </nav>
                <div class="sidebar-note"><span class="eyebrow">HECHO PARA ESCUCHAR</span><h2>Encuentra tu<br />próximo ritmo.</h2><p>Todas tus canciones.<br />Un solo lugar.</p><div class="mini-record" aria-hidden="true"></div></div>
                <div class="sidebar-bottom"><span class="online-dot" aria-hidden="true"></span> Tu espacio musical</div>
            </aside>
            <main class="main-content" id="library">
                <header class="topbar"><span class="breadcrumb">Tu espacio <span>/</span> <strong>Biblioteca</strong></span><div class="account"><span class="avatar" aria-hidden="true">♪</span><span class="username"><%= Encode(DisplayName) %></span><a class="logout" href="Logout.aspx">Cerrar sesión <span aria-hidden="true">↗</span></a></div></header>
                <section class="hero" aria-labelledby="heroTitle">
                    <div class="hero-copy"><span class="eyebrow"><span class="live-dot" aria-hidden="true"></span> TU BIBLIOTECA PERSONAL</span><h1 id="heroTitle">Tu día.<br />A tu ritmo.</h1><p>Dale play a lo que te mueve.</p><button type="button" class="primary-button" id="playLibrary" disabled="disabled"><span aria-hidden="true">▶</span> Escuchar biblioteca</button><div class="hero-stats"><span><strong><%= SongCount %></strong> canciones</span><span aria-hidden="true">·</span><span><strong><%= TotalPlays %></strong> reproducciones</span></div></div>
                    <div class="record-art" aria-hidden="true"><span class="orbit-label">POLIMUSIC — DALE PLAY A TU DÍA</span><div class="vinyl"><div class="vinyl-label"><span>poli<br /><b>music.</b></span><i></i></div></div><div class="record-caption">EL SONIDO DE TU MOMENTO <span>33⅓ RPM</span></div></div>
                </section>
                <section class="catalog" aria-labelledby="catalogTitle">
                    <div class="section-heading"><div><span class="eyebrow muted">DALE PLAY</span><h2 id="catalogTitle">Todas tus canciones</h2></div><div class="search-box"><span aria-hidden="true">⌕</span><label class="sr-only" for="searchInput">Buscar por nombre</label><input id="searchInput" type="search" placeholder="Buscar una canción" autocomplete="off" /><button id="clearSearch" type="button" aria-label="Limpiar búsqueda" hidden="hidden">×</button></div></div>
                    <div id="loadError" runat="server" visible="false" class="state-message error" role="alert"><h3>No pudimos cargar tu música</h3><p>Comprueba la conexión con la base de datos y vuelve a intentarlo.</p><a class="text-link" href="Song.aspx">Volver a cargar</a></div>
                    <div id="emptyState" runat="server" visible="false" class="state-message"><h3>Tu biblioteca está por comenzar</h3><p>Aún no hay canciones registradas. Agrega canciones a tu catálogo para escucharlas aquí.</p></div>
                    <div id="songTable" runat="server" class="table-scroll">
                        <table class="song-table"><caption class="sr-only">Canciones de la biblioteca</caption><thead><tr><th scope="col" class="number-column">#</th><th scope="col">Título</th><th scope="col" class="plays-column">Reproducciones</th><th scope="col" class="action-column"><span class="sr-only">Reproducir</span></th></tr></thead><tbody>
                        <asp:Repeater ID="songList" runat="server"><ItemTemplate>
                            <tr class="song-row" data-id="<%# Encode(Eval("ID_SONG")) %>" data-name="<%# Encode(Eval("SONG_NAME")) %>" data-src="<%# Encode(Eval("AUDIO_URL")) %>" data-available="<%# Convert.ToBoolean(Eval("AVAILABLE")) ? "true" : "false" %>">
                                <td class="track-number"><%# Container.ItemIndex + 1 %></td>
                                <td><div class="track-info"><div class="cover cover-<%# Container.ItemIndex % 5 %>" aria-hidden="true"><span>♫</span></div><div class="track-copy"><span class="track-title"><%# Encode(Eval("SONG_NAME")) %></span><span class="track-subtitle"><%# Convert.ToBoolean(Eval("AVAILABLE")) ? "PoliMusic · Audio" : "Archivo de audio no disponible" %></span></div></div></td>
                                <td class="play-count"><%# Encode(Eval("PLAYS")) %></td><td><button type="button" class="row-play" aria-label="<%# Encode("Reproducir " + Eval("SONG_NAME")) %>" <%# Convert.ToBoolean(Eval("AVAILABLE")) ? "" : "disabled=\"disabled\"" %>><span aria-hidden="true">▶</span></button></td>
                            </tr>
                        </ItemTemplate></asp:Repeater>
                        </tbody></table>
                    </div>
                    <div id="noResults" class="state-message" hidden="hidden"><h3>No encontramos esa canción</h3><p>Prueba con otro nombre o limpia la búsqueda.</p></div>
                    <p id="searchStatus" class="sr-only" role="status" aria-live="polite"></p>
                    <p class="catalog-footnote">Tu música, sin distracciones. <span aria-hidden="true">♪</span></p>
                </section>
            </main>
        </div>
        <footer class="player" aria-label="Reproductor de música">
            <div class="now-playing"><div class="cover player-cover" id="playerCover" aria-hidden="true">♫</div><div class="track-copy"><strong id="currentTitle">Tu próxima canción te espera</strong><span id="currentSubtitle">Elige una canción para empezar</span></div></div>
            <div class="playback"><div class="playback-buttons"><button type="button" id="previousTrack" class="icon-button" aria-label="Canción anterior" disabled="disabled">❮</button><button type="button" id="togglePlay" class="toggle-play" aria-label="Reproducir" disabled="disabled">▶</button><button type="button" id="nextTrack" class="icon-button" aria-label="Siguiente canción" disabled="disabled">❯</button></div><div class="timeline"><span id="elapsed">0:00</span><input type="range" id="seek" min="0" max="100" value="0" step="0.1" aria-label="Posición de reproducción" disabled="disabled" /><span id="duration">0:00</span></div></div>
            <div class="volume"><label for="volumeControl">Volumen</label><input type="range" id="volumeControl" min="0" max="1" step="0.01" value="0.75" /></div>
            <audio id="audioPlayer" preload="none"></audio>
        </footer>
        <p id="playerStatus" class="player-status" role="status" aria-live="polite" hidden="hidden"></p>
        <noscript><p class="noscript-message">Activa JavaScript para buscar y reproducir canciones.</p></noscript>
    </form>
</body>
</html>
