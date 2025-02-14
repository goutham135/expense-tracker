import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../heplers.dart';
import '../services/auth_service.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  var error = StateProvider((ref) => '',);
  var loader = StateProvider((ref) => false,);
  final _formKey = GlobalKey<FormState>();

  void handleSignUp() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (_formKey.currentState!.validate()) {
      // if(email.isEmpty){
      //   ref.read(error.notifier).state = "Please enter email.";
      // } else if(password.isEmpty){
      //   ref.read(error.notifier).state = "Please enter password.";
      // } else{
        ref.read(loader.notifier).state = true;
        var result = await _authService.signUp(email, password);
        if(result == null){
          ref.read(error.notifier).state = "Invalid email or password.";
        }else if (result is String) {
          ref.read(error.notifier).state = result;
        } else {
          ref.read(loader.notifier).state = false;
          Navigator.pop(context);
        }
      // }
    }
  }

  @override
  Widget build(BuildContext context) {
    String errorMsg = ref.watch(error);
    bool isLoading = ref.watch(loader);
    return Scaffold(
      appBar: AppBar(title: const Text("Sign Up")),
      body: Stack(
        children: [
          Center(
            child: Card(
              margin: const EdgeInsets.all(20),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: emailController,
                        decoration: const InputDecoration(labelText: "Email"),
                        validator: (value) => value!.isEmpty ? 'Email is required' : isValidEmail(value) ? null : 'Please enter valid email',
                      ),
                      TextFormField(
                        controller: passwordController,
                        decoration: const InputDecoration(labelText: "Password"),
                        obscureText: true,
                        validator: (value) => value!.isEmpty ? 'Password is required' : isValidPassword(value) ? null : 'Password must be at least 6 characters long,\n should contain at least 1 uppercase letter,\n and include at least 1 special character.',
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(onPressed: handleSignUp, child: const Text("Sign Up")),
                      if (errorMsg.isNotEmpty)Text(errorMsg, maxLines: 3, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
              ),
            ),
          ),
          if(isLoading)const Center(child: CircularProgressIndicator())
        ],
      ),
    );
  }
}
