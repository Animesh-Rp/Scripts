// ==UserScript==
// @name         Plex Skip Forward 10s
// @namespace    http://tampermonkey.net/
// @version      1.0
// @description  Change Plex skip forward from 30s to 5s and for youtube it also
// @match        https://app.plex.tv/*
// @match        https://www.youtube.com/*
// @grant        none
// ==/UserScript==

(function() {
    'use strict';

    // Observe keydown events
    document.addEventListener('keydown', function(e) {
        let video = document.querySelector('video');
        if (!video) return;

        if (e.key === "ArrowRight") {
            e.preventDefault();
            e.stopImmediatePropagation(); // stop other scripts
            video.currentTime += 5;
        }
        if (e.key === "ArrowLeft") {
            e.preventDefault();
            e.stopImmediatePropagation(); // stop other scripts
            video.currentTime -= 5;
        }
    }, true); // use capture phase to run before site scripts
})();
