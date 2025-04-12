import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:therapist/core/theme/theme.dart';
import 'package:therapist/presentation/therapy_goals/widgets/save_therapy_button.dart';
import 'package:therapist/presentation/therapy_goals/widgets/therapy_container.dart';
import 'package:therapist/presentation/therapy_goals/widgets/therapy_date_time_picker.dart';
import 'package:therapist/presentation/therapy_goals/widgets/therapy_type_field.dart';
import 'package:therapist/presentation/widgets/snackbar_service.dart';
import 'package:therapist/provider/therapy_provider.dart';

class TherapyGoalsScreen extends StatefulWidget {
  const TherapyGoalsScreen({super.key});

  @override
  State<TherapyGoalsScreen> createState() => _TherapyGoalsScreenState();
}

class _TherapyGoalsScreenState extends State<TherapyGoalsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<TherapyProvider>().getThearpyType();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final therapyProvider = context.read<TherapyProvider>();
      if (therapyProvider.saveTherapyStatus.isSuccess) {
        SnackbarService.showSuccess('Therapy details saved successfully.');
        _navigateToHomeScreen();
        _resetAllFields();
      } else if (therapyProvider.saveTherapyStatus.isFailure) {
        SnackbarService.showError('Something went wrong. Please try again later.');
      }
    });
  }

  void _navigateToHomeScreen() {
    Navigator.of(context).pop();
  }

  void _resetAllFields() {
    context.read<TherapyProvider>().resetAllFields();
  }

  AppBar _getAppBar() {
    return AppBar(
      leading: GestureDetector(
        onTap: () {
          _resetAllFields();
          _navigateToHomeScreen();
        },
        child: Image.asset(
          'assets/arrow_left.png',
          width: 24,
          height: 24,
        ),
      ),
      title: const Text(
        'Tailored Goals',
        style: TextStyle(
            color: Colors.black, fontSize: 20, fontWeight: FontWeight.w600),
      ),
      centerTitle: true,
    );
  }

  Future<void> _selectDate() async {
    final therapyProvider = context.read<TherapyProvider>();

    final DateTime? dateTime = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppTheme.primaryColor,
              onPrimary: Colors.white,
              onSurface: AppTheme.textColor,
            ),
          ),
          child: child!,
        );
      },
    );

    if (dateTime != null) {
      therapyProvider.setSelectedDateTime(dateTime);
    }
  }

  void _onSaveTherapyDetails() {
    final therapyProvider = context.read<TherapyProvider>();
    therapyProvider.saveTherapyDetails();
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<TherapyProvider>(context, listen: true).saveTherapyStatus;
    return Scaffold(
      appBar: _getAppBar(),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 25),
        child: SaveTherapyButton(
          text: 'Save Therapy Details',
          onPressed: _onSaveTherapyDetails,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 22, right: 22, top: 22),
        child: Column(
          spacing: 30,
          children: [
            Consumer<TherapyProvider>(builder: (context, provider, child) {
              return TherapyTypeField(
                selectedTherapyType: provider.selectedTherapyType,
                therapyType: provider.therapyTypes,
                onChanged: (value) {
                  provider.setSelectedTherapyType = value ?? '';
                },
              );
            }),
            Consumer<TherapyProvider>(
              builder: (context, provider, child) {

                String? selectedDateTime() {
                  if(provider.selectedDateTime != null) {
                    return DateFormat('dd MMM yyyy').format(provider.selectedDateTime!);
                  }
                  return null;
                }

                return TherapyDateTimePicker(
                  value: selectedDateTime(),
                  label: 'Therapy Date',
                  icon: Icons.calendar_month_outlined,
                  onTap: _selectDate,
                );
              },
            ),
            Consumer<TherapyProvider>(
              builder: (context, provider, child) {
                return TherapyContainer(
                  therapyDetailsType: TherapyDetailsType.goals,
                  therapyInfo: provider.selectedTherapyGoals,
                );
              },
            ),
            Consumer<TherapyProvider>(
              builder: (context, provider, child) {
                return TherapyContainer(
                  therapyDetailsType: TherapyDetailsType.observation,
                  therapyInfo: provider.selectedTherapyObservations,
                );
              },
            ),
            Consumer<TherapyProvider>(
              builder: (context, provider, child) {
                return TherapyContainer(
                  therapyDetailsType: TherapyDetailsType.regression,
                  therapyInfo: provider.selectedTherapyRegressions,
                );
              },
            ),
            Consumer<TherapyProvider>(
              builder: (context, provider, child) {
                return TherapyContainer(
                  therapyDetailsType: TherapyDetailsType.activities,
                  therapyInfo: provider.selectedTherapyActivities,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
