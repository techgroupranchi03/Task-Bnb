import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../domain/entities/property_entity.dart';
import '../providers/add_property_provider.dart';
import '../providers/properties_provider.dart';

class AddEditPropertiesPage extends ConsumerStatefulWidget {
  final String? propertyId;
  final PropertyEntity? editingProperty;

  const AddEditPropertiesPage({
    super.key,
    this.propertyId,
    this.editingProperty,
  });

  @override
  ConsumerState<AddEditPropertiesPage> createState() =>
      _AddEditPropertiesPageState();
}

class _AddEditPropertiesPageState extends ConsumerState<AddEditPropertiesPage> {
  late final TextEditingController _nameController;
  late final TextEditingController _googleMapLinkController;
  late final TextEditingController _addressController;
  late final GlobalKey<FormState> _formKey;
  late final ImagePicker _imagePicker;
  File? _selectedImage;
  String? _existingImageUrl; // network image URL for edit mode
  bool _isEditMode = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _googleMapLinkController = TextEditingController();
    _addressController = TextEditingController();
    _formKey = GlobalKey<FormState>();
    _imagePicker = ImagePicker();

    // Load existing property data if in edit mode
    _isEditMode = widget.propertyId != null && widget.editingProperty != null;
    if (_isEditMode && widget.editingProperty != null) {
      _loadPropertyData(widget.editingProperty!);
    }
  }

  void _loadPropertyData(PropertyEntity property) {
    _nameController.text = property.name;
    _googleMapLinkController.text = property.googleMapLink ?? '';
    _addressController.text = property.address ?? '';
    // Store the existing network image url so it can be displayed in edit mode
    _existingImageUrl = property.propertyImageUrl;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _googleMapLinkController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );
      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
        });
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error picking image: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  Widget _buildEmptyPlaceholder(ColorScheme cs, ThemeData theme) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.add_photo_alternate_outlined,
          size: 48,
          color: cs.primary.withAlpha(150),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'Tap to upload image',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: cs.primary.withAlpha(180),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  void _submitForm() {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedImage == null && !_isEditMode) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select an image'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    if (_isEditMode) {
      // Update property
      ref
          .read(addPropertyProvider.notifier)
          .updateProperty(
            propertyId: widget.propertyId!,
            name: _nameController.text.trim(),
            address: _addressController.text.trim(),
            googleMapLink: _googleMapLinkController.text.trim(),
            image: _selectedImage,
          );
    } else {
      // Create new property
      ref
          .read(addPropertyProvider.notifier)
          .createProperty(
            name: _nameController.text.trim(),
            address: _addressController.text.trim(),
            googleMapLink: _googleMapLinkController.text.trim(),
            image: _selectedImage,
          );
    }
  }

  void _onSuccess() {
    ref.invalidate(propertiesProvider);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Property created successfully!'),
        backgroundColor: AppColors.success,
        duration: Duration(seconds: 2),
      ),
    );
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        Navigator.of(context).pop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final state = ref.watch(addPropertyProvider);

    ref.listen(addPropertyProvider, (prev, next) {
      if (next.isSuccess && next.createdProperty != null) {
        _onSuccess();
      }
      if (next.failure != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.failure!.message),
            backgroundColor: AppColors.error,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    });

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: theme.appBarTheme.backgroundColor,
        title: Text(
          _isEditMode ? 'Edit Property' : 'Add Property',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: cs.onSurface,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded, color: cs.onSurface),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.screenPaddingH,
          vertical: AppSpacing.screenPaddingV,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Section: Basic Details ──────────────────────────────
              Text(
                'Property Details',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: cs.onSurface,
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              // ── Property Name ──────────────────────────────────────────
              AppTextField(
                label: 'Property Name',
                hint: 'Enter property name',
                controller: _nameController,
                prefixIcon: Icons.home_work_rounded,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Property name is required';
                  }
                  if (value.trim().length < 3) {
                    return 'Property name must be at least 3 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppSpacing.md),

              // ── Google Map Link ────────────────────────────────────────
              AppTextField(
                label: 'Google Map Link',
                hint: 'https://maps.google.com/...',
                controller: _googleMapLinkController,
                prefixIcon: Icons.map_rounded,
                keyboardType: TextInputType.url,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Google Map link is required';
                  }
                  if (!value.contains('maps.google.com') &&
                      !value.contains('google.com/maps') &&
                      !value.contains('goo.gl')) {
                    return 'Please enter a valid Google Maps link';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppSpacing.md),

              // ── Address ────────────────────────────────────────────
              AppTextField(
                label: 'Address',
                hint: 'Enter property address',
                controller: _addressController,
                // prefixIcon: Icons.location_on_rounded,
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Address is required';
                  }
                  if (value.trim().length < 5) {
                    return 'Address must be at least 5 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppSpacing.xl),

              // ── Image Upload Section ────────────────────────────────
              Text(
                'Property Image',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: cs.onSurface,
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              // ── Image Container with Overlaid Icon Buttons ──────────
              Stack(
                alignment: Alignment.center,
                children: [
                  // Background container — entire area is tappable
                  GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      width: double.infinity,
                      height: 200,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: cs.outline.withAlpha(100),
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                        color: cs.surface.withAlpha(50),
                      ),
                      child: _selectedImage != null
                          // ── Newly picked local file ──────────────
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(
                                AppSpacing.radiusMd - 2,
                              ),
                              child: Image.file(
                                _selectedImage!,
                                fit: BoxFit.cover,
                              ),
                            )
                          : (_existingImageUrl != null && _existingImageUrl!.isNotEmpty)
                              // ── Existing network image (edit mode) ──
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                    AppSpacing.radiusMd - 2,
                                  ),
                                  child: CachedNetworkImage(
                                    imageUrl: _existingImageUrl!,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    placeholder: (context, url) => Container(
                                      color: cs.primary.withAlpha(15),
                                      child: Center(
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: cs.primary,
                                        ),
                                      ),
                                    ),
                                    errorWidget: (context, url, error) => _buildEmptyPlaceholder(cs, theme),
                                  ),
                                )
                              // ── Empty placeholder ─────────────────
                              : _buildEmptyPlaceholder(cs, theme),
                    ),
                  ),

                  // Close/Delete button (top right corner) — local or network image
                  if (_selectedImage != null || (_existingImageUrl != null && _existingImageUrl!.isNotEmpty))
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.error,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.error.withAlpha(100),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                _selectedImage = null;
                                _existingImageUrl = null;
                              });
                            },
                            borderRadius: BorderRadius.circular(20),
                            child: Icon(
                              Icons.close_rounded,
                              size: 22,
                              color: AppColors.white,
                            ),
                          ),
                        ),
                      ),
                    ),

                  // Camera button overlay when an image is already shown
                  if (_selectedImage != null || (_existingImageUrl != null && _existingImageUrl!.isNotEmpty))
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: cs.primary.withAlpha(200),
                        boxShadow: [
                          BoxShadow(
                            color: cs.primary.withAlpha(100),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: _pickImage,
                          borderRadius: BorderRadius.circular(28),
                          child: const Icon(
                            Icons.camera_alt_rounded,
                            size: 26,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: AppSpacing.xl),

              // ── Create/Update Property Button (Gradient) ────────────────
              GradientButton(
                label: _isEditMode ? 'Update Property' : 'Create Property',
                onPressed: state.isLoading ? null : _submitForm,
                isLoading: state.isLoading,
                height: 56,
              ),
              const SizedBox(height: AppSpacing.lg),
            ],
          ),
        ),
      ),
    );
  }
}
