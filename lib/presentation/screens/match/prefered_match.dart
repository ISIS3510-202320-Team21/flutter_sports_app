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
  final DateTime? selectedDate;

  const PreferedMatch(
      {required this.selectedSport, this.selectedDate, Key? key})
      : super(key: key);

  @override
  _PreferedMatchState createState() => _PreferedMatchState();
}

class _PreferedMatchState extends State<PreferedMatch> {
  DateTime? selectedStartTime;
  DateTime? selectedEndTime;
  Level? selectedLevel;
  User? user;
  List<Level>? levels;

  @override
  void initState() {
    super.initState();
    user = BlocProvider.of<AuthenticationBloc>(context).user;
  }

  @override
  Widget build(BuildContext context) {
    return Provider<MatchBloc>(
        create: (context) => MatchBloc(),
        child: Builder(builder: (BuildContext innerContext) {
          innerContext.read<MatchBloc>().add(FetchLevelsEvent());
          return _buildUI(context);
        }));
  }

  Widget _buildUI(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<MatchBloc, MatchState>(builder: (context, state) {
        if (state is MatchLoadingState) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is LevelsLoadedState) {
          levels = state.levels;
        } else if (state is MatchErrorState) {
          return const Center(child: Text('Error loading data'));
        } else if (state is MatchCreatedState) {
          WidgetsBinding.instance!.addPostFrameCallback((_) {
            ScaffoldMessenger.of(context)
                .showSnackBar(const SnackBar(content: Text('Waiting for a match!')));
          });
          BlocProvider.of<GlobalBloc>(context).add(NavigateToIndexEvent(AppScreens.Home.index));
        }
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
                        : DateFormat('dd/MM/yyyy').format(widget.selectedDate!),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              ),
              const Divider(),
              ListTile(
                leading: widget.selectedSport.image != null &&
                        widget.selectedSport.image!.isNotEmpty
                    ? Image.network(
                        widget.selectedSport.image!,
                        fit: BoxFit.cover,
                      )
                    : Icon(Icons.sports_tennis,
                        color: Theme.of(context).colorScheme.primary),
                title: Text(widget.selectedSport.name,
                    style: Theme.of(context).textTheme.titleMedium),
              ),
              const Divider(),
              ListTile(
                title: Text(
                  selectedLevel?.name ?? "Select Level",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text("Select Level"),
                        content: SizedBox(
                          width: double.maxFinite,
                          height: 200,
                          child: ListView.builder(
                            itemCount: levels?.length,
                            itemBuilder: (BuildContext context, int index) {
                              return ListTile(
                                title: Text(levels![index].name),
                                onTap: () {
                                  setState(() {
                                    selectedLevel = state.levels[index];
                                  });
                                  Navigator.of(context).pop();
                                },
                              );
                            },
                          ),
                        ),
                        actions: <Widget>[
                          TextButton(
                            child: const Text("Cancel"),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
              const Divider(),
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
                        initialTime: TimeOfDay.fromDateTime(selectedStartTime!)
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
                                    pickedEnd.minute > pickedStart.minute))) {
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
                              content:
                                  Text("End time should be after start time."),
                            ),
                          );
                        }
                      });
                    });
                  }
                },
              ),
              const SizedBox(height: 100),
              ElevatedButton(
                onPressed: () {
                  BlocProvider.of<MatchBloc>(context).add(CreateMatchEvent(
                      Match(
                          date: widget.selectedDate,
                          city: "Bogotá",
                          court: "Centro de Deportes",
                          level: selectedLevel!,
                          sport: widget.selectedSport,
                          time:
                              '${DateFormat('HH:mm').format(selectedStartTime!)} - ${DateFormat('HH:mm').format(selectedEndTime!)}',
                          userCreated: user,
                          status: "Pending"),
                      user!.id));
                },
                style: ButtonStyle(
                  padding: MaterialStateProperty.all(
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 40)),
                  backgroundColor: MaterialStateProperty.all(
                      Theme.of(context).colorScheme.primary),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  shadowColor: MaterialStateProperty.all(Colors.black45),
                  elevation: MaterialStateProperty.all(5),
                  overlayColor: MaterialStateProperty.all(Colors.black12),
                ),
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
      }),
    );
  }

}
