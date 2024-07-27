import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:quill_html_editor/quill_html_editor.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MaterialApp(debugShowCheckedModeBanner: false, home: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ///[controller] create a QuillEditorController to access the editor methods
  late QuillEditorController controller;

  ///[customToolBarList] pass the custom toolbarList to show only selected styles in the editor

  final customToolBarList = [
    ToolBarStyle.bold,
    ToolBarStyle.italic,
    ToolBarStyle.align,
    ToolBarStyle.color,
    ToolBarStyle.background,
    ToolBarStyle.listBullet,
    ToolBarStyle.listOrdered,
    ToolBarStyle.clean,
    ToolBarStyle.addTable,
    ToolBarStyle.editTable,
  ];

  final _toolbarColor = Colors.grey.shade200;
  final _backgroundColor = Colors.white70;
  final _toolbarIconColor = Colors.black87;
  final _editorTextStyle = const TextStyle(
      fontSize: 18,
      color: Colors.black,
      fontWeight: FontWeight.normal,
      fontFamily: 'Roboto');
  final _hintTextStyle = const TextStyle(
      fontSize: 18, color: Colors.black38, fontWeight: FontWeight.normal);

  bool _hasFocus = false;
  
  int selectedText = 0;
  final GlobalKey _textKey = GlobalKey();
  final List<Comment> _comments = [];
  final TextEditingController commentController = TextEditingController();

  void _addComment(String text){
    final comment = Comment(text: text);

    setState(() {
      _comments.add(comment);
    });
  }

showModalSheet(){ 
  return showModalBottomSheet(
    isDismissible: false,
    context: context, builder: (context){
      return Container(
        height: 300,
      );
  });
}



  @override
  void initState() {
    controller = QuillEditorController();
    controller.onTextChanged((text) {
      debugPrint('listening to $text');
    });
    controller.onEditorLoaded(() {
      debugPrint('Editor Loaded :)');
    });
    super.initState();
  }

  @override
  void dispose() {
    /// please do not forget to dispose the controller
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: !kIsWeb ? Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: true,
      
        body:        Stack(
                        children: [
                            Positioned.fill(
                              child: SingleChildScrollView(
                                padding: EdgeInsets.only(
                                  top: 130,
                                  bottom: MediaQuery.of(context).viewInsets.bottom + 80),
                                child: Column(
                                  children: [
                                    Row(
                                              children: [
                                                Expanded(
                                                  flex: 3,
                                                  child: QuillHtmlEditor(
                                                        text: "<h1>Hello</h1>This is a quill html editor example 😊",
                                                        hintText: 'Hint text goes here',
                                                        controller: controller,
                                                        isEnabled: true,
                                                        ensureVisible: false,
                                                        minHeight: 500,
                                                        autoFocus: false,
                                                        textStyle: _editorTextStyle,
                                                        hintTextStyle: _hintTextStyle,
                                                        hintTextAlign: TextAlign.start,
                                                        //padding: const EdgeInsets.only(left: 10, top: 10),
                                                        hintTextPadding: const EdgeInsets.only(left: 20),
                                                        backgroundColor: _backgroundColor,
                                                        inputAction: InputAction.newline,
                                                        onEditingComplete: (s) => debugPrint('Editing completed $s'),
                                                        // loadingBuilder: (context) {
                                                        //   return const Center(
                                                        //       child: CircularProgressIndicator(
                                                        //     strokeWidth: 1,
                                                        //     color: Colors.red,
                                                        //   ));
                                                        // },
                                                        onFocusChanged: (focus) {
                                                          debugPrint('has focus $focus');
                                                          setState(() {
                                                            _hasFocus = focus;
                                                          });
                                                        },
                                                        onTextChanged: (text) => debugPrint('widget text change $text'),
                                                        onEditorCreated: () {
                                                          debugPrint('Editor has been loaded');
                                                          setHtmlText('Testing text on load');
                                                        },
                                                        onEditorResized: (height) =>
                                                            debugPrint('Editor resized $height'),
                                                        onSelectionChanged: (sel) {
                                                              debugPrint('index ${sel.index}, range ${sel.length}');
                                                              setState(() {
                                                                selectedText = sel.length ?? 0;
                                                              });
                                    
                                                              if(sel.length != 0){
                                                                  showModalSheet();
                                                              }
                                                        }
                                                          
                                                      ),
                                                ),
                                                  const SizedBox.shrink(),
                                                // Container(
                                                //   color: Colors.blue,
                                                //   width: 200,
                                                //   height: 500,
                                                //   child: Center(child: Text('Container'),),
                                                // )
                                              ],
                                            ),
                                  ],
                                ),
                              ),
                            ),
                          Positioned(
                            top: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                             
                              color: _toolbarColor,
                              child: ToolBar(
                                toolBarColor: _toolbarColor,
                                padding: const EdgeInsets.all(8),
                                iconSize: 25,
                                iconColor: _toolbarIconColor,
                                activeIconColor: Colors.greenAccent.shade400,
                                controller: controller,
                                crossAxisAlignment: WrapCrossAlignment.start,
                                direction: Axis.horizontal,
                                customButtons: [
                                  Container(
                                    width: 25,
                                    height: 25,
                                    decoration: BoxDecoration(
                                        color: _hasFocus ? Colors.green : Colors.grey,
                                        borderRadius: BorderRadius.circular(15)),
                                  ),
                                  InkWell(
                                      onTap: () => unFocusEditor(),
                                      child: const Icon(
                                        Icons.favorite,
                                        color: Colors.black,
                                      )),
                                  InkWell(
                                      onTap: () async {
                                        var selectedText = await controller.getSelectedText();
                                        debugPrint('selectedText $selectedText');
                                        var selectedHtmlText =
                                            await controller.getSelectedHtmlText();
                                        debugPrint('selectedHtmlText $selectedHtmlText');
                                      },
                                      child: const Icon(
                                        Icons.add_circle,
                                        color: Colors.black,
                                      )),
                                ],
                              ),
                            ),
                          ),
                          
                                                     
                            
                        
                          // Expanded(
                          //   flex: 2,
                          //   child: ListView.builder(
                          //   itemCount: _comments.length,
                          //   itemBuilder:
                          // (context, index){
                          //   final comment = _comments[index];
                          //   return ListTile(
                          //     title: Text(comment.text),
                          //   );
                          // }
                          // ),)
                          Positioned(
                            
                            left: 0,
                            right: 0,
                            bottom: 0,
                            child: 
                            
                          Container(
         // width: double.maxFinite,
          color: _toolbarColor,
          padding: const EdgeInsets.all(8),
          child: Wrap(
            children: [
                selectedText == 0 ? 
              Wrap(children: [             
              textButton(
                  text: 'Set Text',
                  onPressed: () {
                    setHtmlText(htmlContent);
                    //setHtmlText('This text is set by you 🫵');
                  }),
              textButton(
                  text: 'Get Text',
                  onPressed: () {
                    getHtmlText();
                  }),
              textButton(
                  text: 'Insert Video',
                  onPressed: () {
                    ////insert
                    insertVideoURL(
                        'https://www.youtube.com/watch?v=4AoFA19gbLo');
                    insertVideoURL('https://vimeo.com/440421754');
                    insertVideoURL(
                        'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4');
                  }),
              textButton(
                  text: 'Insert Image',
                  onPressed: () {
                    insertNetworkImage('https://i.imgur.com/0DVAOec.gif');
                  }),
              textButton(
                  text: 'Insert Index',
                  onPressed: () {
                    insertHtmlText("This text is set by the insertText method",
                        index: 10);
                  }),
              textButton(
                  text: 'Undo',
                  onPressed: () {
                    controller.undo();
                  }),
              textButton(
                  text: 'Redo',
                  onPressed: () {
                    controller.redo();
                  }),
              textButton(
                  text: 'Clear History',
                  onPressed: () async {
                    controller.clearHistory();
                  }),
              textButton(
                  text: 'Clear Editor',
                  onPressed: () {
                    controller.clear();
                  }),
              textButton(
                  text: 'Get Delta',
                  onPressed: () async {
                    var delta = await controller.getDelta();
                    debugPrint('delta');
                    debugPrint(jsonEncode(delta));
                  }),
              textButton(
                  text: 'Set Delta',
                  onPressed: () {
                    final Map<dynamic, dynamic> deltaMap = {
                      "ops": [
                        {
                          "insert": {
                            "video":
                                "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4"
                          }
                        },
                        {
                          "insert": {
                            "video": "https://www.youtube.com/embed/4AoFA19gbLo"
                          }
                        },
                        {"insert": "Hello"},
                        {
                          "attributes": {"header": 1},
                          "insert": "\n"
                        },
                        {"insert": "You just set the Delta text 😊\n"}
                      ]
                    };
                    controller.setDelta(deltaMap);
                  }),

              ],): 
                Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  
                   decoration:
                    BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                      
                      BoxShadow(
                      color: Theme.of(context).canvasColor,
                    blurRadius: 0.1,
                    spreadRadius: 0.4,
                    offset: const Offset(2,6),
                    
                   )]),
                   child: Padding(
                     padding: const EdgeInsets.only(top:14.0, left: 9,right: 9),
                     child: Column(
                      
                      children: [
                       TextField(
                         controller: commentController,
                          decoration: InputDecoration(
                            hintText: 'Make your comment...',
                          border: OutlineInputBorder(
                            
                            borderRadius: BorderRadius.circular(50)
                          )
                        ),
                      ),
                      const SizedBox(height: 9,),
                      Row(
                         mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton(onPressed: (){
                            setState(() {
                              selectedText = 2;
                            });
                          }, child: const Text('Cancel')),
                          ElevatedButton(onPressed: (){
                              _addComment(commentController.text);
                              controller.setFormat(format: 'background',value: '#FF9800');

                          }, child: const Text('Comment'))
                        ],
                      )
                     ],),
                   ),
                  ),
              
            ],
          ),
        ),
                          
                          )
                                       
                        ],
                                       ),
        
      ): Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: true,
        body: 
           CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    ToolBar(
                      toolBarColor: _toolbarColor,
                      padding: const EdgeInsets.all(8),
                      iconSize: 25,
                      iconColor: _toolbarIconColor,
                      activeIconColor: Colors.greenAccent.shade400,
                      controller: controller,
                      crossAxisAlignment: WrapCrossAlignment.start,
                      direction: Axis.horizontal,
                      customButtons: [
                        Container(
                          width: 25,
                          height: 25,
                          decoration: BoxDecoration(
                              color: _hasFocus ? Colors.green : Colors.grey,
                              borderRadius: BorderRadius.circular(15)),
                        ),
                        InkWell(
                            onTap: () => unFocusEditor(),
                            child: const Icon(
                              Icons.favorite,
                              color: Colors.black,
                            )),
                        InkWell(
                            onTap: () async {
                              var selectedText = await controller.getSelectedText();
                              debugPrint('selectedText $selectedText');
                              var selectedHtmlText =
                                  await controller.getSelectedHtmlText();
                              debugPrint('selectedHtmlText $selectedHtmlText');
                            },
                            child: const Icon(
                              Icons.add_circle,
                              color: Colors.black,
                            )),
                      ],
                    ),
                    
                      SizedBox(
                        height: MediaQuery.of(context).size.height,
                        child: Column(
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  Flexible(
                                    flex: 3,
                                    child: QuillHtmlEditor(
                                          text: "<h1>Hello</h1>This is a quill html editor example 😊",
                                          hintText: 'Hint text goes here',
                                          controller: controller,
                                          isEnabled: true,
                                          ensureVisible: false,
                                          minHeight: 500,
                                          autoFocus: false,
                                          textStyle: _editorTextStyle,
                                          hintTextStyle: _hintTextStyle,
                                          hintTextAlign: TextAlign.start,
                                          //padding: const EdgeInsets.only(left: 10, top: 10),
                                          hintTextPadding: const EdgeInsets.only(left: 20),
                                          backgroundColor: _backgroundColor,
                                          inputAction: InputAction.newline,
                                          onEditingComplete: (s) => debugPrint('Editing completed $s'),
                                          // loadingBuilder: (context) {
                                          //   return const Center(
                                          //       child: CircularProgressIndicator(
                                          //     strokeWidth: 1,
                                          //     color: Colors.red,
                                          //   ));
                                          // },
                                          onFocusChanged: (focus) {
                                            debugPrint('has focus $focus');
                                            setState(() {
                                              _hasFocus = focus;
                                            });
                                          },
                                          onTextChanged: (text) => debugPrint('widget text change $text'),
                                          onEditorCreated: () {
                                            debugPrint('Editor has been loaded');
                                            setHtmlText('Testing text on load');
                                          },
                                          onEditorResized: (height) =>
                                              debugPrint('Editor resized $height'),
                                          onSelectionChanged: (sel) {
                                                debugPrint('index ${sel.index}, range ${sel.length}');
                                                setState(() {
                                                  selectedText = sel.length ?? 0;
                                                });
                                          }
                                            
                                        ),
                                  ),
                                    const SizedBox.shrink(),
                                  // Container(
                                  //   color: Colors.blue,
                                  //   width: 200,
                                  //   height: 500,
                                  //   child: Center(child: Text('Container'),),
                                  // )
                                ],
                              ),
                            ),
                          ],
                        ),
                     ),
                      
                  
                    // Expanded(
                    //   flex: 2,
                    //   child: ListView.builder(
                    //   itemCount: _comments.length,
                    //   itemBuilder:
                    // (context, index){
                    //   final comment = _comments[index];
                    //   return ListTile(
                    //     title: Text(comment.text),
                    //   );
                    // }
                    // ),)
                
                  ],
                ),
              ),
            ],
          ),
       // ),
        bottomNavigationBar: Container(
          width: double.maxFinite,
          color: _toolbarColor,
          padding: const EdgeInsets.all(8),
          child: Wrap(
            children: [
                selectedText == 0 ? 
              Wrap(children: [
                ElevatedButton(

                onPressed: () async {
                  setState(() {
                    bool setTextField  = true;
                  });
                  final selection = await controller.getSelectionRange();
                  if(selection == null || selection.length == 0) {
                    ScaffoldMessenger.of(context).showSnackBar( 
                      const SnackBar(content: Text('Select text to comment on')),
                    
                    );
                  } else {
                  

                  }
                },
                child: const Text('Add Comment')),

              textButton(
                  text: 'Set Text',
                  onPressed: () {
                    setHtmlText(htmlContent);
                    //setHtmlText('This text is set by you 🫵');
                  }),
              textButton(
                  text: 'Get Text',
                  onPressed: () {
                    getHtmlText();
                  }),
              textButton(
                  text: 'Insert Video',
                  onPressed: () {
                    ////insert
                    insertVideoURL(
                        'https://www.youtube.com/watch?v=4AoFA19gbLo');
                    insertVideoURL('https://vimeo.com/440421754');
                    insertVideoURL(
                        'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4');
                  }),
              textButton(
                  text: 'Insert Image',
                  onPressed: () {
                    insertNetworkImage('https://i.imgur.com/0DVAOec.gif');
                  }),
              textButton(
                  text: 'Insert Index',
                  onPressed: () {
                    insertHtmlText("This text is set by the insertText method",
                        index: 10);
                  }),
              textButton(
                  text: 'Undo',
                  onPressed: () {
                    controller.undo();
                  }),
              textButton(
                  text: 'Redo',
                  onPressed: () {
                    controller.redo();
                  }),
              textButton(
                  text: 'Clear History',
                  onPressed: () async {
                    controller.clearHistory();
                  }),
              textButton(
                  text: 'Clear Editor',
                  onPressed: () {
                    controller.clear();
                  }),
              textButton(
                  text: 'Get Delta',
                  onPressed: () async {
                    var delta = await controller.getDelta();
                    debugPrint('delta');
                    debugPrint(jsonEncode(delta));
                  }),
              textButton(
                  text: 'Set Delta',
                  onPressed: () {
                    final Map<dynamic, dynamic> deltaMap = {
                      "ops": [
                        {
                          "insert": {
                            "video":
                                "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4"
                          }
                        },
                        {
                          "insert": {
                            "video": "https://www.youtube.com/embed/4AoFA19gbLo"
                          }
                        },
                        {"insert": "Hello"},
                        {
                          "attributes": {"header": 1},
                          "insert": "\n"
                        },
                        {"insert": "You just set the Delta text 😊\n"}
                      ]
                    };
                    controller.setDelta(deltaMap);
                  }),

              ],): 
                Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  
                   decoration:
                    BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                      
                      BoxShadow(
                      color: Theme.of(context).canvasColor,
                    blurRadius: 0.1,
                    spreadRadius: 0.4,
                    offset: const Offset(2,6),
                    
                   )]),
                   child: Padding(
                     padding: const EdgeInsets.only(top:14.0, left: 9,right: 9),
                     child: Column(
                      
                      children: [
                       TextField(
                         controller: commentController,
                          decoration: InputDecoration(
                            hintText: 'Make your comment...',
                          border: OutlineInputBorder(
                            
                            borderRadius: BorderRadius.circular(50)
                          )
                        ),
                      ),
                      const SizedBox(height: 9,),
                      Row(
                         mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton(onPressed: (){
                            setState(() {
                              selectedText = 2;
                            });
                          }, child: const Text('Cancel')),
                          ElevatedButton(onPressed: (){
                              _addComment(commentController.text);
                              controller.setFormat(format: 'background',value: '#FF9800');

                          }, child: const Text('Comment'))
                        ],
                      )
                     ],),
                   ),
                  ),
              
            ],
          ),
        ),
      ),
      
    );
  }

  Widget textButton({required String text, required VoidCallback onPressed}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: MaterialButton(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          color: _toolbarIconColor,
          onPressed: onPressed,
          child: Text(
            text,
            style: TextStyle(color: _toolbarColor),
          )),
    );
  }

  ///[getHtmlText] to get the html text from editor
  void getHtmlText() async {
    String? htmlText = await controller.getText();
    debugPrint(htmlText);
  }

  ///[setHtmlText] to set the html text to editor
  void setHtmlText(String text) async {
    await controller.setText(text);
  }

  ///[insertNetworkImage] to set the html text to editor
  void insertNetworkImage(String url) async {
    await controller.embedImage(url);
  }

  ///[insertVideoURL] to set the video url to editor
  ///this method recognises the inserted url and sanitize to make it embeddable url
  ///eg: converts youtube video to embed video, same for vimeo
  void insertVideoURL(String url) async {
    await controller.embedVideo(url);
  }

  /// to set the html text to editor
  /// if index is not set, it will be inserted at the cursor postion
  void insertHtmlText(String text, {int? index}) async {
    await controller.insertText(text, index: index);
  }

  /// to clear the editor
  void clearEditor() => controller.clear();

  /// to enable/disable the editor
  void enableEditor(bool enable) => controller.enableEditor(enable);

  /// method to un focus editor
  void unFocusEditor() => controller.unFocus();

  void formatText() => controller.formatText();
}


class Comment{
final String text;
Comment({required this.text});

}

const String htmlContent = '''
<html>
<body>
  <article>
    <h1>Sample Article</h1>
    <p>This is a paragraph with some sample content.<br>The Next Line</p>
    <h2>List Example</h2>
    <ul>
      <li>List item 1</li>
      <li>List item 2</li>
      <li>List item 3</li>
    </ul>
    <h2>Table Example</h2>
    <table border="1">
      <tr>
        <td>Header 1</td>
        <td>Header 2</td>
        <td>Header 1</td>
        <td>Header 2</td>
      </tr>
      <tr>
        <td>Data 1</td>
        <td>Data 2</td>
        <td>Data 1</td>
        <td>Data 2</td>
      </tr>
    </table>
    <h2>Image Example</h2>
    <p><img src="https://hips.hearstapps.com/hmg-prod/images/bright-forget-me-nots-royalty-free-image-1677788394.jpg" alt="Flowers image"></p>
    <h2>IFrame Example</h2>
    <p><iframe width="520" height="300" src="https://www.youtube.com/embed/dQw4w9WgXcQ"></iframe></p>
    </ul>
    <h2>Video Example</h2>
    <video width="320" height="240" controls>
  <source src="http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerFun.mp4" type="video/mp4">
  Your browser does not support the video tag.
  <figcaption> Hello World</figcaption>
</video>
<h2>Another Video Example</h2>
    <video width="320" height="240" controls>
  <source src="http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4" type="video/mp4">
  Your browser does not support the video tag.
  <figcaption> Hello World</figcaption>
</video>
<h2>Another Random Image</h2>
<p><img src="https://www.shutterstock.com/shutterstock/photos/2056485080/display_1500/stock-vector-address-and-navigation-bar-icon-business-concept-search-www-http-pictogram-d-concept-2056485080.jpg" alt="Flowers image"></p>
  </article>
</body>
</html>
''';







