///Generate the video List and convert it to a container with the thumbnail
async function replaceVideoWithThumbnail(htmlContent) {
    //Create a temporary element to hold the HTML content
    const tempDiv = document.createElement('div');
    tempDiv.innerHTML = htmlContent;

    const videos = tempDiv.querySelectorAll('video');

    for (let video of videos) {
        const videoSrc = video.getAttribute('src') || video.querySelector('source').getAttribute('src');
        if (videoSrc) {
            try {
                const thumbnailUrl = await generateThumbnail(videoSrc);

                //Create an <img> tag with the thumbnail URL
                const img = document.createElement('img');
                img.setAttribute('src', thumbnailUrl);
                img.setAttribute('alt', 'Video Thumbnail');
                img.classList.add('video-thumbnail');

                img.style.width = '40px';
                img.style.height = 'auto';
                img.style.display = 'block';

                //Create a div to wrap the img and the play button
                const wrapperDiv = document.createElement('div');
                wrapperDiv.classList.add('thumbnail-wrapper');

                // Inline styles for the wrapper div
                wrapperDiv.style.position = 'relative';
                // wrapperDiv.style.display = 'inline-block';
                wrapperDiv.style.backgroundColor = 'blue';
                wrapperDiv.style.width = '50%'
                wrapperDiv.style.height = '600px';


                const playButton = document.createElement('div');
                playButton.classList.add('play-button');
                playButton.innerHTML = '&#9658';
                playButton.style.position = 'fixed';
                playButton.style.top = '50px';
                playButton.style.left = '50%';
                playButton.style.transform = 'translate(-50%, -50%)';
                playButton.style.fontSize = '150px';
                playButton.style.color = 'red';
                playButton.style.backgroundColor = 'rgba(0, 0, 0, 0.5)';
                playButton.style.borderRadius = '50%';
                playButton.style.padding = '20px';
                playButton.style.cursor = 'pointer';



                //Append the playButtonDiv to the wrapperDiv after the img
                wrapperDiv.appendChild(img);
                wrapperDiv.appendChild(playButton);


                tempDiv.appendChild(wrapperDiv);
                //video.appendChild(wrapperDiv);
                // video.parentNode.replaceChild(wrapperDiv, video);
            } catch (error) {
                console.log('Error generating thumbnail:', error);
            }
        }
    }
    return tempDiv.innerHTML; //Return the modified HTML             
}



/// Generate the video List and convert it to a container with the thumbnail
async function replaceVideoWithThumbnail2(htmlContent) {
    const tempDiv = document.createElement('div');
    tempDiv.innerHTML = htmlContent;

    const videos = tempDiv.querySelectorAll('video');

    for (let video of videos) {
        const videoSrc = video.getAttribute('src') || video.querySelector('source').getAttribute('src');
        if (videosrc) {
            try {
                const thumbnail = await generateThumbnail(videoSrc);

                const alt = 'adf';

                let doc = `
                <div style='position:relative;'>
                <img src=${thumbnail} style='width:100%;' alt = ${alt} />
                <span style = 'position:absolute; color:white; left:50%; bottom:50%; transform: translateX(-50%)'>
                play icon
                </span>
                </div>
                `;

                const wrapper = document.createElement('div');

                wrapper.innerHTML = doc;

                document.body.appendChild(wrapper); //replace with appropriate code

            } catch (error) { }
        }
    }
}

















const thumbnailUrl = await generateThumbnail(videoSrc);
const range = quilleditor.getSelection(true);
quilleditor.insertEmbed(range.index, 'videoThumbnail', {
    src: src,
    videoUrl: videoSrc,
    alt: alt
});