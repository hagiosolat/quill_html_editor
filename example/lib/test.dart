// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:quill_html_editor/quill_html_editor.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   runApp(const MaterialApp(debugShowCheckedModeBanner: false, home: MyApp()));
// }

// class MyApp extends StatefulWidget {
//   const MyApp({super.key});

//   @override
//   State<MyApp> createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   late QuillEditorController controller;

//   final customToolBarList = [
//     ToolBarStyle.bold,
//     ToolBarStyle.italic,
//     ToolBarStyle.align,
//     ToolBarStyle.color,
//     ToolBarStyle.background,
//     ToolBarStyle.listBullet,
//     ToolBarStyle.listOrdered,
//     ToolBarStyle.clean,
//     ToolBarStyle.addTable,
//     ToolBarStyle.editTable,
//   ];

//   final _toolbarColor = Colors.grey.shade200;
//   final _backgroundColor = Colors.white70;
//   final _toolbarIconColor = Colors.black87;
//   final _editorTextStyle = const TextStyle(
//       fontSize: 18,
//       color: Colors.black,
//       fontWeight: FontWeight.normal,
//       fontFamily: 'Roboto');
//   final _hintTextStyle = const TextStyle(
//       fontSize: 18, color: Colors.black38, fontWeight: FontWeight.normal);

//   bool _hasFocus = false;

//   int selectedText = 0;
//   final GlobalKey _textKey = GlobalKey();
//   final List<Comment> _comments = [];
//   final TextEditingController commentController = TextEditingController();

//   void _addComment(String text) {
//     final comment = Comment(text: text);

//     setState(() {
//       _comments.add(comment);
//     });
//   }

//   @override
//   void initState() {
//     controller = QuillEditorController();
//     controller.onTextChanged((text) {
//       debugPrint('listening to $text');
//     });
//     controller.onEditorLoaded(() {
//       debugPrint('Editor Loaded :)');
//     });
//     super.initState();
//   }

//   @override
//   void dispose() {
//     controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         backgroundColor: Colors.white,
//         resizeToAvoidBottomInset: true,
//         body: Stack(
//           children: [
//             // Content that scrolls
//             Positioned.fill(
//               child: SingleChildScrollView(
//                 padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom + 80), // Added padding to avoid the keyboard
//                 child: Column(
//                   children: [
//                     Row(
//                       children: [
//                         Expanded(
//                           flex: 3,
//                           child: QuillHtmlEditor(
//                             text: "<h1>Hello</h1>This is a quill html editor example 😊",
//                             hintText: 'Hint text goes here',
//                             controller: controller,
//                             isEnabled: true,
//                             ensureVisible: false,
//                             autoFocus: false,
//                             textStyle: _editorTextStyle,
//                             hintTextStyle: _hintTextStyle,
//                             hintTextAlign: TextAlign.start,
//                             hintTextPadding: const EdgeInsets.only(left: 20),
//                             backgroundColor: _backgroundColor,
//                             inputAction: InputAction.newline,
//                             onEditingComplete: (s) => debugPrint('Editing completed $s'),
//                             onFocusChanged: (focus) {
//                               debugPrint('has focus $focus');
//                               setState(() {
//                                 _hasFocus = focus;
//                               });
//                             },
//                             onTextChanged: (text) => debugPrint('widget text change $text'),
//                             onEditorCreated: () {
//                               debugPrint('Editor has been loaded');
//                               setHtmlText('Testing text on load');
//                             },
//                             onEditorResized: (height) =>
//                                 debugPrint('Editor resized $height'),
//                             onSelectionChanged: (sel) {
//                               debugPrint('index ${sel.index}, range ${sel.length}');
//                               setState(() {
//                                 selectedText = sel.length ?? 0;
//                               });
//                             }
//                           ),
//                         ),
//                         Container(
//                           color: Colors.blue,
//                           width: 100,
//                           height: 200, // Fixed height for demonstration
//                           child: Center(child: Text('Container')),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 60), // Add space for the bottom sheet
//                   ],
//                 ),
//               ),
//             ),
//             // Fixed toolbar at the top
//             Positioned(
//               top: 0,
//               left: 0,
//               right: 0,
//               child: Container(
//                 color: _toolbarColor,
//                 padding: const EdgeInsets.all(8),
//                 child: ToolBar(
//                   toolBarColor: _toolbarColor,
//                   padding: const EdgeInsets.all(8),
//                   iconSize: 25,
//                   iconColor: _toolbarIconColor,
//                   activeIconColor: Colors.greenAccent.shade400,
//                   controller: controller,
//                   crossAxisAlignment: WrapCrossAlignment.start,
//                   direction: Axis.horizontal,
//                   customButtons: [
//                     Container(
//                       width: 25,
//                       height: 25,
//                       decoration: BoxDecoration(
//                           color: _hasFocus ? Colors.green : Colors.grey,
//                           borderRadius: BorderRadius.circular(15)),
//                     ),
//                     InkWell(
//                         onTap: () => unFocusEditor(),
//                         child: const Icon(
//                           Icons.favorite,
//                           color: Colors.black,
//                         )),
//                     InkWell(
//                         onTap: () async {
//                           var selectedText = await controller.getSelectedText();
//                           debugPrint('selectedText $selectedText');
//                           var selectedHtmlText =
//                               await controller.getSelectedHtmlText();
//                           debugPrint('selectedHtmlText $selectedHtmlText');
//                         },
//                         child: const Icon(
//                           Icons.add_circle,
//                           color: Colors.black,
//                         )),
//                   ],
//                 ),
//               ),
//             ),
//             // Fixed bottom section
//             Positioned(
//               bottom: 0,
//               left: 0,
//               right: 0,
//               child: Container(
//                 color: _toolbarColor,
//                 padding: const EdgeInsets.all(8),
//                 child: Wrap(
//                   children: [
//                     selectedText == 0 
//                       ? Wrap(
//                           children: [
//                             ElevatedButton(
//                               onPressed: () async {
//                                 setState(() {
//                                   bool setTextField  = true;
//                                 });
//                                 final selection = await controller.getSelectionRange();
//                                 if (selection == null || selection.length == 0) {
//                                   ScaffoldMessenger.of(context).showSnackBar( 
//                                     const SnackBar(content: Text('Select text to comment on')),
//                                   );
//                                 }
//                               },
//                               child: const Text('Add Comment')
//                             ),
//                             textButton(
//                               text: 'Set Text',
//                               onPressed: () {
//                                 setHtmlText(htmlContent);
//                               }
//                             ),
//                             textButton(
//                               text: 'Get Text',
//                               onPressed: () {
//                                 getHtmlText();
//                               }
//                             ),
//                             textButton(
//                               text: 'Insert Video',
//                               onPressed: () {
//                                 insertVideoURL('https://www.youtube.com/watch?v=4AoFA19gbLo');
//                                 insertVideoURL('https://vimeo.com/440421754');
//                                 insertVideoURL('http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4');
//                               }
//                             ),
//                             textButton(
//                               text: 'Insert Image',
//                               onPressed: () {
//                                 insertNetworkImage('https://i.imgur.com/0DVAOec.gif');
//                               }
//                             ),
//                             textButton(
//                               text: 'Insert Index',
//                               onPressed: () {
//                                 insertHtmlText("This text is set by the insertText method", index: 10);
//                               }
//                             ),
//                             textButton(
//                               text: 'Undo',
//                               onPressed: () {
//                                 controller.undo();
//                               }
//                             ),
//                             textButton(
//                               text: 'Redo',
//                               onPressed: () {
//                                 controller.redo();
//                               }
//                             ),
//                             textButton(
//                               text: 'Clear History',
//                               onPressed: () async {
//                                 controller.clearHistory();
//                               }
//                             ),
//                             textButton(
//                               text: 'Clear Editor',
//                               onPressed: () {
//                                 controller.clear();
//                               }
//                             ),
//                             textButton(
//                               text: 'Get Delta',
//                               onPressed: () async {
//                                 var delta = await controller.getDelta();
//                                 debugPrint('delta');
//                                 debugPrint(jsonEncode(delta));
//                               }
//                             ),
//                             textButton(
//                               text: 'Set Delta',
//                               onPressed: () {
//                                 final Map<dynamic, dynamic> deltaMap = {
//                                   "ops": [
//                                     {
//                                       "insert": {
//                                         "video": "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4"
//                                       }
//                                     },
//                                     {
//                                       "insert": {
//                                         "video": "https://www.youtube.com/embed/4AoFA19gbLo"
//                                       }
//                                     },
//                                     {"insert": "Hello"},
//                                     {
//                                       "attributes": {"header": 1},
//                                       "insert": "\n"
//                                     },
//                                   ]
//                                 };
//                                 controller.setDelta(deltaMap);
//                               }
//                             ),
//                           ],
//                         )
//                       : Container(
//                           margin: const EdgeInsets.only(bottom: 10),
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(15),
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Theme.of(context).canvasColor,
//                                 blurRadius: 0.1,
//                                 spreadRadius: 0.4,
//                                 offset: const Offset(0, 0),
//                               )
//                             ],
//                           ),
//                           child: TextFormField(
//                             key: _textKey,
//                             controller: commentController,
//                             minLines: 1,
//                             maxLines: 5,
//                             onChanged: (value) {
//                               debugPrint('onChanged $value');
//                             },
//                             onEditingComplete: () {
//                               _addComment(commentController.text);
//                               commentController.clear();
//                             },
//                             textInputAction: TextInputAction.done,
//                             keyboardType: TextInputType.text,
//                             decoration: InputDecoration(
//                               hintText: 'Add a comment',
//                               contentPadding: const EdgeInsets.symmetric(horizontal: 8),
//                               border: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(10),
//                                 borderSide: const BorderSide(color: Colors.transparent),
//                               ),
//                             ),
//                           ),
//                         ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void setHtmlText(String text) {
//     controller.setHtmlText(text);
//   }

//   void getHtmlText() async {
//     final htmlText = await controller.getHtmlText();
//     debugPrint('HTML Text: $htmlText');
//   }

//   void insertVideoURL(String url) {
//     controller.insertVideoURL(url);
//   }

//   void insertNetworkImage(String url) {
//     controller.insertNetworkImage(url);
//   }

//   void insertHtmlText(String text, {int? index}) {
//     controller.insertHtmlText(text, index: index);
//   }

//   Widget textButton({required String text, required VoidCallback onPressed}) {
//     return TextButton(
//       onPressed: onPressed,
//       child: Text(text),
//     );
//   }

//   void unFocusEditor() {
//     FocusScope.of(context).unfocus();
//   }
// }
