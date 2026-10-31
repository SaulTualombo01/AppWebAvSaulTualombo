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
        if (row === current) { if (audio.paused) startAudio(); else audio.pause(); return; }
        loadVersion += 1;
        audio.pause();
        current = row;
        counted = false;
        audio.src = row.dataset.src;
        audio.load();
        document.getElementById('currentTitle').textContent = row.dataset.name;
        document.getElementById('currentSubtitle').textContent = 'PoliMusic · Tu biblioteca';
        document.getElementById('playerCover').className = row.querySelector('.cover').className + ' player-cover';
        seek.value = 0;
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
    audio.addEventListener('loadedmetadata', function () {
        seek.disabled = !isFinite(audio.duration) || audio.duration <= 0;
        document.getElementById('duration').textContent = time(audio.duration);
    });
    audio.addEventListener('timeupdate', function () {
        document.getElementById('elapsed').textContent = time(audio.currentTime);
        if (isFinite(audio.duration) && audio.duration > 0) seek.value = audio.currentTime / audio.duration * 100;
        seek.setAttribute('aria-valuetext', time(audio.currentTime) + ' de ' + time(audio.duration));
    });
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
    seek.addEventListener('input', function () { if (isFinite(audio.duration)) audio.currentTime = Number(seek.value) / 100 * audio.duration; });
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
