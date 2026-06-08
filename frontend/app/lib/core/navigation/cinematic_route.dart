import 'package:flutter/material.dart';

// Rota usada quando uma tela chama outra.
// Mantivemos essa funcao para as telas antigas continuarem chamando buildCloudRoute.
// Por dentro ela usa MaterialPageRoute normal, que e mais simples para explicar.
Route<T> buildCloudRoute<T>(Widget page) {
  return MaterialPageRoute<T>(builder: (_) => page);
}
