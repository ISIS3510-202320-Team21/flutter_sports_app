import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sportsapp/logic/blocs/authentication/bloc/authentication_bloc.dart';

class SignUpView extends StatefulWidget {
  @override
  _SignUpViewState createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  String _email = '', _password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sports app")),
      body: BlocConsumer<AuthenticationBloc, AuthenticationState>(
        listener: (context, state) {
          if (state is Authenticated) Navigator.of(context).pushNamed('/home');
          if (state is AuthError)
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.error)));
        },
        builder: (context, state) {
          if (state is AuthLoading)
            return const Center(child: CircularProgressIndicator());
          return _signUpForm();
        },
      ),
    );
  }

  Widget _signUpForm() => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 60),
            const Text('Welcome to my sports app!',
                textAlign: TextAlign.center, style: TextStyle(fontSize: 40)),
            TextField(
                decoration: InputDecoration(
                    labelText: 'E-mail', border: OutlineInputBorder()),
                onChanged: (val) => _email = val),
            TextField(
                decoration: InputDecoration(
                    labelText: 'Password', border: OutlineInputBorder()),
                onChanged: (val) => _password = val,
                obscureText: true),
            ElevatedButton(
                onPressed: _authenticateWithEmailAndPassword,
                child: const Text('SignUp')),
            TextButton(
                onPressed: () => Navigator.of(context).pushNamed('/'),
                child: const Text("Already have an account?")),
          ],
        ),
      );

  void _authenticateWithEmailAndPassword() {
    BlocProvider.of<AuthenticationBloc>(context)
        .add(SignUpRequested(_email, _password));
  }
}
