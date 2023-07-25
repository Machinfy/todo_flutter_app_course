import 'package:flutter/material.dart';

class DefaultTextField extends StatelessWidget {
  const DefaultTextField({
    super.key,
    required this.textController,
    required this.label,
    required this.preIcon,
    this.onTap,
    this.onSubmitted,
    this.hint,
  });

  final TextEditingController textController;
  //final void Function()? onTap;
  final VoidCallback? onTap;
  final void Function(String)? onSubmitted;
  final String label;
  final String? hint;
  final IconData preIcon;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: textController,
      onTap: onTap,
      autocorrect: false,
      onChanged: (value) {
        print('onChanged called: $value');
      },
      onSubmitted: onSubmitted,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
          prefixIcon: Icon(preIcon), label: Text(label), hintText: hint),
    );
  }
}
