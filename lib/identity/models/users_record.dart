import 'dart:async';

import 'package:firebase_cloud_firestore/firebase_cloud_firestore.dart';
import 'package:pet_shelter/firebase_auth/firestore_util.dart';

class UsersRecord extends FirestoreRecord {
  UsersRecord._(
    super.reference,
    super.data,
  ) {
    _initializeFields();
  }

  // "email" field.
  String? _email;

  String get email => _email ?? '';

  bool hasEmail() => _email != null;



  // "phone_number" field.
  String? _phoneNumber;

  String get phoneNumber => _phoneNumber ?? '';

  bool hasPhoneNumber() => _phoneNumber != null;

  // "display_name" field.
  String? _displayName;

  String get displayName => _displayName ?? '';

  bool hasDisplayName() => _displayName != null;

  // "photo_url" field.
  String? _photoUrl;

  String get photoUrl => _photoUrl ?? '';

  bool hasPhotoUrl() => _photoUrl != null;

  // "uid" field.
  String? _uid;

  String get uid => _uid ?? '';

  bool hasUid() => _uid != null;


  // "isDeleted" field.
  bool? _isDeleted;

  bool get isDeleted => _isDeleted ?? false;

  bool hasIsDeleted() => _isDeleted != null;


  // "birthdate" field.
  DateTime? _birthdate;

  DateTime? get birthdate => _birthdate;

  bool hasBirthdate() => _birthdate != null;


  bool? _isAdmin;

  bool get isAdmin => _isAdmin ?? false;

  bool hasIsAdmin() => _isAdmin != null;

  void _initializeFields() {
    _email = snapshotData['email'] as String?;
    _phoneNumber = snapshotData['phone_number'] as String?;
    _displayName = snapshotData['display_name'] as String?;
    _photoUrl = snapshotData['photo_url'] as String?;
    _uid = snapshotData['uid'] as String?;
    _isDeleted = castToType<bool>(snapshotData['isDeleted']);
    _birthdate = snapshotData['birthdate'] != null
        ? DateTime.parse((snapshotData['birthdate'] as Timestamp).toDate().toString())
        : null;
    _isAdmin = castToType<bool>(snapshotData['is_admin']);
  }

  static CollectionReference get collection => FirebaseFirestore.instance.collection('Users');

  static Stream<UsersRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => UsersRecord.fromSnapshot(s));

  static Future<UsersRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => UsersRecord.fromSnapshot(s));

  static UsersRecord fromSnapshot(DocumentSnapshot snapshot) => UsersRecord._(
        snapshot.reference,
        snapshot.data() as Map<String, dynamic>,
      );

  static UsersRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      UsersRecord._(reference, data);

  @override
  String toString() => 'UsersRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is UsersRecord && reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createUsersRecordData({
  String? email,
  String? phoneNumber,
  String? displayName,
  String? photoUrl,
  String? uid,
  bool? isAdmin = false,
  DateTime? birthdate,
}) {
  final firestoreData = <String, dynamic>{
    'email': email,
    'phone_number': phoneNumber,
    'display_name': displayName,
    'photo_url': photoUrl,
    'uid': uid,
    'birthdate': birthdate,
    'is_admin': isAdmin,
  };

  return firestoreData;
}