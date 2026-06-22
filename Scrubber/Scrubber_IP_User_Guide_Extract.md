# Scrubber IP User Guide Extract

Source: UniVista DDR/LPDDR Combo Controller User Guide, Chapter 2, Section 2.14 and Section 2.16.2.4 screenshots provided in this thread.

Note: This is a local working extract for verification planning. Some text is normalized from the screenshots for readability.

## 2.14 Scrubber

The Scrubber performs periodic scrubbing on DRAM and can issue RMW commands to update SDRAM when correctable errors are detected.

## 2.14.1 Correctable Error Fix

The Scrubber receives correctable error information from RDP and issues an RMW command to the error address. The single-bit error is corrected by the write part of the RMW command and written back to DRAM.

This feature takes effect when:

- `csrScbrEn = 1` and `csrScbrPeriod != 0`
- or `csrScbrMode = 2'b10`

In `csrScbrMode = 2'b10`, the scrubber only sends FIX RMW commands and does not send periodic scrubbing commands.

If `scbr_fifo_full_itr` is asserted, it indicates that a large number of single-bit errors have occurred recently.

## 2.14.2 Trigger Scrubbing In CQ Idle

The controller is considered idle when the command queue is empty. When this condition is detected, an internal counter loads the value programmed by `csrScbrCtrlIdleCnt` and counts down on each controller clock.

When the counter expires, either the scrubbing operation begins or the next address is tested. The controller clock is based on the controller operating frequency.

Configuring `csrScbrCtrlIdleCnt = 16'h0000` disables the idle-trigger operation.

## 2.14.3 Periodic Scrubbing

The Scrubber can be configured to periodically scrub memory to catch single-bit errors before they become multi-bit errors.

Periodic scrubbing supports three modes:

- Initialization Write
- Periodic RD
- Periodic RMW

### 2.14.3.1 Initialization Write

Initialization Write is used to fill write data in the configured area and fill ECC code in the corresponding ECC area. The write data is processed by WDP when the system is powered on.

This prevents unfilled data areas from continuously producing uncorrectable errors.

Before Initialization Write, software sets `csrScbrPeriod = 0` and issues WR commands back-to-back to complete initialization quickly.

Table 2-46, Initialization Write Programming Sequence:

| Step | Action | Name | Value | Description |
| :--- | :--- | :--- | :--- | :--- |
| 1 | Write | `csrScbrStartAddr0/1` | Expected start address | Configure the start address. |
| 2 | Write | `csrScbrEndAddr0/1` | Expected end address | Configure the end address. |
| 3 | Write | `csrScbrPeriod` | `8'h00` | Send Initialization WR commands back-to-back. |
| 4 | Write | `csrScbrMode` | `2'h1` | Set mode to Init WR. |
| 5 | Write | `csrScbrEn` | `1'h1` | Enable scrubber. |
| 6 | Read | `csrScbrRoundDone` | - | If `1'b1`, go to Step 8. If `1'b0`, go to Step 7. |
| 7 | Read | `csrScbrAddrRangeStatus` | - | Identify the cause of the configuration error. |
| 8 | Write | `csrScbrEn` | `1'h0` | Disable scrubber. |

### 2.14.3.2 Periodic RD

Periodic Read is typically used for data scrubbing.

Before Periodic RD, software should set `csrScbrPeriod` to a value other than `8'h00`. This prevents scrubbing commands from continuously occupying DDRCTL and affecting overall system efficiency.

When `csrScbrPeriod = 8'h00`, even if RDP detects a correctable error, the data in SDRAM cannot be corrected. This is because periodic scrubbing commands are continuously sent, preventing the RMW command from being sent for error correction.

If the goal is to complete scrubbing of the area as soon as possible, `csrScbrPeriod` can be set to `8'h00`.

Table 2-47, Periodic RD Programming Sequence:

| Step | Action | Name | Value | Description |
| :--- | :--- | :--- | :--- | :--- |
| 1 | Write | `csrScbrStartAddr0/1` | Expected start address | Configure the start address. |
| 2 | Write | `csrScbrEndAddr0/1` | Expected end address | Configure the end address. |
| 3 | Write | `csrScbrPeriod` | Config | Configure the period of scrubbing. |
| 4 | Write | `csrScbrMode` | `2'h0` | Set mode to Periodic RD. |
| 5 | Write | `csrScbrEn` | `1'h1` | Enable scrubber. |
| 6 | Read | `csrScbrRoundDone` | - | If `1'b1`, go to Step 8. If `1'b0`, go to Step 7. |
| 7 | Read | `csrScbrAddrRangeStatus` | - | Identify the cause of the configuration error. |
| 8 | Write | `csrScbrEn` | `1'h0` | Disable scrubber. |

### 2.14.3.3 Periodic RMW

Periodic RMW is usually used to correct data errors directly. If a certain region has more errors, software can configure the scrubber to scrub that region using RMW commands.

Periodic RMW should be avoided for normal scrubbing because RMW commands continuously consume CQ. Periodic RMW is less efficient than Periodic RD when no errors occur.

Before Periodic RMW, software should set `csrScbrPeriod`. This value is usually not set to `8'h00`, to prevent scrubbing commands from continuously occupying DDRCTL and affecting overall system efficiency.

When `csrScbrPeriod = 8'h00`, even if RDP detects a correctable error, the data in SDRAM cannot be corrected. This is because periodic scrubbing commands are continuously sent and the FIX RMW command for 1-bit error correction cannot be sent.

If the goal is to complete scrubbing of the area as soon as possible, `csrScbrPeriod` can be set to `8'h00`.

Table 2-48, Periodic RMW Programming Sequence:

| Step | Action | Name | Value | Description |
| :--- | :--- | :--- | :--- | :--- |
| 1 | Write | `csrScbrStartAddr0/1` | Expected start address | Configure the start address. |
| 2 | Write | `csrScbrEndAddr0/1` | Expected end address | Configure the end address. |
| 3 | Write | `csrScbrPeriod` | Config | Configure the period of scrubbing. |
| 4 | Write | `csrScbrMode` | `2'h3` | Set mode to Periodic RMW. |
| 5 | Write | `csrScbrEn` | `1'h1` | Enable scrubber. |
| 6 | Read | `csrScbrRoundDone` | - | If `1'b1`, go to Step 8. If `1'b0`, go to Step 7. |
| 7 | Read | `csrScbrAddrRangeStatus` | - | Identify the cause of the configuration error. |
| 8 | Write | `csrScbrEn` | `1'h0` | Disable scrubber. |

## 2.14.4 Scrubber Related Registers

Table 2-49, Scrubber CSRs:

| Field Name | Range | Default | Description |
| :--- | :--- | :--- | :--- |
| `ScrbEn` | `0x0-0x1` | `0x0` | Enable Scrubber or not. |
| `ScrbStartAddr0[31:0]` | `0x00000000-0xFFFFFFFF` | `0x0` | UIF Start Address `[31:0]`. |
| `ScrbStartAddr1[3:0]` | `0x0-0xF` | `0x0` | UIF Start Address `[35:32]`. |
| `ScrbEndAddr0[31:0]` | `0x00000000-0xFFFFFFFF` | `0x0` | UIF End Address `[31:0]`. |
| `ScrbEndAddr1[3:0]` | `0x0-0xF` | `0x0` | UIF End Address `[35:32]`. |
| `ScrbMode[1:0]` | `0x0-0x3` | `0x0` | Indicates Scrubber mode. |
| `ScrbPeriod[7:0]` | `0x00-0xFF` | `0x0` | Indicates the period of periodic scrubbing. |
| `ScrbError` | `0x0-0x1` | `0x0` | Error occurred during scrubber configuration. |
| `ScrbState[7:0]` | `0x00-0x80` | `0x00` | Scrubber FSM state. |
| `ScrbAddrRangeStatus[2:0]` | `0x0-0x7` | `0x0` | Address range status. |
| `ScrbFixRmwFifoFull` | `0x0-0x1` | `0x0` | The FIFO that buffers error-correcting requests from RDP is full. |
| `ScrbRoundDone` | `0x0-0x1` | `0x0` | Scrubber has finished a round of scrubbing or not. |
| `ScrbWdata0[31:0]` | `0x00000000-0xFFFFFFFF` | `0x0` | Write data `[31:0]` for Initialization Write mode. |
| `ScrbWdata1[31:0]` | `0x00000000-0xFFFFFFFF` | `0x0` | Write data `[63:32]` for Initialization Write mode. |

`ScrbMode[1:0]` encoding:

| Value | Mode |
| :--- | :--- |
| `2'h0` | Periodic RD |
| `2'h1` | Initialization Write |
| `2'h2` | Only send FIX RMW mode |
| `2'h3` | Periodic RMW |

`ScrbPeriod[7:0]` behavior:

- If `ScrbPeriod == 0`, commands are sent back-to-back.
- If `ScrbPeriod != 0`, commands are sent at an interval of `ScrbPeriod * 512`.
- Eight periodic scrubbing commands are issued after each interval.

`ScrbState[7:0]` encoding:

| Value | State |
| :--- | :--- |
| `8'b00000001` | IDLE |
| `8'b00000010` | Scrubber Initialization |
| `8'b00000100` | Sending Periodic Scrubbing commands |
| `8'b00001000` | Sending Fix 1-bit error RMW command |
| `8'b00010000` | Waiting Period |
| `8'b00100000` | Error |
| `8'b01000000` | Initialization Write End |
| `8'b10000000` | Hold |

`ScrbAddrRangeStatus[2:0]` from the screenshots:

| Bit | Description |
| :--- | :--- |
| `[0]` | Reserved. |
| `[1]` | `{ScrbStartAddr1, ScrbStartAddr0} > {ScrbEndAddr1, ScrbEndAddr0}` if this bit is `1'b1`. |
| `[2]` | Reserved. |

## 2.16.2.4 Scrubber Retry Behavior

Scrubber supports enable through `csrScbrEn`. However, SCBR read commands may not be retried properly. This does not affect the normal function of SCBR and does not cause system hang.

When `Alert_n` is pulled low, all SCBR read commands in RCQ are marked as needing retry. During the low period of `Alert_n` and the recovery phase, all SCBR read data is discarded.

Scenario 1, Data1 outside the retry window is discarded:

- If `Cmd1` is outside the retry window and `Data1` returns after `Alert_n` is asserted, the data is discarded and no retry is triggered.
- This is equivalent to an invalid scrubber read at the corresponding address.
- This problem can be avoided by configuring `csrCaparRetryWindow`.

Scenario 2, already returned Data1 is still retried:

- If `Cmd1` is within the retry window and `Data1` returns before `Alert_n` is asserted, a retry is still performed.
- This is equivalent to executing two scrubber read operations on the same address.
- This problem can be avoided by configuring `csrRetryAddLat`.

## Alignment With Current RTL

Current RTL files:

- `scbr_top.v`
- `scbr_ctrl.v`
- `scbr_addr_gen.v`
- `scbr_addr_rev_map.v`

Current extracted RTL/macro alignment:

- `CTL_CMD_ADDR_W = 34` in the provided macro screenshots, while the user guide register table describes `ScrbStartAddr1[3:0]` and `ScrbEndAddr1[3:0]` as UIF address `[35:32]`. For this local RTL drop, the effective command address width is 34 bits, so only address bits `[33:32]` are consumed by `scbr_top/scbr_addr_gen`.
- `csrScbrMode = 2'h0` maps to `CTL_CMD_TYPE_RD`.
- `csrScbrMode = 2'h1` maps to `CTL_CMD_TYPE_WR` and is used as Initialization Write.
- `csrScbrMode = 2'h2` maps to `CTL_CMD_TYPE_MWR`; `scbr_ctrl` treats this as FIX RMW only mode and sends `CTL_CMD_TYPE_RMW` commands from the fix FIFO.
- `csrScbrMode = 2'h3` maps to `CTL_CMD_TYPE_RMW` and is used as Periodic RMW.
- The user guide lists only `ScrbPeriod`, but the local RTL also has `csrScbrRndInterval` and `csrScbrCtrlIdleCnt`.
- The screenshot lists `ScrbAddrRangeStatus[0]` and `[2]` as reserved. The local RTL assigns additional meanings for inline ECC range checking:
  - bit 2: endpoint is in ECC region
  - bit 1: start address exceeds end address
  - bit 0: selected range has no protected region

## Verification Planning Notes For seq/vseq

Recommended sequence groups:

1. Initialization Write sequence
   - Configure start/end.
   - Set `csrScbrPeriod = 0`.
   - Set `csrScbrMode = 2'h1`.
   - Enable scrubber.
   - Expect WR commands back-to-back.
   - Poll `csrScbrRoundDone` or `csrScbrState == WR_END`.

2. Periodic RD sequence
   - Configure start/end.
   - Set `csrScbrPeriod != 0` for normal operation.
   - Set `csrScbrMode = 2'h0`.
   - Enable scrubber.
   - Expect groups of 8 RD commands separated by `csrScbrPeriod * 512`.
   - Inject correctable error while period is nonzero and check FIX RMW can be scheduled.

3. Periodic RD fast-scan sequence
   - Same as Periodic RD, but set `csrScbrPeriod = 0`.
   - Expect back-to-back RD commands.
   - If injecting correctable errors, expect FIX RMW starvation risk described by the guide.

4. Periodic RMW sequence
   - Configure start/end.
   - Set `csrScbrPeriod != 0`.
   - Set `csrScbrMode = 2'h3`.
   - Enable scrubber.
   - Expect periodic RMW commands.
   - Use mainly for high-error regions, not baseline data scrub.

5. FIX RMW only sequence
   - Set `csrScbrMode = 2'h2`.
   - Enable scrubber.
   - Generate RDP correctable error requests.
   - Expect no periodic scrub commands and only FIX RMW commands from the FIFO.

6. CQ idle trigger sequence
   - Configure `csrScbrCtrlIdleCnt != 0`.
   - Make CQ non-idle first so the counter reloads.
   - Make CQ idle and wait until the counter expires.
   - Expect scrubber to start or test the next address earlier than the normal period timeout.
   - Configure `csrScbrCtrlIdleCnt = 0` and confirm idle trigger is disabled.

7. Address error sequence
   - Program start address greater than end address.
   - Enable scrubber.
   - Expect `csrScbrError = 1` and `ScrbAddrRangeStatus[1] = 1`.

8. FIX RMW FIFO full sequence
   - Generate many RDP correctable error requests quickly.
   - Expect `scbr_fifo_full_itr` and `ScrbFixRmwFifoFull` when the FIFO approaches/full condition occurs.

9. Hold/resume sequence
   - Assert `scbr_hold` in INIT, SEND_PERIODIC, WAIT_PERIODIC, and SEND_FIX.
   - Deassert hold.
   - Expect FSM to return to the saved expected state and continue.

10. Retry behavior sequence
    - Enable Periodic RD.
    - Create CA parity retry window scenarios with `Alert_n`.
    - Scenario 1: read data returns after `Alert_n` assertion outside retry window, expect data discard and no retry.
    - Scenario 2: read data returns before `Alert_n` assertion but command is within retry window, expect retry and duplicate scrub read behavior.
