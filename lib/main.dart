import 'package:flutter/material.dart';

import 'src/app.dart';
import 'src/di/injection.dart';

void main() {
    configureInjection(Env.prod);
    runApp(MyApp());
} 
