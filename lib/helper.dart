import 'package:flutter/material.dart';

const BOLD = "Orbitron";
const REG = "OrbitronReg";

buildText(String val,
    {num size = 20,
    String fam: REG,
    Color color: Colors.white,
    TextDecoration decor}) {
  return Text(val,
      style: TextStyle(
          fontSize: size.toDouble(),
          color: color,
          fontFamily: fam,
          decoration: decor));
}