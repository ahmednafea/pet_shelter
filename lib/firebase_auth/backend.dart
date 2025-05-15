
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_cloud_firestore/firebase_cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:pet_shelter/firebase_auth/auth_util.dart';
import 'package:pet_shelter/identity/models/users_record.dart';


export 'dart:async' show StreamSubscription;

/// Functions to query UsersRecords (as a Stream and as a Future).
Future<int> queryUsersRecordCount({
  Query Function(Query)? queryBuilder,
  int limit = -1,
}) =>
    queryCollectionCount(
      UsersRecord.collection,
      queryBuilder: queryBuilder,
      limit: limit,
    );

Future<int> queryCollectionCount(
  Query collection, {
  Query Function(Query)? queryBuilder,
  int limit = -1,
}) {
  final builder = queryBuilder ?? (q) => q;
  var query = builder(collection);
  if (limit > 0) {
    query = query.limit(limit);
  }

  return query.count().get().catchError((err) {
    debugPrint('Error querying $collection: $err');
  }).then((value) => value.count!);
}

extension FilterExtension on Filter {
  Filter filterIn(String field, List? list) =>
      (list?.isEmpty ?? true) ? Filter(field, whereIn: null) : Filter(field, whereIn: list);

  Filter filterNotIn(String field, List? list) =>
      (list?.isEmpty ?? true) ? Filter(field, whereNotIn: null) : Filter(field, whereNotIn: list);

  Filter filterArrayContainsAny(String field, List? list) => (list?.isEmpty ?? true)
      ? Filter(field, arrayContainsAny: null)
      : Filter(field, arrayContainsAny: list);
}

extension QueryExtension on Query {
  Query whereIn(String field, List? list) =>
      (list?.isEmpty ?? true) ? where(field, whereIn: null) : where(field, whereIn: list);

  Query whereNotIn(String field, List? list) =>
      (list?.isEmpty ?? true) ? where(field, whereNotIn: null) : where(field, whereNotIn: list);

  Query whereArrayContainsAny(String field, List? list) => (list?.isEmpty ?? true)
      ? where(field, arrayContainsAny: null)
      : where(field, arrayContainsAny: list);
}

class FFFirestorePage<T> {
  final List<T> data;
  final Stream<List<T>>? dataStream;
  final QueryDocumentSnapshot? nextPageMarker;

  FFFirestorePage(this.data, this.dataStream, this.nextPageMarker);
}

// Creates a Firestore document representing the logged in user if it doesn't yet exist
Future maybeCreateUser(User user) async {
  final userRecord = UsersRecord.collection.doc(user.uid);
  final userExists = await userRecord.get().then((u) => u.exists);
  if (userExists) {
    currentUserDocument = await UsersRecord.getDocumentOnce(userRecord);
    return;
  }

  final userData = createUsersRecordData(
    email: user.email ??
        FirebaseAuth.instance.currentUser?.email ??
        user.providerData.firstOrNull?.email,
    displayName: user.displayName ??
        FirebaseAuth.instance.currentUser?.displayName ??
        user.email!.split("@").first,
    photoUrl: user.photoURL,
    uid: user.uid,
    phoneNumber: user.phoneNumber,
  );

  await userRecord.set(userData);
  currentUserDocument = UsersRecord.getDocumentFromData(userData, userRecord);
}

Future updateUserDocument({String? email}) async {
  await currentUserDocument?.reference.update(createUsersRecordData(email: email));
}

Future<bool> isUserDeleted(DocumentReference ref) async {
  var user = await UsersRecord.getDocumentOnce(ref);
  if (user.isDeleted) {
    return true;
  }
  return false;
}