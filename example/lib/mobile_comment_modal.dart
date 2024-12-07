// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';

// class MobileCommentModal extends StatefulWidget {
//   const MobileCommentModal({super.key});

//   @override
//   State<MobileCommentModal> createState() => _MobileCommentModalState();
// }

// class _MobileCommentModalState extends State<MobileCommentModal> {

//    void _addComment(String text) {
//     final comment = Comment(text: text);

//     setState(() {
//       _comments.add(comment);
//       commentController.clear();
//       selectedTextlength = 0;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.only(
//         bottom: MediaQuery.of(context).viewInsets.bottom,
//       ),
//       child: Container(
//         width: double.maxFinite,
//         padding: const EdgeInsets.all(8.0),
//         margin: const EdgeInsets.only(bottom: 10),
//         decoration:
//             BoxDecoration(borderRadius: BorderRadius.circular(15), boxShadow: [
//           BoxShadow(
//             color: Theme.of(context).canvasColor,
//             blurRadius: 0.1,
//             spreadRadius: 0.4,
//             offset: const Offset(2, 6),
//           )
//         ]),
//         child: Wrap(
//           children: [
//             Padding(
//               padding: const EdgeInsets.only(top: 14.0, left: 9, right: 9),
//               child: Column(
//                 children: [
//                   TextField(
//                     controller: commentController,
//                     autofocus: true,
//                     decoration: InputDecoration(
//                         hintText: 'Make your comment...',
//                         border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(50))),
//                   ),
//                   const SizedBox(
//                     height: 9,
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceAround,
//                     children: [
//                       ElevatedButton(
//                           onPressed: () {
//                             Navigator.pop(context);
//                           },
//                           child: const Text('Cancel')),
//                       ElevatedButton(
//                           onPressed: () {
//                             _addComment(commentController.text);
//                             controller.setFormat(
//                                 format: 'background',
//                                 value: '#FF9800',
//                                 index: index,
//                                 length: length);
//                             Navigator.pop(context);
//                           },
//                           child: const Text('Comment'))
//                     ],
//                   )
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }