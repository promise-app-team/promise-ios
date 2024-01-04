document.addEventListener("DOMContentLoaded", function() {
    const isMobile = isMobileDevice()

    if (isMobile) {
        var path = window.location.pathname;
        var pathSegments = path.split('/');

        if (pathSegments[1] === 'promise') {
            setTimeout(() => redirect(), 500)
        }
    }
});

function isMobileDevice() {
    return /iPhone|iPad/i.test(navigator.userAgent);
}

function isKakaoTalkInAppBrowser() {
    return navigator.userAgent.toLowerCase().match(/kakaotalk/i)
}

function redirect() {
    const isKakaoTalk = isKakaoTalkInAppBrowser()
   
    if (isKakaoTalk) {
        const targetUrl = location.href
        window.location.href = 'kakaotalk://web/openExternal?url='+encodeURIComponent(targetUrl);
        return  
    }

    window.location.href = 'https://apps.apple.com';

    // window.location.href = 'https://global-song-391605.web.app/promise/123';
    // window.location.href = 'https://apps.apple.com/app';
}
