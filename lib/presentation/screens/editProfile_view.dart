import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_app_sports/data/models/user.dart';
import 'package:flutter_app_sports/presentation/screens/MainLayout.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../logic/blocs/authentication/bloc/authentication_bloc.dart';
import '../../logic/blocs/edit_profile/bloc/edit_profile_bloc.dart';
import '../../logic/blocs/global_events/bloc/global_bloc.dart';
import '../../logic/blocs/global_events/bloc/global_event.dart';

class EditProfileView extends StatefulWidget {
  const EditProfileView({super.key});

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  List<String> roles = [];
  List<String> universities = [];
  List<String> genders = [];
  late User user;
  final _emailController = TextEditingController();
  final _nameController = TextEditingController();
  var _phoneNumberController = TextEditingController();
  var _roleController = TextEditingController();
  var _universityController = TextEditingController();
  var _genderController = TextEditingController();
  var _bornDate;
  final _formKey = GlobalKey<FormState>();

  final EditProfileBloc editProfileBloc = EditProfileBloc();

  @override
  void initState() {
    user = BlocProvider.of<AuthenticationBloc>(context).user!;
    editProfileBloc.add(EditProfileInitialEvent(userId: user.id));
    _bornDate = user.bornDate;
    _emailController.text = user.email;
    _nameController.text = user.name;
    _phoneNumberController = TextEditingController(text: user.phoneNumber);
    _roleController = TextEditingController(text: user.role);
    _universityController = TextEditingController(text: user.university);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return BlocConsumer<EditProfileBloc, EditProfileState>(
        bloc: editProfileBloc,
        listenWhen: (previous, current) => current is EditProfileActionState,
        buildWhen: (previous, current) => current is! EditProfileActionState,
        listener: (context, state) {
          if (state is SubmissionErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(state.message), backgroundColor: Colors.red),
            );
          } else if (state is NoInternetActionState) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text("No internet connection"),
                  backgroundColor: Colors.red),
            );
          } else if (state is SubmittedUserActionState) {
            BlocProvider.of<GlobalBloc>(context)
                .add(NavigateToIndexEvent(AppScreens.Profile.index));
            editProfileBloc.add(EditProfileInitialEvent(userId: user.id));
            BlocProvider.of<AuthenticationBloc>(context)
                .add(UpdateUserEvent(state.user));
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text("User updated"), backgroundColor: Colors.green),
            );
            _emailController.text = state.user.email;
            _nameController.text = state.user.name;
            _phoneNumberController =
                TextEditingController(text: state.user.phoneNumber);
            _roleController = TextEditingController(text: state.user.role);
            _universityController =
                TextEditingController(text: state.user.university);
            _genderController = TextEditingController(text: state.user.gender);
            _bornDate = state.user.bornDate;
          }
        },
        builder: (context, state) {
          roles = editProfileBloc.roles;
          universities = editProfileBloc.universities;
          genders = editProfileBloc.genders;

          if (roles.isEmpty || universities.isEmpty || genders.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          switch (state.runtimeType) {
            case EditProfileLoadingState:
              return const Scaffold(
                  body: Center(
                child: CircularProgressIndicator(),
              ));
            default:
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
                          _buildTextField(
                              context, _nameController, user.name, 'Name...',
                              (text) {
                            if (text == null || text.isEmpty) {
                              return 'Can\'t be empty';
                            }
                            return null;
                          }),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02,
                          ),
                          _buildTextField(
                              context, _emailController, user.email, 'Email...',
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
                          _buildPhoneNumberField(),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02,
                          ),
                          _buildDatePicker(),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02,
                          ),
                          _buildDropdown(
                              'Role', _roleController, user.role!, roles),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02,
                          ),
                          _buildDropdown('University', _universityController,
                              user.university!, universities),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02,
                          ),
                          _buildDropdown('Gender', _genderController,
                              user.gender!, genders),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.03,
                          ),
                          ElevatedButton(
                            onPressed: () => _changeInfo(context),
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
                                    'CHANGE INFO',
                                    textAlign: TextAlign.center,
                                    style: textTheme.titleMedium?.copyWith(
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
                        ],
                      ),
                    ),
                  ),
                ),
              );
          }
        });
  }

Widget _buildTextField(
  BuildContext context,
  TextEditingController controller,
  String initialValue, 
  String labelText,
  String? Function(String?) validator, {
  bool isObscure = false,
  TextInputType keyboardType = TextInputType.text,
}) {
  return TextFormField(
    controller: controller,
    validator: (value) {
      if (RegExp(r'[^\u0000-\u007F]+').hasMatch(value ?? '')) {
        return 'Please enter only valid characters';
      }
      return validator(value);
    },
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
            color: Theme.of(context).colorScheme.error,
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
      user.phoneNumber ?? '',
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

  Widget _buildDropdown(String label, TextEditingController controller,
      String defaultValue, List<String> items) {
    // Asegurarse de que el valor por defecto esté en la lista de opciones
    if (!items.contains(defaultValue) && defaultValue.isNotEmpty) {
      items.insert(0, defaultValue);
    }

    // Inicializar el controlador con el valor por defecto si está vacío
    if (defaultValue.isNotEmpty && controller.text.isEmpty) {
      controller.text = defaultValue;
    }

    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      value: controller.text.isEmpty ? null : controller.text,
      onChanged: (value) => setState(() => controller.text = value ?? ''),
      items: items
          .map((item) => DropdownMenuItem(value: item, child: Text(item)))
          .toList(),
      validator: (value) {
        if (value == null || value.isEmpty) return 'Please select a $label';
        return null;
      },
    );
  }

  void _changeInfo(BuildContext context) async {

    if (_formKey.currentState!.validate()) {
      editProfileBloc.add(
        SubmitUserEvent(
          email: _emailController.text,
          name: _nameController.text,
          phoneNumber: _phoneNumberController.text,
          role: _roleController.text,
          university: _universityController.text,
          gender: _genderController.text,
          bornDate: _bornDate,
          userId: user.id,
        ),
      );
    }

    // var connectivityResult = await (Connectivity().checkConnectivity());
    // if (connectivityResult == ConnectivityResult.none) {
    //   editProfileBloc.add(NoInternetEvent());
    // } else {
    //   if (_formKey.currentState!.validate()) {
    //     editProfileBloc.add(
    //       SubmitUserEvent(
    //         email: _emailController.text,
    //         name: _nameController.text,
    //         phoneNumber: _phoneNumberController.text,
    //         role: _roleController.text,
    //         university: _universityController.text,
    //         gender: _genderController.text,
    //         bornDate: _bornDate,
    //         userId: user.id,
    //       ),
    //     );
    //   }
    // }
  }
}