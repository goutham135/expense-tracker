import 'package:expense_management/screens/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/auth_service.dart';
import 'display_expenses.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  var error = StateProvider((ref) => '',);
  final _formKey = GlobalKey<FormState>();
  var loader = StateProvider((ref) => false,);

  void handleLogin() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    if (_formKey.currentState!.validate()) {
      // if(email.isEmpty){
      //   ref.read(error.notifier).state = "Please enter email.";
      // } else if(password.isEmpty){
      //   ref.read(error.notifier).state = "Please enter password.";
      // } else{
      ref.read(loader.notifier).state = true;
      var result = await _authService.logIn(email, password);
      ref.read(loader.notifier).state = false;
      if(result == null){
          ref.read(error.notifier).state = "Invalid email or password.";
        }else if (result is String) {
          ref.read(error.notifier).state = result;
        } else {
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => ExpensesScreen(),), (route) => false,);
        }
      // }
    }
  }

  void gotoSignUp(){
    ref.read(error.notifier).state = "";
    emailController.clear();
    passwordController.clear();
    Navigator.push(context, MaterialPageRoute(builder: (context) => const SignUpScreen(),));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.clear();
    passwordController.clear();
  }


  @override
  Widget build(BuildContext context) {
    String errorMsg = ref.watch(error);
    bool isLoading = ref.watch(loader);
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Stack(
        children: [
          Center(
            child: Card(
              margin: const EdgeInsets.all(20.0),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextFormField(
                        controller: emailController,
                        decoration: const InputDecoration(labelText: "Email"),
                        validator: (value) => value!.isEmpty ? 'Email is required' : null,
                      ),
                      TextFormField(
                        controller: passwordController,
                        decoration: const InputDecoration(labelText: "Password"),
                        obscureText: true,
                        validator: (value) => value!.isEmpty ? 'Password is required' : null,
                      ),
                      if (errorMsg.isNotEmpty) Text(errorMsg, style: const TextStyle(color: Colors.red)),
                      const SizedBox(height: 20),
                      ElevatedButton(onPressed: handleLogin, child: const Text("Login")),
                      ElevatedButton(onPressed: gotoSignUp, child: const Text("Create account? Sign Up")),
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
