// Mocks generated by Mockito 5.4.4 from annotations
// in finance_90s_baby/test/api_mocks.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i4;

import 'package:appwrite/appwrite.dart' as _i2;
import 'package:appwrite/models.dart' as _i8;
import 'package:file_picker/file_picker.dart' as _i5;
import 'package:finance_90s_baby/api/auth_api.dart' as _i7;
import 'package:finance_90s_baby/api/database_api.dart' as _i6;
import 'package:finance_90s_baby/api/storage_api.dart' as _i3;
import 'package:mockito/mockito.dart' as _i1;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: deprecated_member_use
// ignore_for_file: deprecated_member_use_from_same_package
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeStorage_0 extends _i1.SmartFake implements _i2.Storage {
  _FakeStorage_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeDatabases_1 extends _i1.SmartFake implements _i2.Databases {
  _FakeDatabases_1(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeAccount_2 extends _i1.SmartFake implements _i2.Account {
  _FakeAccount_2(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [StorageAPI].
///
/// See the documentation for Mockito's code generation for more information.
class MockStorageAPI extends _i1.Mock implements _i3.StorageAPI {
  MockStorageAPI() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.Storage get storage => (super.noSuchMethod(
        Invocation.getter(#storage),
        returnValue: _FakeStorage_0(
          this,
          Invocation.getter(#storage),
        ),
      ) as _i2.Storage);

  @override
  _i4.Future<String?> getLessonContent(String? fileId) => (super.noSuchMethod(
        Invocation.method(
          #getLessonContent,
          [fileId],
        ),
        returnValue: _i4.Future<String?>.value(),
      ) as _i4.Future<String?>);

  @override
  _i4.Future<_i5.PlatformFile?> pickFile() => (super.noSuchMethod(
        Invocation.method(
          #pickFile,
          [],
        ),
        returnValue: _i4.Future<_i5.PlatformFile?>.value(),
      ) as _i4.Future<_i5.PlatformFile?>);

  @override
  _i4.Future<String?> uploadFile(_i5.PlatformFile? file) => (super.noSuchMethod(
        Invocation.method(
          #uploadFile,
          [file],
        ),
        returnValue: _i4.Future<String?>.value(),
      ) as _i4.Future<String?>);

  @override
  _i4.Future<void> deleteFile(String? fileId) => (super.noSuchMethod(
        Invocation.method(
          #deleteFile,
          [fileId],
        ),
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);
}

/// A class which mocks [DatabaseAPI].
///
/// See the documentation for Mockito's code generation for more information.
class MockDatabaseAPI extends _i1.Mock implements _i6.DatabaseAPI {
  MockDatabaseAPI() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.Databases get database => (super.noSuchMethod(
        Invocation.getter(#database),
        returnValue: _FakeDatabases_1(
          this,
          Invocation.getter(#database),
        ),
      ) as _i2.Databases);

  @override
  _i4.Future<List<Map<String, dynamic>>> getLessons() => (super.noSuchMethod(
        Invocation.method(
          #getLessons,
          [],
        ),
        returnValue: _i4.Future<List<Map<String, dynamic>>>.value(
            <Map<String, dynamic>>[]),
      ) as _i4.Future<List<Map<String, dynamic>>>);

  @override
  _i4.Future<void> addLesson({
    required String? title,
    required String? fileUrl,
    required String? fileId,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #addLesson,
          [],
          {
            #title: title,
            #fileUrl: fileUrl,
            #fileId: fileId,
          },
        ),
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);

  @override
  _i4.Future<void> addComment(
    String? lessonId,
    String? userId,
    String? commentText,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #addComment,
          [
            lessonId,
            userId,
            commentText,
          ],
        ),
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);

  @override
  _i4.Future<List<Map<String, dynamic>>> getAllComments() =>
      (super.noSuchMethod(
        Invocation.method(
          #getAllComments,
          [],
        ),
        returnValue: _i4.Future<List<Map<String, dynamic>>>.value(
            <Map<String, dynamic>>[]),
      ) as _i4.Future<List<Map<String, dynamic>>>);

  @override
  _i4.Future<void> deleteLesson(String? lessonId) => (super.noSuchMethod(
        Invocation.method(
          #deleteLesson,
          [lessonId],
        ),
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);

  @override
  _i4.Future<List<Map<String, dynamic>>> getCommentsForLesson(
          String? lessonId) =>
      (super.noSuchMethod(
        Invocation.method(
          #getCommentsForLesson,
          [lessonId],
        ),
        returnValue: _i4.Future<List<Map<String, dynamic>>>.value(
            <Map<String, dynamic>>[]),
      ) as _i4.Future<List<Map<String, dynamic>>>);

  @override
  _i4.Future<void> updateLessonCompletion(
    String? lessonId,
    bool? completed,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #updateLessonCompletion,
          [
            lessonId,
            completed,
          ],
        ),
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);

  @override
  _i4.Future<void> markLessonCompletedUserProgress(
    String? userId,
    String? lessonId,
    bool? completed,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #markLessonCompletedUserProgress,
          [
            userId,
            lessonId,
            completed,
          ],
        ),
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);

  @override
  _i4.Future<bool> isLessonCompleted(
    String? userId,
    String? lessonId,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #isLessonCompleted,
          [
            userId,
            lessonId,
          ],
        ),
        returnValue: _i4.Future<bool>.value(false),
      ) as _i4.Future<bool>);
}

/// A class which mocks [AuthAPI].
///
/// See the documentation for Mockito's code generation for more information.
class MockAuthAPI extends _i1.Mock implements _i7.AuthAPI {
  MockAuthAPI() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.Account get account => (super.noSuchMethod(
        Invocation.getter(#account),
        returnValue: _FakeAccount_2(
          this,
          Invocation.getter(#account),
        ),
      ) as _i2.Account);

  @override
  _i4.Future<void> createUser(
    String? email,
    String? password,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #createUser,
          [
            email,
            password,
          ],
        ),
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);

  @override
  _i4.Future<String?> getUserRole() => (super.noSuchMethod(
        Invocation.method(
          #getUserRole,
          [],
        ),
        returnValue: _i4.Future<String?>.value(),
      ) as _i4.Future<String?>);

  @override
  _i4.Future<_i8.User?> registerUser(
    String? email,
    String? password,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #registerUser,
          [
            email,
            password,
          ],
        ),
        returnValue: _i4.Future<_i8.User?>.value(),
      ) as _i4.Future<_i8.User?>);

  @override
  _i4.Future<_i8.Session?> loginUser(
    String? email,
    String? password,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #loginUser,
          [
            email,
            password,
          ],
        ),
        returnValue: _i4.Future<_i8.Session?>.value(),
      ) as _i4.Future<_i8.Session?>);

  @override
  _i4.Future<void> logoutUser() => (super.noSuchMethod(
        Invocation.method(
          #logoutUser,
          [],
        ),
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);

  @override
  _i4.Future<_i8.User?> getCurrentUser() => (super.noSuchMethod(
        Invocation.method(
          #getCurrentUser,
          [],
        ),
        returnValue: _i4.Future<_i8.User?>.value(),
      ) as _i4.Future<_i8.User?>);
}
