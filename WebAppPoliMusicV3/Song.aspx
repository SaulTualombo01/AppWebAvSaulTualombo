<%@ Page Title="Canciones · PoliMusic" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Song.aspx.cs" Inherits="WebAppPoliMusicV3.Song" CodePage="65001" %>
<asp:Content ID="SongContent" ContentPlaceHolderID="MainContent" runat="server">
<style>
body { background:#000;color:#fff;padding:0;font-family:Arial,Helvetica,sans-serif; }
body > form > .navbar,body > form > .body-content > hr,body > form > .body-content > footer:not(.player) {display:none}
body > form > .body-content {max-width:none;padding:0;margin:0}
#musicApp {--muted:#b3b3b3;--green:#1ed760;padding:8px 8px 120px;font-size:14px}
#musicApp *,.player * {box-sizing:border-box}
#musicApp a {color:inherit;text-decoration:none}
#musicApp button,.player button {border:0;cursor:pointer;font:inherit}
#musicApp button:disabled,.player button:disabled {opacity:.35;cursor:not-allowed}
#musicApp button:focus-visible,#musicApp a:focus-visible,.player button:focus-visible,input:focus-visible {outline:2px solid #fff;outline-offset:4px}
.pm-topbar {height:64px;display:flex;align-items:center;gap:20px;padding:0 16px 8px}
.pm-brand {font-size:24px;font-weight:800;letter-spacing:-1px;min-width:245px}
.pm-logo {display:inline-grid;place-items:center;background:#1ed760;color:#000;border-radius:50%;width:35px;height:35px;font-size:32px;margin-right:8px;vertical-align:middle}
.home-link {border-radius:50%;background:#222;font-size:26px;width:46px;height:46px;display:grid;place-items:center}
.search-box {display:flex;align-items:center;gap:12px;background:#242424;border-radius:30px;padding:0 18px;max-width:450px;flex:1;height:48px;border:1px solid transparent}
.search-box:focus-within {border-color:#fff}
.search-box > span {font-size:28px;color:#ccc}
.search-box input {width:100%;background:none;border:0;color:white;outline:0;max-width:none}
.search-box button {background:none;color:#fff;font-size:24px!important}
.account {margin-left:auto;display:flex;align-items:center;gap:12px}
.avatar {width:36px;height:36px;border-radius:50%;object-fit:cover;border:3px solid #282828}
.logout {font-size:12px;font-weight:700;color:#bbb!important}
.pm-layout {display:grid;grid-template-columns:280px minmax(0,1fr);gap:8px}
.sidebar {background:#121212;border-radius:8px;padding:22px 16px;display:flex;flex-direction:column;gap:24px}
.sidebar h2 {font-size:17px;margin:0;font-weight:700}
.library-label {display:flex;justify-content:space-between;color:#b3b3b3}
.pill {display:inline-block;padding:8px 15px;border-radius:22px;background:#252525;font-size:13px}
.pill.active {background:#1ed760;color:#000}
.library-item {display:flex;gap:12px;align-items:center;padding:10px 6px;border-radius:6px}
.library-item:hover {background:#222}
.library-item img {width:48px;height:48px;border-radius:4px;object-fit:cover}
.library-item strong,.library-item small {display:block}
.library-item small {color:#aaa;margin-top:5px}
.sidebar-note {margin-top:auto;padding:20px 10px;color:#aaa;font-size:12px;line-height:1.8}
.main-content {background:linear-gradient(180deg,#25483c 0,#182c24 260px,#121212 500px);border-radius:8px;overflow:hidden;min-height:calc(100vh - 190px)}
.pm-intro {padding:24px 28px 12px}
.filters {display:flex;gap:8px;margin-bottom:25px}
.filters .active {background:#fff;color:#000}
.pm-intro h1 {font-size:clamp(24px,3vw,36px);font-weight:800;letter-spacing:-1px;margin:0 0 8px}
.pm-intro p {color:#c4d0c9;margin-bottom:24px}
.quick-links {display:grid;grid-template-columns:repeat(3,minmax(0,1fr));gap:10px}
.quick-link {display:flex;align-items:center;gap:14px;background:#ffffff12;border-radius:5px;overflow:hidden;font-weight:700}
.quick-link:hover {background:#ffffff26}
.quick-link img {height:62px;width:62px;object-fit:cover}
.hero {display:flex;align-items:center;gap:26px;padding:28px}
.hero-art {width:165px;height:165px;object-fit:cover;box-shadow:0 10px 35px #0007;border-radius:5px}
.eyebrow {font-size:11px;letter-spacing:1.6px;font-weight:700}
.hero h2 {font-size:clamp(32px,5vw,64px);font-weight:800;letter-spacing:-2px;margin:12px 0}
.hero p {color:#bac9c0}
.hero-stats {font-size:12px;color:#d8dedb}
.catalog {padding:8px 28px 28px;background:linear-gradient(#12121222,#121212)}
.section-heading {display:flex;align-items:center;gap:18px;margin:12px 0 22px}
.section-heading h2 {font-size:22px;font-weight:700;margin:0}
.section-heading small {display:block;color:#999;margin-top:5px}
.primary-button {height:52px;width:52px;border-radius:50%;background:#1ed760;color:#000;font-size:22px!important}
.primary-button:hover {transform:scale(1.05);background:#3be477}
.table-scroll {overflow-x:auto}
.song-table {width:100%;border-collapse:collapse;color:#b3b3b3}
.song-table th {text-align:left;font-size:12px;font-weight:400;border-bottom:1px solid #ffffff20;padding:10px}
.song-table td {padding:10px}
.number-column {width:35px}
.action-column {width:50px}
.plays-column {text-align:right!important}
.play-count {text-align:right;font-variant-numeric:tabular-nums}
.song-row:hover {background:#ffffff12}
.song-row.is-current .track-title,.song-row.is-current .track-number {color:#1ed760}
.track-info {display:flex;align-items:center;gap:12px}
.cover {width:44px;height:44px;flex-shrink:0;border-radius:4px;background:linear-gradient(135deg,#4c3a97,#7ba999);display:grid;place-items:center;overflow:hidden}
.cover img {width:100%;height:100%;object-fit:cover}
.track-copy {display:flex;flex-direction:column;gap:4px;min-width:0}
.track-title {color:#fff;font-weight:500}
.track-subtitle {font-size:12px;color:#aaa}
.row-play {background:transparent;color:#fff;border-radius:50%;width:32px;height:32px}
.row-play:hover {background:#1ed760;color:#000}
.state-message {padding:30px;text-align:center;color:#bbb}
.state-message h3 {font-size:20px;color:#fff}
.error {background:#3e2525;border-radius:8px}
.text-link {text-decoration:underline!important}
.player {position:fixed;bottom:0;left:0;right:0;min-height:100px;background:#000;z-index:20;display:grid;grid-template-columns:1fr 1.25fr 1fr;align-items:center;gap:24px;padding:14px 22px;color:#fff;font-size:13px}
.now-playing {display:flex;align-items:center;gap:12px;min-width:0}
.player-cover {width:56px;height:56px}
#currentTitle {overflow:hidden;text-overflow:ellipsis;white-space:nowrap}
#currentSubtitle {color:#aaa;font-size:11px}
.playback-buttons {display:flex;align-items:center;justify-content:center;gap:24px;margin-bottom:9px}
.icon-button {background:none;color:#bbb}
.toggle-play {width:33px;height:33px;border-radius:50%;background:#fff;color:#000}
.timeline {display:flex;align-items:center;gap:10px;color:#aaa;font-size:11px}
.playback {min-width:0}
.timeline span {min-width:34px;text-align:center;font-variant-numeric:tabular-nums}
.timeline input {flex:1;min-width:0}
.player #seek {--progress:0%;appearance:none;-webkit-appearance:none;width:100%;height:18px;margin:0;cursor:pointer;background:transparent}
#seek::-webkit-slider-runnable-track {height:4px;border-radius:4px;background:linear-gradient(to right,#fff 0%,#fff var(--progress),#4d4d4d var(--progress),#4d4d4d 100%)}
#seek::-moz-range-track {height:4px;border-radius:4px;background:#4d4d4d}
#seek::-moz-range-progress {height:4px;border-radius:4px;background:#fff}
#seek::-webkit-slider-thumb {appearance:none;-webkit-appearance:none;width:12px;height:12px;margin-top:-4px;border:0;border-radius:50%;background:#fff;opacity:0}
#seek::-moz-range-thumb {width:12px;height:12px;border:0;border-radius:50%;background:#fff;opacity:0}
#seek:hover::-webkit-slider-runnable-track,#seek:focus-visible::-webkit-slider-runnable-track {background:linear-gradient(to right,#1ed760 0%,#1ed760 var(--progress),#4d4d4d var(--progress),#4d4d4d 100%)}
#seek:hover::-moz-range-progress,#seek:focus-visible::-moz-range-progress {background:#1ed760}
#seek:hover::-webkit-slider-thumb,#seek:focus-visible::-webkit-slider-thumb {opacity:1}
#seek:hover::-moz-range-thumb,#seek:focus-visible::-moz-range-thumb {opacity:1}
.player #seek:disabled {cursor:default;opacity:.45}
.player input {accent-color:#1ed760;height:4px;max-width:none}
.volume {display:flex;align-items:center;justify-content:flex-end;gap:12px;color:#aaa}
.volume input {width:95px}
.player-status {position:fixed;bottom:110px;left:50%;transform:translateX(-50%);z-index:25;background:#fff;color:#111;border-radius:7px;padding:12px 20px;box-shadow:0 5px 25px #0008}
.sr-only {position:absolute;width:1px;height:1px;padding:0;overflow:hidden;clip:rect(0,0,0,0);white-space:nowrap;border:0}
[hidden] {display:none!important}
.noscript-message {padding:20px;background:#442}
@media(min-width:1500px) {.pm-layout {grid-template-columns:320px minmax(0,1fr)} .hero-art {width:200px;height:200px}}
@media(max-width:1000px) {.pm-layout {grid-template-columns:220px minmax(0,1fr)}.pm-brand {min-width:0}.username {display:none}.quick-links {grid-template-columns:repeat(2,minmax(0,1fr))}.quick-link:last-child {display:none}.hero-art {width:125px;height:125px}.volume label {display:none}}
@media(max-width:700px) {.pm-topbar {padding:0 4px 8px;gap:10px}.pm-brand {font-size:0}.pm-logo {font-size:30px;margin:0}.home-link,.sidebar {display:none}.search-box {padding:0 12px}.pm-layout {display:block}.pm-intro,.hero,.catalog {padding:20px 16px}.hero {gap:16px}.hero-art {width:95px;height:95px}.hero h2 {font-size:32px;letter-spacing:-1px}.hero p {font-size:12px}.player {grid-template-columns:1fr;gap:10px;padding:10px 16px}.now-playing {position:absolute;top:12px;left:16px;max-width:55%}.player-cover {width:32px;height:32px}#currentSubtitle,.volume {display:none}.playback-buttons {justify-content:flex-end;height:33px}.quick-link {font-size:12px;gap:8px}.quick-link img {width:45px;height:45px}.track-subtitle {font-size:10px}.song-table td {padding:8px 5px}.plays-column {font-size:10px!important}.cover {width:34px;height:34px}}
</style>
<div id="musicApp" data-token="<%= Encode(PlayToken) %>" data-endpoint="<%= ResolveUrl("~/Song") %>">
    <header class="pm-topbar">
        <a class="pm-brand" href="<%= ResolveUrl("~/Song.aspx") %>"><span class="pm-logo" aria-hidden="true">≋</span>PoliMusic</a>
        <a class="home-link" href="<%= ResolveUrl("~/Default.aspx") %>" aria-label="Inicio">⌂</a>
        <div class="search-box"><span aria-hidden="true">⌕</span><label class="sr-only" for="searchInput">Buscar canciones</label><input id="searchInput" type="search" placeholder="¿Qué quieres escuchar?" autocomplete="off" /><button id="clearSearch" type="button" aria-label="Limpiar búsqueda" hidden="hidden">×</button></div>
        <div class="account"><span class="username"><%= Encode(DisplayName) %></span><img class="avatar" src="<%= Encode(PhotoUrl) %>" alt="Tu perfil" /><a class="logout" href="<%= ResolveUrl("~/Logout.aspx") %>">Cerrar sesión</a></div>
    </header>
    <div class="pm-layout">
        <aside class="sidebar" aria-label="Tu biblioteca">
            <div class="library-label"><h2>▤ &nbsp; Tu biblioteca</h2><span aria-hidden="true">♫</span></div>
            <div><a class="pill" href="#catalogTitle">Canciones</a> <a class="pill" id="searchLink" href="#searchInput">Buscar</a></div>
            <a class="library-item" href="#catalogTitle"><img src="<%= ResolveUrl("~/PlaylistImages/playlist1.png") %>" alt="" /><span><strong>Tu música</strong><small>Biblioteca · <%= SongCount %> canciones</small></span></a>
            <a class="library-item" href="#heroTitle"><img src="<%= ResolveUrl("~/PlaylistImages/playlist2.png") %>" alt="" /><span><strong>Para tu día</strong><small>Explora tu colección</small></span></a>
            <div class="sidebar-note">UN ESPACIO PARA TU MÚSICA<br />Dale play. Disfruta el momento.<br /><br />PoliMusic · Saul Tualombo</div>
        </aside>
        <main class="main-content">
            <section class="pm-intro">
                <div class="filters"><a class="pill active" href="<%= ResolveUrl("~/Song.aspx") %>">Todo</a><a class="pill" href="#catalogTitle">Música</a></div>
                <h1>¡Bienvenido, <%= Encode(DisplayName) %>!</h1>
                <p>Tu música favorita, a un play de distancia.</p>
                <div class="quick-links">
                    <a class="quick-link" href="#catalogTitle"><img src="<%= ResolveUrl("~/PlaylistImages/playlist1.png") %>" alt="" />Tus canciones</a>
                    <a class="quick-link" href="#heroTitle"><img src="<%= ResolveUrl("~/PlaylistImages/playlist2.png") %>" alt="" />Hecho para ti</a>
                    <a class="quick-link" href="#catalogTitle"><img src="<%= ResolveUrl("~/PlaylistImages/playlist3.png") %>" alt="" />Descubre tu ritmo</a>
                </div>
            </section>
            <section class="hero" aria-labelledby="heroTitle">
                <img class="hero-art" src="<%= ResolveUrl("~/PlaylistImages/playlist5.png") %>" alt="Portada de tu colección musical" />
                <div><span class="eyebrow">TU COLECCIÓN</span><h2 id="heroTitle">Dale play a tu día.</h2><p>Una canción para cada momento. Encuentra la tuya.</p><div class="hero-stats"><strong>PoliMusic</strong> · <%= SongCount %> canciones · <%= TotalPlays %> reproducciones</div></div>
            </section>
            <section class="catalog" aria-labelledby="catalogTitle">
                <div class="section-heading"><button type="button" class="primary-button" id="playLibrary" aria-label="Reproducir biblioteca" disabled="disabled">▶</button><div><h2 id="catalogTitle">Tus canciones</h2><small>El soundtrack de tu día</small></div></div>                    <div id="loadError" runat="server" visible="false" class="state-message error" role="alert"><h3>No pudimos cargar tu música</h3><p>Comprueba la conexión con la base de datos y vuelve a intentarlo.</p><a class="text-link" href="Song.aspx">Volver a cargar</a></div>
                    <div id="emptyState" runat="server" visible="false" class="state-message"><h3>Tu biblioteca está por comenzar</h3><p>Aún no hay canciones registradas. Agrega canciones a tu catálogo para escucharlas aquí.</p></div>
                    <div id="songTable" runat="server" class="table-scroll">
                        <table class="song-table"><caption class="sr-only">Canciones de la biblioteca</caption><thead><tr><th scope="col" class="number-column">#</th><th scope="col">Título</th><th scope="col" class="plays-column">Reproducciones</th><th scope="col" class="action-column"><span class="sr-only">Reproducir</span></th></tr></thead><tbody>
                        <asp:Repeater ID="songList" runat="server"><ItemTemplate>
                            <tr class="song-row" data-id="<%# Encode(Eval("ID_SONG")) %>" data-name="<%# Encode(Eval("SONG_NAME")) %>" data-src="<%# Encode(Eval("AUDIO_URL")) %>" data-available="<%# Convert.ToBoolean(Eval("AVAILABLE")) ? "true" : "false" %>">
                                <td class="track-number"><%# Container.ItemIndex + 1 %></td>
                                <td><div class="track-info"><div class="cover cover-<%# Container.ItemIndex % 5 %>" aria-hidden="true"><img src="<%# ResolveUrl("~/PlaylistImages/playlist" + (Container.ItemIndex % 5 + 1) + ".png") %>" alt="" /></div><div class="track-copy"><span class="track-title"><%# Encode(Eval("SONG_NAME")) %></span><span class="track-subtitle"><%# Convert.ToBoolean(Eval("AVAILABLE")) ? "PoliMusic · Audio" : "Archivo de audio no disponible" %></span></div></div></td>
                                <td class="play-count"><%# Encode(Eval("PLAYS")) %></td><td><button type="button" class="row-play" aria-label="<%# Encode("Reproducir " + Eval("SONG_NAME")) %>" <%# Convert.ToBoolean(Eval("AVAILABLE")) ? "" : "disabled=\"disabled\"" %>><span aria-hidden="true">▶</span></button></td>
                            </tr>
                        </ItemTemplate></asp:Repeater>
                        </tbody></table>
                    </div>
                    <div id="noResults" class="state-message" hidden="hidden"><h3>No encontramos esa canción</h3><p>Prueba con otro nombre o limpia la búsqueda.</p></div>
                    <p id="searchStatus" class="sr-only" role="status" aria-live="polite"></p>
</section></main></div></div>
        <footer class="player" aria-label="Reproductor de música">
            <div class="now-playing"><div class="cover player-cover" id="playerCover" aria-hidden="true">♫</div><div class="track-copy"><strong id="currentTitle">Tu próxima canción te espera</strong><span id="currentSubtitle">Elige una canción para empezar</span></div></div>
            <div class="playback"><div class="playback-buttons"><button type="button" id="previousTrack" class="icon-button" aria-label="Canción anterior" disabled="disabled">❮</button><button type="button" id="togglePlay" class="toggle-play" aria-label="Reproducir" disabled="disabled">▶</button><button type="button" id="nextTrack" class="icon-button" aria-label="Siguiente canción" disabled="disabled">❯</button></div><div class="timeline"><span id="elapsed">0:00</span><input type="range" id="seek" min="0" max="100" value="0" step="0.1" aria-label="Posición de reproducción" disabled="disabled" /><span id="duration">0:00</span></div></div>
            <div class="volume"><label for="volumeControl">Volumen</label><input type="range" id="volumeControl" min="0" max="1" step="0.01" value="0.75" /></div>
            <audio id="audioPlayer" preload="none"></audio>
        </footer>
        <p id="playerStatus" class="player-status" role="status" aria-live="polite" hidden="hidden"></p>
        <noscript><p class="noscript-message">Activa JavaScript para buscar y reproducir canciones.</p></noscript>
<script>
(function () {
    'use strict';
    var app = document.getElementById('musicApp');
    if (!app) return;
    var audio = document.getElementById('audioPlayer');
    var rows = Array.prototype.slice.call(document.querySelectorAll('.song-row'));
    var tracks = rows.filter(function (row) { return row.dataset.available === 'true'; });
    var play = document.getElementById('togglePlay');
    var previous = document.getElementById('previousTrack');
    var next = document.getElementById('nextTrack');
    var library = document.getElementById('playLibrary');
    var seek = document.getElementById('seek');
    var status = document.getElementById('playerStatus');
    var search = document.getElementById('searchInput');
    var clear = document.getElementById('clearSearch');
    var current = null;
    var counted = false;
    var loadVersion = 0;
    var composing = false;
    var format = new Intl.NumberFormat('es-EC');
    audio.volume = 0.75;

    function message(text) { status.textContent = text; status.hidden = !text; }
    function time(seconds) {
        if (!isFinite(seconds)) return '0:00';
        return Math.floor(seconds / 60) + ':' + ('0' + Math.floor(seconds % 60)).slice(-2);
    }
    function updateButtons() {
        play.textContent = audio.paused ? '▶' : 'Ⅱ';
        play.setAttribute('aria-label', audio.paused ? 'Reproducir' : 'Pausar');
        rows.forEach(function (row) {
            var selected = row === current;
            row.classList.toggle('is-current', selected);
            var button = row.querySelector('.row-play');
            var playing = selected && !audio.paused;
            button.querySelector('span').textContent = playing ? 'Ⅱ' : '▶';
            button.setAttribute('aria-label', (playing ? 'Pausar ' : 'Reproducir ') + row.dataset.name);
        });
    }
    function startAudio() {
        var version = loadVersion;
        var result = audio.play();
        if (result && result.catch) result.catch(function () {
            if (version !== loadVersion) return;
            message('No se pudo reproducir el audio. Pulsa reproducir para volver a intentarlo.');
            updateButtons();
        });
    }
    function selectTrack(row) {
        if (!row || row.dataset.available !== 'true') return;
        message('');
        if (row === current && !audio.ended) { if (audio.paused) startAudio(); else audio.pause(); return; }
        loadVersion += 1;
        audio.pause();
        current = row;
        counted = false;
        audio.src = row.dataset.src;
        audio.load();
        document.getElementById('currentTitle').textContent = row.dataset.name;
        document.getElementById('currentSubtitle').textContent = 'PoliMusic · Tu biblioteca';
        document.getElementById('playerCover').className = 'cover player-cover';
        document.getElementById('playerCover').replaceChildren(row.querySelector('.cover img').cloneNode(true));
        seek.value = 0;
        seek.style.setProperty('--progress', '0%');
        seek.disabled = true;
        document.getElementById('elapsed').textContent = '0:00';
        document.getElementById('duration').textContent = '0:00';
        play.disabled = false;
        previous.disabled = tracks.length < 2;
        next.disabled = tracks.length < 2;
        updateButtons();
        startAudio();
    }
    function step(direction) {
        var index = tracks.indexOf(current);
        selectTrack(tracks[(index + direction + tracks.length) % tracks.length]);
    }
    rows.forEach(function (row) {
        row.querySelector('.row-play').addEventListener('click', function () { selectTrack(row); });
        row.querySelector('.play-count').textContent = format.format(Number(row.querySelector('.play-count').textContent));
    });
    library.disabled = tracks.length === 0;
    library.addEventListener('click', function () {
        var visible = tracks.filter(function (row) { return !row.hidden; });
        if (!visible.length) { message('No hay canciones con audio en esta búsqueda.'); return; }
        if (current === visible[0]) { if (audio.paused) startAudio(); } else selectTrack(visible[0]);
    });
    play.addEventListener('click', function () { if (!current) return; if (audio.paused) startAudio(); else audio.pause(); });
    previous.addEventListener('click', function () { step(-1); });
    next.addEventListener('click', function () { step(1); });
    audio.addEventListener('playing', function () {
        message('');
        updateButtons();
        if (counted || !current) return;
        counted = true;
        var row = current;
        fetch(app.dataset.endpoint, {
            method: 'POST', credentials: 'same-origin',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: 'action=play&id=' + encodeURIComponent(row.dataset.id) + '&token=' + encodeURIComponent(app.dataset.token)
        }).then(function (response) {
            if (response.status === 403 || response.redirected) {
                message('Tu sesión terminó. Vuelve a iniciar sesión para continuar.');
                audio.pause();
                return null;
            }
            if (!response.ok) throw new Error('counter');
            return response.json();
        }).then(function (result) {
            if (result && typeof result.plays === 'number') row.querySelector('.play-count').textContent = format.format(result.plays);
        }).catch(function () { message('El audio continúa, pero no pudimos guardar esta reproducción.'); });
    });
    audio.addEventListener('pause', updateButtons);
    function updateTimeline() {
        var duration = audio.duration;
        var available = isFinite(duration) && duration > 0;
        var position = available ? Math.min(duration, Math.max(0, audio.currentTime)) : 0;
        seek.disabled = !available;
        seek.value = available ? position / duration * 100 : 0;
        seek.style.setProperty('--progress', seek.value + '%');
        document.getElementById('elapsed').textContent = time(position);
        document.getElementById('duration').textContent = time(duration);
        seek.setAttribute('aria-valuetext', time(position) + ' de ' + time(duration));
    }
    audio.addEventListener('loadedmetadata', updateTimeline);
    audio.addEventListener('durationchange', updateTimeline);
    audio.addEventListener('timeupdate', updateTimeline);
    audio.addEventListener('seeked', updateTimeline);
    audio.addEventListener('emptied', updateTimeline);
    audio.addEventListener('ended', function () {
        var index = tracks.indexOf(current);
        if (index + 1 < tracks.length) selectTrack(tracks[index + 1]);
        else updateButtons();
    });
    audio.addEventListener('error', function () {
        message('No se pudo abrir este audio. Intenta con otra canción o revisa el archivo.');
        seek.disabled = true;
        updateButtons();
    });
    seek.addEventListener('input', function () {
        if (!isFinite(audio.duration) || audio.duration <= 0) return;
        audio.currentTime = Number(seek.value) / 100 * audio.duration;
        updateTimeline();
    });
    document.getElementById('volumeControl').addEventListener('input', function (event) { audio.volume = Number(event.target.value); });

    function normalize(value) { return value.normalize('NFD').replace(/[\u0300-\u036f]/g, '').toLocaleLowerCase('es'); }
    function filterSongs(updateUrl) {
        var query = normalize(search.value.trim());
        var count = 0;
        rows.forEach(function (row) { row.hidden = normalize(row.dataset.name).indexOf(query) < 0; if (!row.hidden) count += 1; });
        clear.hidden = search.value.length === 0;
        document.getElementById('noResults').hidden = !query || count !== 0 || rows.length === 0;
        document.getElementById('searchStatus').textContent = count + (count === 1 ? ' canción encontrada' : ' canciones encontradas');
        if (updateUrl) {
            var url = new URL(window.location.href);
            if (search.value) url.searchParams.set('q', search.value); else url.searchParams.delete('q');
            window.history.replaceState(null, '', url.toString());
        }
    }
    search.value = new URL(window.location.href).searchParams.get('q') || '';
    filterSongs(false);
    search.addEventListener('compositionstart', function () { composing = true; });
    search.addEventListener('compositionend', function () { composing = false; filterSongs(true); });
    search.addEventListener('input', function () { if (!composing) filterSongs(true); });
    search.addEventListener('keydown', function (event) { if (event.key === 'Enter') { event.preventDefault(); if (!composing) filterSongs(true); } });
    clear.addEventListener('click', function () { search.value = ''; filterSongs(true); search.focus(); });
    document.getElementById('searchLink').addEventListener('click', function (event) { event.preventDefault(); search.focus(); search.scrollIntoView({ block: 'center' }); });
}());
</script>
</asp:Content>

