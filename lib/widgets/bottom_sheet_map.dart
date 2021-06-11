import 'package:flutter/material.dart';
import 'package:places/widgets/map.dart';

class BottomSheetMap extends StatelessWidget {
  const BottomSheetMap({
    Key key,
    @required this.isLoading,
    @required this.isSelected,
    @required this.selectionModeCallback,
  }) : super(key: key);

  final ValueNotifier<bool> isLoading;
  final bool isSelected;
  final Function selectionModeCallback;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          Container(
            height: 20,
            alignment: Alignment.center,
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Container(
                height: 5,
                width: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.grey,
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    Navigator.of(context).pop();
                  }),
              IconButton(
                  icon: Icon(Icons.done),
                  onPressed: () {
                    selectionModeCallback(isSelected: true);
                    Navigator.of(context).pop();
                  }),
            ],
          ),
          ValueListenableBuilder(
            valueListenable: isLoading,
            builder: (context, bool isLoading, _) => isLoading
                ? Expanded(child: Center(child: CircularProgressIndicator()))
                : Expanded(
                    child: PlaceMap(isSelected: isSelected),
                  ),
          ),
        ],
      ),
    );
  }
}
