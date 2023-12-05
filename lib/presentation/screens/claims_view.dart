import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_app_sports/logic/blocs/authentication/bloc/authentication_bloc.dart';
import 'package:flutter_app_sports/logic/blocs/claims/bloc/claims_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class ClaimsView extends StatefulWidget {
  @override
  _ClaimsViewState createState() => _ClaimsViewState();
}

class _ClaimsViewState extends State<ClaimsView> {
  final _claimController = TextEditingController();
  bool isOffline = false;
  StreamSubscription<ConnectivityResult>? _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    _connectivitySubscription =
        Connectivity().onConnectivityChanged.listen(_updateConnectionStatus);
    checkInitialConnectivity();
  }

  void checkInitialConnectivity() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    _updateConnectionStatus(connectivityResult);
  }

  void _updateConnectionStatus(ConnectivityResult result) {
    setState(() {
      isOffline = result == ConnectivityResult.none;
    });
  }

  @override
  void dispose() {
    _connectivitySubscription?.cancel();
    _claimController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return isOffline ? _buildOfflineWidget() : _buildClaimsWidget(context);
  }

  Widget _buildOfflineWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(Icons.signal_wifi_off, size: 80, color: Colors.grey),
          SizedBox(height: 20),
          Text("No internet connection."),
        ],
      ),
    );
  }

  Widget _buildClaimsWidget(BuildContext context) {
    final authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);
    final authState = authenticationBloc.state;

    if (authState is Authenticated) {
      final userId = authState.usuario.id;

      return BlocProvider<ClaimsBloc>(
        create: (context) => ClaimsBloc(),
        child: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Submit your claim',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _claimController,
                  decoration: const InputDecoration(
                    hintText: 'Enter your claim here...',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 5,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    String claimContent = _claimController.text;
                    BlocProvider.of<ClaimsBloc>(context).add(
                      ClaimsSubmitButtonPressedEvent(
                        claimContent: claimContent,
                        userId: userId,
                      ),
                    );
                  },
                  child: const Text('Submit'),
                ),
                const SizedBox(height: 16),
                BlocBuilder<ClaimsBloc, ClaimsState>(
                  builder: (context, state) {
                    if (state is ClaimsSubmitButtonPressedState && state.isSubmitting) {
                      return const CircularProgressIndicator();
                    } else if (state is ClaimsSubmitSuccessState) {
                      return const Text('Claim submitted successfully!');
                    } else if (state is ClaimsSubmitErrorState) {
                      return Text('Error submitting claim: ${state.error}');
                    }
                    return Container();
                  },
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      return Center(child: Text("User not authenticated"));
    }
  }
}