document.addEventListener("DOMContentLoaded", function() {
    const isIOS = isIOSDevice();

    if (isIOS) {
        const path = window.location.pathname;
        const link = `https://global-song-391605.web.app${path}`;
        
        assignGetPromiseBtnHandler(link)

        const isKakaoTalk = isKakaoTalkInAppBrowser();
        if(isKakaoTalk) {
            window.location.href = 'kakaotalk://web/openExternal?url='+encodeURIComponent(link);
            return;
        }
    }
});

function assignGetPromiseBtnHandler(link) {
    const element = document.querySelector('.btn-get-promise');
    element.onclick = () => {
        window.location.href = link;
    };
};

function isIOSDevice() {
    return /iPhone|iPad/i.test(navigator.userAgent);
};

function isKakaoTalkInAppBrowser() {
    return navigator.userAgent.toLowerCase().match(/kakaotalk/i);
};
