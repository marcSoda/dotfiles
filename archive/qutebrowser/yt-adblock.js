
// ==UserScript==
// @name Skip YouTube ads
// @description Skips the ads in YouTube videos and removes specific elements from the DOM
// @run-at document-start
// @include *.youtube.com/*
// ==/UserScript==

document.addEventListener('load', () => {
    const btn = document.querySelector('.videoAdUiSkipButton,.ytp-ad-skip-button-modern')
    if (btn) {
        btn.click();
    }
    const ad = [...document.querySelectorAll('.ad-showing')][0];
    if (ad) {
        document.querySelector('video').currentTime = 9999999999;
    }

    // Remove elements with the class 'style-scope ytd-popup-container' and prevent-autonav="true"
    const popupContainers = document.querySelectorAll('.style-scope.ytd-popup-container[prevent-autonav="true"]');
    popupContainers.forEach(element => {
        element.remove();
    });

    // Remove all <tp-yt-iron-overlay-backdrop> elements
    const overlays = document.querySelectorAll('tp-yt-iron-overlay-backdrop');
    overlays.forEach(element => {
        element.remove();
    });
}, true);


// // ==UserScript==
// // @name Skip YouTube ads
// // @description Skips the ads in YouTube videos
// // @run-at document-start
// // @include *.youtube.com/*
// // ==/UserScript==

// document.addEventListener('load', () => {
//     const btn = document.querySelector('.videoAdUiSkipButton,.ytp-ad-skip-button-modern')
//     if (btn) {
//         btn.click()
//     }
//     const ad = [...document.querySelectorAll('.ad-showing')][0];
//     if (ad) {
//         document.querySelector('video').currentTime = 9999999999;
//     }
// }, true);
