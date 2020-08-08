RESULTS_START EQU $c000
RESULTS_N_ROWS EQU 2

SECTION "header-mbc-type", ROM0[$147]

MBCType::
    DB $10, $00, $03

include "base.inc"
include "delay.inc"

RTC_SECONDS EQU $08
RTC_MINUTES EQU $09
RTC_HOURS EQU $0A
RTC_DAYS_LOW EQU $0B
RTC_DAYS_HIGH EQU $0C

ONE_SECOND EQU 1048576
HALF_SECOND EQU 524288
TOLERANCE EQU 128

rLATCH EQU $6000

CorrectResults:


RunTest:
    ld hl, RESULTS_START

    ; with RAM disabled altogether
    ld a, RTC_SECONDS
    ld [rRAMB], a

    ld a, [$a000]
    ld [hli], a

    ; make sure the RTC is enabled
    ld a, $0a
    ld [rRAMG], a

    ld a, RTC_DAYS_HIGH
    ld [rRAMB], a
    xor a
    ld [$a000], a

    ; before any latching
    ld a, RTC_SECONDS
    ld [rRAMB], a

    ld a, $20
    ld [$a000], a
    ld a, [$a000]
    ld [hli], a

    ; write 0
    xor a
    ld [rLATCH], a

    ld a, [$a000]
    ld [hli], a

    ; write 1
    ld a, 1
    ld [rLATCH], a

    ld a, [$a000]
    ld [hli], a

    ; now, what happens when we write a 0 again?
    xor a
    ld [rLATCH], a

    ld a, [$a000]
    ld [hli], a

    ; does changing things in this state propagate immediately?
    ld a, $10
    ld [$a000], a
    ld a, [$a000]
    ld [hli], a

    delay ONE_SECOND + TOLERANCE
    ld a, [$a000]
    ld [hli], a

    ld a, 1
    ld [rLATCH], a
    ld a, [$a000]
    ld [hli], a

    ; does writing 1 without writing 0 do anything?
    ld a, $0e
    ld [$a000], a

    ld a, 1
    ld [rLATCH], a

    ld a, [$a000]
    ld [hli], a

    ; does changing the bank latch?
    ld a, $0c
    ld [$a000], a

    ld a, RTC_MINUTES
    ld [rRAMB], a

    ld a, RTC_SECONDS
    ld [rRAMB], a

    ld a, [$a000]
    ld [hli], a

    ; does reenabling the RAM latch?
    ld a, $18
    ld [$a000], a

    xor a
    ld [rRAMG], a
    ld a, $0a
    ld [rRAMG], a

    ld a, [$a000]
    ld [hli], a

    ; finish off the results row, we don't want to show uninit'd RAM
    xor a
    ld [hli], a
    ld [hli], a
    ld [hli], a
    ld [hli], a
    ld [hli], a

    ret
