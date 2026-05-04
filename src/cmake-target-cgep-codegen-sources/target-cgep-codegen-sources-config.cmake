# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
include_guard(GLOBAL)

function(target_cgep_codegen_sources)
  set(options)
  set(oneValueArgs CONFIG FILE_SET TARGET)
  set(multiValueArgs)
  cmake_parse_arguments(tccs "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

  set(tccs_target ${tccs_TARGET})
  if (NOT tccs_TARGET)
    message(FATAL_ERROR "${CMAKE_CURRENT_FUNCTION_LIST_FILE}:${CMAKE_CURRENT_LIST_LINE}: TARGET argument is required")
  endif()
  message(TRACE "${CMAKE_CURRENT_FUNCTION}: tccs_target=\"${tccs_target}\"")

  if (tccs_CONFIG)
    unset(tccs_config)
    unset(tccs_config CACHE)
    find_file(tccs_config
      "${tccs_CONFIG}"
      PATHS "${CMAKE_CURRENT_SOURCE_DIR}"
      NO_DEFAULT_PATH
      NO_CACHE
      REQUIRED
    )
  else()
    message(FATAL_ERROR "${CMAKE_CURRENT_FUNCTION_LIST_FILE}:${CMAKE_CURRENT_LIST_LINE}: CONFIG argument is required")
  endif()
  message(TRACE "${CMAKE_CURRENT_FUNCTION}: tccs_config=\"${tccs_config}\"")

  # We want <name>.hpp as the output, so derive it from the config file name
  get_filename_component(tccs_config_name "${tccs_config}" NAME_WLE)
  message(TRACE "${CMAKE_CURRENT_FUNCTION}: tccs_config_name=\"${tccs_config_name}\"")
  set(tccs_output_dir "${CMAKE_CURRENT_BINARY_DIR}/cmake-target-cgep-codegen-sources")
  set(tccs_output_file "${tccs_output_dir}/${tccs_target}/${tccs_config_name}.hpp")
  message(TRACE "${CMAKE_CURRENT_FUNCTION}: tccs_output_file=\"${tccs_output_file}\"")

  if(tccs_FILE_SET)
    set(tccs_file_set "${tccs_FILE_SET}")
  else()
    set(tccs_file_set "${tccs_target}_codegen_HEADERS")
  endif()
  message(TRACE "${CMAKE_CURRENT_FUNCTION}: tccs_file_set=\"${tccs_file_set}\"")

  set(tccs_prefix_dir "${tccs_target}")
  message(TRACE "${CMAKE_CURRENT_FUNCTION}: tccs_prefix_dir=\"${tccs_prefix_dir}\"")

  unset(tccs_codegen_script)
  unset(tccs_codegen_script CACHE)
  find_file(tccs_codegen_script
    "cgep-codegen.py"
    PATHS "${CMAKE_CURRENT_FUNCTION_LIST_DIR}"
    NO_DEFAULT_PATH
    NO_CACHE
    REQUIRED
  )
  message(TRACE "${CMAKE_CURRENT_FUNCTION}: tccs_codegen_script=\"${tccs_codegen_script}\"")

  set(tccs_depfile "${tccs_output_file}.dep")
  message(TRACE "${CMAKE_CURRENT_FUNCTION}: tccs_depfile=\"${tccs_depfile}\"")

  find_program(uv_PROGRAM uv REQUIRED)

  add_custom_command(
    OUTPUT "${tccs_output_file}"
    COMMAND
        "${uv_PROGRAM}"
        run
        --script "${tccs_codegen_script}"
        --config "${tccs_config}"
        --output "${tccs_output_file}"
        --template-dir "${CMAKE_CURRENT_FUNCTION_LIST_DIR}"
        --depfile "${tccs_depfile}"
    DEPENDS "${tccs_codegen_script}"
    DEPFILE "${tccs_depfile}"
    COMMENT "Generating ${tccs_output_file}"
    VERBATIM
    CODEGEN
  )
  message(VERBOSE "${CMAKE_CURRENT_LIST_FILE}:${CMAKE_CURRENT_LIST_LINE}: Generated command for \"${tccs_output_file}\".")

  target_sources("${tccs_target}"
    PUBLIC
      FILE_SET "${tccs_file_set}"
      TYPE HEADERS
      BASE_DIRS "${tccs_output_dir}"
      FILES
        "${tccs_output_file}"
  )
endfunction()
