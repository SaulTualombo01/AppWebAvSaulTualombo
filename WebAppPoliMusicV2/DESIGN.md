---
version: alpha
name: PoliMusic
description: Biblioteca musical en español inspirada en Spotify, con un vinilo como identidad visual.
colors:
  primary: "#1ed760"
  background: "#080808"
  surface: "#121212"
  raised: "#1c1c1c"
  text: "#f5f5f3"
  muted: "#a6aaa7"
  border: "#303431"
  danger: "#ffb4ac"
typography:
  display:
    fontFamily: "Arial Black, Segoe UI, sans-serif"
  body:
    fontFamily: "Segoe UI, Arial, sans-serif"
rounded:
  DEFAULT: "12px"
spacing:
  section-gap: "34px"
omitted:
  - section: components
    reason: Los estados se documentan en el cuerpo; no hay biblioteca de componentes.
---

# PoliMusic

## Dirección
Biblioteca para usuarios autenticados que quieren encontrar y escuchar sus canciones.
La referencia explícita del usuario es Spotify: superficies oscuras, verde para reproducir,
navegación lateral y reproductor persistente. Un vinilo de CSS acompaña el título «Tu día.
A tu ritmo.» sin depender de servicios externos. La página conserva la marca PoliMusic.
No se inventan artistas, duraciones ni portadas que no existen en TBL_SONG.

## Propiedad y alcance
Content/song.css es la fuente de tokens en tiempo de ejecución. Los colores anteriores
reflejan sus variables :root (--brand corresponde a primary); esta documentación y CSS
se actualizan juntos. Los colores adicionales del vinilo y las carátulas son ilustración,
no tonos semánticos. Song.aspx y Scripts/song.js consumen ese único estilo.
Login.aspx y SignUp.aspx conservan su presentación anterior: no existía un sistema visual.
El diseño nuevo se limita al catálogo solicitado, sin rediseñar autenticación.

## Tipografía y geometría
Arial Black para el título; Segoe UI para controles y canciones; cifras tabulares para
contadores y tiempos. Textos y nombres accesibles en español. Dos columnas desde 801px;
navegación superior hasta 800px; reproductor apilado hasta 520px. Contenido con altura
natural y espacio inferior reservado para el reproductor fijo. Las listas pueden crecer.

## Comportamiento y estados
Song.aspx usa las capas BLL y DAL y la sesión USER existente. Logout.aspx es el único
destino para cerrar sesión y elimina tanto la cookie de autenticación como la sesión.
Los errores de catálogo incluyen recarga; un catálogo vacío explica cómo comenzar.
Cada archivo ausente se identifica en texto y tiene reproducción deshabilitada.
Scripts/song.js es dueño de búsqueda local, reproducción y mensajes accesibles. La búsqueda
se refleja en q en la URL, ignora tildes y tiene botón para limpiar, respetando composición.
El servidor valida sesión y token antes de registrar una reproducción por POST.
El contador se incrementa al comenzar el audio; pausar y reanudar no vuelve a contarlo.
No existen acciones de edición o eliminación en esta pantalla de escucha.

## Accesibilidad
Botones nativos, etiquetas para búsqueda y rangos, foco visible, enlace de salto, tabla
semántica y mensajes con role=status. Los errores persisten hasta otra acción.
Transiciones de 150ms desactivadas con reduced-motion; scrollbars visibles y globales.
No se usan diálogos del navegador ni componentes de selección propios.
