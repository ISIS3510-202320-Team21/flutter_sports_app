// ignore_for_file: must_be_immutable

import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_sports/data/models/level.dart';
import 'package:flutter_app_sports/data/models/match.dart';
import 'package:flutter_app_sports/data/models/sport.dart';
import 'package:flutter_app_sports/data/models/user.dart';
import 'package:flutter_app_sports/logic/blocs/authentication/bloc/authentication_bloc.dart';
import 'package:flutter_app_sports/logic/blocs/global_events/bloc/global_bloc.dart';
import 'package:flutter_app_sports/logic/blocs/global_events/bloc/global_event.dart';
import 'package:flutter_app_sports/logic/blocs/match/bloc/match_bloc.dart';
import 'package:flutter_app_sports/presentation/screens/MainLayout.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PreferedMatch extends StatefulWidget {
  final Sport selectedSport;
  DateTime? selectedDate;

  PreferedMatch({required this.selectedSport, this.selectedDate, Key? key})
      : super(key: key);

  @override
  _PreferedMatchState createState() => _PreferedMatchState();
}

class _PreferedMatchState extends State<PreferedMatch> {
  DateTime? selectedStartTime;
  DateTime? selectedEndTime;
  Level? selectedLevel;
  String? selectedCity;
  String? selectedCourt;
  User? user;
  List<Level>? levels;
  List<String>? cities;
  List<String>? courts;
  bool allDataLoaded = false;
  MatchBloc matchBloc = MatchBloc();
  StreamSubscription<ConnectivityResult>? _connectivitySubscription;
  bool _isConnected = true;

  @override
  void initState() {
    super.initState();
    user = BlocProvider.of<AuthenticationBloc>(context).user;
    matchBloc.add(FetchLevelsEvent());
    matchBloc.add(FetchCitiesRequested());
    matchBloc.add(FetchCourtsRequested());
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
      _isConnected = result != ConnectivityResult.none;
    });
    if (_isConnected) {
      _retryConnection();
    }
  }

  void _retryConnection() {
    matchBloc.add(FetchLevelsEvent());
    matchBloc.add(FetchCitiesRequested());
    matchBloc.add(FetchCourtsRequested());
  }

  @override
  void dispose() {
    _connectivitySubscription?.cancel();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime now = DateTime.now();
    DateTime tomorrow = DateTime(now.year, now.month, now.day);

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: widget.selectedDate ?? tomorrow,
      firstDate: tomorrow,
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != widget.selectedDate) {
      setState(() {
        widget.selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isConnected) {
      return Container(
        color: Colors.white,
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.wifi_off,
                size: 100,
                color: Colors.grey,
              ),
              SizedBox(height: 20),
              Text(
                "No internet connection available.",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      );
    }
    return Container(
      color: Colors.white,
      child: SingleChildScrollView(
        child: BlocConsumer<MatchBloc, MatchState>(
          bloc: matchBloc,
          builder: (context, state) {
            if (!allDataLoaded) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is MatchLoadingState) {
              // Mientras los datos se están cargando o no todos están cargados, mostramos un loader.
              return const Center(child: CircularProgressIndicator());
            } else if (state is MatchErrorState) {
              return const Center(child: Text('Error loading data'));
            } else {
              // Una vez que todos los datos estén cargados, construimos la UI correspondiente.
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ListTile(
                        leading: Icon(Icons.calendar_today,
                            color: Theme.of(context).colorScheme.primary),
                        title: Text(
                          widget.selectedDate == null
                              ? "Select Date"
                              : DateFormat('dd/MM/yyyy')
                                  .format(widget.selectedDate!),
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        onTap: () =>
                            _selectDate(context), // Agregado evento onTap
                      ),
                    ),
                    const SizedBox(height: 10),
                    ListTile(
                      leading: widget.selectedSport.image != null &&
                              widget.selectedSport.image!.isNotEmpty
                          ? CachedNetworkImage(
                              imageUrl: widget.selectedSport.image!,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => const Center(
                                child: SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.0,
                                  ),
                                ),
                              ),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            )
                          : Icon(Icons.sports_tennis,
                              color: Theme.of(context).colorScheme.primary),
                      title: Text(widget.selectedSport.name,
                          style: Theme.of(context).textTheme.titleMedium),
                    ),
                    const SizedBox(height: 10),
                    ListTile(
                      title: Text(
                        selectedStartTime == null || selectedEndTime == null
                            ? "Select Time"
                            : '${DateFormat('HH:mm').format(selectedStartTime!)} - ${DateFormat('HH:mm').format(selectedEndTime!)}',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      onTap: () async {
                        final TimeOfDay? pickedStart = await showTimePicker(
                          context: context,
                          initialTime: selectedStartTime != null
                              ? TimeOfDay.fromDateTime(selectedStartTime!)
                              : TimeOfDay.now(),
                          builder: (BuildContext context, Widget? child) {
                            return Theme(
                              data: ThemeData.light().copyWith(
                                primaryColor: Colors.blue,
                                buttonTheme: const ButtonThemeData(
                                  textTheme: ButtonTextTheme.primary,
                                ),
                                dialogBackgroundColor: Colors.white,
                              ),
                              child: child!,
                            );
                          },
                        );

                        if (pickedStart != null) {
                          setState(() {
                            selectedStartTime = DateTime(
                                DateTime.now().year,
                                DateTime.now().month,
                                DateTime.now().day,
                                pickedStart.hour,
                                pickedStart.minute);

                            showTimePicker(
                              context: context,
                              initialTime:
                                  TimeOfDay.fromDateTime(selectedStartTime!)
                                      .replacing(hour: pickedStart.hour + 1),
                              builder: (BuildContext context, Widget? child) {
                                return Theme(
                                  data: ThemeData.light().copyWith(
                                    primaryColor: Colors.blue,
                                    buttonTheme: const ButtonThemeData(
                                      textTheme: ButtonTextTheme.primary,
                                    ),
                                    dialogBackgroundColor: Colors.white,
                                  ),
                                  child: child!,
                                );
                              },
                            ).then((pickedEnd) {
                              if (pickedEnd != null &&
                                  (pickedEnd.hour > pickedStart.hour ||
                                      (pickedEnd.hour == pickedStart.hour &&
                                          pickedEnd.minute >
                                              pickedStart.minute))) {
                                setState(() {
                                  selectedEndTime = DateTime(
                                      DateTime.now().year,
                                      DateTime.now().month,
                                      DateTime.now().day,
                                      pickedEnd.hour,
                                      pickedEnd.minute);
                                });
                              } else if (pickedEnd != null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        "End time should be after start time."),
                                  ),
                                );
                              }
                            });
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 10),
                    ListTile(
                      title: Text(
                        selectedLevel?.name ?? "Select Level",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      onTap: () {
                        _showLevelDialog(context, levels);
                      },
                    ),
                    const SizedBox(height: 10),
                    ListTile(
                      title: Text(
                        selectedCourt ?? "Select Court",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      onTap: () {
                        _showCourtDialog(context,
                            courts); // Esta función mostrará el diálogo de selección de cancha.
                      },
                    ),
                    const SizedBox(height: 10),
                    ListTile(
                      title: Text(
                        selectedCity ?? "Select City",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      onTap: () {
                        _showCityDialog(context,
                            cities); // Esta función mostrará el diálogo de selección de ciudad.
                      },
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      style: ButtonStyle(
                        fixedSize: MaterialStateProperty.all<Size>(
                            const Size(double.infinity, 50)),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                        ),
                      ),
                      onPressed: () {
                        DateTime now = DateTime.now();
                        if (widget.selectedDate != null &&
                            widget.selectedDate!.day == now.day &&
                            selectedStartTime != null &&
                            selectedStartTime!.isBefore(now)) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  "You cannot create a match for a time that has already passed."),
                            ),
                          );
                          return;
                        }

                        if (selectedStartTime == null ||
                            selectedEndTime == null ||
                            selectedLevel == null ||
                            selectedCity == null ||
                            selectedCourt == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Please fill all the fields."),
                            ),
                          );
                          return;
                        }

                        matchBloc.add(CreateMatchEvent(
                            Match(
                                date: widget.selectedDate,
                                city: selectedCity!,
                                court: selectedCourt!,
                                level: selectedLevel!,
                                sport: widget.selectedSport,
                                time:
                                    '${DateFormat('HH:mm').format(selectedStartTime!)} - ${DateFormat('HH:mm').format(selectedEndTime!)}',
                                userCreated: user,
                                status: "Pending"),
                            user!.id));
                        selectedCity = null;
                        selectedCourt = null;
                        selectedLevel = null;
                        selectedStartTime = null;
                        selectedEndTime = null;
                      },
                      child: const Text(
                        "CREATE",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  ]),
                ),
              );
            }
          },
          listener: (BuildContext context, MatchState state) {
            if (state is LevelsLoadedState) {
              levels = state.levels;
            } else if (state is CitiesLoadSuccess) {
              cities = state.cities;
            } else if (state is CourtsLoadSuccess) {
              courts = state.courts;
            } else if (state is MatchCreatedState) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Waiting for a match!')));
              });
              BlocProvider.of<GlobalBloc>(context)
                  .add(NavigateToIndexEvent(AppScreens.Home.index));
              matchBloc.add(NewMatchNavigateEvent());
            }
            allDataLoaded = levels != null && cities != null && courts != null;
          },
        ),
      ),
    );
  }

  void _showCityDialog(BuildContext context, List<String>? cities) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Select City"),
          content: _buildDialogList(cities, (String value) {
            setState(() {
              selectedCity = value;
            });
            Navigator.of(context).pop();
          }),
        );
      },
    );
  }

  void _showLevelDialog(BuildContext context, List<Level>? levels) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Select Level"),
          content: _buildDialogList(levels?.map((e) => e.name).toList(),
              (String value) {
            setState(() {
              selectedLevel =
                  levels?.firstWhere((element) => element.name == value);
            });
            Navigator.of(context).pop();
          }),
        );
      },
    );
  }

  void _showCourtDialog(BuildContext context, List<String>? courts) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Select Court"),
          content: _buildDialogList(courts, (String value) {
            setState(() {
              selectedCourt = value;
            });
            Navigator.of(context).pop();
          }),
          // Resto del código del diálogo...
        );
      },
    );
  }

  Widget _buildDialogList(List<String>? items, Function(String) onTap) {
    return SizedBox(
      width: double.maxFinite,
      height: 200,
      child: ListView.builder(
        itemCount: items?.length ?? 0,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text(items![index]),
            onTap: () => onTap(items[index]),
          );
        },
      ),
    );
  }
}