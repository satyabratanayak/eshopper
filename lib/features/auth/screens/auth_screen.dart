import 'package:eshopper/common/widgets/custom_button.dart';
import 'package:eshopper/common/widgets/custom_textfield.dart';
import 'package:eshopper/constants/global_variables.dart';
import 'package:eshopper/constants/string_constants.dart';
import 'package:eshopper/features/auth/services/auth_service.dart';
import 'package:flutter/material.dart';

enum Auth { signin, signup }

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
  final AuthService authService = AuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  bool isLoading = false;
  bool isSignupEnabled = false;
  bool isSigninEnabled = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
    _emailController.addListener(_updateButtonState);
    _passwordController.addListener(_updateButtonState);
    _nameController.addListener(_updateButtonState);
  }

  void _updateButtonState() {
    final isNameFilled = _nameController.text.isNotEmpty;
    final isEmailFilled = _emailController.text.isNotEmpty;
    final isPasswordFilled = _passwordController.text.isNotEmpty;

    setState(() {
      isSignupEnabled = isNameFilled && isEmailFilled && isPasswordFilled;
      isSigninEnabled = isEmailFilled && isPasswordFilled;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _tabController.dispose();
  }

  void signUpUser() async {
    setState(() => isLoading = true);
    authService.signUpUser(
      context: context,
      email: _emailController.text,
      password: _passwordController.text,
      name: _nameController.text,
    );
    setState(() => isLoading = false);
  }

  void signInUser() async {
    setState(() => isLoading = true);
    authService.signInUser(
      context: context,
      email: _emailController.text,
      password: _passwordController.text,
    );
    setState(() => isLoading = false);
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
                Container(
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
                          duration: const Duration(milliseconds: 1),
                          child: (_tabController.index == 0)
                              ? _buildSignUp()
                              : _buildSignIn(),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Form _buildSignUp() {
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
          CustomButton(
            text: isLoading ? StringConstants.loading : StringConstants.signUp,
            color: GlobalVariables.secondaryColor,
            onTap: () {
              if (_signUpFormKey.currentState!.validate()) {
                signUpUser();
              }
            },
            isEnabled: isSignupEnabled && !isLoading,
          ),
        ],
      ),
    );
  }

  Form _buildSignIn() {
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
            text: isLoading ? StringConstants.loading : StringConstants.signIn,
            color: GlobalVariables.secondaryColor,
            onTap: () {
              if (_signInFormKey.currentState!.validate()) {
                signInUser();
              }
            },
            isEnabled: isSigninEnabled && !isLoading,
          ),
        ],
      ),
    );
  }
}
