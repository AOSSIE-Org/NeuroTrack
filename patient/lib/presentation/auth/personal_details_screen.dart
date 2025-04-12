import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';


import 'package:patient/presentation/assessments/assessment_screen.dart';
import 'package:patient/presentation/assessments/assessments_list_screen.dart';

import 'package:patient/presentation/home/home_screen.dart';

import 'package:patient/core/core.dart';
import 'package:patient/model/auth_models/personal_info_model.dart';
import 'package:patient/presentation/assessments/assessments_list_screen.dart';
import 'package:patient/presentation/widgets/snackbar_service.dart';
import 'package:patient/provider/auth_provider.dart';
import 'package:provider/provider.dart';



class PersonalDetailsScreen extends StatefulWidget {
  const PersonalDetailsScreen({super.key});

  @override
  State<PersonalDetailsScreen> createState() => _PersonalDetailsScreenState();
}

class _PersonalDetailsScreenState extends State<PersonalDetailsScreen> {
  bool isAssessmentForChild = false;
  // Adult Variables
  final adultNameController = TextEditingController();
  final phoneController = TextEditingController();
  final adultAgeController = TextEditingController();
  Country? selectedCountry;
  String? selectedGender = '';

  // Child Variables
  final childNameController = TextEditingController();
  final childAgeController = TextEditingController();
  final guardianPhoneController = TextEditingController();
  Country? selectedChildCountry;
  String selectedRelation = '';
  String? selectedChildGender = '';

  // Form validation
  final _formKey = GlobalKey<FormState>();
  final Map<String, String?> _validationErrors = {};


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if(!mounted) {
        return;
      }
      final authProvider = context.read<AuthProvider>();

      void showErrorSnackBar(String errorMessage) {
        SnackbarService.showError(errorMessage);
      }

      if(authProvider.apiStatus.isSuccess) {
        SnackbarService.showSuccess('Personal Info saved successfully');
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const AssessmentsListScreen(),
          ),
        );
      } else if(authProvider.apiStatus.isFailure) {
        showErrorSnackBar(authProvider.apiErrorMessage);
      }
    });

  }


  PersonalInfoModel get getPersonalInfo {

    int parseAge(String age) {
      return int.tryParse(age) ?? 0;
    }

    bool isAdult(String age) {
      return parseAge(age) >= 18;
    }

    return PersonalInfoModel(
      patientId: '',
      patientName: isAssessmentForChild
          ? childNameController.text
          : adultNameController.text,
      age: isAssessmentForChild ? parseAge(childAgeController.text) : parseAge(adultAgeController.text),
      isAdult: isAssessmentForChild ? isAdult(childAgeController.text) : isAdult(adultAgeController.text),
      phoneNo: phoneController.text,
      email: '',
      guardianName: isAssessmentForChild ? adultNameController.text : '',
      guardianRelation: isAssessmentForChild ? guardianPhoneController.text : phoneController.text,
      country: selectedCountry?.displayName ?? '',
      gender: isAssessmentForChild ? selectedChildGender ?? '' : selectedGender ?? '',
    );
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<AuthProvider>(context, listen: true).apiStatus;
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
        child: FilledButton(
          onPressed: () {

            if (_formKey.currentState?.validate() ?? false) {
              final personalInfoModel = getPersonalInfo;
              final authProvider = context.read<AuthProvider>();
              authProvider.storePatientPersonalInfo(personalInfoModel);
            }

          },
          child: const Text(
            'Continue',
            style: TextStyle(fontSize: 16),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 74),
                const Text(
                  "Personal Details",
                  style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w600,
                      color: Colors.black),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Tell us a bit about yourself',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color.fromRGBO(92, 93, 103, 1)),
                ),
                const SizedBox(height: 42),
                _buildDropDown(
                  headerText: '  Assessment is for?',
                  initialSelection: 'Myself',
                  onSelected: (value) {
                    setState(() {
                      isAssessmentForChild = value != 'Myself';
                    });
                  },
                  dropdownItems: [
                    const DropdownMenuEntry(
                      label: 'Myself',
                      value: 'Myself',
                    ),
                    const DropdownMenuEntry(
                      label: 'For my child',
                      value: 'For my child',
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                if (isAssessmentForChild)
                  _buildChildForm()
                else
                  _buildAdultForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAdultForm() {
    return Column(
      children: [
        _buildTextField(
          fieldName: 'adultName',
          label: 'Full Name',
          controller: adultNameController,
          hintText: 'What should we call you?',
          keyboardType: TextInputType.name,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your name';
            }
            if (value.length < 3) {
              return 'Name must be at least 3 characters';
            }
            return null;
          },
        ),
        const SizedBox(height: 20),
        _buildTextField(
          fieldName: 'adultPhone',
          label: 'Phone Number',
          controller: phoneController,
          hintText: '+91 12345-67890',
          keyboardType: TextInputType.phone,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your phone number';
            }

            if (!RegExp(r'^\+?[0-9]{10,15}$')
                .hasMatch(value.replaceAll(RegExp(r'\s+'), ''))) {
              return 'Please enter a valid phone number';
            }
            return null;
          },
        ),
        const SizedBox(height: 20),
        _buildTextField(
          fieldName: 'adultAge',
          label: 'Age',
          controller: adultAgeController,
          hintText: 'Your Age',
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your age';
            }
            final age = int.tryParse(value);
            if (age == null || age <= 0) {
              return 'Please enter a valid age';
            }
            return null;
          },
        ),
        const SizedBox(height: 20),
        _buildDropDown(
            headerText: '  Gender',
            dropdownItems: [
              const DropdownMenuEntry(value: 'Male', label: 'Male'),
              const DropdownMenuEntry(value: 'Female', label: 'Female'),
              const DropdownMenuEntry(value: 'Others', label: 'Others'),
            ],
            onSelected: (value) {
              setState(() {
                selectedGender = value;
              });
            }),
        const SizedBox(height: 20),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              '  Country',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                  height: 1.25,
                  fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 4),
            GestureDetector(
                onTap: () => showCountryPicker(
                      context: context,
                      onSelect: (value) {
                        setState(() {
                          selectedCountry = value;
                        });
                      },
                    ),
                child: Container(
                  height: 56,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: _validationErrors['country'] != null
                          ? Colors.red
                          : Colors.grey.shade600,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 10),
                      Text(
                        selectedCountry?.name ?? '',
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                        ),
                      ),
                      const Spacer(),
                      Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: Colors.grey.shade600,
                      ),
                      const SizedBox(width: 14),
                    ],
                  ),
                )),
            if (_validationErrors['country'] != null)
              Padding(
                padding: const EdgeInsets.only(left: 12, top: 8),
                child: Text(
                  _validationErrors['country']!,
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildChildForm() {
    return Column(
      children: [
        _buildTextField(
          fieldName: 'childName',
          label: 'Patient Name',
          controller: childNameController,
          hintText: 'What should we call him?',
          keyboardType: TextInputType.name,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter patient name';
            }
            if (value.length < 2) {
              return 'Name must be at least 2 characters';
            }
            return null;
          },
        ),
        const SizedBox(height: 20),
        _buildTextField(
          fieldName: 'childAge',
          label: 'Patient Age',
          controller: childAgeController,
          hintText: 'Patient\'s Age',
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter patient age';
            }
            final age = int.tryParse(value);
            if (age == null || age <= 0) {
              return 'Please enter a valid age';
            }
            return null;
          },
        ),
        const SizedBox(height: 20),
        _buildDropDown(
            headerText: '  Relation with patient',
            initialSelection: '',
            dropdownItems: [
              const DropdownMenuEntry(value: 'Guardian', label: 'Guardian'),
              const DropdownMenuEntry(value: 'Other', label: 'Other'),
            ],
            onSelected: (value) {
              setState(() {
                selectedRelation = value;
              });
            }),
        const SizedBox(height: 20),
        _buildDropDown(
            headerText: '  Patient Gender',
            dropdownItems: [
              const DropdownMenuEntry(value: 'Male', label: 'Male'),
              const DropdownMenuEntry(value: 'Female', label: 'Female'),
              const DropdownMenuEntry(value: 'Others', label: 'Others'),
            ],
            onSelected: (value) {
              setState(() {
                selectedChildGender = value;
              });
            }),
        const SizedBox(height: 20),
        _buildTextField(
          fieldName: 'guardianPhone',
          label: 'Your phone number',
          controller: guardianPhoneController,
          hintText: '+91 12345-67890',
          keyboardType: TextInputType.phone,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your phone number';
            }

            if (!RegExp(r'^\+?[0-9]{10,15}$')
                .hasMatch(value.replaceAll(RegExp(r'\s+'), ''))) {
              return 'Please enter a valid phone number';
            }
            return null;
          },
        ),
        const SizedBox(height: 20),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              '  Country',
              style: TextStyle(fontSize: 14, color: Colors.black),
            ),
            const SizedBox(height: 4),
            GestureDetector(
                onTap: () => showCountryPicker(
                      context: context,
                      onSelect: (value) {
                        setState(() {
                          selectedChildCountry = value;
                          _validationErrors.remove('country');
                        });
                      },
                    ),
                child: Container(
                  height: 56,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: _validationErrors['country'] != null
                          ? Colors.red
                          : Colors.grey.shade600,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 10),
                      Text(
                        selectedChildCountry?.name ?? '',
                        style: const TextStyle(fontSize: 15),
                      ),
                      const Spacer(),
                      Icon(Icons.keyboard_arrow_down_rounded,
                          color: Colors.grey.shade600),
                      const SizedBox(width: 14),
                    ],
                  ),
                )),
            if (_validationErrors['country'] != null)
              Padding(
                padding: const EdgeInsets.only(left: 12, top: 8),
                child: Text(
                  _validationErrors['country']!,
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildTextField({
    required String fieldName,
    required String label,
    required TextEditingController controller,
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          '  $label',
          style: const TextStyle(
              color: Colors.black,
              fontSize: 12,
              height: 1.25,
              fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 4),
        TextFormField(
          keyboardType: keyboardType,
          controller: controller,
          validator: validator,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          decoration: InputDecoration(
            hintText: hintText,
            fillColor: Colors.blue,
            hintStyle: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 16,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade600)),
            errorStyle: const TextStyle(color: Colors.red),
          ),
        ),
      ],
    );
  }

  Column _buildDropDown({
    required String headerText,
    required List<DropdownMenuEntry> dropdownItems,
    void Function(dynamic)? onSelected,
    dynamic initialSelection,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          headerText,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 12,
            height: 1.25,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        DropdownMenu(
          onSelected: onSelected,
          initialSelection: initialSelection,
          trailingIcon: Icon(
            Icons.keyboard_arrow_down_rounded,
            color: Colors.grey.shade600,
          ),
          expandedInsets: const EdgeInsets.all(0),
          dropdownMenuEntries: dropdownItems,
        ),
      ],
    );
  }
}
