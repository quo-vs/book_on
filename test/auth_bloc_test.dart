import 'package:book_on/blocs/auth/auth.dart';
import 'package:book_on/repositories/auth_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class FakeAuthRepository extends Mock implements AuthRepository {}

void main() {
  FakeAuthRepository? fakeAuthRepository;

  setUp(() {
    fakeAuthRepository = FakeAuthRepository();
  });

  group('Auth', () {
    test(
      'Authenticate with email and password',
      () {
        when(fakeAuthRepository!.login(email: '', password: ''))
            .thenAnswer((_) async {
              fakeAuthRepository!.currentUser() ;
            });
        final bloc = AuthBloc(fakeAuthRepository!);
        final displayName = 'user';
        bloc.add(LoggedIn(displayName: displayName));
        expectLater(
          bloc,
          emitsInOrder([
            AuthAuthenticated(displayName: displayName),
          ]),
        );
      },
    );
  });
}