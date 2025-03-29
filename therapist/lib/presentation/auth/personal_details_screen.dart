import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/common/chips_input_field.dart';
import '../../core/entities/auth_entities/therapist_personal_info_entity.dart';
import '../../provider/auth_provider.dart';
import '../../provider/therapist_provider.dart';
import '../home/home_screen.dart';

class PersonalDetailsScreen extends StatefulWidget {
  const PersonalDetailsScreen({super.key});

  @override
  State<PersonalDetailsScreen> createState() => _PersonalDetailsScreenState();
}

class _PersonalDetailsScreenState extends State<PersonalDetailsScreen> {
  final nameController = TextEditingController();
  final ageController = TextEditingController();
  final licenseController = TextEditingController();
  String selectedGender = '';
  List<String> selectedTherapies = [];

  // Form validation
  final _formKey = GlobalKey<FormState>();

  // Selected values
  int? selectedProfessionId;
  String? selectedProfessionName;
  String? selectedRegulatoryBody;
  String? selectedSpecialization;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Load professions when screen is first shown
      Provider.of<TherapistDataProvider>(context, listen: false).fetchProfessions();
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    ageController.dispose();
    licenseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Use the providers
    final therapistDataProvider = Provider.of<TherapistDataProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Personal Details"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
        child: FilledButton(
          onPressed: authProvider.isLoading
              ? null
              : () async {
                  if (_formKey.currentState?.validate() ?? false) {
                    if (selectedProfessionId == null ||
                        selectedGender.isEmpty ||
                        selectedRegulatoryBody == null ||
                        selectedSpecialization == null ||
                        selectedTherapies.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please fill in all fields'),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }

                    // Create therapist personal info entity
                    final personalInfo = TherapistPersonalInfoEntity(
                      name: nameController.text,
                      age: int.parse(ageController.text),
                      gender: selectedGender,
                      professionId: selectedProfessionId!,
                      professionName: selectedProfessionName!,
                      regulatoryBody: selectedRegulatoryBody!,
                      licenseNumber: licenseController.text,
                      specialization: selectedSpecialization!,
                      therapies: selectedTherapies,
                      id: authProvider.userId!,
                    );

                    // Save to Supabase
                    final success = await authProvider.storePersonalInfo(personalInfo);

                    if (success) {
                      // Navigate to home screen
                      if (mounted) {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => const HomeScreen(),
                          ),
                        );
                      }
                    } else {
                      // Show error message
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(authProvider.errorMessage),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
                  }
                },
          child: authProvider.isLoading
              ? const CircularProgressIndicator(color: Colors.white)
              : const Text(
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
                const SizedBox(height: 20),
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
                _buildTextField(
                  label: 'Full Name',
                  controller: nameController,
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
                  label: 'Age',
                  controller: ageController,
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
                  dropdownItems: const [
                    DropdownMenuEntry(value: 'Male', label: 'Male'),
                    DropdownMenuEntry(value: 'Female', label: 'Female'),
                    DropdownMenuEntry(value: 'Others', label: 'Others'),
                  ],
                  onSelected: (value) {
                    setState(() {
                      selectedGender = value;
                    });
                  },
                ),
                const SizedBox(height: 20),
                
                // Profession dropdown
                _buildDropDown(
                  headerText: '  Profession',
                  dropdownItems: therapistDataProvider.professionDropdownItems,
                  onSelected: (value) async {
                    setState(() {
                      selectedProfessionId = value;
                      selectedProfessionName = therapistDataProvider.professions
                          .firstWhere((p) => p.id == value)
                          .name;
                      
                      // Reset dependent fields
                      selectedRegulatoryBody = null;
                      selectedSpecialization = null;
                      selectedTherapies = [];
                    });
                    
                    // Load related data
                    await therapistDataProvider.setSelectedProfession(
                      value, 
                      selectedProfessionName!
                    );
                  },
                ),
                const SizedBox(height: 20),
                
                // Regulatory Body dropdown (only shown when profession is selected)
                if (selectedProfessionId != null)
                  _buildDropDown(
                    headerText: '  Regulatory Body',
                    dropdownItems: therapistDataProvider.regulatoryBodyDropdownItems,
                    onSelected: (value) {
                      setState(() {
                        selectedRegulatoryBody = value;
                      });
                      therapistDataProvider.setSelectedRegulatoryBody(value);
                    },
                  ),
                  
                if (selectedProfessionId != null)
                  const SizedBox(height: 20),
                
                // Specialization dropdown (only shown when profession is selected)
                if (selectedProfessionId != null)
                  _buildDropDown(
                    headerText: '  Specialization',
                    dropdownItems: therapistDataProvider.specializationDropdownItems,
                    onSelected: (value) {
                      setState(() {
                        selectedSpecialization = value;
                      });
                      therapistDataProvider.setSelectedSpecialization(value);
                    },
                  ),
                  
                if (selectedProfessionId != null)
                  const SizedBox(height: 20),
                
                // License number field
                _buildTextField(
                  label: 'Registration/License Number',
                  controller: licenseController,
                  hintText: 'Enter your registration/license number',
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your registration/license number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                
                // Therapies choice chips (only shown when profession is selected)
                if (selectedProfessionId != null)
                  OfferedTherapiesChoiceChipInput(
                    initialSelected: const [],
                    therapies: therapistDataProvider.therapies,
                    onSelectedTherapiesChanged: (value) {
                      setState(() {
                        selectedTherapies = value;
                      });
                    },
                  ),
                  
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
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
  Column _buildDropDown<T>({
    required String headerText,
    required List<DropdownMenuEntry<T>> dropdownItems,
    void Function(T)? onSelected,
    T? initialSelection,
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
        DropdownMenu<T>(
          onSelected: onSelected != null 
              ? (T? value) {
                  if (value != null) {
                    onSelected(value);
                  }
                }
              : null,
          initialSelection: initialSelection,
          trailingIcon: Icon(
            Icons.keyboard_arrow_down_rounded,
            color: Colors.grey.shade600,
          ),
          expandedInsets: const EdgeInsets.all(0),
          dropdownMenuEntries: dropdownItems,
          enableFilter: dropdownItems.length > 5,
          enableSearch: dropdownItems.length > 10,
          width: MediaQuery.of(context).size.width - 40, // Full width minus padding
        ),
      ],
    );
  }
}