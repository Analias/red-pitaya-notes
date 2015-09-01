module tx_0 {
  # Create xlconstant
  cell xilinx.com:ip:xlconstant:1.1 const_0 {
    CONST_WIDTH 9
    CONST_VAL 511
  }

  # Create blk_mem_gen
  cell xilinx.com:ip:blk_mem_gen:8.2 bram_0 {
    MEMORY_TYPE True_Dual_Port_RAM
    USE_BRAM_BLOCK Stand_Alone
    WRITE_WIDTH_A 64
    WRITE_DEPTH_A 512
    WRITE_WIDTH_B 32
    WRITE_DEPTH_B 1024
    ENABLE_A Always_Enabled
    ENABLE_B Always_Enabled
    REGISTER_PORTB_OUTPUT_OF_MEMORY_PRIMITIVES false
  }

  # Create axis_bram_reader
  cell pavel-demin:user:axis_bram_reader:1.0 reader_0 {
    AXIS_TDATA_WIDTH 64
    BRAM_DATA_WIDTH 64
    BRAM_ADDR_WIDTH 9
    CONTINUOUS TRUE
  } {
    BRAM_PORTA bram_0/BRAM_PORTA
    cfg_data const_0/dout
    aclk /ps_0/FCLK_CLK0
    aresetn /rst_slice_2/Dout
  }

  # Create axis_broadcaster
  cell xilinx.com:ip:axis_broadcaster:1.1 bcast_0 {
    S_TDATA_NUM_BYTES.VALUE_SRC USER
    M_TDATA_NUM_BYTES.VALUE_SRC USER
    S_TDATA_NUM_BYTES 8
    M_TDATA_NUM_BYTES 4
    M00_TDATA_REMAP {tdata[31:0]}
    M01_TDATA_REMAP {tdata[63:32]}
  } {
    S_AXIS reader_0/M_AXIS
    aclk /ps_0/FCLK_CLK0
    aresetn /rst_0/peripheral_aresetn
  }

  # Create floating_point
  cell xilinx.com:ip:floating_point:7.0 fp_0 {
    OPERATION_TYPE Float_to_fixed
    RESULT_PRECISION_TYPE Custom
    C_RESULT_EXPONENT_WIDTH 2
    C_RESULT_FRACTION_WIDTH 22
  } {
    S_AXIS_A bcast_0/M00_AXIS
    aclk /ps_0/FCLK_CLK0
  }

  # Create floating_point
  cell xilinx.com:ip:floating_point:7.0 fp_1 {
    OPERATION_TYPE Float_to_fixed
    RESULT_PRECISION_TYPE Custom
    C_RESULT_EXPONENT_WIDTH 2
    C_RESULT_FRACTION_WIDTH 22
  } {
    S_AXIS_A bcast_0/M01_AXIS
    aclk /ps_0/FCLK_CLK0
  }

  # Create axis_combiner
  cell  xilinx.com:ip:axis_combiner:1.1 comb_0 {
    TDATA_NUM_BYTES.VALUE_SRC USER
    TDATA_NUM_BYTES 3
  } {
    S00_AXIS fp_0/M_AXIS_RESULT
    S01_AXIS fp_1/M_AXIS_RESULT
    aclk /ps_0/FCLK_CLK0
    aresetn /rst_0/peripheral_aresetn
  }

  # Create fir_compiler
  cell xilinx.com:ip:fir_compiler:7.2 fir_0 {
    DATA_WIDTH.VALUE_SRC USER
    DATA_WIDTH 24
    COEFFICIENTVECTOR {-1.64778017504821e-08, -4.73241630972268e-08, -7.93887202510813e-10, 3.09352878404732e-08, 1.86286930170453e-08, 3.27498410738459e-08, -6.30102226167167e-09, -1.52285677682317e-07, -8.3046659925013e-08, 3.14547551704176e-07, 3.0563443720122e-07, -4.74191170936088e-07, -7.13516353637052e-07, 5.47346136364469e-07, 1.33466425117543e-06, -4.14159729529697e-07, -2.1505805167364e-06, -6.77370572592844e-08, 3.07556732594925e-06, 1.03705030011379e-06, -3.94449669341147e-06, -2.59199261221929e-06, 4.5155281147441e-06, 4.7479775540806e-06, -4.49299517091285e-06, -7.3984868150555e-06, 3.5722846504364e-06, 1.02898691170903e-05, -1.50387107353356e-06, -1.3021295240213e-05, -1.83214092103955e-06, 1.50786524338075e-05, 6.35486564203855e-06, -1.59062103558083e-05, -1.17328814234578e-05, 1.50114934158482e-05, 1.7372569768772e-05, -1.2094722058868e-05, -2.24676380665025e-05, 7.16993391498536e-06, 2.6104136561553e-05, -6.63533219677271e-07, -2.74301756351097e-05, -6.5509220415395e-06, 2.58651740895229e-05, 1.32048470152478e-05, -2.13176717945138e-05, -1.77907027055154e-05, 1.43667632087369e-05, 1.88203618402145e-05, -6.35774541616115e-06, -1.51630343053795e-05, -6.34775211606745e-07, 6.41598042358286e-06, 4.00816779990772e-06, 6.75786427495096e-06, -1.00568276595242e-06, -2.24038754539457e-05, -1.07627144658563e-05, 3.72348063680045e-05, 3.27016483734519e-05, -4.68623365684776e-05, -6.4654596102959e-05, 4.62618530987231e-05, 0.000104405186187604, -3.05417822389159e-05, -0.000147462039044046, -4.11988492941763e-06, 0.000187192149427276, 5.94738872977826e-05, -0.000215382165368829, -0.000134306205056022, 0.000223231707413482, 0.000223842467853673, -0.000202707525832297, -0.000319634132913427, 0.000148101234438772, 0.000410063834262648, -5.75617203263258e-05, -0.000481530835333756, -6.56785883501223e-05, 0.000520268055965709, 0.000212671446175585, -0.000514635433840052, -0.000369018416426279, 0.000457481956518536, 0.000515991139965089, -0.000348488553042298, -0.000632902559924025, 0.000195654944186418, 0.0007002120212925, -1.57980533235907e-05, -0.000703228336453903, -0.000166384301618619, 0.000635864008017495, 0.000320845194620058, -0.000503825995204771, -0.000416271406422987, 0.000326578104854305, 0.00042540796787085, -0.000137467838420373, -0.000331057668557775, -1.84374142285803e-05, 0.000131957627239175, 8.89995757708005e-05, 0.00015241240647753, -2.20123054012764e-05, -0.000479127624786442, -0.000226160883563179, 0.000781626029320044, 0.000680353834824278, -0.000973879377410335, -0.00133747123832419, 0.0009575439273188, 0.00215830699134156, -0.000633087020788471, -0.00306249654401996, -8.62725214973823e-05, 0.00392762347821018, 0.00125893533211075, -0.00459335597324047, -0.00289915450301595, 0.00487097350981681, 0.00496287622449415, -0.00455803533665138, -0.00733691211923137, 0.00345727985864366, 0.00983285937836248, -0.00139823865832502, -0.0121865644117635, -0.00174040558057665, 0.0140627425075149, 0.00600874467154933, -0.0150660618718172, -0.0113705309052728, 0.0147488226410386, 0.0176878273610446, -0.0126189031570254, -0.024713994167311, 0.00813110758014333, 0.0320875294424435, -0.000645074386954854, -0.0393183133783369, -0.0106929019249101, 0.0457380506106455, 0.0272512610765445, -0.0503228869030081, -0.051717777909343, 0.0510207089335854, 0.0905740632435812, -0.0416086421590015, -0.163752798676903, -0.0108029883454992, 0.356394892122178, 0.554828584068277, 0.356394892122178, -0.0108029883454991, -0.163752798676903, -0.0416086421590015, 0.0905740632435811, 0.0510207089335854, -0.0517177779093429, -0.0503228869030081, 0.0272512610765445, 0.0457380506106455, -0.0106929019249102, -0.0393183133783369, -0.00064507438695485, 0.0320875294424435, 0.00813110758014329, -0.024713994167311, -0.0126189031570254, 0.0176878273610446, 0.0147488226410386, -0.0113705309052728, -0.0150660618718171, 0.00600874467154933, 0.0140627425075149, -0.00174040558057665, -0.0121865644117635, -0.00139823865832503, 0.00983285937836247, 0.00345727985864367, -0.00733691211923136, -0.00455803533665138, 0.00496287622449412, 0.00487097350981681, -0.00289915450301594, -0.00459335597324047, 0.00125893533211074, 0.00392762347821018, -8.62725214973905e-05, -0.00306249654401996, -0.000633087020788478, 0.00215830699134156, 0.000957543927318803, -0.00133747123832419, -0.000973879377410332, 0.000680353834824281, 0.000781626029320044, -0.000226160883563182, -0.000479127624786432, -2.20123054012747e-05, 0.000152412406477518, 8.89995757707986e-05, 0.000131957627239177, -1.84374142285765e-05, -0.000331057668557778, -0.000137467838420379, 0.000425407967870852, 0.000326578104854307, -0.000416271406422977, -0.000503825995204774, 0.000320845194620049, 0.000635864008017497, -0.000166384301618614, -0.000703228336453902, -1.57980533236122e-05, 0.0007002120212925, 0.000195654944186431, -0.000632902559924025, -0.000348488553042308, 0.000515991139965087, 0.000457481956518538, -0.000369018416426278, -0.000514635433840056, 0.000212671446175584, 0.00052026805596571, -6.56785883501209e-05, -0.00048153083533375, -5.75617203263265e-05, 0.00041006383426265, 0.000148101234438772, -0.000319634132913426, -0.000202707525832298, 0.000223842467853674, 0.000223231707413481, -0.000134306205056025, -0.000215382165368828, 5.94738872977819e-05, 0.000187192149427276, -4.11988492941881e-06, -0.000147462039044046, -3.05417822389158e-05, 0.000104405186187604, 4.62618530987209e-05, -6.46545961029588e-05, -4.6862336568477e-05, 3.27016483734519e-05, 3.72348063680038e-05, -1.07627144658563e-05, -2.24038754539479e-05, -1.00568276595241e-06, 6.75786427495104e-06, 4.00816779990794e-06, 6.41598042358196e-06, -6.34775211606731e-07, -1.51630343053798e-05, -6.35774541616107e-06, 1.8820361840215e-05, 1.43667632087368e-05, -1.77907027055151e-05, -2.13176717945137e-05, 1.32048470152478e-05, 2.58651740895228e-05, -6.55092204153851e-06, -2.74301756351097e-05, -6.635332196774e-07, 2.6104136561553e-05, 7.16993391498544e-06, -2.24676380665025e-05, -1.20947220588679e-05, 1.7372569768772e-05, 1.50114934158484e-05, -1.17328814234578e-05, -1.59062103558088e-05, 6.35486564203859e-06, 1.50786524338076e-05, -1.83214092103956e-06, -1.3021295240213e-05, -1.50387107353356e-06, 1.02898691170899e-05, 3.5722846504364e-06, -7.39848681505549e-06, -4.49299517091288e-06, 4.74797755408055e-06, 4.51552811474408e-06, -2.59199261221921e-06, -3.94449669341148e-06, 1.0370503001137e-06, 3.07556732594924e-06, -6.77370572592208e-08, -2.1505805167364e-06, -4.14159729529704e-07, 1.33466425117544e-06, 5.47346136364436e-07, -7.13516353637049e-07, -4.74191170936075e-07, 3.05634437201223e-07, 3.14547551704175e-07, -8.3046659925011e-08, -1.52285677682316e-07, -6.30102226167187e-09, 3.27498410738376e-08, 1.86286930170424e-08, 3.09352878404784e-08, -7.9388720251083e-10, -4.73241630972246e-08, -1.64778017504831e-08}
    COEFFICIENT_WIDTH 24
    QUANTIZATION Quantize_Only
    BESTPRECISION true
    FILTER_TYPE Interpolation
    INTERPOLATION_RATE 2
    NUMBER_PATHS 2
    RATESPECIFICATION Input_Sample_Period
    SAMPLEPERIOD 2500
    OUTPUT_ROUNDING_MODE Truncate_LSBs
    OUTPUT_WIDTH 25
  } {
    S_AXIS_DATA comb_0/M_AXIS
    aclk /ps_0/FCLK_CLK0
  }

  # Create axis_broadcaster
  cell xilinx.com:ip:axis_broadcaster:1.1 bcast_1 {
    S_TDATA_NUM_BYTES.VALUE_SRC USER
    M_TDATA_NUM_BYTES.VALUE_SRC USER
    S_TDATA_NUM_BYTES 8
    M_TDATA_NUM_BYTES 3
    M00_TDATA_REMAP {tdata[55:32]}
    M01_TDATA_REMAP {tdata[23:0]}
  } {
    S_AXIS fir_0/M_AXIS_DATA
    aclk /ps_0/FCLK_CLK0
    aresetn /rst_0/peripheral_aresetn
  }

  # Create cic_compiler
  cell xilinx.com:ip:cic_compiler:4.0 cic_0 {
    INPUT_DATA_WIDTH.VALUE_SRC USER
    FILTER_TYPE Interpolation
    NUMBER_OF_STAGES 6
    FIXED_OR_INITIAL_RATE 1250
    INPUT_SAMPLE_FREQUENCY 0.1
    CLOCK_FREQUENCY 125
    INPUT_DATA_WIDTH 24
    QUANTIZATION Truncation
    OUTPUT_DATA_WIDTH 24
    USE_XTREME_DSP_SLICE false
  } {
    S_AXIS_DATA bcast_1/M00_AXIS
    aclk /ps_0/FCLK_CLK0
  }

  # Create cic_compiler
  cell xilinx.com:ip:cic_compiler:4.0 cic_1 {
    INPUT_DATA_WIDTH.VALUE_SRC USER
    FILTER_TYPE Interpolation
    NUMBER_OF_STAGES 6
    FIXED_OR_INITIAL_RATE 1250
    INPUT_SAMPLE_FREQUENCY 0.1
    CLOCK_FREQUENCY 125
    INPUT_DATA_WIDTH 24
    QUANTIZATION Truncation
    OUTPUT_DATA_WIDTH 24
    USE_XTREME_DSP_SLICE false
  } {
    S_AXIS_DATA bcast_1/M01_AXIS
    aclk /ps_0/FCLK_CLK0
  }

  # Create axis_combiner
  cell  xilinx.com:ip:axis_combiner:1.1 comb_1 {
    TDATA_NUM_BYTES.VALUE_SRC USER
    TDATA_NUM_BYTES 3
  } {
    S00_AXIS cic_0/M_AXIS_DATA
    S01_AXIS cic_1/M_AXIS_DATA
    aclk /ps_0/FCLK_CLK0
    aresetn /rst_0/peripheral_aresetn
  }

  # Create axis_constant
  cell pavel-demin:user:axis_constant:1.0 phase_0 {
    AXIS_TDATA_WIDTH 32
  } {
    cfg_data /cfg_slice_1/Dout
    aclk /ps_0/FCLK_CLK0
  }

  # Create dds_compiler
  cell xilinx.com:ip:dds_compiler:6.0 dds_0 {
    DDS_CLOCK_RATE 125
    SPURIOUS_FREE_DYNAMIC_RANGE 138
    FREQUENCY_RESOLUTION 0.2
    PHASE_INCREMENT Streaming
    DSP48_USE Maximal
    HAS_TREADY true
    HAS_PHASE_OUT false
    PHASE_WIDTH 30
    OUTPUT_WIDTH 24
    DSP48_USE Minimal
  } {
    S_AXIS_PHASE phase_0/M_AXIS
    aclk /ps_0/FCLK_CLK0
  }

  # Create axis_lfsr
  cell pavel-demin:user:axis_lfsr:1.0 lfsr_0 {} {
    aclk /ps_0/FCLK_CLK0
    aresetn /rst_slice_2/Dout
  }

  # Create cmpy
  cell xilinx.com:ip:cmpy:6.0 mult_0 {
    FLOWCONTROL Blocking
    APORTWIDTH.VALUE_SRC USER
    BPORTWIDTH.VALUE_SRC USER
    APORTWIDTH 24
    BPORTWIDTH 24
    ROUNDMODE Random_Rounding
    OUTPUTWIDTH 17
  } {
    S_AXIS_A comb_1/M_AXIS
    S_AXIS_B dds_0/M_AXIS_DATA
    S_AXIS_CTRL lfsr_0/M_AXIS
    aclk /ps_0/FCLK_CLK0
  }
}
