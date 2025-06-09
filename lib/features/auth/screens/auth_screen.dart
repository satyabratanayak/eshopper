import 'package:eshopper/common/widgets/custom_button.dart';
import 'package:eshopper/common/widgets/custom_textfield.dart';
import 'package:eshopper/constants/global_variables.dart';
import 'package:eshopper/constants/string_constants.dart';
import 'package:eshopper/features/auth/services/auth_service.dart';
import 'package:flutter/material.dart';

enum AuthTab { signUp, signIn }

class AuthScreen extends StatefulWidget {
  static const String routeName = '/auth-screen';
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final _signUpFormKey = GlobalKey<FormState>();
  final _signInFormKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _otpController = TextEditingController();

  final AuthService _authService = AuthService();

  bool _isLoading = false;
  bool _isOtpValidated = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _otpController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  bool get _isSignupValid =>
      _nameController.text.isNotEmpty &&
      _emailController.text.isNotEmpty &&
      _passwordController.text.isNotEmpty;

  bool get _isSigninValid =>
      _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty;

  Future<void> _getOtp() async {
    setState(() => _isLoading = true);
    _authService.getOtp(context, email: _emailController.text);
    setState(() {
      _isOtpValidated = true;
      _isLoading = false;
    });
  }

  Future<void> _verifyOtp() async {
    setState(() => _isLoading = true);
    bool isVerified = await _authService.verifyOtp(
      context,
      email: _emailController.text,
      otp: _otpController.text,
    );
    setState(() => _isLoading = false);
    if (isVerified) {
      _signUpUser();
      _tabController.animateTo(1);
    }
  }

  Future<void> _signUpUser() async {
    setState(() => _isLoading = true);
    _authService.signUpUser(
      context: context,
      email: _emailController.text,
      password: _passwordController.text,
      name: _nameController.text,
    );
    setState(() => _isLoading = false);
  }

  Future<void> _signInUser() async {
    setState(() => _isLoading = true);
    _authService.signInUser(
      context: context,
      email: _emailController.text,
      password: _passwordController.text,
    );
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: GlobalVariables.greyBackgroundCOlor,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  StringConstants.welcome,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 20),
                _buildAuthCard(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAuthCard() {
    return Container(
      decoration: BoxDecoration(
        color: GlobalVariables.backgroundColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TabBar(
            controller: _tabController,
            labelColor: GlobalVariables.secondaryColor,
            unselectedLabelColor: Colors.black,
            indicatorColor: GlobalVariables.secondaryColor,
            dividerColor: Colors.grey[200],
            tabs: const [
              Tab(text: StringConstants.signUp),
              Tab(text: StringConstants.signIn),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: AnimatedSize(
              duration: const Duration(milliseconds: 300),
              child: _tabController.index == 0
                  ? _buildSignUpForm()
                  : _buildSignInForm(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSignUpForm() {
    return Form(
      key: _signUpFormKey,
      child: Column(
        children: [
          CustomTextField(
            controller: _nameController,
            hintText: StringConstants.name,
          ),
          const SizedBox(height: 10),
          CustomTextField(
            controller: _emailController,
            hintText: StringConstants.email,
            textInputType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 10),
          CustomTextField(
            controller: _passwordController,
            hintText: StringConstants.password,
            obscureText: true,
          ),
          const SizedBox(height: 20),
          if (_isOtpValidated)
            Column(
              children: [
                CustomTextField(
                  controller: _otpController,
                  hintText: StringConstants.enterOtptext,
                  textInputType: TextInputType.number,
                ),
                const SizedBox(height: 20),
                CustomButton(
                  text: _isLoading
                      ? StringConstants.loading
                      : StringConstants.verifyOtp,
                  color: GlobalVariables.secondaryColor,
                  onTap: _verifyOtp,
                  isEnabled: !_isLoading && _otpController.text.isNotEmpty,
                ),
              ],
            )
          else
            CustomButton(
              text: _isLoading
                  ? StringConstants.loading
                  : StringConstants.getOtptext,
              color: GlobalVariables.secondaryColor,
              onTap: () {
                if (_signUpFormKey.currentState!.validate()) {
                  _getOtp();
                }
              },
              isEnabled: _isSignupValid && !_isLoading,
            ),
        ],
      ),
    );
  }

  Widget _buildSignInForm() {
    return Form(
      key: _signInFormKey,
      child: Column(
        children: [
          CustomTextField(
            controller: _emailController,
            hintText: StringConstants.email,
            textInputType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 10),
          CustomTextField(
            controller: _passwordController,
            hintText: StringConstants.password,
            obscureText: true,
          ),
          const SizedBox(height: 20),
          CustomButton(
            text: _isLoading ? StringConstants.loading : StringConstants.signIn,
            color: GlobalVariables.secondaryColor,
            onTap: () {
              if (_signInFormKey.currentState!.validate()) {
                _signInUser();
              }
            },
            isEnabled: _isSigninValid && !_isLoading,
          ),
        ],
      ),
    );
  }
}
