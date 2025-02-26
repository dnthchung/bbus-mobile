import 'package:logger/logger.dart';

var logger = Logger(
  filter: null,
  output: null,
  printer: PrettyPrinter(
    methodCount: 1,
    errorMethodCount: 8,
    lineLength: 120,
    colors: true,
    printEmojis: true,
  ),
);
