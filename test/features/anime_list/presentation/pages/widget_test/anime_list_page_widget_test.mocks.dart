// Mocks generated by Mockito 5.3.2 from annotations
// in mikrogrup/test/features/anime_list/presentation/pages/anime_list_page_widget_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i5;

import 'package:firebase_crashlytics/firebase_crashlytics.dart' as _i3;
import 'package:flutter_bloc/flutter_bloc.dart' as _i6;
import 'package:mikrogrup/features/anime_list/domain/use_cases/get_anime_list.dart'
    as _i2;
import 'package:mikrogrup/features/anime_list/presentation/cubit/anime_cubit.dart'
    as _i4;
import 'package:mockito/mockito.dart' as _i1;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeGetAnimeList_0 extends _i1.SmartFake implements _i2.GetAnimeList {
  _FakeGetAnimeList_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeFirebaseCrashlytics_1 extends _i1.SmartFake
    implements _i3.FirebaseCrashlytics {
  _FakeFirebaseCrashlytics_1(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeAnimeState_2 extends _i1.SmartFake implements _i4.AnimeState {
  _FakeAnimeState_2(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [AnimeCubit].
///
/// See the documentation for Mockito's code generation for more information.
class MockAnimeCubit extends _i1.Mock implements _i4.AnimeCubit {
  MockAnimeCubit() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.GetAnimeList get getAnimeListUseCase => (super.noSuchMethod(
        Invocation.getter(#getAnimeListUseCase),
        returnValue: _FakeGetAnimeList_0(
          this,
          Invocation.getter(#getAnimeListUseCase),
        ),
      ) as _i2.GetAnimeList);

  @override
  _i3.FirebaseCrashlytics get crashlytics => (super.noSuchMethod(
        Invocation.getter(#crashlytics),
        returnValue: _FakeFirebaseCrashlytics_1(
          this,
          Invocation.getter(#crashlytics),
        ),
      ) as _i3.FirebaseCrashlytics);

  @override
  int get currentPage => (super.noSuchMethod(
        Invocation.getter(#currentPage),
        returnValue: 0,
      ) as int);

  @override
  set currentPage(int? _currentPage) => super.noSuchMethod(
        Invocation.setter(
          #currentPage,
          _currentPage,
        ),
        returnValueForMissingStub: null,
      );

  @override
  bool get hasNextPage => (super.noSuchMethod(
        Invocation.getter(#hasNextPage),
        returnValue: false,
      ) as bool);

  @override
  set hasNextPage(bool? _hasNextPage) => super.noSuchMethod(
        Invocation.setter(
          #hasNextPage,
          _hasNextPage,
        ),
        returnValueForMissingStub: null,
      );

  @override
  String get currentFilter => (super.noSuchMethod(
        Invocation.getter(#currentFilter),
        returnValue: '',
      ) as String);

  @override
  set currentFilter(String? _currentFilter) => super.noSuchMethod(
        Invocation.setter(
          #currentFilter,
          _currentFilter,
        ),
        returnValueForMissingStub: null,
      );

  @override
  _i4.AnimeState get state => (super.noSuchMethod(
        Invocation.getter(#state),
        returnValue: _FakeAnimeState_2(
          this,
          Invocation.getter(#state),
        ),
      ) as _i4.AnimeState);

  @override
  _i5.Stream<_i4.AnimeState> get stream => (super.noSuchMethod(
        Invocation.getter(#stream),
        returnValue: _i5.Stream<_i4.AnimeState>.empty(),
      ) as _i5.Stream<_i4.AnimeState>);

  @override
  bool get isClosed => (super.noSuchMethod(
        Invocation.getter(#isClosed),
        returnValue: false,
      ) as bool);

  @override
  _i5.Future<void> loadAnimeList({
    String? filter = r'All',
    String? status,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #loadAnimeList,
          [],
          {
            #filter: filter,
            #status: status,
          },
        ),
        returnValue: _i5.Future<void>.value(),
        returnValueForMissingStub: _i5.Future<void>.value(),
      ) as _i5.Future<void>);

  @override
  void emit(_i4.AnimeState? state) => super.noSuchMethod(
        Invocation.method(
          #emit,
          [state],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void onChange(_i6.Change<_i4.AnimeState>? change) => super.noSuchMethod(
        Invocation.method(
          #onChange,
          [change],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void addError(
    Object? error, [
    StackTrace? stackTrace,
  ]) =>
      super.noSuchMethod(
        Invocation.method(
          #addError,
          [
            error,
            stackTrace,
          ],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void onError(
    Object? error,
    StackTrace? stackTrace,
  ) =>
      super.noSuchMethod(
        Invocation.method(
          #onError,
          [
            error,
            stackTrace,
          ],
        ),
        returnValueForMissingStub: null,
      );

  @override
  _i5.Future<void> close() => (super.noSuchMethod(
        Invocation.method(
          #close,
          [],
        ),
        returnValue: _i5.Future<void>.value(),
        returnValueForMissingStub: _i5.Future<void>.value(),
      ) as _i5.Future<void>);
}
