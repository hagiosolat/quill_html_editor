
const thumbnailUrl = await generateThumbnail(videoSrc);
const range = quilleditor.getSelection(true);
quilleditor.insertEmbed(range.index, 'videoThumbnail', {
    src: src,
    videoUrl: videoSrc,
    alt: alt
});



async function setHtmlText(htmlString) {
    console.log('*****&&&****&&&*****&&&*****&&&&&******&&&******&&&&&*****&&&&****&&&&****');
    try {
        console.log('*****&&&****&&&*****&&&*****&&&&&******&&&******&&&&&*****&&&&****&&&&****');
        quilleditor.enable(false);
        const tempDiv = document.createElement('div');
        tempDiv.innerHTML = htmlString;

        let index = quilleditor.getLength();

        Array.from(tempDiv.childNodes).forEach(async (node) => {


            if (node.nodeType === 1) {
                if (node.tagName === 'video' || node.tagName === 'source') {

                    const videoUrl = node.querySelector('source')?.getAttribute('src') || node.getAttribute('src');

                    if (videoUrl) {
                        console.log('*****&&&****&&&*****&&&*****&&&&&******&&&******&&&&&*****&&&&****&&&&****');
                        quilleditor.insertEmbed(index, 'videothumbnail', videoUrl);

                        index += 1;
                    }
                } else {

                    quilleditor.clipboard.dangerouslyPasteHTML(index, node.outerHTML || node.textContent);
                    index = quilleditor.getLength();
                }
            }

        });
        quilleditor.getSelection(quilleditor.getLength(), Quill.source.SILENT);




        //   const modifiedHtml = await replaceVideoWithThumbnail(htmlString);

        //  console.log(`\${modifiedHtml}`);
        //   console.log('*****&&&****&&&*****&&&*****&&&&&******&&&******&&&&&*****&&&&****&&&&****');
        //   quilleditor.enable(false);
        //   quilleditor.clipboard.dangerouslyPasteHTML(modifiedHtml);  
        // quilleditor.clipboard.dangerouslyPasteHTML(htmlString);   
    } catch (e) {
        console.log('setHtmlText', e);
    }
    setTimeout(() => quilleditor.enable($isEnabled), 10);
    return '';
}


async function setHtmlText(htmlString) {
    const tempDiv = document.createElement('div');
    tempDiv.innerHTML = htmlString;

    let index = quilleditor.getLength();

    for (const node of tempDiv.childNodes) {
        index = await processNode(node, index);//update the index after processing
    }

    quilleditor.setSelection(quilleditor.getLength(), Quill.sources.SILENT);
}


async function processNode(node, index) {
    switch (node.nodeType) {
        case 1:
            return await handleElementNode(node, index);
        case 3:
            return await handleTextNode(node, index);
        case 4:
            return await handleCommentNode(node, index);
        default:
            console.warn('Unknown node type:', node.nodeType);
            return index;
    }
}





///Generate the video List and convert it to a container with the thumbnail
async function replaceVideoWithThumbnail(htmlContent) {
    //Create a temporary element to hold the HTML content
    const tempDiv = document.createElement('div');
    tempDiv.innerHTML = htmlContent;

    const videos = tempDiv.querySelectorAll('video');

    const iframes = tempDiv.querySelectorAll('iframe');

    for (let video of videos) {
        const width = video.getAttribute('width');
        const height = video.getAttribute('height');
        const videoSrc = video.getAttribute('src') || video.querySelector('source').getAttribute('src');
        if (videoSrc) {
            try {

                const thumbnailUrl = await generateThumbnail(videoSrc);

                const thumbnailWithButton = insertThumbnailWithPlayButton(thumbnailUrl, videoSrc, width, height);


                video.parentNode.replaceChild(thumbnailWithButton, video);


            } catch (error) {
                console.log('Error generating thumbnail:', error);
            }
        }
    }

    for (let iframe of iframes) {
        const videoSrc = iframe.getAttribute('src');

        if (videoSrc) {
            try {
                const thumbnailUrl = await getYouTubeThumbnail(url);
                const thumbnailWithButton = insertThumbnailWithPlayButton(thumbnailUrl, videoSrc);

                iframe.parentNode.replaceChild(thumbnailWithButton, iframe);

            } catch (e) {
                console.log('Error generating thumbnail:', e);
            }
        }
    }


    return tempDiv.innerHTML; //Return the modified HTML             
}


function getYouTubeThumbnail(url) {


    // Regular expression to extract the video ID from a YouTube URL
    const regex = /(?:https?:\/\/)?(?:www\.)?(?:youtube\.com\/(?:[^\/\n\s]+\/\S+\/|(?:v|embed|e)\/|\S*?[?&]v=)|youtu\.be\/)([a-zA-Z0-9_-]{11})/;
    const match = url.match(regex);

    if (match && match[1]) {
        const videoId = match[1];

        // Construct different thumbnail URLs
        const thumbnails =
            `https://img.youtube.com/vi/${videoId}/hqdefault.jpg`;



        return thumbnails;
    } else {
        console.error('Invalid YouTube URL');
        return null;
    }
}











///Generate the video List and convert it to a container with the thumbnail
async function replaceVideoWithThumbnail(htmlContent) {
    //Create a temporary element to hold the HTML content
    const tempDiv = document.createElement('div');
    tempDiv.innerHTML = htmlContent;

    const videos = tempDiv.querySelectorAll('video');
    // const iframes = tempDiv.querySelectorAll('iframe');


    for (let iframe of iframes) {

        //       const videoSrc = iframe.getAttribute('src');

        //        if (videoSrc) {
        //           try {
        //           Console.log(`\${videoSrc}`);
        //           const thumbnailUrl = await getYouTubeThumbnail(url);
        //           const thumbnailWithButton = insertThumbnailWithPlayButton(thumbnailUrl, videoSrc);

        //           iframe.parentNode.replaceChild(thumbnailWithButton, iframe);

        //       } catch (e) {
        //           console.log('Error generating videoThumbnail:', e);
        //       }
        //     }
        //  }
        for (let video of videos) {
            const width = video.getAttribute('width');
            const height = video.getAttribute('height');
            const videoSrc = video.getAttribute('src') || video.querySelector('source').getAttribute('src');
            if (videoSrc) {
                try {
                    //Create an <img> tag with the thumbnail URL
                    console.log(`This is the width of the video \${width}`);
                    console.log(`This is the height of the video \${height}`);

                    const thumbnailUrl = await generateThumbnail(videoSrc);

                    const thumbnailWithButton = insertThumbnailWithPlayButton(thumbnailUrl, videoSrc, width, height);


                    video.parentNode.replaceChild(thumbnailWithButton, video);


                } catch (error) {
                    console.log('Error generating thumbnail:', error);
                }
            }
        }


        return tempDiv.innerHTML; //Return the modified HTML             
    }



}

















async function setHtmlText(htmlContent) {
    // Parse the HTML string into a DOM structure
    const tempDiv = document.createElement('div');
    tempDiv.innerHTML = htmlContent;

    let index = 0; // Keeps track of insertion index in Quill

    // Recursive function to process each node
    async function processNode(node) {
        if (node.nodeType === Node.ELEMENT_NODE) {
            if (node.tagName === 'VIDEO') {
                // Handle video tags
                const videoSource = node.querySelector('source');
                if (videoSource) {
                    const videoUrl = videoSource.getAttribute('src');
                    // const thumbnailUrl = await generateThumbnail(videoUrl);

                    // Insert video thumbnail as a custom blot
                    quill.insertEmbed(index, 'videoThumbnail', videoUrl);
                    index += 1; // Increment index for the next insert
                }
            } else {
                // Recursively process child nodes
                for (const childNode of node.childNodes) {
                    await processNode(childNode);
                }
            }
        } else if (node.nodeType === Node.TEXT_NODE) {
            // Insert plain text
            quill.insertText(index, node.textContent);
            index += node.textContent.length;
        }
    }

    // Start processing nodes
    for (const childNode of tempDiv.childNodes) {
        await processNode(childNode);
    }
}

// Mock function to generate a thumbnail (replace with real logic)
async function generateThumbnail(videoUrl) {
    return 'https://via.placeholder.com/150?text=Video+Thumbnail'; // Placeholder
}

// Custom Video Blot Definition
class CustomVideoBlot extends BlockEmbed {
    static create(value) {
        const node = super.create();
        const { videoUrl, thumbnailUrl } = value;

        // Create div container
        const container = document.createElement('div');
        container.classList.add('video-container');
        container.style.position = 'relative';
        container.style.display = 'inline-block';

        // Create thumbnail image
        const img = document.createElement('img');
        img.src = thumbnailUrl;
        img.alt = 'Video Thumbnail';
        img.style.cursor = 'pointer';
        img.style.display = 'block';

        container.appendChild(img);
        container.setAttribute('data-video-url', videoUrl);

        // Handle click event (optional)
        img.addEventListener('click', () => {
            alert(`Play video: ${videoUrl}`);
        });

        node.appendChild(container);
        return node;
    }

    static value(domNode) {
        const container = domNode.querySelector('.video-container');
        return {
            videoUrl: container.getAttribute('data-video-url'),
            thumbnailUrl: container.querySelector('img').getAttribute('src'),
        };
    }
}

CustomVideoBlot.blotName = 'video';
CustomVideoBlot.tagName = 'div';
Quill.register(CustomVideoBlot);

// Usage Example
const quill = new Quill('#editor', {
    theme: 'snow',
    modules: {
        toolbar: true,
    },
});

// Input HTML string
const htmlContent = `
    <h1>Sample Article</h1>
    <p>This is some text before the video.</p>
    <video width="320" height="240" controls>
        <source src="http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerFun.mp4" type="video/mp4">
    </video>
    <p>This is some text after the video.</p>
`;

// Load HTML into Quill
loadHtmlIntoQuill(quill, htmlContent);





///Generate the video List and convert it to a container with the thumbnail
async function replaceVideoWithThumbnail(htmlContent) {
    //Create a temporary element to hold the HTML content
    const tempDiv = document.createElement('div');
    tempDiv.innerHTML = htmlContent;

    const videos = tempDiv.querySelectorAll('video');

    const iframes = tempDiv.querySelectorAll('iframe');
    console.log(`Printing the iframe here is what I am trying to do here right now \${iframes}`);

    for (let iframe of iframes) {

        const videoSrc = iframe.getAttribute('src');


        if (videoSrc) {
                   try {
            Console.log(`\${videoSrc}`);
            //           const thumbnailUrl = await getYouTubeThumbnail(url);
            //           const thumbnailWithButton = insertThumbnailWithPlayButton(thumbnailUrl, videoSrc);

            //           iframe.parentNode.replaceChild(thumbnailWithButton, iframe);

                   } catch (e) {
            console.log('Error generating videoThumbnail:', e);
        }
    }
}
//    for(let video of videos){
//      const width = video.getAttribute('width');
//      const height = video.getAttribute('height');
//     const videoSrc = video.getAttribute('src') || video.querySelector('source').getAttribute('src');
//     if(videoSrc){
//         try {
//               //Create an <img> tag with the thumbnail URL
//                    console.log(`This is the width of the video \${width}`);
//                    console.log(`This is the height of the video \${height}`);

//                    const thumbnailUrl = await generateThumbnail(videoSrc);

//                    const thumbnailWithButton = insertThumbnailWithPlayButton(thumbnailUrl, videoSrc, width, height);


//                       video.parentNode.replaceChild(thumbnailWithButton, video);


//                 } catch(error) {
//          console.log('Error generating thumbnail:', error);
//         }
//     }
//  }    
return tempDiv.innerHTML; //Return the modified HTML             
      }
