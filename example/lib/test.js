class VideoBlot extends BlockEmbed {
    static create(value) {
        let node = super.create(value);

        if (value.url.includes('.mp4')) {
            let video = document.createElement('video');
            video.setAttribute('id', 'videoElement');
            video.setAttribute('width', value.width || 520);
            video.setAttribute('height', value.height || 300);
            video.setAttribute('controls', true);
            //PositionAttributor.add(node, 'relative');


            let source = document.createElement('source');
            source.setAttribute('src', `\${value.url}#t=0.3`);
            source.setAttribute('type', 'video/mp4');

            video.addEventListener('loadedmetadata', () => {
                let key = value.url;
                if (videoMap.hasOwnProperty(key)) {
                    // console.log('This is something that happen');
                    // console.log(videoMap[key]);
                    video.currentTime = videoMap[key] * 0.001;
                }

            });

            video.addEventListener('timeupdate', () => {

                const currentTime = video.currentTime * 1000;
                const duration = video.duration * 1000;
                const progress = (currentTime / duration) * 100;
                var postMap = {};
                postMap['totalDuration'] = duration;
                postMap['currentPosition'] = currentTime;
                postMap['videoUrl'] = value.url;
                if ($kIsWeb) {
                    GetVideoTracking(JSON.stringify(postMap))
                } else {
                    GetVideoTracking.postMessage(JSON.stringify(postMap))
                }
            });

            const buttonContainer = document.createElement('div');
            textAlignAttr.add(buttonContainer, 'center');
            marginTopAttr.add(buttonContainer, '8px');

            const markAsReadButton = document.createElement('button');
            markAsReadButton.innerText = 'Mark as Read';
            paddingAttr.add(markAsReadButton, '8px 12px');
            borderAttr.add(markAsReadButton, 'none');
            BackgroundColorAttributor.add(markAsReadButton, 'green')
            ColorAttributor.add(markAsReadButton, 'white');
            borderRadiusAttr.add(markAsReadButton, '4px');
            CursorAttributor.add(markAsReadButton, 'pointer');


            markAsReadButton.addEventListener('click', () => {
                console.log('Mark As read button pressed');
                console.log(`\${value.id}`);
            });

            video.addEventListener('play', () => {
            });

            video.addEventListener('pause', () => {
                if ($kIsWeb) {
                } else {
                }
            });

            video.addEventListener('ended', () => {
                if ($kIsWeb) {
                } else {
                }
            });
            buttonContainer.appendChild(markAsReadButton);
            node.appendChild(buttonContainer);
            video.appendChild(source);
            node.appendChild(video);

        }
        return node;
    }

    static value(node) {
        let source = node.querySelector('source');
        let video = node.querySelector('video')

        return {
            width: video.getAttribute('width'),
            height: video.getAttribute('height'),
            url: source ? source.getAttribute('src') : '',
        };
    }
}
VideoBlot.blotName = 'div';
VideoBlot.tagName = 'div';
Quill.register(VideoBlot);















class VideoBlot extends BlockEmbed {
    static create(value) {
        let node = super.create(value);
        node.setAttribute('id', 'videoElement');
        node.setAttribute('width', value.width || 520);
        node.setAttribute('height', value.height || 300);
        node.setAttribute('controls', true);
        //PositionAttributor.add(node, 'relative');


        let source = document.createElement('source');
        source.setAttribute('src', `\${value.url}#t=0.3`);
        source.setAttribute('type', 'video/mp4');

        node.addEventListener('loadedmetadata', () => {
            let key = value.url;
            if (videoMap.hasOwnProperty(key)) {
                // console.log('This is something that happen');
                // console.log(videoMap[key]);
                node.currentTime = videoMap[key] * 0.001;
            }

        });

        node.addEventListener('timeupdate', () => {

            const currentTime = node.currentTime * 1000;
            const duration = node.duration * 1000;
            const progress = (currentTime / duration) * 100;
            var postMap = {};
            postMap['totalDuration'] = duration;
            postMap['currentPosition'] = currentTime;
            postMap['videoUrl'] = value.url;
            if ($kIsWeb) {
                GetVideoTracking(JSON.stringify(postMap))
            } else {
                GetVideoTracking.postMessage(JSON.stringify(postMap))
            }
        });

        const buttonContainer = document.createElement('div');
        textAlignAttr.add(buttonContainer, 'center');
        marginTopAttr.add(buttonContainer, '8px');

        const markAsReadButton = document.createElement('button');
        markAsReadButton.innerText = 'Mark as Read';
        paddingAttr.add(markAsReadButton, '8px 12px');
        borderAttr.add(markAsReadButton, 'none');
        BackgroundColorAttributor.add(markAsReadButton, 'green')
        ColorAttributor.add(markAsReadButton, 'white');
        borderRadiusAttr.add(markAsReadButton, '4px');
        CursorAttributor.add(markAsReadButton, 'pointer');


        node.addEventListener('play', () => {
        });

        node.addEventListener('pause', () => {
            if ($kIsWeb) {
            } else {
            }
        });

        node.addEventListener('ended', () => {
            if ($kIsWeb) {
            } else {
            }
        });
        buttonContainer.appendChild(markAsReadButton)
        node.appendChild(buttonContainer);
        node.appendChild(source);
        return node;
    }

    static value(node) {
        let source = node.querySelector('source');

        return {
            width: node.getAttribute('width'),
            height: node.getAttribute('height'),
            url: source ? source.getAttribute('src') : '',
        };
    }
}
VideoBlot.blotName = 'video';
VideoBlot.tagName = 'video';
Quill.register(VideoBlot);
















let BlockEmbed = Quill.import('blots/block/embed');
class IframeBlot extends BlockEmbed {
    static create(value) {
        let node = super.create(value);

        if (value.url.includes('.youtube')) {


        }
        node.setAttribute('id', 'videoframe');
        node.setAttribute('width', value.width || 520);
        node.setAttribute('height', value.height || 300);
        node.setAttribute('src', `\${value.src}?enablejsapi=1`);
        node.setAttribute('allowfullscreen', true);

        node.addEventListener('load', () => {
            IframeBlot.addYoutubeTracking(node);
        });

        return node;
    }

    static value(node) {
        return {
            width: node.getAttribute('width'),
            height: node.getAttribute('height'),
            src: node.getAttribute('src')
        };
    }

    static addYoutubeTracking(node) {
        const player = new YT.Player(node.id, {
            events: {
                'onReady': (event) => this.onPlayerReady(event, node),
                'onStateChange': (event) => this.onPlayerStateChange(event, node)
            }
        });
    }

    static onPlayerReady(event, node) {
        const key = node.getAttribute('src');
        console.log(key);
        if (videoMap.hasOwnProperty(key)) {
            console.log('This is something that happen');
            const savedPosition = videoMap[key] * 0.001;
            event.target.seekTo(parseFloat(savedPosition), true); //Resume playback
        }
        // console.log('Testing the Youtube videos when ready for playing or resumption');
    }

    static onPlayerStateChange(event, node) {
        if (event.data == YT.PlayerState.PLAYING) {
            IframeBlot.trackProgress(event.target, node);
        } else if (event.data == YT.PlayerState.ENDED) {
            console.log('Video has ended.');
        }
    }

    static trackProgress(player, node) {
        const duration = player.getDuration();
        const videoUrl = node.getAttribute('src');
        const trackInterval = setInterval(() => {
            if (player.getPlayerState() === YT.PlayerState.PLAYING) {
                const currentTime = player.getCurrentTime();
                var postMap = {};
                postMap['totalDuration'] = duration * 1000;
                postMap['currentPosition'] = currentTime * 1000;
                postMap['videoUrl'] = videoUrl;
                const progress = (currentTime / duration) * 100;
                if ($kIsWeb) {
                    GetVideoTracking(JSON.stringify(postMap));
                    //   GetVideoTracking(progress.toFixed(2));
                } else {
                    GetVideoTracking.postMessage(JSON.stringify(postMap))
                    // GetVideoTracking.postMessage(progress.toFixed(2));
                }
            } else {
                clearInterval(trackInterval);
            }
        }, 1000);
    }
}
IframeBlot.blotName = 'regex';
IframeBlot.tagName = 'iframe';


Quill.register(IframeBlot);












































class IframeBlot extends BlockEmbed {
    static create(value) {
        let node = super.create(value);

        if (value.url.includes('youtube')) {
            let video = document.createElement('iframe');
            iframe.setAttribute('id', 'videoframe');
            iframe.setAttribute('width', value.width || 520);
            iframe.setAttribute('height', value.height || 300);
            iframe.setAttribute('src', `\${value.src}?enablejsapi=1`);
            iframe.setAttribute('allowfullscreen', true);

            const buttonContainer = document.createElement('div');
            textAlignAttr.add(buttonContainer, 'center');
            marginTopAttr.add(buttonContainer, '8px');

            const markAsReadButton = document.createElement('button');
            markAsReadButton.innerText = 'Mark as Read';
            paddingAttr.add(markAsReadButton, '8px 12px');
            borderAttr.add(markAsReadButton, 'none');
            BackgroundColorAttributor.add(markAsReadButton, 'green')
            ColorAttributor.add(markAsReadButton, 'white');
            borderRadiusAttr.add(markAsReadButton, '4px');
            CursorAttributor.add(markAsReadButton, 'pointer');

            // iframe.addEventListener('load', () => {
            //     IframeBlot.addYoutubeTracking(node);
            // });


            buttonContainer.appendChild(markAsReadButton);
            node.appendChild(buttonContainer);
            node.appendChild(iframe);

        }
        return node;
    }

    // static value(node) {
    //     let iframe = node.querySelector('iframe');
    //     return {
    //         width: iframe.getAttribute('width'),
    //         height: iframe.getAttribute('height'),
    //         src: iframe.getAttribute('src')
    //     };
    // }


    static onPlayerReady(event, node) {
        const key = node.getAttribute('src');
        console.log(key);
        if (videoMap.hasOwnProperty(key)) {
            console.log('This is something that happen');
            const savedPosition = videoMap[key] * 0.001;
            event.target.seekTo(parseFloat(savedPosition), true); //Resume playback
        }
        // console.log('Testing the Youtube videos when ready for playing or resumption');
    }

    static onPlayerStateChange(event, node) {
        if (event.data == YT.PlayerState.PLAYING) {
            IframeBlot.trackProgress(event.target, node);
        } else if (event.data == YT.PlayerState.ENDED) {
            console.log('Video has ended.');
        }
    }

    static trackProgress(player, node) {
        const duration = player.getDuration();
        const videoUrl = node.getAttribute('src');
        const trackInterval = setInterval(() => {
            if (player.getPlayerState() === YT.PlayerState.PLAYING) {
                const currentTime = player.getCurrentTime();
                var postMap = {};
                postMap['totalDuration'] = duration * 1000;
                postMap['currentPosition'] = currentTime * 1000;
                postMap['videoUrl'] = videoUrl;
                const progress = (currentTime / duration) * 100;
                if ($kIsWeb) {
                    GetVideoTracking(JSON.stringify(postMap));
                    //   GetVideoTracking(progress.toFixed(2));
                } else {
                    GetVideoTracking.postMessage(JSON.stringify(postMap))
                    // GetVideoTracking.postMessage(progress.toFixed(2));
                }
            } else {
                clearInterval(trackInterval);
            }
        }, 1000);
    }
}
IframeBlot.blotName = 'regex';
IframeBlot.tagName = 'iframe';
Quill.register(IframeBlot);


















































































class VideoBlot extends BlockEmbed {
    static create(value) {
        let node = super.create(value);
        PositionAttributor.add(node, 'relative');

        if (value.url.includes('.mp4')) {
            let video = document.createElement('video');
            video.setAttribute('id', 'videoElement');
            video.setAttribute('width', value.width || 520);
            video.setAttribute('height', value.height || 300);
            video.setAttribute('controls', true);
            //PositionAttributor.add(node, 'relative');


            let source = document.createElement('source');
            source.setAttribute('src', `\${value.url}#t=0.3`);
            source.setAttribute('type', 'video/mp4');

            video.addEventListener('loadedmetadata', () => {
                let key = value.url;
                if (videoMap.hasOwnProperty(key)) {
                    // console.log('This is something that happen');
                    // console.log(videoMap[key]);
                    video.currentTime = videoMap[key] * 0.001;
                }

            });

            video.addEventListener('timeupdate', () => {

                const currentTime = video.currentTime * 1000;
                const duration = video.duration * 1000;
                const progress = (currentTime / duration) * 100;
                var postMap = {};
                postMap['totalDuration'] = duration;
                postMap['currentPosition'] = currentTime;
                postMap['videoUrl'] = value.url;
                if ($kIsWeb) {
                    GetVideoTracking(JSON.stringify(postMap))
                } else {
                    GetVideoTracking.postMessage(JSON.stringify(postMap))
                }
            });

            const buttonContainer = document.createElement('div');
            textAlignAttr.add(buttonContainer, 'center');
            marginTopAttr.add(buttonContainer, '8px');

            const markAsReadButton = document.createElement('button');
            markAsReadButton.innerText = 'Mark as Read';
            paddingAttr.add(markAsReadButton, '8px 12px');
            borderAttr.add(markAsReadButton, 'none');
            BackgroundColorAttributor.add(markAsReadButton, 'green')
            ColorAttributor.add(markAsReadButton, 'white');
            borderRadiusAttr.add(markAsReadButton, '4px');
            CursorAttributor.add(markAsReadButton, 'pointer');


            markAsReadButton.addEventListener('click', () => {
                console.log('Mark As read button pressed');
                console.log(`\${value.id}`);
            });

            video.addEventListener('play', () => {
            });

            video.addEventListener('pause', () => {
                if ($kIsWeb) {
                } else {
                }
            });

            video.addEventListener('ended', () => {
                if ($kIsWeb) {
                } else {
                }
            });
            video.appendChild(source);
            node.appendChild(video);
            buttonContainer.appendChild(markAsReadButton);
            node.appendChild(buttonContainer);

        }

        else if (value.url.includes('youtube')) {
            const iframe = document.createElement('iframe');
            iframe.setAttribute('src', value.url);
            iframe.setAttribute('width', value.width || '560');
            iframe.setAttribute('height', value.height || '315');
            iframe.setAttribute('frameborder', '0');
            iframe.setAttribute(
                'allow',
                'accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture'
            );
            iframe.setAttribute('allowfullscreen', true);


            // Create the button
            const button = document.createElement('button');
            button.innerText = 'Mark as Watched';
            button.style.marginTop = '10px';
            button.style.padding = '5px 10px';
            button.style.backgroundColor = '#007BFF';
            button.style.color = '#fff';
            button.style.border = 'none';
            button.style.cursor = 'pointer';
            button.style.borderRadius = '5px';

            node.appendChild(iframe);
            node.appendChild(button);

        }
        return node;
    }

    static value(node) {
        let source = node.querySelector('source');
        let video = node.querySelector('video')
        const iframe = node.querySelector('iframe');

        if (source != null) {
            return {
                width: vvideo.getAttribute('width'),
                height: video.getAttribute('height'),
                url: source ? source.getAttribute('src') : '',
            };
        } else {
            return {
                url: iframe ? iframe.getAttribute('src') : '',
                width: iframe ? iframe.getAttribute('width') : '560',
                height: iframe ? iframe.getAttribute('height') : '315',
            };
        }
    }
}
VideoBlot.blotName = 'div';
VideoBlot.tagName = 'div';
//videoBlot.className = 'videoContainer'
Quill.register(VideoBlot);











































































































































class VideoBlot extends BlockEmbed {
    static create(value) {
        let node = super.create(value);
        // PositionAttributor.add(node, 'relative');

        if (value.url.includes('.mp4')) {

            console.log('This is the video Log for videos');
            let video = document.createElement('video');
            video.setAttribute('id', 'videoElement');
            video.setAttribute('width', value.width || 520);
            video.setAttribute('height', value.height || 300);
            video.setAttribute('controls', true);
            //PositionAttributor.add(node, 'relative');


            let source = document.createElement('source');
            source.setAttribute('src', `\${value.url}#t=0.3`);
            source.setAttribute('type', 'video/mp4');

            video.addEventListener('loadedmetadata', () => {
                let key = value.url;
                if (videoMap.hasOwnProperty(key)) {
                    // console.log('This is something that happen');
                    // console.log(videoMap[key]);
                    video.currentTime = videoMap[key] * 0.001;
                }

            });

            video.addEventListener('timeupdate', () => {

                const currentTime = video.currentTime * 1000;
                const duration = video.duration * 1000;
                const progress = (currentTime / duration) * 100;
                var postMap = {};
                postMap['totalDuration'] = duration;
                postMap['currentPosition'] = currentTime;
                postMap['videoUrl'] = value.url;
                if ($kIsWeb) {
                    GetVideoTracking(JSON.stringify(postMap))
                } else {
                    GetVideoTracking.postMessage(JSON.stringify(postMap))
                }
            });

            const buttonContainer = document.createElement('div');
            textAlignAttr.add(buttonContainer, 'center');
            marginTopAttr.add(buttonContainer, '8px');

            const markAsReadButton = document.createElement('button');
            markAsReadButton.innerText = 'Mark as Read';
            paddingAttr.add(markAsReadButton, '8px 12px');
            borderAttr.add(markAsReadButton, 'none');
            BackgroundColorAttributor.add(markAsReadButton, 'green')
            ColorAttributor.add(markAsReadButton, 'white');
            borderRadiusAttr.add(markAsReadButton, '4px');
            CursorAttributor.add(markAsReadButton, 'pointer');


            markAsReadButton.addEventListener('click', () => {
                console.log('Mark As read button pressed');
                console.log(`\${value.id}`);
            });

            video.addEventListener('play', () => {
            });

            video.addEventListener('pause', () => {
                if ($kIsWeb) {
                } else {
                }
            });

            video.addEventListener('ended', () => {
                if ($kIsWeb) {
                } else {
                }
            });
            video.appendChild(source);
            node.appendChild(video);
            buttonContainer.appendChild(markAsReadButton);
            node.appendChild(buttonContainer);

        }

        //   else if(value.url.includes('youtube')) {
        //             const iframe = document.createElement('iframe');
        //     iframe.setAttribute('src', value.url);
        //     iframe.setAttribute('width', value.width || '560');
        //    iframe.setAttribute('height', value.height || '315');
        //    iframe.setAttribute('frameborder', '0');
        //   iframe.setAttribute(
        //   'allow',
        //   'accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture'
        // );
        //   iframe.setAttribute('allowfullscreen', true);


        //     // Create the button
        // const button = document.createElement('button');
        // button.innerText = 'Mark as Watched';
        // button.style.marginTop = '10px';
        // button.style.padding = '5px 10px';
        // button.style.backgroundColor = '#007BFF';
        // button.style.color = '#fff';
        // button.style.border = 'none';
        // button.style.cursor = 'pointer';
        // button.style.borderRadius = '5px';
        // node.appendChild(iframe);
        // node.appendChild(button);  
        //   }
        return node;
    }

    static value(node) {
        let source = node.querySelector('source');
        let video = node.querySelector('video')
        // const iframe = node.querySelector('iframe');

        return {
            width: vvideo.getAttribute('width'),
            height: video.getAttribute('height'),
            url: source ? source.getAttribute('src') : '',
        };

        // else {
        //  return {
        //   url: iframe ? iframe.getAttribute('src') : '',
        //   width: iframe ? iframe.getAttribute('width') : '560',
        //   height: iframe ? iframe.getAttribute('height') : '315',
        // };
        //    }      
    }
}
VideoBlot.blotName = 'div';
VideoBlot.tagName = 'div';
//videoBlot.className = 'videoContainer'
Quill.register(VideoBlot);























































































































function wrapMediaWithDiv() {
    // Get all video and iframe tags
    const mediaElements = document.querySelectorAll('video, iframe');

    mediaElements.forEach((media) => {
        // Create a div element
        const wrapperDiv = document.createElement('div');
        wrapperDiv.style.position = 'relative'; // Example styling
        wrapperDiv.style.margin = '10px 0';    // Add some spacing if needed

        // Insert the div before the media element
        media.parentNode.insertBefore(wrapperDiv, media);

        // Move the media element inside the div
        wrapperDiv.appendChild(media);
    });
}

// Call the function
wrapMediaWithDiv();
