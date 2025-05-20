import 'package:firebase_cloud_firestore/firebase_cloud_firestore.dart';
import 'package:pet_shelter/firebase_auth/firestore_util.dart';

class PostRecord extends FirestoreRecord {
  String? userId;
  String? image;
  String? description;

  PostRecord._(super.reference, super.data) {
    _initializeFields();
  }

  void _initializeFields() {
    userId = snapshotData['user_id'] as String?;
    image = snapshotData['image'] as String?;
    description = snapshotData['description'] as String?;
  }

  static CollectionReference get collection => FirebaseFirestore.instance.collection('posts');

  static Stream<PostRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => PostRecord.fromSnapshot(s));

  static Future<PostRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => PostRecord.fromSnapshot(s));

  static PostRecord fromSnapshot(DocumentSnapshot snapshot) =>
      PostRecord._(snapshot.reference, snapshot.data() as Map<String, dynamic>);

  @override
  String toString() => 'Post (reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is PostRecord && reference.path.hashCode == other.reference.path.hashCode;
}
Map<String, dynamic> createPostRecordData({
  String? userId,
  String? image,
  String? description
}) {
  final firestoreData = <String, dynamic>{
    'user_id': userId,
    'image': image,
    'description': description
  };

  return firestoreData;
}