# FlutterLibrary
A Library containing all kinds of useful Widgets and Layouts for Flutter

# Layouts

## DynamicMultiChildLayout
I rewrote the source code of Flutter's CustomMultiChildLayout to ged rid of the restriction that it can't depend on it's children's sizes.
Now it can.
The result is the DynamicMultiChildLayout which is like a CustomMultiChildLayout but the layout can depend on the children's sizes.
Basically it measures the sizes of the children at runtime.

## Grid
A better GridView.
Instead of the cels having a fixed size, like a Datatable the cells respond to the size of the content.
Each Column has the width of the widest child in the column and each row has the height of the tallest child in the row.
Takes advantage of the DynamicMultiChildLayout.

## Tree
Like a column but it indents every child which is also a tree by a (configurable) amount of pixels.
Takes advantage of the DynamicMultiChildLayout.

## CRGrid
A Grid Layout using only Columns and Rows

# Widgets

## NinftyConstrains
BoxConstraints which does not constrain any finite widths and heights but it constrains infinite widths and heights.
Basically it's an inverse BoxConstraints.tightForFinite.

## SelectableTable
An Excel-Like table.
A better Datagrid.
Can only hold Text content since it needs to measure the size before building (which even the DynamicMultiChildLayout can't do) and i wrote a function for that, but it only works on text.
Header-Rows and Header-Columns are unselectable.
Like a true programmer, it starts counting at 0.

# Other

## Notifications
A notification which can be used for mouseclicks and keyboard events

## utils
A must-have for any flutter project imho.
Contains things like date-string-conversion, a snackbar messaging system and functions to exit the application.
