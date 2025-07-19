import 'dart:convert';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:dima_application/generated/flutter-models/ModelProvider.dart';
import 'package:dima_application/services/nutritionist_profile_service.dart';
import 'package:dima_application/Views/UserTypeRouter/user_type_router.dart';
import 'package:flutter/material.dart';

class EnterNutritionistProfile extends StatefulWidget {
  const EnterNutritionistProfile({super.key});

  @override
  State<EnterNutritionistProfile> createState() => _EnterNutritionistProfileState();
}

class _EnterNutritionistProfileState extends State<EnterNutritionistProfile> {
  final _formKey = GlobalKey<FormState>();
  final _givenNameController = TextEditingController();
  final _familyNameController = TextEditingController();
  final _specializationController = TextEditingController();
  final _bioController = TextEditingController();
  final _profilePictureUrlController = TextEditingController();
  bool _isAvailable = true;
  bool _isLoading = false;
  final _profileService = NutritionistProfileService();

  @override
  void initState() {
    super.initState();
    _loadExistingProfile();
  }

  @override
  void dispose() {
    _givenNameController.dispose();
    _familyNameController.dispose();
    _specializationController.dispose();
    _bioController.dispose();
    _profilePictureUrlController.dispose();
    super.dispose();
  }

  Future<void> _loadExistingProfile() async {
    try {
      final profile = await _profileService.getMyProfile();
      
      if (profile != null) {
        setState(() {
          _givenNameController.text = profile.givenName ?? '';
          _familyNameController.text = profile.familyName ?? '';
          _specializationController.text = profile.specialization ?? '';
          _bioController.text = profile.bio ?? '';
          _profilePictureUrlController.text = profile.profilePictureUrl ?? '';
          _isAvailable = profile.isAvailable ?? true;
        });
      }
    } catch (e) {
      safePrint('Error loading nutritionist profile: $e');
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final updatedProfile = await _profileService.updateMyProfile(
        givenName: _givenNameController.text.trim(),
        familyName: _familyNameController.text.trim(),
        specialization: _specializationController.text.trim(),
        bio: _bioController.text.trim(),
        profilePictureUrl: _profilePictureUrlController.text.trim().isEmpty 
            ? null 
            : _profilePictureUrlController.text.trim(),
        isAvailable: _isAvailable,
      );

      if (updatedProfile != null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Profile saved successfully!'),
              backgroundColor: Colors.green,
            ),
          );
          
                   // Navigate to the main nutritionist screen by rebuilding the router
         Navigator.of(context).pushReplacement(
           MaterialPageRoute(
             builder: (context) => const UserTypeRouter(),
           ),
         );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Error saving profile. Please try again.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving profile: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Complete Your Profile'),
        automaticallyImplyLeading: false, // Prevent back navigation
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(
                Icons.medical_services,
                size: 80,
                color: Colors.blue,
              ),
              const SizedBox(height: 16),
              const Text(
                'Welcome! Please complete your nutritionist profile',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              
              // Given Name
              TextFormField(
                controller: _givenNameController,
                decoration: const InputDecoration(
                  labelText: 'First Name',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your first name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              // Family Name
              TextFormField(
                controller: _familyNameController,
                decoration: const InputDecoration(
                  labelText: 'Last Name',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your last name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              // Specialization
              TextFormField(
                controller: _specializationController,
                decoration: const InputDecoration(
                  labelText: 'Specialization',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.work),
                  hintText: 'e.g., Sports Nutrition, Weight Management',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your specialization';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              // Bio
              TextFormField(
                controller: _bioController,
                decoration: const InputDecoration(
                  labelText: 'Bio',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.description),
                  hintText: 'Tell clients about your expertise and approach',
                ),
                maxLines: 4,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your bio';
                  }
                  if (value.trim().length < 50) {
                    return 'Bio should be at least 50 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              // Profile Picture URL
              TextFormField(
                controller: _profilePictureUrlController,
                decoration: const InputDecoration(
                  labelText: 'Profile Picture URL (Optional)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.image),
                  hintText: 'https://example.com/photo.jpg',
                ),
              ),
              const SizedBox(height: 16),
              
              // Availability Toggle
              SwitchListTile(
                title: const Text('Available for new clients'),
                subtitle: const Text('Clients can request your services'),
                value: _isAvailable,
                onChanged: (value) {
                  setState(() {
                    _isAvailable = value;
                  });
                },
                secondary: const Icon(Icons.visibility),
              ),
              const SizedBox(height: 24),
              
              // Save Button
              ElevatedButton(
                onPressed: _isLoading ? null : _saveProfile,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text(
                        'Save Profile',
                        style: TextStyle(fontSize: 16),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 