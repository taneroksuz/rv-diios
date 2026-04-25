#!/bin/bash
set -e

start=`date +%s`

FORMAT_FLAGS=(
  --indentation_spaces=2
  --column_limit=100
  --wrap_spaces=4
  --line_break_penalty=2
  --over_column_limit_penalty=100
  --assignment_statement_alignment=align
  --case_items_alignment=align
  --class_member_variable_alignment=align
  --distribution_items_alignment=align
  --enum_assignment_statement_alignment=align
  --formal_parameters_alignment=align
  --named_parameter_alignment=align
  --named_port_alignment=align
  --port_declarations_alignment=align
  --named_parameter_indentation=indent
  --named_port_indentation=indent
  --port_declarations_indentation=indent
  --compact_indexing_and_selections=true
  --expand_coverpoints=false
  --wrap_end_else_clauses=false
  --inplace
)

SV_FILES=$(find ${BASEDIR} -name "*.sv" | sort)

${VERIBLE}-verilog-format ${FORMAT_FLAGS[@]} ${SV_FILES[@]}

end=`date +%s`
echo Execution time was `expr $end - $start` seconds.