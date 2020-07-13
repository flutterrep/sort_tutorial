import 'package:flutter/material.dart';
import 'package:foldtutorial/widgets/form_input_field.dart';

class Item {
  String itemName;
  double itemPrice;

  Item({this.itemName, this.itemPrice});
}

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  List<Item> items = [];
  bool sort = false;


  final _formKey = GlobalKey<FormState>();
  TextEditingController _itemController;
  TextEditingController _priceController;

  @override
  void initState() {
    super.initState();
    _itemController = TextEditingController();
    _priceController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Form(
            key: _formKey,
            child: Column(
              children: [
                FormInputField(
                  itemController: _itemController,
                  hintText: 'Item',
                  validateMessage: 'Please provide the item name',
                  keyboardType: TextInputType.text,
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Expanded(
                      child: FormInputField(
                        itemController: _priceController,
                        hintText: 'Price',
                        validateMessage: 'Please provide the price',
                        keyboardType: TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          items.add(Item(
                              itemName: _itemController.text,
                              itemPrice: double.parse(_priceController.text)));
                          setState(() {
                            _itemController.clear();
                            _priceController.clear();
                          });
                        }
                      },
                      icon: Icon(
                        Icons.subdirectory_arrow_left,
                        size: 30,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          DataTable(
            sortColumnIndex: 1,
              sortAscending: sort,
              columns: [
            DataColumn(
              label: Text('Item'),
            ),
            DataColumn(
              numeric: true,
              // TODO: sort the rows according to the item price
              onSort: (index, ascending) {
                var sortedItems = items;
                sortedItems.sort((a, b) => a.itemPrice.compareTo(b.itemPrice));

                items = ascending ? sortedItems : sortedItems.reversed.toList();
                setState(() {
                  sort = ascending;
                });
              },
              label: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('Price'),
                    ],
                  ),
                ),
              ),
            ),
          ], rows: [
            ...items.map(
              (element) => DataRow(
                cells: [
                  DataCell(
                    Text(element.itemName),
                  ),
                  DataCell(
                    Text(element.itemPrice.toString()),
                  ),
                ],
              ),
            ),
            DataRow(cells: [
              DataCell(Text(
                'Total amount',
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
              DataCell(
                Text(items
                    .fold(0, (prev, el) => prev + el.itemPrice)
                    .toString()),
              )
            ])
          ])
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _priceController.dispose();
    _itemController.dispose();
  }
}
