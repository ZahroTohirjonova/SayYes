import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert'; // Base64 va UTF8 uchun shart
import 'package:flutter/services.dart';
import 'package:willyou/main.dart'; // Clipboard (nusxalash) uchun

class Firstpage extends StatefulWidget {
  const Firstpage({super.key});

  @override
  State<Firstpage> createState() => _FirstpageState();
}

class _FirstpageState extends State<Firstpage> {
  final _formKey = GlobalKey<FormState>();


  void _handleCreate() {
    // 1. Ma'lumotlarni Map (lug'at) ko'rinishiga keltiramiz
    Map<String, dynamic> data = {
      'q': _questionController.text,        // Savol
      'n': _nameController.text,            // Ism
      's': _successMsgController.text,      // "Ha"dan keyingi gap
      'f': 'Great Vibes',                   // Standart shrift (yoki tanlanganini qo'ying)
      'a': 'Hearts',                        // Standart animatsiya
      'bg': 'FFF0F0',                       // Fon rangi
    };

    // 2. Map-ni JSON satriga aylantiramiz
    String jsonStr = jsonEncode(data);

    // 3. JSON-ni Base64 formatiga kodlaymiz
    String base64Str = base64.encode(utf8.encode(jsonStr));

    // 4. Yakuniy URL-ni hosil qilamiz
    // GitHub Pages yoki o'zingizning hosting manzilingizni yozing
    String baseUrl = "https://username.github.io/repository_name/";
    String finalUrl = "$baseUrl?d=$base64Str";

    // 5. Natijani ko'rsatish (Dialog orqali)
    _showResultDialog(finalUrl);
  }

  //Controllerlar
  final TextEditingController _questionController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _successMsgController = TextEditingController();

  void _showResultDialog(String url) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Link Tayyor! 🎉"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Ushbu linkni nusxalab, kerakli insonga yuboring:"),
            const SizedBox(height: 15),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.blueAccent.withOpacity(0.3)),
              ),
              child: Text(
                url,
                style: const TextStyle(fontSize: 12, color: Colors.blueGrey),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Yopish"),
          ),
          ElevatedButton.icon(
            onPressed: () {
              // Clipboard-ga nusxalash
              Clipboard.setData(ClipboardData(text: url));
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Link nusxalandi! ✅")),
              );
            },
            icon: const Icon(Icons.copy, size: 18),
            label: const Text("Nusxalash"),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8AFF),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
              child:Container(
                constraints: const BoxConstraints(maxWidth: 500),
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blueAccent.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0,10)
                    )
                  ]
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.auto_awesome_outlined, size: 50, color: Colors.blueAccent),
                    const SizedBox(height: 16),
                    Text("Create Your Surprise",
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey[900],
                    ),),
                    const SizedBox(height: 8),
                    Text(
                      "Toldiring va shaxsiy link oling",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey),
                    ),
                    const SizedBox(height: 32),

                    _buildInputField(
                      controller: _questionController,
                      label: "Your Question",
                      hint: " ",
                      icon: Icons.question_answer_rounded,
                      validator: (value) {
                        if (value == null || value.isEmpty) return "Please enter a question";
                        return null;
                      },
                    ),

                    // 2. Ism maydoni
                    _buildInputField(
                      controller: _nameController,
                      label: "His/Her Name",
                      hint: "Optional",
                      icon: Icons.person_rounded,
                    ),

                    // 3. Muvaffaqiyat xabari
                    _buildInputField(
                      controller: _successMsgController,
                      label: "Message after 'Yes!'",
                      hint: "",
                      icon: Icons.favorite_rounded,
                      validator: (value) {
                        if (value == null || value.isEmpty) return "Enter a message";
                        return null;
                      },
                    ),

                    const SizedBox(height: 32),

                    const SizedBox(height: 32),

                    // Create Tugmasi
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            // Agar form valid bo'lsa, link yaratish funksiyasini chaqiring
                            _handleCreate();
                            Navigator.push((context), MaterialPageRoute(builder: (context)=>mePage(question: _questionController.text, finalwords: _successMsgController.text,name: _nameController.text,)));
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          "Generate Link",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ],
                ),
              ) ),
        ),
      )
    );
  }
  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: TextFormField(
        controller: controller,
        validator: validator,
        style: GoogleFonts.poppins(fontSize: 15),
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: Icon(icon, color: Colors.blueAccent, size: 22),
          filled: true,
          fillColor: Colors.grey[50],
          labelStyle: const TextStyle(color: Colors.blueGrey),
          floatingLabelStyle: const TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: Colors.grey[200]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Colors.blueAccent, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Colors.redAccent),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Colors.redAccent, width: 2),
          ),
        ),
      ),
    );
  }


}
