import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:therapist/core/theme/theme.dart';
import 'package:therapist/model/therapy_models/therapy_models.dart';
import 'package:therapist/presentation/therapy_goals/widgets/add_new_bottom_sheet.dart';
import 'package:therapist/provider/therapy_provider.dart';

import 'widgets/therapy_container.dart';

class AddTherapyDetailsScreen extends StatefulWidget {
  const AddTherapyDetailsScreen({
    super.key,
    required this.therapyDetailsType,
  });

  final TherapyDetailsType therapyDetailsType;

  @override
  State<AddTherapyDetailsScreen> createState() => _AddTherapyDetailsScreenState();
}

class _AddTherapyDetailsScreenState extends State<AddTherapyDetailsScreen> {

  @override
  void initState() {
    super.initState();
    _getTherapyData();
  }

  void _getTherapyData() {
    switch (widget.therapyDetailsType) {
      case TherapyDetailsType.goals:
        context.read<TherapyProvider>().getTherapyGoals();
        break;
      case TherapyDetailsType.observation:
        context.read<TherapyProvider>().getTherapyObservations();
        break;
      case TherapyDetailsType.regression:
        context.read<TherapyProvider>().getTherapyRegressions();
        break;
      case TherapyDetailsType.activities:
        context.read<TherapyProvider>().getTherapyActivities();
        break;
    }
  }

  void callAddNewTherapyData(BuildContext context, String value) {
    switch (widget.therapyDetailsType) {
      case TherapyDetailsType.goals:
        Provider.of<TherapyProvider>(context, listen: false).addTherapyGoals(value);
        break;
      case TherapyDetailsType.observation:
        Provider.of<TherapyProvider>(context, listen: false).addTherapyObservations(value);
        break;
      case TherapyDetailsType.regression:
        Provider.of<TherapyProvider>(context, listen: false).addTherapyRegressions(value);
        break;
      case TherapyDetailsType.activities:
        Provider.of<TherapyProvider>(context, listen: false).addTherapyActivities(value);
        break;
    }
  }

  List<TherapyModel> _getTherapyDataAsPerSelection() {
    final TherapyProvider provider = Provider.of<TherapyProvider>(context, listen: false);
    switch (widget.therapyDetailsType) {
      case TherapyDetailsType.goals:
        return provider.therapyGoals;
      case TherapyDetailsType.observation:
        return provider.therapyObservations;
      case TherapyDetailsType.regression:
        return provider.therapyRegressions;
      case TherapyDetailsType.activities:
        return provider.therapyActivities;
    }
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return AddNewBottomSheet(
          therapyDetailsType: widget.therapyDetailsType,
          onSumbit:(String value) {
            callAddNewTherapyData(context, value);
            Future.delayed(const Duration(milliseconds: 1000), () {
              _getTherapyData();
            });
            Navigator.of(context).pop();
          }
        );
      },
    );
  }

  String get _getTherapyDetailsText {
    switch (widget.therapyDetailsType) {
      case TherapyDetailsType.goals:
        return 'Add Therapy Goals';
      case TherapyDetailsType.observation:
        return 'Add Therapy Observation';
      case TherapyDetailsType.regression:
        return 'Add Regression';
      case TherapyDetailsType.activities:
        return 'Add Activities';
    }
  }

  List<TherapyModel> _getSelectedDataAsPerTherapySelection() {
    switch (widget.therapyDetailsType) {
      case TherapyDetailsType.goals:
        return context.read<TherapyProvider>().selectedTherapyGoals;
      case TherapyDetailsType.observation:
        return context.read<TherapyProvider>().selectedTherapyObservations;
      case TherapyDetailsType.regression:
        return context.read<TherapyProvider>().selectedTherapyRegressions;
      case TherapyDetailsType.activities:
        return context.read<TherapyProvider>().selectedTherapyActivities;
    }
  }

  void _addToSelectedTherapyData(TherapyModel model) {
    switch (widget.therapyDetailsType) {
      case TherapyDetailsType.goals:
        context.read<TherapyProvider>().addToSelectedGoals(model);
        break;
      case TherapyDetailsType.observation:
        context.read<TherapyProvider>().addToSelectedObservations(model);
        break;
      case TherapyDetailsType.regression:
        context.read<TherapyProvider>().addToSelectedRegressions(model);
        break;
      case TherapyDetailsType.activities:
        context.read<TherapyProvider>().addToSelectedActivities(model);
        break;
    }
  }

  void _removeFromSelectedTherapyData(TherapyModel model) {
    switch (widget.therapyDetailsType) {
      case TherapyDetailsType.goals:
        context.read<TherapyProvider>().removeFromSelectedGoals(model);
        break;
      case TherapyDetailsType.observation:
        context.read<TherapyProvider>().removeFromSelectedObservations(model);
        break;
      case TherapyDetailsType.regression:
        context.read<TherapyProvider>().removeFromSelectedRegressions(model);
        break;
      case TherapyDetailsType.activities:
        context.read<TherapyProvider>().removeFromSelectedActivities(model);
        break;
    }
  }

  AppBar _getAppBar() {
    return AppBar(
        leading: GestureDetector(
          onTap: () {
            context.read<TherapyProvider>().resetTherapyData();
            Navigator.of(context).pop();
          },
          child: Image.asset('assets/arrow_left.png',
           width: 24,
           height: 24,
          ),
        ),
        title:  Text(
          _getTherapyDetailsText,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600
          ),
        ),
        centerTitle: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Align(
        alignment: Alignment.bottomRight,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
          decoration: const BoxDecoration(
            shape: BoxShape.circle
          ),
          child: FloatingActionButton(
            onPressed: () => _showBottomSheet(context),
            backgroundColor: AppTheme.primaryColor,
            child: const Icon(Icons.add, color: Colors.white,),
          ),
        ),
      ),
      appBar: _getAppBar(),
      body: Consumer<TherapyProvider>(
        builder: (context, provider, child) {
          final data = _getTherapyDataAsPerSelection();

          if(data.isEmpty) {
            return const Center(
              child: Text('No data found'),
            );
          }

          return SingleChildScrollView(
            child: Column(
                spacing: 2,
                children: data.map((e) {
                  final data = _getSelectedDataAsPerTherapySelection();
                  final isSelected = data.any((element) => element.id == e.id);
                  return _BuildOptionTile(
                    name: e.name,
                    isSelected: isSelected,
                    onChanged: (value) {
                      if(value ?? false) {
                        _addToSelectedTherapyData(e);
                      } else {
                        _removeFromSelectedTherapyData(e);
                      }
                    },
                  );
                }).toList()),
          );
        },
      ),
    );
  }
}

class _BuildOptionTile extends StatelessWidget {
  const _BuildOptionTile({
    super.key,
    required this.name,
    required this.isSelected,
    required this.onChanged,
  });

  final String name;
  final bool isSelected;
  final Function(bool?)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          activeColor: AppTheme.primaryColor,
          value: isSelected,
          onChanged: onChanged,
        ),
        Expanded(child: Text(name, softWrap: true,)),
      ],
    );
  }
}