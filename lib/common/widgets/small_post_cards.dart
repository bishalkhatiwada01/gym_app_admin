// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:gymapp/common/functions/date.dart';
// import 'package:gymapp/features/posts/data/post_data_model.dart';
// import 'package:gymapp/features/posts/pages/post_detail_page.dart';
// import 'package:gymapp/features/profile/data/user_service.dart';
// import 'package:gymapp/features/profile/model/user_model.dart';

// // Create a provider to fetch user data based on userId from postData
// final userByIdProvider =
//     FutureProvider.family<UserModel, String>((ref, userId) {
//   return UserService().getUserById(userId); // Fetch user by their userId
// });

// class SmallPostCard extends ConsumerWidget {
//   final PostDataModel postData;

//   const SmallPostCard({
//     required this.postData,
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final userById =
//         ref.watch(userByIdProvider(postData.userId)); // Fetch user by userId

//     return InkWell(
//       onTap: () {
//         Navigator.of(context).push(
//           MaterialPageRoute(
//             builder: (_) => PostDetailsPage(
//               postData: postData,
//             ),
//           ),
//         );
//       },
//       child: Card(
//         color: Colors.white,
//         elevation: 0.0,
//         margin: const EdgeInsets.all(10.0),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(12.0),
//         ),
//         child: Container(
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(12.0),
//             gradient: LinearGradient(
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//               colors: [
//                 Colors.blue[200]!,
//                 Colors.purple[200]!,
//               ],
//             ),
//           ),
//           child: SizedBox(
//             width: 300, // Fixed width for the card
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.all(10.0),
//                   child: Row(
//                     children: [
//                       userById.when(
//                         data: (userData) {
//                           return CircleAvatar(
//                             radius: 20,
//                             backgroundImage: NetworkImage(
//                               userData.profileImageUrl ?? '',
//                             ),
//                           );
//                         },
//                         error: (error, stackTrace) {
//                           return const Icon(Icons.error);
//                         },
//                         loading: () => const CircularProgressIndicator(),
//                       ),
//                       const SizedBox(width: 10),
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             userById.when(
//                               data: (userData) {
//                                 return Text(
//                                   userData.name ?? 'User Name',
//                                   style: const TextStyle(
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 16,
//                                   ),
//                                 );
//                               },
//                               error: (error, stackTrace) {
//                                 return const Text('Error loading name');
//                               },
//                               loading: () => const Text('Loading...'),
//                             ),
//                             Text(
//                               "Posted ${timeAgo(DateTime.parse(postData.postCreatedAt))}",
//                               style: const TextStyle(
//                                 fontSize: 12,
//                                 color: Colors.black,
//                                 fontStyle: FontStyle.italic,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Container(
//                   height: 45.5,
//                   padding: const EdgeInsets.symmetric(horizontal: 15),
//                   child: Text(
//                     postData.postContent,
//                     maxLines: 2,
//                     overflow: TextOverflow.ellipsis,
//                     style: const TextStyle(
//                       fontSize: 14,
//                       fontStyle: FontStyle.italic,
//                     ),
//                   ),
//                 ),
//                 ClipRRect(
//                   borderRadius: const BorderRadius.all(Radius.circular(12.0)),
//                   child: postData.postImageUrl.isNotEmpty
//                       ? Image.network(
//                           postData.postImageUrl,
//                           width: double.infinity,
//                           fit: BoxFit.cover,
//                           height: 150,
//                           loadingBuilder: (context, child, loadingProgress) {
//                             if (loadingProgress == null) return child;
//                             return const Center(
//                               child: CircularProgressIndicator(),
//                             );
//                           },
//                           errorBuilder: (context, error, stackTrace) {
//                             return const Center(
//                               child: Text(
//                                 'Error loading image!',
//                                 style: TextStyle(color: Colors.red),
//                               ),
//                             );
//                           },
//                         )
//                       : Image.asset(
//                           'assets/no_image.jpg',
//                           width: double.infinity,
//                           fit: BoxFit.cover,
//                           height: 150,
//                         ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
