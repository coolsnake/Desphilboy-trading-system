// simple trailing stop
#property copyright "Iman Dezfuly"
#property link      "http://www.Iman.ir"
#define version      "20180707"
#include "./desphilboy.mqh"

extern bool ManageAllPairs = true;
extern int TrailingStopUL = 1200, TrailingStopVL = 1100, TrailingStopL = 1000, TrailingStopM = 900,
TrailingStopS = 800, TrailingStopVS = 700, TrailingStopUS = 600, TrailingStopI = 500;

extern int TrailingStepUL = 80, TrailingStepVL = 80, TrailingStepL = 70, TrailingStepM = 70,
TrailingStepS = 70, TrailingStepVS = 60, TrailingStepUS = 60, TrailingStepI = 60;

extern FiboRetrace RetraceFactorUL = Retrace80, RetraceFactorVL = Retrace76, RetraceFactorL = Retrace74, RetraceFactorM = Retrace72,
RetraceFactorS = Retrace70, RetraceFactorVS = Retrace65, RetraceFactorUS = RetraceMax, RetraceFactorI = Retrace60;

extern LifeTimes TimeFrameUL = FiveDays, TimeFrameVL = FourDays, TimeFrameL = ThreeDays, TimeFrameM = TwoAndHalfDays,
TimeFrameS = TwoDays, TimeFrameVS = FourtyHours, TimeFrameUS = ThirtyHours, TimeFrameI = TwentyHours;
extern bool ContinueLifeTimeAfterFirstSL = true;
extern ENUM_TIMEFRAMES PanicTimeFrame = PERIOD_M15;
extern int PanicPIPS = 1000;
extern int PanicStop = 50;
extern FiboRetrace PanicRetrace = RetracePanic;
extern bool SpikeTrading = true;
extern int SpikeHeight = 1500;
extern Groups SpikeTradesGroup = UltraLongTerm;
extern ENUM_TIMEFRAMES SpikeTimeFrame = PERIOD_H1;

extern bool ActiveTrading = false;
extern int ActiveTradingGap = 2500;
extern Groups ActiveTradesGroup = UltraLongTerm;

extern int SpikeAndActiveTradeSpacing = 150;
extern int ActiveAndSpikeTradesDistance = 200;
extern double ActiveAndSpikeLots = 0.01;
extern int ActiveAndSpikeTradeStopLoss = 0;
extern int MaximumNetPositions = 3;
extern int MaximumAbsolutePositions = 6;

extern bool iARVHeuristic = true;
extern bool UnsafeNetPositionsHeuristic = true;
extern bool NetPositionsHeuristic = true;
extern bool ReserveOpositeForLoosingPositions=true;
extern bool HammerCandleHeuristic = true;
extern bool DodgyCandleHeuroistics = true;
extern bool PriceOverTimeHeuristic = true;
extern bool PriceCrossedHeuristic = true;
extern bool ConsecutiveProfitHeuristic = true;

extern string AccountPairNames = "USDJPY,GBPJPY,EURJPY,USDCAD,AUDUSD,XAUUSD";
extern string TimeParamsCoefficientsForPairs = "1.0,1.0,1.0,1.0,1.0,1.0";
extern string TrailingParamsCoefficientsForPairs = "1.0,1.0,1.0,1.0,1.0,1.0";
extern bool DeletePositionsOfOtherPairs = false;

extern int TimerSeconds = 10;
extern bool ShowLoopingSpeed = false;
extern bool verboseLogging = false;
extern bool ShowVolumeBallances = false;

long loopCounter = 0;
long speedCounter = 0;

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int fillTrailingInfo(int & tinfo[][]) {
    tinfo[gid_NoGroup][0] = tinfo[gid_NoGroup][1] = tinfo[gid_NoGroup][2] = tinfo[gid_NoGroup][3] = 0;

    tinfo[gid_UltraLongTerm][TrailingStop] = TrailingStopUL;
    tinfo[gid_UltraLongTerm][Step] = TrailingStepUL;
    tinfo[gid_UltraLongTerm][Retrace] = RetraceFactorUL;
    tinfo[gid_UltraLongTerm][LifePeriod] = TimeFrameUL;

    tinfo[gid_VeryLongTerm][TrailingStop] = TrailingStopVL;
    tinfo[gid_VeryLongTerm][Step] = TrailingStepVL;
    tinfo[gid_VeryLongTerm][Retrace] = RetraceFactorVL;
    tinfo[gid_VeryLongTerm][LifePeriod] = TimeFrameVL;

    tinfo[gid_LongTerm][TrailingStop] = TrailingStopL;
    tinfo[gid_LongTerm][Step] = TrailingStepL;
    tinfo[gid_LongTerm][Retrace] = RetraceFactorL;
    tinfo[gid_LongTerm][LifePeriod] = TimeFrameL;

    tinfo[gid_MediumTerm][TrailingStop] = TrailingStopM;
    tinfo[gid_MediumTerm][Step] = TrailingStepM;
    tinfo[gid_MediumTerm][Retrace] = RetraceFactorM;
    tinfo[gid_MediumTerm][LifePeriod] = TimeFrameM;

    tinfo[gid_ShortTerm][TrailingStop] = TrailingStopS;
    tinfo[gid_ShortTerm][Step] = TrailingStepS;
    tinfo[gid_ShortTerm][Retrace] = RetraceFactorS;
    tinfo[gid_ShortTerm][LifePeriod] = TimeFrameS;

    tinfo[gid_VeryShortTerm][TrailingStop] = TrailingStopVS;
    tinfo[gid_VeryShortTerm][Step] = TrailingStepVS;
    tinfo[gid_VeryShortTerm][Retrace] = RetraceFactorVS;
    tinfo[gid_VeryShortTerm][LifePeriod] = TimeFrameVS;

    tinfo[gid_UltraShortTerm][TrailingStop] = TrailingStopUS;
    tinfo[gid_UltraShortTerm][Step] = TrailingStepUS;
    tinfo[gid_UltraShortTerm][Retrace] = RetraceFactorUS;
    tinfo[gid_UltraShortTerm][LifePeriod] = TimeFrameUS;

    tinfo[gid_InstantTerm][TrailingStop] = TrailingStopI;
    tinfo[gid_InstantTerm][Step] = TrailingStepI;
    tinfo[gid_InstantTerm][Retrace] = RetraceFactorI;
    tinfo[gid_InstantTerm][LifePeriod] = TimeFrameI;

    tinfo[gid_Panic][TrailingStop] = PanicStop;
    tinfo[gid_Panic][Step] = TrailingStepVS;
    tinfo[gid_Panic][Retrace] = PanicRetrace;
    tinfo[gid_Panic][LifePeriod] = PanicTimeFrame;
    return 0;
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int init() {
    Print("Grouped trailing stop version ", version);
    Print("stops(UL,VL,L,M,S,VS,US,I):", TrailingStopUL, ",", TrailingStopVL, ",", TrailingStopL, ",", TrailingStopM, ",", TrailingStopS, ",", TrailingStopVS, ",", TrailingStopUS, ",", TrailingStopI);
    Print("steps(UL,VL,L,M,S,VS,US,I):", TrailingStepUL, ",", TrailingStepVL, ",", TrailingStepL, ",", TrailingStepM, ",", TrailingStepS, ",", TrailingStepVS, ",", TrailingStepUS, ",", TrailingStepI);
    Print("Retraces(UL,VL,L,M,S,VS,US,I):", Fibo[RetraceFactorUL], ",", Fibo[RetraceFactorVL], ",", Fibo[RetraceFactorL], ",", Fibo[RetraceFactorM], ",", Fibo[RetraceFactorS], ",", Fibo[RetraceFactorVS], ",", Fibo[RetraceFactorUS], ",", Fibo[RetraceFactorI]);
    Print("LifeTimes(UL,VL,L,M,S,VS,US,I):", TimeFrameUL, ",", TimeFrameVL, ",", TimeFrameL, ",", TimeFrameM, ",", TimeFrameS, ",", TimeFrameVS, ",", TimeFrameUS, ",", TimeFrameI);
    
    updatePairInfoCache(AccountPairNames,TimeParamsCoefficientsForPairs,TrailingParamsCoefficientsForPairs);
    for (int i = 0; i < numPairs; ++i) {
        Print("Pair ", i, " name is: ", pairNames[i]," ,Time Coefficient: ", pairInfoCache[i].timeParamsCoefficient," ,Trail Coefficient: ", pairInfoCache[i].trailingParamsCoefficient);
    }

    fillTrailingInfo(TrailingInfo);
    EventSetTimer(TimerSeconds);
    beVerbose = verboseLogging;

    return (0);
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnTimer() {
    if (DeletePositionsOfOtherPairs) {
        filterOutTradesNotIn(AccountPairNames);
    }

    if (ActiveTrading && (loopCounter % 20) == 0) {

        for (int i = 0; i < numPairs; ++i) {
            if (CreateBuysCondition(pairNames[i], ActiveTradingGap, MaximumNetPositions * ActiveAndSpikeLots, MaximumAbsolutePositions * ActiveAndSpikeLots)) {
                Print("Creating active trading buystops on ", pairNames[i]);
                appendBuyStops(pairNames[i], ActiveAndSpikeTradesDistance, SpikeAndActiveTradeSpacing, ActiveAndSpikeLots, ActiveAndSpikeTradeStopLoss, ActiveTradesGroup);
            }

            if (CreateSellsCondition(pairNames[i], ActiveTradingGap, MaximumNetPositions * ActiveAndSpikeLots, MaximumAbsolutePositions * ActiveAndSpikeLots)) {
                Print("Creating active trading sellstops on ", pairNames[i]);
                appendSellStops(pairNames[i], ActiveAndSpikeTradesDistance, SpikeAndActiveTradeSpacing, ActiveAndSpikeLots, ActiveAndSpikeTradeStopLoss, ActiveTradesGroup);
            }
        }
    }


    long numLoops = loopCounter - speedCounter;
    speedCounter = loopCounter;
    if (ShowLoopingSpeed) {
        Print("Looping Speed is:", (int)((60 * numLoops) / TimerSeconds), " per minute.");
    }

    if (ShowVolumeBallances) {
        
        for (int i = 0; i < numPairs; ++i) {
            Print("Volume of all sells for ", pairNames[i], " is:", getVolBallance(pairNames[i], OP_SELL));
            Print("Volume of all sellstops for ", pairNames[i], " is:", getVolBallance(pairNames[i], OP_SELLSTOP));
            Print("Volume of Unsafe sells for ", pairNames[i], " is:", getUnsafeSells(pairNames[i]));

            Print("Volume of all buys for ", pairNames[i], " is:", getVolBallance(pairNames[i], OP_BUY));
            Print("Volume of all buystops for ", pairNames[i], " is:", getVolBallance(pairNames[i], OP_BUYSTOP));
            Print("Volume of Unsafe buys for ", pairNames[i], " is:", getUnsafeBuys(pairNames[i]));

        }
    }

    return;
}

//+------------------------------------------------------------------+
//| expert start function                                            |
//+------------------------------------------------------------------+
void start() {
    if(loopCounter % 23 == 0) {
      updatePairInfoCache(AccountPairNames,TimeParamsCoefficientsForPairs,TrailingParamsCoefficientsForPairs);   
    }

    for (int i = 0; i < OrdersTotal(); i++) {
        if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) {
            if ((ManageAllPairs || getPairInfoIndex(OrderSymbol())!= -1) && (OrderType() == OP_BUY || OrderType() == OP_SELL)) {
                trailPosition(OrderTicket()
                , ContinueLifeTimeAfterFirstSL
                , PanicTimeFrame, PanicPIPS
                , iARVHeuristic
                , UnsafeNetPositionsHeuristic
                , NetPositionsHeuristic
                , HammerCandleHeuristic
                , DodgyCandleHeuroistics
                , PriceOverTimeHeuristic
                , ReserveOpositeForLoosingPositions
                , PriceCrossedHeuristic
                ,ConsecutiveProfitHeuristic);
            }
        }
    }

    if (ActiveTrading && (loopCounter % MAHMARAZA_RAHVARA_ID) == 0) {
       
        for (int i = 0; i < numPairs; ++i) {
            if (CreateBuysCondition(pairNames[i], ActiveTradingGap, MaximumNetPositions * ActiveAndSpikeLots, MaximumAbsolutePositions * ActiveAndSpikeLots)) {
                Print("Creating active trading buystops on ", pairNames[i]);
                appendBuyStops(
                    pairNames[i],
                    ActiveAndSpikeTradesDistance,
                    SpikeAndActiveTradeSpacing,
                    ActiveAndSpikeLots,
                    ActiveAndSpikeTradeStopLoss,
                    ActiveTradesGroup);
            }

            if (CreateSellsCondition(pairNames[i], ActiveTradingGap, MaximumNetPositions * ActiveAndSpikeLots, MaximumAbsolutePositions * ActiveAndSpikeLots)) {
                Print("Creating active trading sellstops on ", pairNames[i]);
                appendSellStops(
                    pairNames[i],
                    ActiveAndSpikeTradesDistance,
                    SpikeAndActiveTradeSpacing,
                    ActiveAndSpikeLots,
                    ActiveAndSpikeTradeStopLoss,
                    ActiveTradesGroup);
            }
        }
    }


    if (SpikeTrading) {

        for (int i = 0; i < numPairs; ++i) {
            if (isPanic(pairNames[i], SpikeTimeFrame, SpikeHeight)) {
                appendTradesIfAppropriate(
                    pairNames[i],
                    ActiveAndSpikeTradesDistance,
                    SpikeAndActiveTradeSpacing,
                    SpikeHeight,
                    ActiveAndSpikeLots,
                    MaximumNetPositions * ActiveAndSpikeLots,
                    MaximumAbsolutePositions * ActiveAndSpikeLots,
                    ActiveAndSpikeTradeStopLoss, SpikeTradesGroup);
            }
        }
    }

    loopCounter++;
}
