import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

// Local imports
import 'datatable.dart';
import 'utils/responsive.dart';
import 'utils/spacing.dart';
import 'utils/colors.dart';

/// Configuration for a sortable column
class SortColumn {
  final String label;
  final String field;
  final bool numeric;
  final Comparable Function(dynamic item)? getValue;

  const SortColumn({
    required this.label,
    required this.field,
    this.numeric = false,
    this.getValue,
  });
}

/// Configuration for a custom table button
class CustomTableButton {
  final String text;
  final Icon? icon;
  final VoidCallback onPressed;

  const CustomTableButton({
    required this.text,
    this.icon,
    required this.onPressed,
  });
}

/// A paginated, sortable, and searchable data table widget
class CustomPaginatedTable<T> extends HookWidget {
  final String? title;
  final Widget? header;
  final List<T> data;
  final List<SortColumn> columns;
  final List<DataCell> Function(T) getCells;
  final bool Function(T, String) filterFunction;
  final void Function(T)? onRowTap;
  final List<PopupMenuEntry<String>> Function(BuildContext, T)
      actionMenuBuilder;
  final void Function(String, T)? onActionSelected;
  final List<CustomTableButton>? tableButtons;

  const CustomPaginatedTable({
    super.key,
    this.title,
    this.header,
    required this.data,
    required this.columns,
    required this.getCells,
    required this.filterFunction,
    required this.actionMenuBuilder,
    this.onActionSelected,
    this.onRowTap,
    this.tableButtons,
  });

  @override
  Widget build(BuildContext context) {
    final searchQuery = useState('');
    final rowsPerPage = useState<int>(10);
    final sortColumnIndex = useState<int>(0);
    final isAscending = useState<bool>(true);
    final page = useState<int>(0);
    final start = useState<int>(0);
    final end = useState<int>(10);

    final filteredAndSortedData = useMemoized(() {
      var newData = searchQuery.value.isEmpty
          ? List<T>.from(data)
          : data
              .where((item) => filterFunction(item, searchQuery.value))
              .toList();

      if (columns[sortColumnIndex.value].getValue != null) {
        final sortColumn = columns[sortColumnIndex.value];
        newData.sort((a, b) {
          final valueA = sortColumn.getValue!(a);
          final valueB = sortColumn.getValue!(b);
          return isAscending.value
              ? Comparable.compare(valueA, valueB)
              : Comparable.compare(valueB, valueA);
        });
      }

      return newData;
    }, [searchQuery.value, data, sortColumnIndex.value, isAscending.value]);

    void updateData() {
      start.value = page.value * rowsPerPage.value;
      end.value = start.value + rowsPerPage.value;
      if (end.value > filteredAndSortedData.length) {
        end.value = filteredAndSortedData.length;
      }
    }

    // Reset page to 0 when search query changes
    useEffect(() {
      page.value = 0;
      updateData();
      return null;
    }, [searchQuery.value]);

    // Update start and end when page or rowsPerPage changes
    useEffect(() {
      updateData();
      return null;
    }, [page.value, rowsPerPage.value, filteredAndSortedData]);

    // Helper to check dark mode
    bool isDarkMode(BuildContext ctx) =>
        Theme.of(ctx).brightness == Brightness.dark;

    // create a custom Pagination widget
    List<Widget> pagination() {
      int totalPages =
          (filteredAndSortedData.length / (rowsPerPage.value)).ceil();

      return [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const ClampingScrollPhysics(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: page.value > 0
                    ? () {
                        page.value = page.value - 1;
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0.0),
                  ),
                  backgroundColor: page.value > 0
                      ? isDarkMode(context)
                          ? Theme.of(context).scaffoldBackgroundColor
                          : DataTableColors.white
                      : Colors.grey,
                ),
                child: Text(
                  'Previous',
                  style: TextStyle(
                      color: page.value > 0
                          ? isDarkMode(context)
                              ? null
                              : Theme.of(context).colorScheme.onPrimaryContainer
                          : isDarkMode(context)
                              ? Colors.white.withOpacity(0.5)
                              : Colors.black.withOpacity(0.4)),
                ),
              ),
              DataTableSpacing.w4,
              Wrap(
                spacing: 4,
                children: List.generate(
                  totalPages,
                  (index) => ElevatedButton(
                    onPressed: () {
                      page.value = index;
                      updateData();
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0.0),
                      ),
                      backgroundColor: page.value == index
                          ? isDarkMode(context)
                              ? DataTableColors.primary
                              : Theme.of(context)
                                  .colorScheme
                                  .onPrimaryContainer
                          : Theme.of(context).scaffoldBackgroundColor,
                    ),
                    child: Text(
                      '${index + 1}',
                      style: TextStyle(
                        color: page.value == index
                            ? DataTableColors.white
                            : isDarkMode(context)
                                ? DataTableColors.white
                                : Theme.of(context)
                                    .colorScheme
                                    .onPrimaryContainer,
                      ),
                    ),
                  ),
                ),
              ),
              DataTableSpacing.w4,
              ElevatedButton(
                onPressed: page.value < totalPages - 1
                    ? () {
                        page.value = page.value + 1;
                        updateData();
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0.0),
                  ),
                  backgroundColor: page.value < totalPages - 1
                      ? isDarkMode(context)
                          ? Theme.of(context).scaffoldBackgroundColor
                          : DataTableColors.white
                      : Colors.grey,
                ),
                child: Text(
                  'Next',
                  style: TextStyle(
                    color: page.value < totalPages - 1
                        ? isDarkMode(context)
                            ? null
                            : Theme.of(context).colorScheme.onPrimaryContainer
                        : isDarkMode(context)
                            ? Colors.white.withOpacity(0.5)
                            : Colors.black.withOpacity(0.4),
                  ),
                ),
              ),
            ],
          ),
        ),
      ];
    }

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (header != null) header!,
              DataTableSpacing.h20,
              Row(
                children: [
                  if (title != null)
                    Text(title!, style: Theme.of(context).textTheme.titleLarge),
                  const Spacer(),
                  if (tableButtons != null)
                    ...tableButtons!.map(
                      (button) => Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: ElevatedButton.icon(
                          onPressed: button.onPressed,
                          icon: button.icon ?? const SizedBox.shrink(),
                          label: Text(button.text),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                              vertical: 12.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                  SizedBox(
                    width: 250,
                    height: 40,
                    child: TextField(
                      decoration: const InputDecoration(
                        hintText: 'Search...',
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        searchQuery.value = value;
                      },
                    ),
                  ),
                ],
              ),
              data.isEmpty ? DataTableSpacing.h36 : DataTableSpacing.h20,
              if (data.isEmpty)
                SizedBox(
                    height: MediaQuery.of(context).size.height / 2,
                    child: Center(
                      child: Text(
                        "No Record Found",
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              color: Theme.of(context).colorScheme.onSurface,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ))
              else ...[
                DataTable3(
                  showCheckboxColumn: false,
                  showBottomBorder: true,
                  minWidth: !Responsive.isMobile(context) ? 1000 : 1100,
                  dividerThickness: 1.0,
                  headingRowHeight: 56.0,
                  dataRowHeight: 56.0,
                  columnSpacing: 20.0,
                  headingRowColor: WidgetStateProperty.all(
                      DataTableColors.headerBackground.withOpacity(0.2)),
                  columns: [
                    const DataColumn2(
                      label: Text('Actions'),
                      size: ColumnSize.S,  // Columna pequeña
                    ),
                    ...columns.asMap().entries.map(
                      (entry) {
                        final column = entry.value;
                        // Controlar tamaños: Name e Email con ancho fijo, resto relativo
                        final isNameColumn = column.label == 'Name';
                        final isEmailColumn = column.label == 'Email';
                        
                        return DataColumn2(
                          label: Text(column.label),
                          numeric: column.numeric,
                          fixedWidth: isNameColumn 
                              ? 280  // Ancho fijo para Name
                              : isEmailColumn 
                                  ? 280  // Ancho fijo más grande para Email
                                  : null,  // null = usa tamaño relativo
                          size: (isNameColumn || isEmailColumn) 
                              ? ColumnSize.M  // No se usa si hay fixedWidth, pero lo dejamos
                              : ColumnSize.M,
                          onSort: (columnIndex, ascending) {
                            sortColumnIndex.value = columnIndex - 1;
                            isAscending.value = ascending;
                          },
                        );
                      },
                    ),
                  ],
                  rows: filteredAndSortedData
                      .sublist(
                        start.value,
                        end.value > filteredAndSortedData.length
                            ? filteredAndSortedData.length
                            : end.value,
                      )
                      .map(
                        (item) => DataRow2(
                          color: WidgetStateProperty.all(
                            filteredAndSortedData.indexOf(item) % 2 != 0
                                ? DataTableColors.headerBackground
                                    .withOpacity(0.2)
                                : null,
                          ),
                          cells: [
                            DataCell(
                              PopupMenuButton<String>(
                                icon: const Icon(Icons.menu_outlined),
                                onSelected: (value) =>
                                    onActionSelected?.call(value, item),
                                itemBuilder: (context) =>
                                    actionMenuBuilder(context, item),
                              ),
                            ),
                            ...getCells(item),
                          ],
                          onSelectChanged: (selected) {
                            if (selected == true) {
                              onRowTap?.call(item);
                            }
                          },
                        ),
                      )
                      .toList(),
                ),
                if (filteredAndSortedData.isEmpty)
                  const Center(child: Text("No Record Found")),
                DataTableSpacing.h20,
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        "Showing ${start.value + 1} to ${filteredAndSortedData.length >= 10 ? end.value : filteredAndSortedData.length} of ${filteredAndSortedData.length} entries",
                      ),
                    ),
                    const Spacer(),
                    if (!Responsive.isMobile(context))
                      Row(children: pagination()),
                  ],
                ),
                DataTableSpacing.h20,
                if (Responsive.isMobile(context))
                  Column(children: pagination()),
              ]
            ],
          ),
        ),
      ),
    );
  }
}


