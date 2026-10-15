import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/auth_provider.dart';
import '../../domain/entities/auth_entity.dart';
import '../../../../app/router/app_router.dart';
import '../../../../app/theme/app_spacing.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage>
    with SingleTickerProviderStateMixin {
  final _phoneController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  final List<TextEditingController> _otpControllers =
      List.generate(4, (_) => TextEditingController());
  final List<FocusNode> _otpFocusNodes =
      List.generate(4, (_) => FocusNode());

  final _formKey = GlobalKey<FormState>();
  late final AnimationController _animCtrl;
  late final Animation<double> _fadeAnim;
  late final Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnim = CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.12),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut));
    _animCtrl.forward();
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    _phoneController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    for (final c in _otpControllers) {
      c.dispose();
    }
    for (final f in _otpFocusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  void _clearOtpFields() {
    for (final c in _otpControllers) {
      c.clear();
    }
  }

  String _getOtpCode() =>
      _otpControllers.map((c) => c.text).join();

  Future<void> _onSendOtp() async {
    final phone = _phoneController.text.trim();
    if (phone.isEmpty) return;
    _clearOtpFields();
    final ok = await ref.read(authProvider.notifier).sendOtp(phone);
    if (ok) {
      _animCtrl
        ..reset()
        ..forward();
    }
  }

  Future<void> _onVerifyOtp() async {
    final otp = _getOtpCode();
    if (otp.length < 4) return;
    final success = await ref.read(authProvider.notifier).verifyOtp(otp);
    if (success && mounted) {
      context.go(AppRoutes.dashboard);
    }
  }

  Future<void> _onAdminLogin() async {
    if (!_formKey.currentState!.validate()) return;
    final success = await ref.read(authProvider.notifier).adminLogin(
          username: _usernameController.text.trim(),
          password: _passwordController.text,
        );
    if (success && mounted) {
      context.go(AppRoutes.dashboard);
    }
  }

  String _formatTimer(int seconds) {
    final m = seconds ~/ 60;
    final s = (seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final authState = ref.watch(authProvider);
    final errorMsg = authState.failure?.message;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Stack(
        children: [
          // ── Background Ambient Blobs ──────────────────────
          Positioned(
            top: -80,
            left: -60,
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: cs.primary.withAlpha(isDark ? 30 : 22),
              ),
            ),
          ),
          Positioned(
            top: 60,
            right: -80,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: cs.secondary.withAlpha(isDark ? 20 : 18),
              ),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: FadeTransition(
                opacity: _fadeAnim,
                child: SlideTransition(
                  position: _slideAnim,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: AppSpacing.xxl),

                      // ── Logo Icon ─────────────────────────
                      Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [cs.primary, cs.secondary],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                          boxShadow: [
                            BoxShadow(
                              color: cs.primary.withAlpha(80),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.task_alt_rounded,
                          color: cs.onPrimary,
                          size: AppSpacing.iconLg,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),

                      // ── Brand Name ────────────────────────
                      ShaderMask(
                        shaderCallback: (bounds) => LinearGradient(
                          colors: [cs.primary, cs.secondary],
                        ).createShader(bounds),
                        child: Text(
                          'TaskBnB',
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: cs.onPrimary,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        authState.isOtpSent
                            ? 'Enter the OTP sent to your number'
                            : 'Sign in to your account',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: cs.onSurface.withAlpha(160),
                          fontWeight: FontWeight.w400,
                        ),
                      ),

                      const SizedBox(height: AppSpacing.xl),

                      // ── Role Tabs ─────────────────────────
                      if (!authState.isOtpSent) ...[
                        _RoleSelectorBar(
                          selected: authState.selectedRole,
                          onSelect: (r) =>
                              ref.read(authProvider.notifier).setRole(r),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                      ],

                      // ── Body ──────────────────────────────
                      if (authState.isOtpSent)
                        _buildOtpView(authState, theme, cs, errorMsg)
                      else if (authState.selectedRole == AuthRole.admin)
                        _buildAdminForm(authState, theme, cs, errorMsg)
                      else
                        _buildPhoneForm(authState, theme, cs, errorMsg),

                      const SizedBox(height: AppSpacing.xxl),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Phone Form ─────────────────────────────────────────────────────────────
  Widget _buildPhoneForm(
    AuthState authState,
    ThemeData theme,
    ColorScheme cs,
    String? errorMsg,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _InputCard(
          child: TextField(
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            maxLength: 10,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w500,
              letterSpacing: 1.2,
            ),
            decoration: InputDecoration(
              counterText: '',
              border: InputBorder.none,
              hintText: 'Enter 10-digit mobile number',
              hintStyle: theme.textTheme.bodyMedium?.copyWith(
                color: cs.onSurface.withAlpha(100),
              ),
              prefixIcon: Icon(Icons.phone_outlined, color: cs.primary, size: AppSpacing.iconMd),
            ),
          ),
        ),

        // ── Inline Error ──────────────────────────────────
        if (errorMsg != null) ...[
          const SizedBox(height: AppSpacing.sm),
          _InlineError(message: errorMsg),
        ],

        const SizedBox(height: AppSpacing.lg),

        _GradientButton(
          onPressed: authState.isLoading ? null : _onSendOtp,
          isLoading: authState.isLoading,
          label: 'Send OTP',
        ),
      ],
    );
  }

  // ── OTP View ──────────────────────────────────────────────────────────────
  Widget _buildOtpView(
    AuthState authState,
    ThemeData theme,
    ColorScheme cs,
    String? errorMsg,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Phone indicator chip
        Center(
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            decoration: BoxDecoration(
              color: cs.primary.withAlpha(20),
              borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
              border: Border.all(color: cs.primary.withAlpha(60)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.phone_outlined, size: AppSpacing.iconSm, color: cs.primary),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  '+91 ${authState.phone}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: cs.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                GestureDetector(
                  onTap: () => ref.read(authProvider.notifier).resetOtp(),
                  child: Text(
                    'Change',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: cs.secondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),

        // OTP Boxes
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(4, (i) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
              child: _OtpBox(
                controller: _otpControllers[i],
                focusNode: _otpFocusNodes[i],
                textStyle: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                onChanged: (val) {
                  if (val.isNotEmpty && i < 3) {
                    _otpFocusNodes[i + 1].requestFocus();
                  } else if (val.isEmpty && i > 0) {
                    _otpFocusNodes[i - 1].requestFocus();
                  }
                  if (_getOtpCode().length == 4) _onVerifyOtp();
                },
              ),
            );
          }),
        ),

        // ── Inline Error ──────────────────────────────────
        if (errorMsg != null) ...[
          const SizedBox(height: AppSpacing.sm),
          _InlineError(message: errorMsg),
        ],

        const SizedBox(height: AppSpacing.lg),

        // Timer and Resend
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(Icons.timer_outlined, size: AppSpacing.iconSm, color: cs.onSurface.withAlpha(120)),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  _formatTimer(authState.resendCountdown),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: cs.onSurface.withAlpha(120),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            GestureDetector(
              onTap: authState.resendCountdown == 0
                  ? () => ref.read(authProvider.notifier).resendOtp()
                  : null,
              child: Text(
                'Resend OTP',
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: authState.resendCountdown == 0
                      ? cs.primary
                      : cs.onSurface.withAlpha(80),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: AppSpacing.lg),

        _GradientButton(
          onPressed: authState.isLoading ? null : _onVerifyOtp,
          isLoading: authState.isLoading,
          label: 'Verify OTP',
        ),
      ],
    );
  }

  // ── Admin Form ────────────────────────────────────────────────────────────
  Widget _buildAdminForm(
    AuthState authState,
    ThemeData theme,
    ColorScheme cs,
    String? errorMsg,
  ) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _InputCard(
            child: TextFormField(
              controller: _usernameController,
              style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Username',
                hintStyle: theme.textTheme.bodyMedium?.copyWith(
                  color: cs.onSurface.withAlpha(100),
                ),
                prefixIcon: Icon(Icons.person_outline, color: cs.primary, size: AppSpacing.iconMd),
              ),
              validator: (v) => (v == null || v.isEmpty) ? 'Please enter your username' : null,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          _InputCard(
            child: TextFormField(
              controller: _passwordController,
              obscureText: _obscurePassword,
              style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Password',
                hintStyle: theme.textTheme.bodyMedium?.copyWith(
                  color: cs.onSurface.withAlpha(100),
                ),
                prefixIcon: Icon(Icons.lock_outline, color: cs.primary, size: AppSpacing.iconMd),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                    color: cs.onSurface.withAlpha(140),
                    size: AppSpacing.iconSm,
                  ),
                  onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                ),
              ),
              validator: (v) => (v == null || v.isEmpty) ? 'Please enter your password' : null,
            ),
          ),

          // ── Inline Error ────────────────────────────────
          if (errorMsg != null) ...[
            const SizedBox(height: AppSpacing.sm),
            _InlineError(message: errorMsg),
          ],

          const SizedBox(height: AppSpacing.lg),
          _GradientButton(
            onPressed: authState.isLoading ? null : _onAdminLogin,
            isLoading: authState.isLoading,
            label: 'Sign In as Admin',
          ),
        ],
      ),
    );
  }
}

// ── Role Selector ─────────────────────────────────────────────────────────────
class _RoleSelectorBar extends StatelessWidget {
  final AuthRole selected;
  final ValueChanged<AuthRole> onSelect;

  const _RoleSelectorBar({
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final roles = [
      (AuthRole.client, Icons.person_outline, 'Client'),
      (AuthRole.team, Icons.group_outlined, 'Team'),
      (AuthRole.admin, Icons.admin_panel_settings_outlined, 'Admin'),
    ];

    return Container(
      padding: const EdgeInsets.all(AppSpacing.xs),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(color: cs.outline),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(isDark ? 20 : 12),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: roles.map((r) {
          final (role, icon, label) = r;
          final isActive = selected == role;
          return Expanded(
            child: GestureDetector(
              onTap: () => onSelect(role),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOut,
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  gradient: isActive
                      ? LinearGradient(
                          colors: [cs.primary, cs.secondary],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                      : null,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  boxShadow: isActive
                      ? [
                          BoxShadow(
                            color: cs.primary.withAlpha(80),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : null,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      icon,
                      size: AppSpacing.iconSm + 2,
                      color: isActive
                          ? cs.onPrimary
                          : cs.onSurface.withAlpha(140),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      label,
                      style: theme.textTheme.labelMedium?.copyWith(
                        fontWeight:
                            isActive ? FontWeight.w700 : FontWeight.w500,
                        color: isActive
                            ? cs.onPrimary
                            : cs.onSurface.withAlpha(140),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ── Input Card ────────────────────────────────────────────────────────────────
class _InputCard extends StatelessWidget {
  final Widget child;

  const _InputCard({required this.child});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(color: cs.outline),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(isDark ? 20 : 10),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: child,
    );
  }
}

// ── Inline Error ──────────────────────────────────────────────────────────────
class _InlineError extends StatelessWidget {
  final String message;

  const _InlineError({required this.message});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final errorColor = cs.error;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.error_outline, size: AppSpacing.iconSm, color: errorColor),
        const SizedBox(width: AppSpacing.xs),
        Expanded(
          child: Text(
            message,
            style: theme.textTheme.bodySmall?.copyWith(
              color: errorColor,
              fontWeight: FontWeight.w500,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}

// ── Gradient Button ───────────────────────────────────────────────────────────
class _GradientButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isLoading;
  final String label;

  const _GradientButton({
    required this.onPressed,
    required this.isLoading,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return GestureDetector(
      onTap: onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: AppSpacing.buttonHeightLg,
        decoration: BoxDecoration(
          gradient: onPressed == null
              ? LinearGradient(
                  colors: [
                    cs.primary.withAlpha(100),
                    cs.secondary.withAlpha(80),
                  ],
                )
              : LinearGradient(
                  colors: [cs.primary, cs.secondary],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          boxShadow: onPressed != null
              ? [
                  BoxShadow(
                    color: cs.primary.withAlpha(90),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ]
              : null,
        ),
        child: Center(
          child: isLoading
              ? SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    color: cs.onPrimary,
                    strokeWidth: 2.5,
                  ),
                )
              : Text(
                  label,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: cs.onPrimary,
                    letterSpacing: 0.4,
                  ),
                ),
        ),
      ),
    );
  }
}

// ── OTP Box ───────────────────────────────────────────────────────────────────
class _OtpBox extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;
  final TextStyle? textStyle;

  const _OtpBox({
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return SizedBox(
      width: 60,
      height: 64,
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        style: textStyle?.copyWith(fontSize: 22, fontWeight: FontWeight.bold),
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        decoration: InputDecoration(
          counterText: '',
          filled: true,
          fillColor: cs.surface,
          contentPadding: EdgeInsets.zero,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            borderSide: BorderSide(
              color: cs.outline,
              width: 1.5,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            borderSide: BorderSide(color: cs.primary, width: 2),
          ),
        ),
        onChanged: onChanged,
      ),
    );
  }
}
