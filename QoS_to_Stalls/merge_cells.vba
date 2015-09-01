Sub SplitMergedCells()
'this will find all merged cells on
'the currently selected worksheet and then
'unmerge them, placing the text that was
'in them when merged into each individual
'cell and set the alignment to LEFT
'
'see this site for instructions on placing
'this code into your workbook:
' http://www.contextures.com/xlvba01.html#Regular
'
  Dim myWS As Worksheet
  Dim myCells As Range
  Dim anyCell As Range
  Dim mergedCells As Range
  Dim mCell As Range
  Dim cellText As String
  
  Set myWS = ActiveSheet
  Set myCells = myWS.UsedRange
  For Each anyCell In myCells
    If anyCell.MergeCells Then
      cellText = anyCell.Value
      Set mergedCells = anyCell.MergeArea
      anyCell.MergeCells = False
      For Each mCell In mergedCells
        mCell = cellText
        mCell.HorizontalAlignment = xlLeft
      Next
      Set mergedCells = Nothing
    End If
  Next
  Set myCells = Nothing
  Set myWS = Nothing
  MsgBox "All Merged Cells are now Unmerged", _
   vbOKOnly + vbInformation, "Task Completed"
End Sub
