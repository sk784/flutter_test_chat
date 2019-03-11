@TestOn('browser')
import 'dart:async';

import 'package:angular/angular.dart';
import 'package:test/test.dart';
import 'package:angular_test/angular_test.dart';
import 'package:chat_web/src/components/sign_in_component/sign_in_component.dart';
import 'package:chat_web/src/components/sign_in_component/sign_in_component.template.dart' as ng;
import 'sign_in_component_test.template.dart' as self;
import 'package:chat_web/services.dart';
import 'package:angular_router/angular_router.dart';
import 'sign_in_component_po.dart';
import 'package:pageloader/html.dart';
import 'package:mockito/mockito.dart';
import 'package:chat_models/chat_models.dart';
import 'package:chat_web/routes.dart';
import 'utils.dart';

class MockWebUsersClient extends Mock implements WebUsersClient {}
class MockRouter extends Mock implements Router {}
class MockPlatformLocation extends Mock implements PlatformLocation {}
class MockSession extends Mock implements Session {}

@GenerateInjector([
  ClassProvider(WebUsersClient, useClass: MockWebUsersClient),
  ClassProvider(Session, useClass: MockSession),
  ValueProvider.forToken(appBaseHref, '/'),
  ClassProvider(PlatformLocation, useClass: MockPlatformLocation),
  ClassProvider(LocationStrategy, useClass: HashLocationStrategy),
  ClassProvider(Location),
  ClassProvider(Router, useClass: MockRouter),
])
final InjectorFactory rootInjector = self.rootInjector$Injector;

main() {
  final injector = InjectorProbe(rootInjector);
  final testBed = NgTestBed.forComponent<SignInComponent>(
    ng.SignInComponentNgFactory,
    rootInjector: injector.factory
  );
  NgTestFixture<SignInComponent> fixture;
  SignInComponentPO po;

  setUp(() async {
    fixture = await testBed.create();
    final context = HtmlPageLoaderElement.createFromElement(fixture.rootElement);
    po = SignInComponentPO.create(context);
  });

  tearDown(disposeAnyRunningTest);

  test('basic', () {
    expect(fixture.text, stringContainsInOrder(['username', 'password', 'Sign In', 'Sign Up']));
  });

  test('username input', () {
    expect(po.usernameMaterialInput.exists, true);
    expect(po.usernameMaterialInput.attributes['label'], 'username');
  });

  test('password input', () {
    expect(po.passwordMaterialInput.exists, true);
    expect(po.passwordMaterialInput.attributes['label'], 'password');
  });

  test('sign in button', () {
    expect(po.signInButton.exists, true);
    expect(po.signInButton.innerText, 'Sign In');
  });

  test('input username and password', () async {
    await po.usernameInput.type('username');
    await po.psswordInput.type('password');
    await fixture.update((c) {
      expect(c.username, 'username');
      expect(c.password, 'password');
    });
  });

  test('sign in button click calls signIn method', () async {
    final mockWebUsersClient = injector.get(WebUsersClient);
    await fixture.update((c) {
      c.username = 'username';
      c.password = 'password';
    });
    await po.signInButton.click();
    verify(mockWebUsersClient.login('username', 'password')).called(1);
  });

  test('navigate after successful login', () async {
    final mockRouter = injector.get<MockRouter>(Router);
    final mockWebUsersClient = injector.get<MockWebUsersClient>(WebUsersClient);
    when(mockWebUsersClient.login('username', 'password')).thenAnswer((_) => Future.value(User(
      id: UserId('id'),
      name: 'username'
    )));
    fixture.update((c) async {
      c.username = 'username';
      c.password = 'password';
      await c.signIn();
      final result = verify(mockRouter.navigate(captureAny));
      expect(result.captured.single, RoutePaths.chats.toUrl());
    });
  });
}