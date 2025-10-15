// lib/presentation/pages/orders_add_page.dart
import 'package:flutter/material.dart';
import '../widgets/custom_button.dart';

class OrdersAddPage extends StatefulWidget {
  const OrdersAddPage({super.key});

  @override
  State<OrdersAddPage> createState() => _OrdersAddPageState();
}

class _OrdersAddPageState extends State<OrdersAddPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _clientController = TextEditingController();
  final TextEditingController _dessertController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  @override
  void dispose() {
    _clientController.dispose();
    _dessertController.dispose();
    _quantityController.dispose();
    _noteController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  InputDecoration _fieldDecoration(BuildContext context, String label) {
    final colorScheme = Theme.of(context).colorScheme;
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: colorScheme.primary, width: 1.4),
      ),
    );
  }

  String? _requiredValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Campo obligatorio';
    }
    return null;
  }

  String? _quantityValidator(String? value) {
    final String? baseValidation = _requiredValidator(value);
    if (baseValidation != null) {
      return baseValidation;
    }
    final num? parsed = num.tryParse(value!.trim());
    if (parsed == null || parsed <= 0) {
      return 'Ingresa una cantidad válida';
    }
    return null;
  }

  Future<void> _selectDate() async {
    FocusScope.of(context).requestFocus(FocusNode());
    final DateTime now = DateTime.now();
    final DateTime firstDate = DateTime(now.year, now.month, now.day);

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: firstDate,
      firstDate: firstDate,
      lastDate: DateTime(now.year + 5),
    );

    if (picked != null) {
      setState(() {
        _dateController.text = _formatDate(picked);
      });
    }
  }

  String _formatDate(DateTime date) {
    final String day = date.day.toString().padLeft(2, '0');
    final String month = date.month.toString().padLeft(2, '0');
    final String year = date.year.toString();
    return '$day/$month/$year';
  }

  void _handleSave() {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    final Map<String, String> orderData = <String, String>{
      'cliente': _clientController.text.trim(),
      'postre': _dessertController.text.trim(),
      'cantidad': _quantityController.text.trim(),
      'anotacion': _noteController.text.trim(),
      'fechaEntrega': _dateController.text.trim(),
    };

    Navigator.pushNamed(
      context,
      '/pedidos/detalle',
      arguments: orderData,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.background, // ignore: deprecated_member_use
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    const SizedBox(height: 24),
                    Text(
                      'Agregar Pedido',
                      style: theme.textTheme.headlineLarge,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    TextFormField(
                      controller: _clientController,
                      decoration: _fieldDecoration(context, 'Nombre del cliente'),
                      textInputAction: TextInputAction.next,
                      validator: _requiredValidator,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _dessertController,
                      decoration: _fieldDecoration(context, 'Postre a vender'),
                      textInputAction: TextInputAction.next,
                      validator: _requiredValidator,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _quantityController,
                      decoration: _fieldDecoration(context, 'Cantidad'),
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      validator: _quantityValidator,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _noteController,
                      minLines: 2,
                      maxLines: 4,
                      decoration: _fieldDecoration(context, 'Anotación'),
                      validator: _requiredValidator,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _dateController,
                      readOnly: true,
                      decoration: _fieldDecoration(
                        context,
                        'Fecha de entrega  __-__-____',
                      ).copyWith(
                        suffixIcon: const Icon(Icons.calendar_today),
                      ),
                      validator: _requiredValidator,
                      onTap: _selectDate,
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: 220,
                      child: CustomButton(
                        label: 'Guardar',
                        filled: true,
                        onPressed: _handleSave,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: 220,
                      child: CustomButton(
                        label: 'Volver',
                        filled: true,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
