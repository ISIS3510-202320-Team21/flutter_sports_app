import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
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
  int userid = 0;
  final _emailController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _roleController = TextEditingController();
  final _universityController = TextEditingController();
  final _genderController = TextEditingController();
  var _bornDate;
  final _formKey = GlobalKey<FormState>();

  final EditProfileBloc editProfileBloc = EditProfileBloc();
  final AuthenticationBloc authenticationBloc = AuthenticationBloc();

  @override
  void initState() {
    // Lanza los eventos para cargar los datos al iniciar la vista
    int? userId = BlocProvider.of<AuthenticationBloc>(context).user?.id;
    userid = userId!;
    editProfileBloc.add(EditProfileInitialEvent(userId: userId!));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return BlocConsumer<EditProfileBloc, EditProfileState>(
      bloc: editProfileBloc,
      listenWhen: (previous, current) => current is EditProfileActionState,
      buildWhen: (previous, current) => current is !EditProfileActionState,
      listener: (context, state) {
        if (state is EditProfileErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Error")),
          );
        }
        else if (state is SubmittedUserActionState){
          BlocProvider.of<GlobalBloc>(context)
              .add(NavigateToIndexEvent(0));
          //snackbar green
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("User updated"),
              backgroundColor: Colors.green),
          );
          _emailController.clear();
          _nameController.clear();
          _phoneNumberController.clear();
          _roleController.clear();
          _universityController.clear();
          _genderController.clear();
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
          case EditProfileLoadedSuccessState || EditProfileErrorState:
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
                        _buildTextField(context, _nameController, 'Name', (text) {
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
                        _buildDropdown(
                            'University', _universityController, universities),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02,
                        ),
                        _buildDropdown('Gender', _genderController, genders),
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
                          height: MediaQuery.of(context).size.height * 0.04,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          default:
            return const SizedBox();
        }
      }
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

  void _changeInfo(BuildContext context) {
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
          userId: userid
        ),
      );
    }
  }
}