{#/*============================================================================
  Vídeo de topo (customização) — CARROSSEL de 2 vídeos hospedados no Bunny Stream,
  entregues como .mp4 720p. Cada vídeo toca em "modo fundo":
  autoplay, mudo, em loop, sem controles. Setas nas laterais alternam entre eles.
  Inclui botão de som (mudo/ligado) que age no vídeo ativo.

  Slide 0 = vídeo NOVO (hero-slide1-*). Slide 1 = vídeo ANTIGO (hero-slide2-*).
  Os nomes acima são os títulos na biblioteca do Bunny (library 741861).
  O corte 1:1 do mobile é um ARQUIVO próprio: o Bunny não corta por URL como
  o Cloudinary fazia, então cada slide tem duas versões enviadas separadamente.
  Para inverter a ordem, basta trocar a ordem dos dois <video> abaixo.

  Responsivo: por padrão carrega a versão 16:9 (desktop). No mobile o JS troca
  cada vídeo para a versão 1:1 (quadrada) — carrega só o necessário.

  A troca de slide usa display (block/none) inline !important, de propósito: o
  tema aplica uma transição de opacidade no .hero-video-media que "briga" com
  qualquer opacity/classe nossa; display é imune a isso.
==============================================================================*/#}

<section class="hero-video-section" data-store="home-hero-video">
    <div class="hero-video exx-hero-carousel">

        {# Slide 0 — vídeo NOVO #}
        <video
            class="hero-video-media exx-hero-slide"
            data-hero-slide="0"
            autoplay muted playsinline webkit-playsinline="true" preload="auto"
            poster="https://vz-efb4f846-b46.b-cdn.net/43ee63c3-379c-450b-8414-2fa295102dfb/thumbnail.jpg">
            <source src="https://vz-efb4f846-b46.b-cdn.net/43ee63c3-379c-450b-8414-2fa295102dfb/play_720p.mp4" type="video/mp4">
        </video>

        {# Slide 1 — vídeo ANTIGO (começa oculto) #}
        <video
            class="hero-video-media exx-hero-slide"
            data-hero-slide="1"
            muted playsinline webkit-playsinline="true" preload="auto"
            style="display:none"
            poster="https://vz-efb4f846-b46.b-cdn.net/b4b2bcdb-d78c-4aa1-aa0c-47adae94a6ed/thumbnail.jpg">
            <source src="https://vz-efb4f846-b46.b-cdn.net/b4b2bcdb-d78c-4aa1-aa0c-47adae94a6ed/play_720p.mp4" type="video/mp4">
        </video>

        {# Setas de navegação (uma de cada lado) #}
        <button type="button" class="exx-hero-nav exx-hero-nav--prev" id="heroPrev" aria-label="Vídeo anterior">&#8249;</button>
        <button type="button" class="exx-hero-nav exx-hero-nav--next" id="heroNext" aria-label="Próximo vídeo">&#8250;</button>

        {# Botão de som — começa mudo; clique ativa/desativa o áudio do vídeo ativo #}
        <button type="button" class="hero-video-sound" id="heroVideoSound" aria-label="Ativar som do vídeo" aria-pressed="false">
            <svg class="icon-sound-off" viewBox="0 0 24 24" aria-hidden="true"><path d="M16.5 12A4.5 4.5 0 0 0 14 7.97v2.21l2.45 2.45c.03-.2.05-.42.05-.63zm2.5 0c0 .94-.2 1.82-.54 2.64l1.51 1.51A8.8 8.8 0 0 0 21 12c0-4.28-2.99-7.86-7-8.77v2.06c2.89.86 5 3.54 5 6.71zM4.27 3 3 4.27 7.73 9H3v6h4l5 5v-6.73l4.25 4.25c-.67.52-1.42.93-2.25 1.18v2.06a8.94 8.94 0 0 0 3.69-1.81L19.73 21 21 19.73l-9-9L4.27 3zM12 4 9.91 6.09 12 8.18V4z"/></svg>
            <svg class="icon-sound-on" viewBox="0 0 24 24" aria-hidden="true"><path d="M3 9v6h4l5 5V4L7 9H3zm13.5 3A4.5 4.5 0 0 0 14 7.97v8.05c1.48-.73 2.5-2.25 2.5-4.02zM14 3.23v2.06c2.89.86 5 3.54 5 6.71s-2.11 5.85-5 6.71v2.06c4.01-.91 7-4.49 7-8.77s-2.99-7.86-7-8.77z"/></svg>
        </button>
    </div>
</section>

<style>
    .exx-hero-nav {
        position: absolute; top: 50%; transform: translateY(-50%);
        z-index: 6; width: 48px; height: 48px; border-radius: 50%;
        border: 0; background: rgba(0, 0, 0, .38); color: #fff;
        font-size: 30px; line-height: 1; cursor: pointer; padding: 0;
        display: flex; align-items: center; justify-content: center;
        transition: background .2s ease;
    }
    .exx-hero-nav:hover { background: rgba(0, 0, 0, .6); }
    .exx-hero-nav--prev { left: 16px; }
    .exx-hero-nav--next { right: 16px; }
    @media (max-width: 767px) {
        .exx-hero-nav { width: 40px; height: 40px; font-size: 26px; }
        .exx-hero-nav--prev { left: 8px; }
        .exx-hero-nav--next { right: 8px; }
    }
</style>

<script>
(function () {
    var carousel = document.querySelector('.exx-hero-carousel');
    if (!carousel) return;
    var slides = [].slice.call(carousel.querySelectorAll('.exx-hero-slide'));
    if (!slides.length) return;
    var prev = document.getElementById('heroPrev');
    var next = document.getElementById('heroNext');
    var soundBtn = document.getElementById('heroVideoSound');

    // Fontes 1:1 para mobile, por slide (mesma ordem dos <video> acima)
    var MOBILE = [
        { // slide 0 — novo
            mp4: 'https://vz-efb4f846-b46.b-cdn.net/afdaf9f4-3733-4b18-895a-766b22ca159f/play_720p.mp4',
            poster: 'https://vz-efb4f846-b46.b-cdn.net/afdaf9f4-3733-4b18-895a-766b22ca159f/thumbnail.jpg'
        },
        { // slide 1 — antigo (ja tem versao quadrada propria)
            mp4: 'https://vz-efb4f846-b46.b-cdn.net/273f23d3-4df4-4ebd-b97a-12854f0c93e0/play_720p.mp4',
            poster: 'https://vz-efb4f846-b46.b-cdn.net/273f23d3-4df4-4ebd-b97a-12854f0c93e0/thumbnail.jpg'
        }
    ];
    if (window.matchMedia && window.matchMedia('(max-width: 767px)').matches) {
        slides.forEach(function (v, i) {
            if (!MOBILE[i]) return;
            v.setAttribute('poster', MOBILE[i].poster);
            v.innerHTML =
                '<source src="' + MOBILE[i].mp4 + '" type="video/mp4">';
            v.load();
        });
    }

    slides.forEach(function (v) {
        v.muted = true; v.defaultMuted = true; v.setAttribute('muted', ''); v.playsInline = true;
    });

    var current = 0, muted = true;
    var AUTO_MS = 8000;        // troca automatica a cada 8s (mostra os dois videos girando)
    var autoTimer = null;
    function playSafe(v) { var p = v.play(); if (p && p.catch) { p.catch(function () {}); } }

    // Troca de slide via display (imune a transicao de opacidade do tema)
    function show(i) {
        i = (i % slides.length + slides.length) % slides.length;
        current = i;
        slides.forEach(function (v, idx) {
            if (idx === i) {
                v.style.setProperty('display', 'block', 'important');
                v.muted = muted;
                try { v.currentTime = 0; } catch (e) {}
                playSafe(v);
            } else {
                v.style.setProperty('display', 'none', 'important');
                try { v.pause(); } catch (e) {}
                v.muted = true;
            }
        });
        // agenda a proxima troca automatica (reinicia o timer a cada troca)
        if (autoTimer) clearTimeout(autoTimer);
        if (slides.length > 1) { autoTimer = setTimeout(function () { show(current + 1); }, AUTO_MS); }
    }

    if (prev) prev.addEventListener('click', function () { show(current - 1); });
    if (next) next.addEventListener('click', function () { show(current + 1); });

    if (soundBtn) {
        soundBtn.addEventListener('click', function () {
            muted = !muted;
            var v = slides[current];
            v.muted = muted;
            if (!muted) { v.volume = 1; playSafe(v); }
            soundBtn.classList.toggle('is-on', !muted);
            soundBtn.setAttribute('aria-pressed', String(!muted));
            soundBtn.setAttribute('aria-label', muted ? 'Ativar som do vídeo' : 'Desativar som do vídeo');
        });
    }

    // Autoplay resiliente (Safari/iOS): tenta tocar o slide ativo em varios eventos
    slides.forEach(function (v) {
        ['loadeddata', 'canplay', 'canplaythrough', 'loadedmetadata'].forEach(function (ev) {
            v.addEventListener(ev, function () { if (slides[current] === v) playSafe(v); });
        });
    });
    // Quando o video ativo termina, roda para o proximo (rotacao automatica)
    slides.forEach(function (v) {
        v.addEventListener('ended', function () { if (slides[current] === v) show(current + 1); });
    });

    window.addEventListener('load', function () { playSafe(slides[current]); });
    function destravar() {
        playSafe(slides[current]);
        document.removeEventListener('touchstart', destravar);
        document.removeEventListener('scroll', destravar);
    }
    document.addEventListener('touchstart', destravar, { passive: true });
    document.addEventListener('scroll', destravar, { passive: true });

    show(0);
})();
</script>
