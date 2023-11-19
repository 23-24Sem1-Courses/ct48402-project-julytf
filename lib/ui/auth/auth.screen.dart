import 'package:ct484_project/models/http_exception.dart';
import 'package:ct484_project/ui/auth/auth.manager.dart';
import 'package:ct484_project/ui/auth/components/auth_text_form_field.dart';
import 'package:ct484_project/ui/auth/values/auth.colors.dart';
import 'package:ct484_project/ui/auth/values/auth.constants.dart';
import 'package:ct484_project/ui/auth/values/auth.routes.dart';
import 'package:ct484_project/ui/auth/values/auth.theme.dart';
import 'package:ct484_project/ui/calendar/calendar.screen.dart';
import 'package:ct484_project/ui/shared/dialog_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum AuthMode { signup, login }

class AuthScreen extends StatefulWidget {
  static const routeName = '/auth';
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  AuthMode _authMode = AuthMode.login;
  final Map<String, String> _authData = {
    'email': '',
    'password': '',
  };
  final _isSubmitting = ValueNotifier<bool>(false);

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool isObscure = true;

  Future<void> _submit(BuildContext context) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();

    try {
      if (_authMode == AuthMode.login) {
        // Log user in
        await context.read<AuthManager>().login(
              _authData['email']!,
              _authData['password']!,
            );
      } else {
        // Sign user up
        await context.read<AuthManager>().signup(
              _authData['email']!,
              _authData['password']!,
            );
      }
    } catch (error) {
      if (mounted) {
        showErrorDialog(
            context,
            (error is HttpException)
                ? error.toString()
                : 'Authentication failed');
      }
    }
    if (context.read<AuthManager>().isAuth) {
      Navigator.of(context).pushReplacementNamed(CalendarScreen.routeName);
    }

    _isSubmitting.value = false;
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.login) {
      setState(() {
        _authMode = AuthMode.signup;
      });
    } else {
      setState(() {
        _authMode = AuthMode.login;
      });
    }
    emailController.clear();
    passwordController.clear();
    _formKey.currentState!.save();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Theme(
      data: AuthTheme.themeData,
      child: Scaffold(
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Container(
                  height: size.height * 0.24,
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xff1E2E3D),
                        Color(0xff152534),
                        Color(0xff0C1C2E),
                      ],
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${_authMode == AuthMode.login ? 'Sign in to your\nAccount' : 'Sign up new\nAccount'}',
                        style: AuthTheme.themeData.textTheme.titleLarge,
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AuthTextFormField(
                        labelText: 'Email',
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        // onChanged: (value) {
                        //   _formKey.currentState?.validate();
                        // },
                        validator: (value) {
                          return value!.isEmpty
                              ? 'Please, Enter Email Address'
                              : AuthConstants.emailRegex.hasMatch(value)
                                  ? null
                                  : 'Invalid Email Address';
                        },
                        controller: emailController,
                        onSaved: (value) {
                          _authData['email'] = value ?? '';
                        },
                      ),
                      AuthTextFormField(
                        labelText: 'Password',
                        keyboardType: TextInputType.visiblePassword,
                        textInputAction: TextInputAction.done,
                        // onChanged: (value) {
                        //   _formKey.currentState?.validate();
                        // },
                        validator: (value) {
                          return value!.isEmpty
                              ? 'Please, Enter Password'
                              : AuthConstants.passwordRegex.hasMatch(value)
                                  ? null
                                  : 'Invalid Password';
                        },
                        controller: passwordController,
                        onSaved: (value) {
                          _authData['password'] = value ?? '';
                        },
                        obscureText: isObscure,
                        suffixIcon: Padding(
                          padding: const EdgeInsets.only(right: 15),
                          child: IconButton(
                            onPressed: () {
                              setState(() {
                                isObscure = !isObscure;
                              });
                            },
                            style: ButtonStyle(
                              minimumSize: MaterialStateProperty.all(
                                const Size(48, 48),
                              ),
                            ),
                            icon: Icon(
                              isObscure
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      ValueListenableBuilder<bool>(
                        valueListenable: _isSubmitting,
                        builder: (context, isSubmitting, child) {
                          if (isSubmitting) {
                            return const CircularProgressIndicator();
                          }
                          return FilledButton(
                            onPressed: () {
                              _submit(context);
                            },
                            style: const ButtonStyle().copyWith(
                              backgroundColor: MaterialStateProperty.all(
                                Colors.grey.shade300,
                              ),
                            ),
                            child: Text(_authMode == AuthMode.login
                                ? 'Login'
                                : 'Register'),
                          );
                        },
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${_authMode == AuthMode.login ? 'Don\'t have an account?' : 'Already have an account?'}',
                        style: AuthTheme.themeData.textTheme.bodySmall
                            ?.copyWith(color: Colors.black),
                      ),
                      TextButton(
                        onPressed: () => _switchAuthMode(),
                        style: AuthTheme.themeData.textButtonTheme.style,
                        child: Text(
                          '${_authMode == AuthMode.login ? 'Sign up' : 'Sign in'}',
                          style:
                              AuthTheme.themeData.textTheme.bodySmall?.copyWith(
                            color: AuthColors.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
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
}
