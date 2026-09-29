
import 'package:thrub_trading/home_page.dart';
import 'package:thrub_trading/signup_page.dart';




  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _rememberMe = false;

  String? _error;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    final email = _emailController.text.trim(); // Remove leading and trailing spaces, (check what trim is used for)
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      setState(() => _error = 'Please enter both email and password.');
      return;
    }

    setState(() {
      _error = null;
      _isLoading = true;
    });

    try {
      // TODO: replace with real login call to API
      await Future.delayed(Duration(seconds: 1));

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } catch (e) {
      setState(() => _error = 'Invalid email or password.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: TextStyle(
        color: Colors.grey,
        fontSize: 12,
        letterSpacing: 1,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String hint,
    bool obscure = false,
    TextInputType? keyboardType,  // check how this works and what it is used for.
    Widget? suffixIcon,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboardType,
      style: TextStyle(color: Colors.white30),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey[400]),
        filled: true,
        fillColor: Colors.grey[900],
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        suffixIcon: suffixIcon,
      ),
    );
  }















                SizedBox(height: 3),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'New here?',
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                    SizedBox(width: 6),
                    Text(
                      'Create an account',
                      style: TextStyle(color: Colors.blue, fontSize: 15),
                    ),
                    GestureDetector(onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SignupPage()),
                      );
                    })
                  ],
                ),
                SizedBox(height: 15),

                // Error box: this part is conditional and only shows if there is an error.
                if (_error != null) ...[
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.red.shade900,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _error!,
                      style: TextStyle(color: Colors.red, fontSize: 16),
                    ),
                  ),
                  SizedBox(height: 16),
                ],
                _buildLabel('EMAIL ADDRESS'),
                SizedBox(height: 8),
                _buildField(
                  controller: _emailController,
                  hint: 'you@example.com',
                  keyboardType: TextInputType.emailAddress, //TODO: how to put an obscure for incorrect email form input.
                ),
                SizedBox(height: 20),
                _buildLabel('PASSWORD'),
                SizedBox(height: 8),
                _buildField(
                  controller: _passwordController,
                  hint: 'Enter your password',
                  obscure: _obscurePassword,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility_off : Icons.visibility,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() => _obscurePassword = !_obscurePassword);
                    },
                  ),
                ),
                SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Checkbox(
                      value: _rememberMe,
                      activeColor: Colors.blue,
                      onChanged: (value) {
                        setState(() => _rememberMe = value ?? false);
                      },
                    ),
                    Text(
                      'Remember me',
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _isLoading ? null : _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: _isLoading ? SizedBox(height: 20, width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                      : Text('Log in', style: TextStyle(color: Colors.black, fontSize: 16),
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

_isLoading ? null : _login,

Navigator.pop(context);
// Or, if this isn't reached via push from login:


if (email != "test@example.com" || password != "12345") {
}


symbol: market['symbol'])


mainAxisAlignment: MainAxisAlignment.spaceAround,
children: [
_buildQuickAction(Icons.show_chart, 'Markets'),
_buildQuickAction(Icons.work_outline, 'Portfolio'),
_buildQuickAction(Icons.graphic_eq, 'Signals'),
_buildQuickAction(Icons.more_horiz, 'More'),
],