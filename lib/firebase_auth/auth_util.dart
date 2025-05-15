import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_cloud_firestore/firebase_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pet_shelter/identity/models/users_record.dart';
import 'package:rxdart/rxdart.dart';

import '../shared.dart';
import 'firebase_auth_manager.dart';

export 'firebase_auth_manager.dart';

final _authManager = FirebaseAuthManager();

FirebaseAuthManager get authManager => _authManager;

String get currentUserEmail => currentUserDocument?.email ?? Shared.store!.state.identityState.currentUser?.email ?? '';

String get currentUserUid => Shared.store!.state.identityState.currentUser?.uid ?? '';

String get currentUserDisplayName =>
    currentUserDocument?.displayName ?? Shared.store!.state.identityState.currentUser?.displayName ?? '';

String get currentUserPhoto => currentUserDocument?.photoUrl ?? Shared.store!.state.identityState.currentUser?.photoUrl ?? '';

String get currentPhoneNumber =>
    currentUserDocument?.phoneNumber ?? Shared.store!.state.identityState.currentUser?.phoneNumber ?? '';

String get currentJwtToken => _currentJwtToken ?? '';

bool get currentUserEmailVerified => Shared.store!.state.identityState.currentUser?.emailVerified ?? false;

/// Create a Stream that listens to the current user's JWT Token, since Firebase
/// generates a new token every hour.
String? _currentJwtToken;
final jwtTokenStream = FirebaseAuth.instance
    .idTokenChanges()
    .map((user) async => _currentJwtToken = await user?.getIdToken())
    .asBroadcastStream();

DocumentReference? get currentUserReference =>
    Shared.store!.state.identityState.currentUser!.loggedIn ? UsersRecord.collection.doc(Shared.store!.state.identityState.currentUser!.uid) : null;

UsersRecord? currentUserDocument;
final authenticatedUserStream = FirebaseAuth.instance
    .authStateChanges()
    .map<String>((user) => user?.uid ?? '')
    .switchMap(
      (uid) => uid.isEmpty
          ? Stream.value(null)
          : UsersRecord.getDocument(UsersRecord.collection.doc(uid)).handleError((_) {}),
    )
    .map((user) => currentUserDocument = user)
    .asBroadcastStream();

class AuthUserStreamWidget extends StatelessWidget {
  const AuthUserStreamWidget({super.key, required this.builder});

  final WidgetBuilder builder;

  @override
  Widget build(BuildContext context) => StreamBuilder(
        stream: authenticatedUserStream,
        builder: (context, _) => builder(context),
      );
}