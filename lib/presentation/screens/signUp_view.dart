import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_sports/logic/blocs/authentication/bloc/authentication_bloc.dart';
import 'package:flutter_app_sports/logic/blocs/fetch/bloc/fetch_bloc.dart';
import 'package:flutter_app_sports/logic/blocs/fetch/bloc/fetch_event.dart';
import 'package:flutter_app_sports/logic/blocs/fetch/bloc/fetch_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  _SignUpViewState createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  List<String> roles = [];
  List<String> universities = [];
  List<String> genders = [];
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _roleController = TextEditingController();
  final _universityController = TextEditingController();
  final _genderController = TextEditingController();
  var _bornDate;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // Lanza los eventos para cargar los datos al iniciar la vista
    BlocProvider.of<FetchBloc>(context).add(FetchRolesRequested());
    BlocProvider.of<FetchBloc>(context).add(FetchUniversitiesRequested());
    BlocProvider.of<FetchBloc>(context).add(FetchGendersRequested());
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    ScreenUtil.init(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        surfaceTintColor: Theme.of(context).colorScheme.onPrimary,
        elevation: 0.0,
        title: Text(
          "SIGN UP",
          style: textTheme.headlineSmall?.copyWith(
              color: Theme.of(context).colorScheme.onBackground,
              fontWeight: FontWeight.bold),
        ),
        toolbarHeight: 0.1 * ScreenUtil().screenHeight,
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      body: BlocConsumer<AuthenticationBloc, AuthenticationState>(
        listener: (context, authState) {
          // Existing AuthenticationBloc listener code...
        },
        builder: (context, authState) {
          // Here you can use BlocBuilder or BlocConsumer for FetchBloc.
          return BlocConsumer<FetchBloc, FetchState>(
            listener: (context, fetchState) {
              // React to the state changes of FetchBloc
              if (fetchState is RolesLoadSuccess) {
                setState(() {
                  roles = fetchState.roles;
                });
              }
              if (fetchState is UniversitiesLoadSuccess) {
                setState(() {
                  universities = fetchState.universities;
                });
              }
              if (fetchState is GendersLoadSuccess) {
                setState(() {
                  genders = fetchState.genders;
                });
              }
            },
            builder: (context, fetchState) {
              // This will rebuild whenever FetchBloc's state changes.
              if (fetchState is RolesLoadInProgress ||
                  fetchState is UniversitiesLoadInProgress ||
                  fetchState is GendersLoadInProgress) {
                return const Center(child: CircularProgressIndicator());
              }

              // If any of the data lists is empty, it means data is not fetched yet.
              if (roles.isEmpty || universities.isEmpty || genders.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }

              // Once all the data is loaded, you can build your form.
              return Container(
                constraints: const BoxConstraints.expand(),
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
                                top: MediaQuery.of(context).size.height * 0.05),
                            child: Image.asset('assets/loginIcon.png'),
                          ),
                          _buildTextField(context, _nameController, 'Name',
                              (text) {
                            if (text == null || text.isEmpty) {
                              return 'Can\'t be empty';
                            }
                            return null;
                          }),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02,
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
                              context, _passwordController, 'Password...',
                              (text) {
                            if (text == null || text.isEmpty) {
                              return 'Can\'t be empty';
                            }
                            return null;
                          }, isObscure: true),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02,
                          ),
                          _buildPhoneNumberField(),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02,
                          ),
                          _buildDatePicker(),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02,
                          ),
                          _buildDropdown('Role', _roleController, roles),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02,
                          ),
                          _buildDropdown('University', _universityController,
                              universities),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02,
                          ),
                          _buildDropdown('Gender', _genderController, genders),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.03,
                          ),
                          ElevatedButton(
                            onPressed: () => _signUp(context),
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
                                    'SIGN UP',
                                    textAlign: TextAlign.center,
                                    style: textTheme.titleLarge?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimary,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.04,
                          ),
                          Center(
                            child: TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
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
                                    const TextSpan(
                                        text: 'Already have an account?'),
                                    const TextSpan(text: '\n'),
                                    TextSpan(
                                      text: 'Login',
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
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
          );
        },
      ),
    );
  }

  Widget _buildTextField(
    BuildContext context,
    TextEditingController controller,
    String labelText,
    String? Function(String?) validator, {
    bool isObscure = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      obscureText: isObscure,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.only(left: 18, top: 15, bottom: 15),
        labelText: labelText,
        filled: true,
        fillColor: Theme.of(context).colorScheme.surface.withOpacity(1),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.onSecondary.withOpacity(0.9)	,
          ),
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

  Widget _buildPhoneNumberField() {
    return _buildTextField(
      context,
      _phoneNumberController,
      'Phone Number',
      (val) {
        if (val == null || val.isEmpty) return 'Can\'t be empty';
        if (!RegExp(r'^[0-9]+$').hasMatch(val)) {
          return 'Enter a valid phone number';
        }
        return null;
      },
      keyboardType: TextInputType.phone,
    );
  }

  Widget _buildDatePicker() {
    return TextFormField(
      readOnly: true,
      decoration: const InputDecoration(
        labelText: 'Born Date',
        border: OutlineInputBorder(),
        suffixIcon: Icon(Icons.calendar_today),
      ),
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
        );
        if (pickedDate != null) {
          setState(() {
            _bornDate = pickedDate;
          });
        }
      },
      controller: TextEditingController(
          text: _bornDate != null
              ? DateFormat('dd/MM/yy').format(_bornDate!)
              : ''),
      validator: (val) {
        if (val == null || val.isEmpty) return 'Please select a date';
        return null;
      },
    );
  }

  Widget _buildDropdown(
      String label, TextEditingController controller, List<String> items) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      value: controller.text.isEmpty ? null : controller.text,
      items: items
          .map((item) => DropdownMenuItem(value: item, child: Text(item)))
          .toList(),
      onChanged: (value) => setState(() => controller.text = value!),
      validator: (value) {
        if (value == null || value.isEmpty) return 'Please select a $label';
        return null;
      },
    );
  }

  void _signUp(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      BlocProvider.of<AuthenticationBloc>(context).add(
        SignUpRequested(
          email: _emailController.text,
          password: _passwordController.text,
          name: _nameController.text,
          phoneNumber: _phoneNumberController.text,
          role: _roleController.text,
          university: _universityController.text,
          gender: _genderController.text,
          bornDate: _bornDate,
        ),
      );
    }
  }
}
