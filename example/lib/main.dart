import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_miracl_sdk/flutter_miracl_sdk.dart';
import 'package:go_router/go_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final configuration = Configuration(
    projectId: "<YOUR_PROJECT_ID>",
    platformUrl: "<YOUR_DOMAIN>"
  );
  await MIRACLTrust.initialize(configuration);

  runApp(MIRACLExampleApp());
}

final GoRouter _router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const HomePage();
      },
      routes: <RouteBase>[
        GoRoute(
          path: '/enterUserId',
          builder: (BuildContext context, GoRouterState state) {
            return const EnterUserIDPage();
          },
        ),
        GoRoute(
          path: '/mailSent/:userId',
          builder: (BuildContext context, GoRouterState state) {
            final userId = state.pathParameters["userId"];
            if (userId == null || userId.isEmpty) {
              return HomePage();
            }

            return EmailSentPage(userId: userId);
          },
        ),
        GoRoute(
          path: '/verification/confirmation',
          builder: (BuildContext context, GoRouterState state) {
            return RegistrationPage(uri: state.uri);
          },
        ),
        GoRoute(
          path: '/finishedFlow',
          builder: (BuildContext context, GoRouterState state) {
            return FinishedFlowPage();
          },
        ),
        GoRoute(
          path: '/authentication/:userId/:pinLength',
          builder: (BuildContext context, GoRouterState state){
            final userId = state.pathParameters["userId"] ;
            final pinLength = int.tryParse(state.pathParameters["pinLength"] ?? "");

            if (userId == null || userId.isEmpty || pinLength == null) {
              return HomePage();
            }

            return AuthenticationPage(userId: userId, pinLength: pinLength);
          },
        )
      ],
    ),
  ],
);



class MIRACLExampleApp extends StatelessWidget {
  final RouteObserver<ModalRoute> routeObserver = RouteObserver<ModalRoute>();

  MIRACLExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MIRACLAppState(),
      child: MaterialApp.router(
        routerConfig: _router,
        title: 'MIRACL Trust Sample Application',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        ),
      ),
    );
  }
}

class MIRACLAppState extends ChangeNotifier {}

class HomePage extends StatefulWidget {
  const HomePage({
    super.key
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<User> users = [];

  Future<void> _loadUsers() async {
    final result = await MIRACLTrust().getUsers(); 
    setState(() {
      users = result;
    });
  }

  @override
  void didUpdateWidget(covariant HomePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    _loadUsers();
  }

  Future<void> _userDeletionDialog(User user) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Do you want to delete this user?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Yes'),
              onPressed: () async {
                MIRACLTrust().delete(user);
                await _loadUsers();
                
                if (!context.mounted) return;

                Navigator.pop(context);
              },
            ),
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(title: const Text('MIRACL Trust Sample Home Page')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: screenHeight * 0.10,
                child: 
                ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (BuildContext context, int index) {
                    User user = users[index];
                    
                    return GestureDetector(
                      onTap: (){
                        final userId = user.userId;
                        final pinLength = user.pinLength;

                        context.go("/authentication/$userId/$pinLength");
                      },
                      onLongPress: () {
                        _userDeletionDialog(user);
                      },
                      child: UserLabel(user: user)
                    );
                  }
                )
              ),
              ElevatedButton(
                onPressed: () {
                  context.go("/enterUserId");
                },
                child: Text('Register User ID'),
              )
          ],),
        ),
      ),
    );
  }
}

class EnterUserIDPage extends StatefulWidget {
  
  const EnterUserIDPage({ super.key });

  @override
  State<EnterUserIDPage> createState() => _EnterUserIDPageState();
}

class _EnterUserIDPageState extends State<EnterUserIDPage> {
  final _textEditingController = TextEditingController();

  Future<void> _sendVerificationEmail() async {
    try {
      await MIRACLTrust().sendVerificationEmail(_textEditingController.text);
      if (!mounted) return; 
      
      context.go("/mailSent/${_textEditingController.text}");
    } on EmailVerificationException catch(emailVerificationException) {
      var snackBarText = "EmailVerificationException: ${emailVerificationException.code}";
      if (emailVerificationException.underlyingError != null) {
        snackBarText += "\nUnderlying error:${emailVerificationException.underlyingError}";
      }

      _showErrorSnackBar(snackBarText);
    }
  }

  void _showErrorSnackBar(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        backgroundColor: Theme.of(context).colorScheme.error,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: const Text('Enter User ID')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _textEditingController,
                keyboardType: TextInputType.emailAddress,
                autofocus: true,
              ),
              ElevatedButton(
                onPressed: () => _sendVerificationEmail(),
                child: const Text('Send Email'),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class EmailSentPage extends StatelessWidget {
  final String userId;

  const EmailSentPage({ super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Email Sent')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Email Sent to $userId",
              textAlign: TextAlign.center,
              style:  const TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class RegistrationPage extends StatefulWidget {
  final Uri uri;

  const RegistrationPage({super.key, required this.uri,});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register User')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _textEditingController,
                obscureText: true,
                keyboardType: TextInputType.number
              ),

              SizedBox(height: 20.0),

              ElevatedButton(
                onPressed: () => _registerUser(),
                child: const Text('Register'),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _registerUser() async {
    try {
      final pinCode = _textEditingController.text;
      final miraclTrust = MIRACLTrust();

      final activationTokenResponse = await miraclTrust.getActivationTokenByURI(widget.uri);
      final user = await miraclTrust.register(
        activationTokenResponse.userId, 
        activationTokenResponse.activationToken, 
        pinCode
      );

      await miraclTrust.authenticate(user, pinCode);

      if (!mounted) return;
      context.go("/finishedFlow");
    } on ActivationTokenException catch(activationTokenException) {
      var activationTokenErrorText = "ActivationTokenException: ${activationTokenException.code}";
      if (activationTokenException.underlyingError != null) {
        activationTokenErrorText += "\nUnderlying error:${activationTokenException.underlyingError}";
      }

      _showErrorSnackBar(activationTokenErrorText);
    } on RegistrationException catch(registrationException) {
      var registrationErrorText = "RegistrationException: ${registrationException.code}";
      if (registrationException.underlyingError != null) {
        registrationErrorText += "\nUnderlying error: ${registrationException.underlyingError}";
      }

      _showErrorSnackBar(registrationErrorText);
    }
  }

  void _showErrorSnackBar(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        backgroundColor: Theme.of(context).colorScheme.error,
      ),
    );
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }
}

class FinishedFlowPage extends StatelessWidget {
  const FinishedFlowPage({ super.key });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Successful authentication')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("You are now authenticated!"),

            ElevatedButton(
              onPressed: () => context.go('/'),
              child: const Text('Start Over'),
            )
          ],
        ),
      ),
    );
  }
}

class AuthenticationPage extends StatefulWidget {
  final String userId;
  final int pinLength;

  const AuthenticationPage({ super.key, required this.userId, required this.pinLength });

  @override
  State<AuthenticationPage> createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<AuthenticationPage> {
  final _pinController = TextEditingController();

  Future<void> _authenticate() async {
    try {
      final miraclTrust = MIRACLTrust();
      final user = await miraclTrust.getUser(widget.userId);
      if (user != null) {
        await miraclTrust.authenticate(user, _pinController.text);

        if (!mounted) return; 
        context.go("/finishedFlow");
      }
    } on AuthenticationException catch(authenticationException) {
      if (!mounted) return;

      String snackBarText;
      switch (authenticationException.code) {
        case AuthenticationExceptionCode.unsuccessfulAuthentication:
          snackBarText = "Wrong PIN. Please try again!";
          break;
        case AuthenticationExceptionCode.revoked:
          snackBarText = "User revoked. Please register again!";
          break;
        default:
          snackBarText = "Authentication Еxception: ${authenticationException.code}";
          if (authenticationException.underlyingError != null) {
            snackBarText += "\nUnderlying error: ${authenticationException.underlyingError}";
          }
      }
      _showErrorSnackBar(snackBarText);
    }
  }

  void _showErrorSnackBar(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        backgroundColor: Theme.of(context).colorScheme.error,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Authenticate with ${widget.userId}")),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                maxLength: widget.pinLength,
                controller: _pinController,
                autofocus: true,
                obscureText: true,
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () => _authenticate(),
                child: const Text('Authenticate'),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class UserLabel extends StatelessWidget {
  const UserLabel({
    super.key,
    required this.user,
  });

  final User user;

  @override
  Widget build(BuildContext context) {

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (user.revoked) ...[
          Icon(Icons.block),
          SizedBox(width: 8)
        ],
        Text(user.userId),
      ],
    );
  }
}