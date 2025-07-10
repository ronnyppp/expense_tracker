import 'package:expense_tracker/widgets/chart/chart.dart';
import 'package:expense_tracker/widgets/expenses_list/expenses_list.dart';
import 'package:expense_tracker/widgets/new_expense.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker/models/expense.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() {
    return _ExpensesState();
  }
}

class _ExpensesState extends State<Expenses> {
  final List<Expense> _registeredExpenses = [
    Expense(
      title: 'Flutter Course',
      amount: 19.99,
      date: DateTime.now(),
      category: Category.work
    ),
    Expense(
      title: 'Movie Theatre Ticket',
      amount: 15.99,
      date: DateTime.now(),
      category: Category.leisure
    )
  ];

  void _openAddExpenseOverlay() {
    // write ctx since we are passing a different context object in builder
    // set isScrollControlled so modal sheet takes up whole screen
    showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true, 
      context: context, 
      builder: (ctx) => 
      NewExpense(onAddExpense: _addExpense),
      );
  }

  void _addExpense(Expense expense) {
    // add expense to registered expenses list
    setState(() {
      _registeredExpenses.add(expense);
    });
  }

  void _removeExpense(Expense expense){
    final expenseIndex = _registeredExpenses.indexOf(expense);

    setState(() {
      _registeredExpenses.remove(expense);
    });
    // quickly show following message when removing multiple expenses
    ScaffoldMessenger.of(context).clearSnackBars();
    // add message/undo when removing expense
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        // tell user expense was deleted
        duration: const Duration(seconds: 3),
        content: const Text("Expense deleted."),
        action: SnackBarAction(label: "Undo", 
        // when user presses undo we insert the expense back into the list in the same position
          onPressed: (){
            _registeredExpenses.insert(expenseIndex, expense);
          }
        ),
        )
    );
  }

  @override
  Widget build(context) {
    // store width of screen
    final width = MediaQuery.of(context).size.width;

    // show message if user hasn't entered expenses
    Widget mainContent = const Center(child: 
      Text("No expenses entered. Begin adding expenses."),
      );
    // show expenses if they have entered expenses
    if(_registeredExpenses.isNotEmpty){
      mainContent = ExpensesList(expenses: _registeredExpenses, 
        onRemoveExpense: _removeExpense,);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("The ExpenseTracker"),
        actions: [
          IconButton(onPressed: _openAddExpenseOverlay,
           icon: const Icon(Icons.add
           ))
        ],
      ),
      // if width is less than 600 set to portrait mode
        body: width < 600 ? Column(
          children: [
            Chart(expenses: _registeredExpenses),
            Expanded(child:
              mainContent,
            ),
          ],
          // if width is greater than 600 set to landscape mode
        ) : Row (
          children: [
            // wrap with expanded since chart also seeks to take all available width
            Expanded(child: Chart(expenses: _registeredExpenses)),
            Expanded(child:
              mainContent,
            ),
          ],
        ) 
    );
  }
}