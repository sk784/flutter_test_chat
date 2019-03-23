@TestOn('browser')
import 'package:angular/angular.dart';
import 'package:angular_test/angular_test.dart';
import 'package:test/test.dart';
import 'package:chat_web/src/components/sign_in_component/sign_in_component.dart';
import 'package:chat_web/src/components/sign_in_component/sign_in_component.template.dart' as ng;
import 'sign_in_component_test.template.dart' as self;
import 'package:chat_web/services.dart';
import 'package:angular_router/angular_router.dart';
import 'sign_in_component_po.dart';
import 'package:pageloader/html.dart';
import 'package:mockito/mockito.dart';
import 'utils.dart';

class MockSession extends Mock implements Session {}

@GenerateInjector([
  ClassProvider(Session, useClass: MockSession),
  routerProvidersForTesting
])
// ignore: undefined_getter
InjectorFactory rootInjector = self.rootInjector$Injector;

main() {
  final injector =InjectorProbe(rootInjector);
  final testBed = NgTestBed.forComponent(
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

  test('default', () {
    expect(fixture.text, stringContainsInOrder(['username', 'password', 'Sign In', 'Sign Up']));
  });

  test('username input', () {
    expect(po.usernameInput.exists, true);
    expect(po.usernameInput.attributes['label'], 'username');
  });
}