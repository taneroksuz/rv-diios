#!/bin/bash
set -e

start=`date +%s`

FORMAT_FLAGS=(
  --inplace
  --column_limit=100
  --indentation_spaces=2
  --wrap_spaces=4
  --line_break_penalty=2
  --over_column_limit_penalty=100
  --try_wrap_long_lines=true
  --wrap_end_else_clauses=false
  --port_declarations_alignment=align
  --port_declarations_indentation=indent
  --named_port_alignment=align
  --named_port_indentation=indent
  --formal_parameters_alignment=align
  --formal_parameters_indentation=indent
  --named_parameter_alignment=align
  --named_parameter_indentation=indent
  --module_net_variable_alignment=align
  --struct_union_members_alignment=align
  --class_member_variable_alignment=align
  --case_items_alignment=align
  --assignment_statement_alignment=align
  --enum_assignment_statement_alignment=align
  --distribution_items_alignment=align
  --alignment_group_boundary=blank-lines
  --compact_indexing_and_selections=true
  --verify_convergence=true
  --failsafe_success=true
)

SV_FILES=$(find ${BASEDIR} -name "*.sv" | sort)

${VERIBLE}-verilog-format ${FORMAT_FLAGS[@]} ${SV_FILES[@]}

end=`date +%s`
echo Execution time was `expr $end - $start` seconds.