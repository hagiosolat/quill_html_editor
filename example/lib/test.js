async function generateVideoThumbnail(videoUrl) {
    // Code to extract a thumbnail from a custom video source (like canvas)
    console.log('trying to generate the video thumbnail');

    return new Promise((resolve) => {
        const video = document.createElement('video');
        video.src = videoUrl;
        video.crossOrigin = 'anonymous';
        video.addEventListener('loadeddata', () => {
            const canvas = document.createElement('canvas');
            canvas.width = video.videoWidth;
            canvas.height = video.videoHeight;
            const context = canvas.getContext('2d');
            context.drawImage(video, 0, 0, canvas.width, canvas.height);
            const thumbnailUrl = canvas.toDataURL();
            console.log(`thumbnail Url inside the function generateVideoThumbnail \${thumbnailUrl}`);
            resolve(thumbnailUrl);
        });

        video.addEventListener('error', (err) => {
            reject('Error loading video for thumbnail generation');
        });
    });
}



///Generate the video List and convert it to a container with the thumbnail
async function replaceVideoWithThumbnail(htmlContent) {
    //Create a temporary element to hold the HTML content
    const tempDiv = document.createElement('div');
    tempDiv.innerHTML = htmlContent;

    const videos = tempDiv.querySelectorAll('video');

    videos.forEach(video => {
        const sourceElement = video.querySelector('source');
        let videoSrc = null;

        if (sourceElement) {
            videoSrc = sourceElement.getAttribute('src');
        } else {
            videoSrc = video.getAttribute('src');
        }
        if (videoSrc) {

            generateVideoThumbnail(videoSrc)
                .then(thumbnailUrl => {
                    console.log(`\${thumbnailUrl}`);
                    //Create an <img> tag with the thumbnail URL
                    const img = document.createElement('img');
                    img.setAttribute('src', thumbnailUrl);
                    img.setAttribute('alt', 'Video Thumbnail');
                    img.classList.add('video-thumbnail');

                    //Replace the <video> tag with the <img> tag
                    video.parentNode.replaceChild(img, video);
                });
        }
    });
    return tempDiv.innerHTML; //Return the modified HTML             
}



videos.forEach(video => {
    const sourceElement = video.querySelector('source');
    let videoSrc = null;
    if (sourceElement) {
        videoSrc = sourceElement.getAttribute('src');
        console.log(`the source attribute is \${videoSrc}`);
    } else {
        videoSrc = video.getAttribute('src');
    }
    if (videoSrc) {
        generateVideoThumbnail(videoSrc).then(thumbnailUrl => {
            //Create an <img> tag with the thumbnail URL
            const img = document.createElement('img');
            img.setAttribute('src', thumbnailUrl);
            img.setAttribute('alt', 'Video Thumbnail');
            img.classList.add('video-thumbnail');

            //Replace the <video> tag with the <img> tag
            video.parentNode.replaceChild(img, video);
        });
    }
}); 