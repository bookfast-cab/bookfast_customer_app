// import 'package:bookfast_customer/ui/widgets/app_common_widgets.dart';
// import 'package:bookfast_customer/utils/app_functions.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_login_facebook/flutter_login_facebook.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:sign_in_with_apple/sign_in_with_apple.dart';
//
// class SocialAuth {
//   static Future<void> initializeFirebase() async {
//     await Firebase.initializeApp();
//   }
//
//   static final FirebaseAuth auth = FirebaseAuth.instance;
//   //static final GoogleSignIn googleSignIn = GoogleSignIn(serverClientId: "520003095939-ts6i6qug7ptvdovch4f56igl6uhcgopq"/*"520003095939-932foo1a5njv60vadk4m33d8028qo06o"*/);
//   static final GoogleSignIn googleSignIn = GoogleSignIn();
//
//  static final fbLogin = FacebookLogin();
//
//
//   static Future<User?> signInWithGoogle({required BuildContext context}) async {
//     User? user;
//     try {
//       if (await googleSignIn.isSignedIn()) {
//         await googleSignIn.signOut();
//       }
//       final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
//
//       //debugPrint("Step 1 =========> ${googleSignInAccount?.authentication}");
//       if (googleSignInAccount != null) {
//         final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
//
//         final AuthCredential credential = GoogleAuthProvider.credential(
//           accessToken: googleSignInAuthentication.accessToken,
//           idToken: googleSignInAuthentication.idToken,
//         );
//
//         //debugPrint("Step 2 =========> ${credential.signInMethod}");
//         final UserCredential userCredential = await auth.signInWithCredential(credential);
//
//         user = userCredential.user;
//         //debugPrint("Step 3 =========> ${userCredential.user?.email}");
//       }
//     } on FirebaseAuthException catch (e) {
//       if (e.code == 'account-exists-with-different-credential') {
//         ScaffoldMessenger.of(context).showSnackBar(
//           customSnackBar(
//             content: 'The account already exists with a different credential',
//           ),
//         );
//       } else if (e.code == 'invalid-credential') {
//         ScaffoldMessenger.of(context).showSnackBar(
//           customSnackBar(
//             content: 'Error occurred while accessing credentials. Try again.',
//           ),
//         );
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         customSnackBar(
//           content: 'Error occurred using Google Sign In. Try again.',
//         ),
//       );
//     }
//
//     return user;
//   }
//
//   static SnackBar customSnackBar({required String content}) {
//     return SnackBar(
//       backgroundColor: Colors.black,
//       content: Text(
//         content,
//         style: const TextStyle(color: Colors.redAccent, letterSpacing: 0.5),
//       ),
//     );
//   }
//
//   static Future<User?> signInWitApple({required BuildContext context}) async {
//     User? user;
//     try {
//       final AppleAuthProvider appleAuthProvider = AppleAuthProvider();
//       appleAuthProvider.addScope('email');
//       appleAuthProvider.addScope('name');
//
//       final UserCredential userCredential = await auth.signInWithProvider(appleAuthProvider);
//
//       user = userCredential.user;
//       //debugPrint("Email------------------>${user?.email.toString()}");
//       //debugPrint("displayName------------------>${user?.displayName}");
//       //debugPrint("uid------------------>${user?.uid}");
//     } on FirebaseAuthException catch (e, st) {
//       if (e.code == 'account-exists-with-different-credential') {
//         debugPrint("Error $e $st");
//         ScaffoldMessenger.of(context).showSnackBar(
//           customSnackBar(
//             content: 'The account already exists with a different credential',
//           ),
//         );
//       } else if (e.code == 'invalid-credential') {
//         debugPrint("Error $e $st");
//         ScaffoldMessenger.of(context).showSnackBar(
//           customSnackBar(
//             content: 'Error occurred while accessing credentials. Try again.',
//           ),
//         );
//       }
//     } catch (e, st) {
//       debugPrint("Error $e $st");
//       ScaffoldMessenger.of(context).showSnackBar(
//         customSnackBar(
//           content: 'Error occurred using Apple Sign In. Try again.',
//         ),
//       );
//     }
//     return user;
//   }
//
//   static Future<FacebookLoginResult?> signInWithFacebook({required BuildContext context}) async {
//    try {
//       fbLogin.logOut();
//
//       //debugPrint("tapped");
//       // Log in
//       final res = await fbLogin.logIn(permissions: [
//         FacebookPermission.publicProfile,
//         FacebookPermission.email,
//       ]);
//
//       // Check result status
//       switch (res.status) {
//         case FacebookLoginStatus.success:
//           // Logged in
//
//           // Send access token to server for validation and auth
//           final FacebookAccessToken? accessToken = res.accessToken;
//           //debugPrint('Access token: ${accessToken!.token}');
//
//           // Get profile data
//           final profile = await fbLogin.getUserProfile();
//           //debugPrint('Hello, ${profile!.name}!  You ID: ${profile.userId}');
//
//           // Get user profile image url
//           String? imageUrl = await fbLogin.getProfileImageUrl(width: 100);
//           //debugPrint('Your profile image: $imageUrl');
//
//           // Get email (since we request email permission)
//           String? email = await fbLogin.getUserEmail();
//           // But user can decline permission
//           if (email != null) //debugPrint('And your email is $email');
//
//             var map = {
//               "type": "facebook",
//               "token": accessToken!.token,
//               "email": email,
//             };
//           // _handleSocialLogin(map, (data) {
//           //   Get.toNamed(RouteHelper.getSignUpPage(
//           //       isSocialSignup: true,
//           //       socialFirstName: profile.name,
//           //       socialEmail: email,
//           //       socialImageUrl: imageUrl,
//           //       socialType: "facebook",
//           //       socialToken: accessToken.token));
//           // });
//           break;
//         case FacebookLoginStatus.cancel:
//           //debugPrint("cancelled");
//           // User cancel log in
//           return null;
//           break;
//         case FacebookLoginStatus.error:
//           // Log in failed
//           //debugPrint('Error while log in: ${res.error}');
//           return null;
//           break;
//       }
//     } catch(e){
//       return null;
//     }
//   }
// }
