import 'package:common_models/common_models.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../values/assets.dart';

typedef EntityMenuItemBuilder<T> = DropdownMenuItem<T> Function(T t);

class DropdownField<T> extends StatelessWidget {
  const DropdownField({
    super.key,
    required this.hintText,
    required this.validateForm,
    required this.data,
    required this.currentValue,
    required this.itemBuilder,
    required this.onChanged,
  });

  final String hintText;
  final bool validateForm;
  final SimpleDataState<DataPage<T>> data;
  final T? currentValue;
  final EntityMenuItemBuilder<T> itemBuilder;
  final ValueChanged<T?>? onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField2<T>(
      items: data.maybeWhen(
        success: (data) => data.items.map(itemBuilder).toList(),
        orElse: () => [],
      ),
      decoration: InputDecoration(hintText: hintText),
      iconStyleData: IconStyleData(
        icon: SvgPicture.asset(Assets.iconChevronDown),
      ),
      value: currentValue,
      autovalidateMode: validateForm ? AutovalidateMode.always : AutovalidateMode.disabled,
      validator: (_) => validateForm && currentValue == null ? 'Field is required' : null,
      onChanged: onChanged,
    );
  }
}
