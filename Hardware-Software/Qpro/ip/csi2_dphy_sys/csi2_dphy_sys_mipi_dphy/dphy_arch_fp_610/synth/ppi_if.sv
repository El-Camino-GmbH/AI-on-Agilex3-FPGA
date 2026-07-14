// (C) 2001-2025 Altera Corporation. All rights reserved.
// Your use of Altera Corporation's design tools, logic functions and other 
// software and tools, and its AMPP partner logic functions, and any output 
// files from any of the foregoing (including device programming or simulation 
// files), and any associated documentation or information are expressly subject 
// to the terms and conditions of the Altera Program License Subscription 
// Agreement, Altera IP License Agreement, or other applicable 
// license agreement, including, without limitation, that your use is for the 
// sole purpose of programming logic devices manufactured by Altera and sold by 
// Altera or its authorized distributors.  Please refer to the applicable 
// agreement for further details.



interface ppi_if_lane;

    logic TxWordClkHS;
    logic [1:0] TxDataWidthHS ;
    logic [31:0] TxDataHS ;
    logic [3:0] TxWordValidHS ;
    logic TxEqActiveHS;
    logic TxEqLevelHS;
    logic TxRequestHS;
    logic TxReadyHS;
    logic TxDataTransferEnHS;
    logic TxSkewCalHS;
    logic TxAlternateCalHS;

    logic TxClkEsc;
    logic TxRequestEsc;
    logic [3:0]  TxRequestTypeEsc;
    logic TxLpdtEsc;
    logic TxUlpsExit;
    logic TxUlpsEsc;
    logic [3:0] TxTriggerEsc;
    logic [7:0] TxDataEsc;
    logic TxValidEsc;
    logic TxReadyEsc;

    logic RxSRst_n;

    logic RxWordClkHS;
    logic [1:0]  RxDataWidthHS;
    logic [31:0] RxDataHS;
    logic [3:0]  RxValidHS;
    logic RxActiveHS;
    logic RxSyncHS;
    logic RxDetectEobHS;
    logic RxClkActiveHS;
    logic RxDDRClkHS;
    logic RxSkewCalHS;
    logic RxAlternateCalHS;
    logic RxErrorCalHS;

    logic RxClkEsc;
    logic RxLpdtEsc;
    logic RxUlpsEsc;
    logic [3:0] RxTriggerEsc;
    logic RxWakeup;
    logic [7:0]  RxDataEsc;
    logic RxValidEsc;

    logic ErrSotHS;
    logic ErrSotSyncHS;
    logic ErrEsc;
    logic ErrSyncEsc;
    logic ErrControl;
    logic ErrContentionLP0;
    logic ErrContentionLP1;  

    logic TurnRequest;
    logic Direction;
    logic TurnDisable;
    logic ForceRxmode;
    logic ForceTxStopmode;
    logic Stopstate;
    logic Stopstate_fr;
    logic Enable;
    logic AlpMode;
    logic TxUlpsClk;
    logic RxUlpsClkNot;
    logic UlpsActiveNot;
    logic TxHSIdleClkHS;
    logic TxHSIdleClkReadyHS;

endinterface : ppi_if_lane

interface ppi_if #(
    parameter NUM_LANES = 4
    ) ;


    logic [NUM_LANES:0] TxWordClkHS;
    logic [NUM_LANES:0] [1:0] TxDataWidthHS ;
    logic [NUM_LANES:0] [31:0] TxDataHS ;
    logic [NUM_LANES:0] [3:0] TxWordValidHS ;
    logic [NUM_LANES:0] TxEqActiveHS;
    logic [NUM_LANES:0] TxEqLevelHS;
    logic [NUM_LANES:0] TxRequestHS;
    logic [NUM_LANES:0] TxReadyHS;
    logic [NUM_LANES:0] TxDataTransferEnHS;
    logic [NUM_LANES:0] TxSkewCalHS;
    logic [NUM_LANES:0] TxAlternateCalHS;

    logic [NUM_LANES:0] TxClkEsc;
    logic [NUM_LANES:0] TxRequestEsc;
    logic [NUM_LANES:0] [3:0]  TxRequestTypeEsc;
    logic [NUM_LANES:0] TxLpdtEsc;
    logic [NUM_LANES:0] TxUlpsExit;
    logic [NUM_LANES:0] TxUlpsEsc;
    logic [NUM_LANES:0] [3:0] TxTriggerEsc;
    logic [NUM_LANES:0] [7:0] TxDataEsc;
    logic [NUM_LANES:0] TxValidEsc;
    logic [NUM_LANES:0] TxReadyEsc;

    logic [NUM_LANES:0] RxSRst_n;
    logic [NUM_LANES:0] RxWordClkHS;
    logic [NUM_LANES:0] [1:0]  RxDataWidthHS;
    logic [NUM_LANES:0] [31:0] RxDataHS;
    logic [NUM_LANES:0] [3:0]  RxValidHS;
    logic [NUM_LANES:0] RxActiveHS;
    logic [NUM_LANES:0] RxSyncHS;
    logic [NUM_LANES:0] RxDetectEobHS;
    logic [NUM_LANES:0] RxClkActiveHS;
    logic [NUM_LANES:0] RxDDRClkHS;
    logic [NUM_LANES:0] RxSkewCalHS;
    logic [NUM_LANES:0] RxAlternateCalHS;
    logic [NUM_LANES:0] RxErrorCalHS;

    logic [NUM_LANES:0] RxClkEsc;
    logic [NUM_LANES:0] RxLpdtEsc;
    logic [NUM_LANES:0] RxUlpsEsc;
    logic [NUM_LANES:0] [3:0] RxTriggerEsc;
    logic [NUM_LANES:0] RxWakeup;
    logic [NUM_LANES:0] [7:0]  RxDataEsc;
    logic [NUM_LANES:0] RxValidEsc;

    logic [NUM_LANES:0] ErrSotHS;
    logic [NUM_LANES:0] ErrSotSyncHS;
    logic [NUM_LANES:0] ErrEsc;
    logic [NUM_LANES:0] ErrSyncEsc;
    logic [NUM_LANES:0] ErrControl;
    logic [NUM_LANES:0] ErrContentionLP0;
    logic [NUM_LANES:0] ErrContentionLP1;  

    logic [NUM_LANES:0] TurnRequest;
    logic [NUM_LANES:0] Direction;
    logic [NUM_LANES:0] TurnDisable;
    logic [NUM_LANES:0] ForceRxmode;
    logic [NUM_LANES:0] ForceTxStopmode;
    logic [NUM_LANES:0] Stopstate;
    logic [NUM_LANES-1:0] Stopstate_fr;
    logic [NUM_LANES:0] Enable;
    logic [NUM_LANES:0] AlpMode;
    logic [NUM_LANES:0] TxUlpsClk;
    logic [NUM_LANES:0] RxUlpsClkNot;
    logic [NUM_LANES:0] UlpsActiveNot;
    logic [NUM_LANES:0] TxHSIdleClkHS;
    logic [NUM_LANES:0] TxHSIdleClkReadyHS;


/*
   modport ppi_protocol_rx (
        input  RxWordClkHS,
        output RxDataWidthHS,
        input  RxDataHS,
        input  RxValidHS,
        input  RxActiveHS,
        input  RxSyncHS,
        output RxDetectEobHS,
        input  RxClkActiveHS,
        input  RxDDRClkHS,
        input  RxSkewCalHS,
        input  RxAlternateCalHS,
        input  RxErrorCalHS,

        input  RxClkEsc,
        input  RxLpdtEsc,
        input  RxUlpsEsc,
        input  RxTriggerEsc,
        input  RxWakeup,
        input  RxDataEsc,
        input  RxValidEsc,

        output TurnRequest,
        input  Direction,
        output TurnDisable,
        output ForceRxmode,
        output ForceTxStopmode,
        input  Stopstate,
        output Enable,
        output AlpMode,
        output TxUlpsClk,
        input  RxUlpsClkNot,
        input  UlpsActiveNot,
        output TxHSIdleClkHS,
        input  TxHSIdleClkReadyHS,
        
        input  ErrSotHS,
        input  ErrSotSyncHS,
        input  ErrEsc,
        input  ErrSyncEsc,
        input  ErrControl,
        input  ErrContentionLP0,
        input  ErrContentionLP1                      );

   modport ppi_dphy_rx (
        output RxWordClkHS,
        input  RxDataWidthHS,
        output RxDataHS,
        output RxValidHS,
        output RxActiveHS,
        output RxSyncHS,
        input  RxDetectEobHS,
        output RxClkActiveHS,
        output RxDDRClkHS,
        output RxSkewCalHS,
        output RxAlternateCalHS,
        output RxErrorCalHS,

        output RxClkEsc,
        output RxLpdtEsc,
        output RxUlpsEsc,
        output RxTriggerEsc,
        output RxWakeup,
        output RxDataEsc,
        output RxValidEsc,

        input  TurnRequest,
        output Direction,
        input  TurnDisable,
        input  ForceRxmode,
        input  ForceTxStopmode,
        output Stopstate,
        input  Enable,
        input  AlpMode,
        input  TxUlpsClk,
        output RxUlpsClkNot,
        output UlpsActiveNot,
        input  TxHSIdleClkHS,
        output TxHSIdleClkReadyHS,
        
        output ErrSotHS,
        output ErrSotSyncHS,
        output ErrEsc,
        output ErrSyncEsc,
        output ErrControl,
        output ErrContentionLP0,
        output ErrContentionLP1                   
    );

    modport ppi_protocol_tx (
        input  TxWordClkHS,
        output TxDataWidthHS,
        output TxDataHS,
        output TxWordValidHS,
        output TxEqActiveHS,
        output TxEqLevelHS,
        output TxRequestHS,
        input  TxReadyHS,
        output TxDataTransferEnHS,
        output TxSkewCalHS,
        output TxAlternateCalHS,
        
        output TxClkEsc,
        output TxRequestEsc,
        output TxRequestTypeEsc,
        output TxLpdtEsc,
        output TxUlpsExit,
        output TxUlpsEsc,
        output TxTriggerEsc,
        output TxDataEsc,
        output TxValidEsc,
        input  TxReadyEsc,

        output TurnRequest,
        input  Direction,
        output TurnDisable,
        output ForceRxmode,
        output ForceTxStopmode,
        input  Stopstate,
        output Enable,
        output AlpMode,
        output TxUlpsClk,
        input  RxUlpsClkNot,
        input  UlpsActiveNot,
        output TxHSIdleClkHS,
        input  TxHSIdleClkReadyHS,
 
        input  ErrSotHS,
        input  ErrSotSyncHS,
        input  ErrEsc,
        input  ErrSyncEsc,
        input  ErrControl,
        input  ErrContentionLP0,
        input  ErrContentionLP1                   
    );

    modport ppi_dphy_tx (
        output TxWordClkHS,
        input  TxDataWidthHS,
        input  TxDataHS,
        input  TxWordValidHS,
        input  TxEqActiveHS,
        input  TxEqLevelHS,
        input  TxRequestHS,
        output TxReadyHS,
        input  TxDataTransferEnHS,
        input  TxSkewCalHS,
        input  TxAlternateCalHS,
        
        input  TxClkEsc,
        input  TxRequestEsc,
        input  TxRequestTypeEsc,
        input  TxLpdtEsc,
        input  TxUlpsExit,
        input  TxUlpsEsc,
        input  TxTriggerEsc,
        input  TxDataEsc,
        input  TxValidEsc,
        output TxReadyEsc,

        input  TurnRequest,
        output Direction,
        input  TurnDisable,
        input  ForceRxmode,
        input  ForceTxStopmode,
        output Stopstate,
        input  Enable,
        input  AlpMode,
        input  TxUlpsClk,
        output RxUlpsClkNot,
        output UlpsActiveNot,
        input  TxHSIdleClkHS,
        output TxHSIdleClkReadyHS,
 
        output ErrSotHS,
        output ErrSotSyncHS,
        output ErrEsc,
        output ErrSyncEsc,
        output ErrControl,
        output ErrContentionLP0,
        output ErrContentionLP1                   
    );

   modport ppi_protocol (
        input  TxWordClkHS,
        output TxDataWidthHS,
        output TxDataHS,
        output TxWordValidHS,
        output TxEqActiveHS,
        output TxEqLevelHS,
        output TxRequestHS,
        input  TxReadyHS,
        output TxDataTransferEnHS,
        output TxSkewCalHS,
        output TxAlternateCalHS,
        
        input  RxWordClkHS,
        output RxDataWidthHS,
        input  RxDataHS,
        input  RxValidHS,
        input  RxActiveHS,
        input  RxSyncHS,
        output RxDetectEobHS,
        input  RxClkActiveHS,
        input  RxDDRClkHS,
        input  RxSkewCalHS,
        input  RxAlternateCalHS,
        input  RxErrorCalHS,

        output TxClkEsc,
        output TxRequestEsc,
        output TxRequestTypeEsc,
        output TxLpdtEsc,
        output TxUlpsExit,
        output TxUlpsEsc,
        output TxTriggerEsc,
        output TxDataEsc,
        output TxValidEsc,
        input  TxReadyEsc,

        input  RxClkEsc,
        input  RxLpdtEsc,
        input  RxUlpsEsc,
        input  RxTriggerEsc,
        input  RxWakeup,
        input  RxDataEsc,
        input  RxValidEsc,

        output TurnRequest,
        input  Direction,
        output TurnDisable,
        output ForceRxmode,
        output ForceTxStopmode,
        input  Stopstate,
        output Enable,
        output AlpMode,
        output TxUlpsClk,
        input  RxUlpsClkNot,
        input  UlpsActiveNot,
        output TxHSIdleClkHS,
        input  TxHSIdleClkReadyHS,
        
        input  ErrSotHS,
        input  ErrSotSyncHS,
        input  ErrEsc,
        input  ErrSyncEsc,
        input  ErrControl,
        input  ErrContentionLP0,
        input  ErrContentionLP1                      );

   modport ppi_dphy (
        output TxWordClkHS,
        input  TxDataWidthHS,
        input  TxDataHS,
        input  TxWordValidHS,
        input  TxEqActiveHS,
        input  TxEqLevelHS,
        input  TxRequestHS,
        output TxReadyHS,
        input  TxDataTransferEnHS,
        input  TxSkewCalHS,
        input  TxAlternateCalHS,
        
        output RxWordClkHS,
        input  RxDataWidthHS,
        output RxDataHS,
        output RxValidHS,
        output RxActiveHS,
        output RxSyncHS,
        input  RxDetectEobHS,
        output RxClkActiveHS,
        output RxDDRClkHS,
        output RxSkewCalHS,
        output RxAlternateCalHS,
        output RxErrorCalHS,

        input  TxClkEsc,
        input  TxRequestEsc,
        input  TxRequestTypeEsc,
        input  TxLpdtEsc,
        input  TxUlpsExit,
        input  TxUlpsEsc,
        input  TxTriggerEsc,
        input  TxDataEsc,
        input  TxValidEsc,
        output TxReadyEsc,

        output RxClkEsc,
        output RxLpdtEsc,
        output RxUlpsEsc,
        output RxTriggerEsc,
        output RxWakeup,
        output RxDataEsc,
        output RxValidEsc,

        input  TurnRequest,
        output Direction,
        input  TurnDisable,
        input  ForceRxmode,
        input  ForceTxStopmode,
        output Stopstate,
        input  Enable,
        input  AlpMode,
        input  TxUlpsClk,
        output RxUlpsClkNot,
        output UlpsActiveNot,
        input  TxHSIdleClkHS,
        output TxHSIdleClkReadyHS,
        
        output ErrSotHS,
        output ErrSotSyncHS,
        output ErrEsc,
        output ErrSyncEsc,
        output ErrControl,
        output ErrContentionLP0,
        output ErrContentionLP1                   
    );
*/

endinterface : ppi_if
`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "60+GolBF4e0rvdeG/kIwDjQE8YQaMEf9cB77u5eoEPi+os0BRm+rCGEK2A1bynYoItBfSieViOAv4oB/JBRU+AJ2r1o752Un8eBHcDcOjw99DeQKgMgO9Xy7rhYRJoTunu2j3fSlgA3aTbhDW63+KkrlHI5JnPn7AUjHCre9m07ArQiacCy1U7t5UdtwqvYvRShv68C/oXPCqv4t0VW3TN7GIrto8WtDVb8oKvFM0t8BKRCWmaOww4crm1QB5wsO4flNLPakXQm4aur7mgo+m1QicnSvuSDN9SHCBe5sl49fncP0QTvXtfLzKU0BN5S+EAaf1bFzI3jbF8ykUn59diQod6U2qmyXji8QLFh3GQ2cnHRPyBJ33KUK7+eN8knOeaFrss+ZMtdeY/nWqm6ptNRevSwCzcRe7MWaCssaUv8Z29OiUYwn3qe2KzBLtDrEjOHhEtt/l2Jt4AzPUI+3w4e5GW8NcDofhAo4t9oOQRB6qB8XzVcacvPaCuiu64z2gihFzGhih3Q0qaX3IFBWawM2ntkkr4ouYCqoFif6KN3txn+NEiNRX5gqUiOLcoBFeFDV7WZ0QiKnsnoYK/owF0fiZWYQx+njhDg0RRsFROLxHfrRbl7xxkmCJj6vdYv9CyxdpZwTujUKioe9b81oreL2JmioFeXN1Pr0uCGH/9s/aTkiEJfzL4x33oLuQ2U8QXAYFuWbAHoty4gPjMWoFhZ59FVaO9XnrUrpvUtU6LoHHt/NSqdR54nQtCkyc/Wd5V28vWsQrbUOHUwyTJxfakZ6jxI2w59ThEWeXt5jc9ulSqwZTp7DlQ6dNL4XOFm7EeHlBEN5ux+ELvKoO91D32GkALQie75W+Hp2lapVPVgKXHpb6LV1t3ennCphictb7uFYEiXws0jhw7pDaobdH5rlqqW/JmEA5WzZskZj/kVYWuaY9yw75Kw8zsg3HNopztEar4sw5Q9WnJX5+UxqzzediBulszPUrMbL4RSNMlznn9Un0/yH1kaAO7ael716"
`endif