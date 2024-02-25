document.addEventListener('DOMContentLoaded', function() {
    const isIOS = isIOSDevice();
    if (!isIOS) return;
    
    const isKakaoTalk = isKakaoTalkInAppBrowser();
    if (isKakaoTalk) return;
        
    // TODO: https://apps.apple.com/app/id123456789
    window.location.href = 'https://apps.apple.com';

    setTimeout(() => {
       window.history.back(); 
    }, 1000);
});

function isIOSDevice() {
    return /iPhone|iPad/i.test(navigator.userAgent);
};

function isKakaoTalkInAppBrowser() {
    return navigator.userAgent.toLowerCase().match(/kakaotalk/i);
};
