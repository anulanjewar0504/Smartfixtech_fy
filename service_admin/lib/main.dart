import 'package:flutter/material.dart';
import 'package:service_admin/dashboard.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async{
  await Supabase.initialize(
    url: 'https://vkagtjdjdbwpjehnecbk.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZrYWd0amRqZGJ3cGplaG5lY2JrIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDg5Nzc1OTYsImV4cCI6MjAyNDU1MzU5Nn0.-djMnTzjVMf_JV74IVNgaiyTT7VEaCdBoo3RJS2WAyw',
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Admin',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.brown),
        useMaterial3: true,
      ),
      home: Dashboard()
    );
  }
}
