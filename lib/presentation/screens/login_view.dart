import 'package:flutter/material.dart';
import 'package:flutter_app_sports/logic/blocs/authentication/bloc/authentication_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginView extends StatelessWidget {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    ScreenUtil.init(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0.0, 
        title: Text(
          "LOGIN",
          style: textTheme.headlineSmall?.copyWith( 
              color: Theme.of(context).colorScheme.onBackground,
              fontWeight: FontWeight.bold),
        ),
        toolbarHeight: 0.1 * ScreenUtil().screenHeight,
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      body: BlocConsumer<AuthenticationBloc, AuthenticationState>(
        listener: (context, state) {
          if (state is Authenticated) Navigator.of(context).pushNamed('/home');
          if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error)),
            );
          }
        },
        builder: (context, state) {
          if (state is AuthLoading) return const CircularProgressIndicator();

          return Container(
            constraints: const BoxConstraints
                .expand(),
            color: Theme.of(context).colorScheme.background,
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * 0.05,
                            bottom: MediaQuery.of(context).size.height * 0.03),
                        child: Image.asset('assets/loginIcon.png'),
                      ),
                      _buildTextField(context, _emailController, 'Email...',
                          (text) {
                        if (text == null || text.isEmpty) {
                          return 'Can\'t be empty';
                        }
                        if (!EmailValidator.validate(text)) {
                          return 'Must be a valid email address';
                        }
                        return null;
                      }),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.02,
                      ),
                      _buildTextField(
                          context, _passwordController, 'Password...', (text) {
                        if (text == null || text.isEmpty) {
                          return 'Can\'t be empty';
                        }
                        return null;
                      }, isObscure: true),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.03,
                      ),
                      ElevatedButton(
                        onPressed: () => _login(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: EdgeInsets.zero,
                          minimumSize: const Size(143, 52),
                        ),
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: Container(
                                decoration: ShapeDecoration(
                                  color: Theme.of(context).primaryColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              child: Text(
                                'LOGIN',
                                textAlign: TextAlign.center,
                                style: textTheme.titleLarge?.copyWith(
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height *
                            0.04, // Ajusta este valor según lo que necesites
                      ),
                      Center(
                        child: TextButton(
                          onPressed: () {
                            Navigator.of(context).pushNamed('/signUp');
                          },
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              style: textTheme.titleLarge?.copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground,
                                  fontWeight: FontWeight.bold),
                              children: [
                                const TextSpan(text: 'Or sign up using'),
                                const TextSpan(text: '\n'),
                                TextSpan(
                                  text: 'Sign up',
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _login(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      BlocProvider.of<AuthenticationBloc>(context).add(
        LoginRequested(_emailController.text, _passwordController.text),
      );
    }
  }

  Widget _buildTextField(BuildContext context, TextEditingController controller,
      String labelText, String? Function(String?) validator,
      {bool isObscure = false}) {
    return TextFormField(
      controller: controller,
      validator: validator,
      obscureText: isObscure,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.only(left: 18, top: 15, bottom: 15),
        labelText: labelText,
        filled: true,
        fillColor: Theme.of(context).colorScheme.surface.withOpacity(1),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(
            color: Colors.red,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(
            color: Colors.red,
          ),
        ),
      ),
    );
  }
}
