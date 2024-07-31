
## 1. How to create video HTML tag in Quill_html_Editor
A quick run down of how the quill_hmtl_editor was refactored to render the Html video tag as well as the Youtube videos.

Of course, video tag cannot render Youtube videos. Hence, Iframe was quill.js default implementation

In the quill_html_editor class; webviewx class was used to render the javascript code.

```
WebViewX(
          key: ValueKey(widget.controller.toolBarKey.hashCode.toString()),
          initialContent: _initialContent,
          initialSourceType: SourceType.html,
          height: _currentHeight,
          onPageStarted: (s) {
            _editorLoaded = false;
          },
          ignoreAllGestures: false,
          width: width,
          onWebViewCreated: (controller) => _webviewController = controller,
          onPageFinished: (src) {
            Future.delayed(const Duration(milliseconds: 100)).then((value) {
              _editorLoaded = true;
              debugPrint('_editorLoaded $_editorLoaded');
              if (mounted) {
                setState(() {});
              }
              widget.controller.enableEditor(isEnabled);
              if (widget.text != null) {
                _setHtmlTextToEditor(htmlText: widget.text!);
              }
              if (widget.autoFocus == true) {
                widget.controller.focus();
              }
              if (widget.onEditorCreated != null) {
                widget.onEditorCreated!();
              }
              widget.controller._editorLoadedController?.add('');
            });
          },
          dartCallBacks: {
            DartCallback(
                name: 'EditorResizeCallback',
                callBack: (height) {
                  if (_currentHeight == double.tryParse(height.toString())) {
                    return;
                  }
                })
          }
            )
```

  ## 2. A walk through on how Dart communicate with Javascript using webviewX .
   - WebviewX  has controller property to interact with the Javascript codes
```
WebviewXcontroller _webviewController;
```

- The controller has a method called callJsmethod
```
_webviewController.callJsMethod('name of the function in JavaScript', []);
```
- 

## 3. A walk through on how JavaScript communicate with Dart Code
   - A dartCallBacks property in the webviewX is a set of DartCallback class, this class is used to receive data from the JavaScript side to the Dart side.
   ```
   class DartCallback {
  /// Callback's name
  ///
  /// Note: Must be UNIQUE
  final String name;

  /// Callback function
  final Function(dynamic message) callBack;

  /// Constructor
  const DartCallback({
    required this.name,
    required this.callBack,
  });

  @override
  bool operator ==(Object other) => other is DartCallback && other.name == name;

  @override
  int get hashCode => name.hashCode;
}
   ```

 - A method at the JavaScript side is used to communicate to the Dart side.
 ```
   node.addEventListener('timeupdate', ()=> {
         const currentTime = node.currentTime;
         const duration = node.duration;
         const progress = (currentTime / duration) * 100;
         if($kIsWeb) {
          GetVideoTracking(progress.toFixed(2));
         }else {
          GetVideoTracking.postMessage(progress.toFixed(2));
          }
        });
 ```
- The code below gets the data at the dart side using the DartCallback class.That is One of the object in a set of DartCallback
  To send data to the Dart side on mobile version,  **postMessage** method is used.
```
   DartCallback(
              name: 'GetVideoTracking',
              callBack: (timing){
                  try {
                    if(timing != null) {
                         print('$timing%');
                    } else {
                      print('nothing is sent');
                    }
                    
                  } catch (e){
                    debugPrint(e.toString());
                  }
              }),
```
*name* Parameter of DartCallback class will take its value as the name of the function used at the Javascript side. 


### I. Javascript code that was added to render Youtube videos using Iframe element; to track the progress of the video.
```
                let BlockEmbed = Quill.import('blots/block/embed');

              class IframeBlot extends BlockEmbed {
                static create(value) {
                 let node = super.create(value);
                 node.setAttribute('id', 'videoframe');
                 node.setAttribute('width', value.width || 520);
                 node.setAttribute('height', value.height || 300);
                 node.setAttribute('src', `\${value.src}?enablejsapi=1`);
                 node.setAttribute('allowfullscreen',true);
                 
                   node.addEventListener('load', ()=> {
                  IframeBlot.addYoutubeTracking(node);
                  });

                 return node;                
                }

                static value(node){
                return {
                 width: node.getAttribute('width'),
                 height: node.getAttribute('height'),
                 src: node.getAttribute('src')
                };
                }

                   static addYoutubeTracking(node) {
             const player = new YT.Player(node.id, {
              events: {
                'onReady': this.onPlayerReady,
                'onStateChange': this.onPlayerStateChange
              }
             });
            }

                  static onPlayerReady(event) {
            console.log('YouTube Player is ready.');
            }

                   static onPlayerStateChange(event) {
             if(event.data == YT.PlayerState.PLAYING) {
              IframeBlot.trackProgress(event.target);
             } else if (event.data == YT.PlayerState.ENDED){
                console.log('Video has ended.');
             }
            }
             
             static trackProgress(player) {
                const duration = player.getDuration();
                const trackInterval = setInterval(() => {
                if(player.getPlayerState() === YT.PlayerState.PLAYING) {
                const currentTime = player.getCurrentTime();
                const progress = (currentTime/duration) * 100;
                  if($kIsWeb){
                    GetVideoTracking(progress.toFixed(2));
                  } else {
                    GetVideoTracking.postMessage(progress.toFixed(2));
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
```
### II. Javascript code to render Html video tag, track the video progress
```
                let BlockEmbed = Quill.import('blots/block/embed');
               class VideoBlot extends BlockEmbed{
               static create(value) {
                 let node = super.create(value);
                 node.setAttribute('id', 'videoElement');
                 node.setAttribute('width', value.width || 520);
                 node.setAttribute('height', value.height || 300);
                 node.setAttribute('controls', true);

                 let source = document.createElement('source');
                 source.setAttribute('src', value.url);
                 source.setAttribute('type', 'video/mp4');

        node.addEventListener('timeupdate', ()=> {
         const currentTime = node.currentTime;
         const duration = node.duration;
         const progress = (currentTime / duration) * 100;
         if($kIsWeb) {
          GetVideoTracking(progress.toFixed(2));
         }else {
          GetVideoTracking.postMessage(progress.toFixed(2));
          }
        });
        
        node.addEventListener('play', ()=> {
         if($kIsWeb){
          VideoStateChange('Video is playing');
         } else {
          VideoStateChange.postMessage('Video is playing');
         }
        });

        node.addEventListener('pause', () => {
         if($kIsWeb){
          VideoStateChange('Video is paused');
         } else {
          VideoStateChange.postMessage('Video is paused');
         }
         });

          node.addEventListener('ended', () => {
         if($kIsWeb){
          VideoStateChange('Video has ended');
         } else {
          VideoStateChange.postMessage('Video has ended');
         }
         });

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
```
## 2. Other changes that was made is highlighting text when comment is made for the package on mobile version.
  **setFormat** function was edited to re-format the text when a comment is made on a text.

  ```
     function setFormat(format, value, index, length) {
               index = index || -1;
               length = length || 0;
            try{
              if(format == 'clean') {
                var range = quilleditor.getSelection(true);
                if(range) {
                  if(range.length == 0) {
                    quilleditor.removeFormat(range.index, quilleditor.root.innerHTML.length);
                  } else {
                    quilleditor.removeFormat(range.index, range.length);
                  }
                } else {
                  quilleditor.format('clean');
                }
              } else {
                 if(index >= 0 && length > 0) {
                  quilleditor.setSelection(index, length);              
                 }

                   quilleditor.format(format, value);
                 
               
              }
            }catch(e){
            console.log('setFormat',e);
            }
              return '';
            }
  ```

## Summary
The quill_html package was re-factored to render video element by extending the blot class.