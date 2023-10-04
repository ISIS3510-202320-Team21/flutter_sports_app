import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_sports/logic/blocs/authentication/bloc/authentication_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  _SignUpViewState createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  String _email = '',
      _password = '',
      _name = '',
      _bornDate = '',
      _phoneNumber = '',
      _role = '',
      _university = '',
      _gender = '';

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sports app")),
      body: BlocConsumer<AuthenticationBloc, AuthenticationState>(
        listener: (context, state) {
          if (state is Authenticated) Navigator.of(context).pushNamed('/home');
          if (state is AuthError) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.error)));
          }
        },
        builder: (context, state) {
          if (state is AuthLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return _signUpForm();
        },
      ),
    );
  }

  Widget _signUpForm() => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const SizedBox(height: 60),
              const Text('Welcome to my sports app!',
                  textAlign: TextAlign.center, style: TextStyle(fontSize: 40)),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
                onChanged: (val) => _name = val,
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return 'Can\'t be empty';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'E-mail',
                  border: OutlineInputBorder(),
                ),
                onChanged: (val) => _email = val,
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return 'Can\'t be empty';
                  }
                  if (!EmailValidator.validate(val)) {
                    return 'Must be a valid email address';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Born Date',
                  border: OutlineInputBorder(),
                ),
                onChanged: (val) => _bornDate = val,
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return 'Can\'t be empty';
                  }
                  // Verifying a date format (dd/mm/aa)
                  RegExp regex = RegExp(r'^\d{2}/\d{2}/\d{2}$');
                  if (!regex.hasMatch(val)) {
                    return 'Date should be in dd/mm/aa format';
                  }
                  return null;
                },
              ),

              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                onChanged: (val) => _password = val,
                obscureText: true,
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return 'Can\'t be empty';
                  }
                  return null;
                },
              ),
              // Phone Number
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(),
                ),
                onChanged: (val) => _phoneNumber = val,
              ),

// Role
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Role',
                  border: OutlineInputBorder(),
                ),
                onChanged: (val) => _role = val,
              ),

// University
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'University',
                  border: OutlineInputBorder(),
                ),
                onChanged: (val) => _university = val,
              ),

// Gender
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Gender',
                  border: OutlineInputBorder(),
                ),
                onChanged: (val) => _gender = val,
              ),

              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _authenticateWithEmailAndPassword();
                  }
                },
                child: const Text('SignUp'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pushNamed('/'),
                child: const Text("Already have an account?"),
              ),
            ],
          ),
        ),
      );

  void _authenticateWithEmailAndPassword() {
    BlocProvider.of<AuthenticationBloc>(context).add(
      SignUpRequested(
        email: _email,
        password: _password,
        name: _name,
        bornDate: _bornDate,
        phoneNumber: _phoneNumber,
        role: _role,
        university: _university,
        gender: _gender,
      ),
    );
  }
}
