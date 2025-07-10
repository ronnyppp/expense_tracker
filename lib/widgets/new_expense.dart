import 'package:flutter/material.dart';
import 'package:expense_tracker/models/expense.dart';

class NewExpense extends StatefulWidget {
  const NewExpense({super.key, required this.onAddExpense});

  final void Function(Expense expense) onAddExpense;

  @override
  State<StatefulWidget> createState() {
    return _NewExpenseState();
  }
}

class _NewExpenseState extends State<NewExpense> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectedDate;
  Category _selectedCategory = Category.leisure;

  void _presentDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);

    final pickedDate = await showDatePicker(
      context: context, 
      initialDate: now, 
      firstDate: firstDate, 
      lastDate: now);
    setState(() {
      _selectedDate = pickedDate;
    });
  }

  void _submitExpenseData() {
    // convert amonut to double
    final enteredAmount = double.tryParse(_amountController.text);
    // check if null or invalid input
    final amountIsInvalid = enteredAmount == null || enteredAmount <= 0;
    // check if ivalid title, amount or date
    if(_titleController.text.trim().isEmpty || amountIsInvalid || _selectedDate == null){
      showDialog(context: context, builder: (ctx) => AlertDialog(
        title: const Text("Invalid input"),
        content: const Text("Please make sure a valid title, amount, date and category were entered."),
        actions: [
          TextButton(onPressed: () {
            Navigator.pop(ctx);
          }, child: const Text("Okay"))
        ],
      ),
      );
      // we use return to not execute code after the if statement
      return;
    }
    widget.onAddExpense(Expense(title: _titleController.text, 
    amount: enteredAmount, date: _selectedDate!, category: _selectedCategory));
    // close modal sheet after adding expense
    Navigator.pop(context);
  }
  // necessary to dispose of text controllers
  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;
    
    return SizedBox(
      height: double.infinity,
      child: SingleChildScrollView(
        child: Padding(
          // increased padding for height to prevent overlap with device features
          // add padding for keyboard space
          padding: EdgeInsets.fromLTRB(16, 48, 16, keyboardSpace + 16),
          child: Column(
              children: [
                TextField(
                  controller: _titleController,
                  maxLength: 50,
                  decoration: const InputDecoration(
                    label: Text("Title")
                  ),
                ),
                Row(
                  children: [
                    // wrap with expanded so it will not take up all space
                    Expanded(child: 
                    TextField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    prefixText: "\$ ",
                    label: Text("Amount")
                  ),
                ),
                    ),
                const SizedBox(width: 16,),
                // wrap with expanded since its a nested row
                Expanded(child:
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // add ! to tell dart it will not be a null value
                    Text(_selectedDate == null ? "Selected Date" : formatter.format(_selectedDate!)),
                    IconButton(onPressed: _presentDatePicker,
                     icon: const Icon(Icons.calendar_month),
                     ),
                  ],
                ),
                ),
                  ]
                ,),
                const SizedBox(height: 16,),
                Row(
                  children: [
                    DropdownButton(
                      value: _selectedCategory,
                      items: Category.values
                      .map(
                        (category) => DropdownMenuItem(
                          value: category,
                          child: Text(category.name.toUpperCase()),
                        ),
                      ).toList(),
                       onChanged: (value) {
                        // if null setstate will not execute and vice versa
                          if(value == null){
                            return;
                          }
                          setState(() {
                            _selectedCategory = value;
                          });
                        }
                       ),
                       const Spacer(),
                    TextButton(onPressed: (){
                      // closes modal sheet
                      Navigator.pop(context);
                    }, child: const Text("Cancel")),
                    ElevatedButton(onPressed: _submitExpenseData,
                     child: const Text("Save Expense"))
                  ],
                ),
              ],
          ),),
      ),
    );
  }
}