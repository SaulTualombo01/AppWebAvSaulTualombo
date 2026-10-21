// ============================================================
// PoliMusic - Reproductor
// ============================================================
(function () {
    var audio = document.getElementById("audioPlayer");
    var bar = document.getElementById("playerbar");
    var title = document.getElementById("playerTitle");
    var artist = document.getElementById("playerArtist");

    if (!audio) return;

    // playSong: expuesta globalmente; usada por los botones de las tarjetas
    window.playSong = function (id, name, artistName, path) {
        audio.src = path;
        title.textContent = name;
        artist.textContent = artistName || "Artista desconocido";
        bar.classList.add("playing");
        audio.play();

        // Marca activa la tarjeta
        document.querySelectorAll(".song-card.playing").forEach(function (c) {
            c.classList.remove("playing");
        });
        var card = document.getElementById("song-" + id);
        if (card) card.classList.add("playing");

        // Incrementa el contador de reproducciones en el servidor
        fetch("play_count.asp?id=" + encodeURIComponent(id)).catch(function () {});
    };

    audio.addEventListener("ended", function () {
        bar.classList.remove("playing");
        document.querySelectorAll(".song-card.playing").forEach(function (c) {
            c.classList.remove("playing");
        });
    });
})();
