//version  20180416
// heaer file for desphilboy
//+------------------------------------------------------------------+
//|                                                   desphilboy.mqh |
//|                                                       Desphilboy |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Desphilboy"
#property link "https://www.mql5.com"
#property strict
//+------------------------------------------------------------------+
//| defines                                                          |
//+------------------------------------------------------------------+
// desphilboy system unique Identifier is Mahmaraza Rahvareh My best friend who died in Motorcycle accident
#define MAHMARAZA_RAHVARA_ID 1921 // He loved this number, was his magic number
#define GROUP_SHIFT_CONSTANT 10000

// 4 default groups IDs verylong, long term, medium term and short term positions plus one custom group for user
#define ULTRALONGTERMGROUP 10000
#define VERYLONGTERMGROUP 20000
#define LONGTERMGROUP 30000
#define MEDTERMGROUP 40000
#define SHORTTERMGROUP 50000
#define VERYSHORTTERMGROUP 60000
#define ULTRASHORTTERMGROUP 70000
#define INSTANTTERMGROUP 80000

// EA signature on the position
#define ImanTrailing_ID 100000
#define GroupedImanTrailing_ID 200000
#define DesphilboyPositionCreator_ID 300000
#define DAPositionCreator_ID 400000

//ARV constants
#define LONGARVAVERAGECANDLES  17
#define SHORTARVAVERAGECANDLES  4

   // these constants are used in times multiplication for reducing or increasing values
#define REDUCTION_WEAK 0.9
#define REDUCTION_MED 0.8
#define REDUCTION_STRONG 0.7

#define INCREASE_WEAK 1.05
#define INCREASE_MED  1.15
#define INCREASE_STRONG 1.3

enum Groups {
    NoGroup = 0,
    UltraLongTerm=ULTRALONGTERMGROUP,
    VeryLongTerm = VERYLONGTERMGROUP,
    LongTerm = LONGTERMGROUP,
    MediumTerm = MEDTERMGROUP,
    ShortTerm = SHORTTERMGROUP,
    VeryShortTerm = VERYSHORTTERMGROUP,
    UltraShortTerm = ULTRASHORTTERMGROUP,
    InstantTerm = INSTANTTERMGROUP
};

enum BuyTypes {
    Buy,
    BuyLimit,
    BuyStop
};

enum SellTypes {
    Sell,
    SellLimit,
    SellStop
};

enum TradeActs {
    Initialize,
    Repair,
    Append,
    Terminate,
    NoAction
};

enum GroupIds {
    gid_NoGroup = 0,
    gid_UltraLongTerm = 1,
    gid_VeryLongTerm = 2,
    gid_LongTerm = 3,
    gid_MediumTerm = 4,
    gid_ShortTerm = 5,
    gid_VeryShortTerm = 6,
    gid_UltraShortTerm = 7,
    gid_InstantTerm = 8,
    gid_Panic = 9
};

enum TrailingFields {
    TrailingStop = 0, Step = 1, Retrace = 2, LifePeriod = 3
};

enum LifeTimes {
    NoLifeTime = 0,
    OneMinute = 1,
    TwoMinutes = 2,
    FiveMinutes = 5,
    TenMinutes = 10,
    Quarter = 15,
    HalfHour = 30,
    Min45 = 45,
    OneHour = 60,
    Footbal = 90,
    TwoHours = 120,
    ThreeHours = 180,
    FourHours = 240,
    SixHours = 360,
    EightHours = 480,
    TenHours = 600,
    TwelveHours = 720,
    SixteenHours = 960,
    TwentyHours = 1200,
    OneDay = 1440,
    ThirtyHours = 1800,
    ThirtyTwoHours = 1920,
    OneAndHalfDay = 2160,
    FourtyHours = 2400,
    TwoDays = 2880,
    TwoDaysAnd8Hours = 3360,
    TwoAndHalfDays = 3600,
    SixtyFourHours = 3840,
    ThreeDays = 4320,
    FourDays = 5760,
    FiveDays = 7200,
    SixDays = 8640,
    SevenDays = 10080,
    EightDays = 11520,
    TenDays = 14400,
    TwelveDays = 17280,
    FortNight = 20160,
    FifteenDays = 21600,
    SixteenDays = 23040,
    EighteenDays = 25920,
    TwentyDays = 28800
    
};




// fibonacci
enum FiboRetrace {
    Retrace0 = 0,
    RetracePanic = 1,
    RetraceMin = 2,
    RetraceLow = 3,
    Retrace45 = 4,
    RetraceHalf = 5,
    Retrace55 = 6, 
    Retrace60 = 7,
    RetraceMax = 8,
    Retrace65= 9,
    Retrace70= 10,
    Retrace72= 11,
    Retrace74= 12,
    Retrace76= 13,
    Retrace78= 14,
    Retrace80= 15,
    Retrace82= 16,
    Retrace87= 17,
    Retrace89= 18,
    Retrace91= 19
};

double Fibo[] = {
    0.000,
    0.1,
    0.236,
    0.382,
    0.45,
    0.500,
    0.55,
    0.6,
    0.618,
    0.65,
    0.70,
    0.72,
    0.74,
    0.76,
    0.78,
    0.80,
    0.82, //whole
    0.87,
    0.89,
    0.91
};

struct pairInfo {
    string pairName;
    double trailingParamsCoefficient;
    double timeParamsCoefficient;
    double netPosition;
    double unsafeNetPosition;
    double unsafeBuys;
    double unsafeSells;
    double buyLots;
    double sellLots;
    int numberOfWinningBuys;
    int numberOfLoosingBuys;
    double volumeOfLoosingBuys;
    int numberOfWinningSells;
    int numberOfLoosingSells;
    double volumeOfLoosingSells;
    int reservedOpositeSells[1000];
    int reservedOpositeBuys[1000];
    int reservedBuysCount;
    double reservedBuysVolume; 
    int reservedSellsCount;
    double reservedSellsVolume;
    int numBuys;
    int numSells;
    int enumeratedSells[1000];
    int enumeratedBuys[1000];
    int enumeratedSellsCount;
    int enumeratedBuysCount;
};

static int TrailingInfo[gid_Panic + 1][LifePeriod + 1];
static bool beVerbose = false;
static pairInfo pairInfoCache [100];
static int pairsCount = 0;
string pairNames[100];
string pairTimeParamsCoefficients[100];
string pairTrailingParamsCoefficients[100];
    
int numPairs;
int numTic;
int numTrc;
    

int updatePairInfoCache(string pairNamesCommaSeparated
                        , string timeParamsCoefficientsCommaSeparated
                        , string trailingParamsCoefficientsCommaSeparated) {   
    
     numPairs = StringSplit(pairNamesCommaSeparated, ',', pairNames);
     if( numPairs < 1) {
     numPairs = StringSplit(Symbol(), ',', pairNames);
     }
     
     numTic = StringSplit(timeParamsCoefficientsCommaSeparated, ',', pairTimeParamsCoefficients);
     numTrc = StringSplit(trailingParamsCoefficientsCommaSeparated, ',', pairTrailingParamsCoefficients);

    for (int i = 0; i < numPairs; ++i) {
        pairInfoCache[i].pairName = pairNames[i];
        
        double timeCoef = i < numTic ? StrToDouble(pairTimeParamsCoefficients[i]) : 1.0;
        pairInfoCache[i].timeParamsCoefficient = timeCoef > 0.05 ? timeCoef : 1.0;
        
        double trailCoef = i < numTrc ? StrToDouble(pairTrailingParamsCoefficients[i]) : 1.0;
        pairInfoCache[i].trailingParamsCoefficient = trailCoef > 0.05 ? trailCoef : 1.0;
         
        pairInfoCache[i].numBuys = getNumberOfBuys(pairInfoCache[i].pairName);
        pairInfoCache[i].numSells = getNumberOfSells(pairInfoCache[i].pairName);
        pairInfoCache[i].buyLots = getVolBallance(pairInfoCache[i].pairName, OP_BUY);
        pairInfoCache[i].sellLots = getVolBallance(pairInfoCache[i].pairName, OP_SELL);
        pairInfoCache[i].netPosition =  pairInfoCache[i].buyLots  - pairInfoCache[i].sellLots;
        pairInfoCache[i].unsafeNetPosition = getUnsafeNetPosition(pairInfoCache[i].pairName);
        pairInfoCache[i].unsafeBuys = getUnsafeBuys(pairInfoCache[i].pairName);
        pairInfoCache[i].unsafeSells = getUnsafeSells(pairInfoCache[i].pairName);
        pairInfoCache[i].numberOfWinningBuys = getNumberOfWinningBuys(pairInfoCache[i].pairName);
        pairInfoCache[i].numberOfLoosingBuys = getNumberOfLoosingBuys(pairInfoCache[i].pairName);
        pairInfoCache[i].volumeOfLoosingBuys = getVolumeOfLoosingBuys(pairInfoCache[i].pairName);
        pairInfoCache[i].numberOfWinningSells = getNumberOfWinningSells(pairInfoCache[i].pairName);
        pairInfoCache[i].numberOfLoosingSells = getNumberOfLoosingSells(pairInfoCache[i].pairName);
        pairInfoCache[i].volumeOfLoosingSells = getVolumeOfLoosingSells(pairInfoCache[i].pairName);
        matchLoosingTrades(pairInfoCache[i]);
        enumerateTrades(pairInfoCache[i]);
    }

    if (beVerbose) {
        Print("*******     Pairs information *******");
        for (int i = 0; i < numPairs; ++i) {
            Print(i, ":", pairInfoCache[i].pairName,",", pairInfoCache[i].timeParamsCoefficient,",",pairInfoCache[i].trailingParamsCoefficient, " information: ");
            
            Print("Number of Buys:", pairInfoCache[i].numBuys, " Number of Sells:", pairInfoCache[i].numSells);
            
               for (int j = 0; j < pairInfoCache[i].enumeratedBuysCount; ++j)
                   Print("enumeratedbuys[", j, "]=", pairInfoCache[i].enumeratedBuys[j]);           
            
                for (int j = 0; j < pairInfoCache[i].enumeratedSellsCount; ++j)
                   Print("enumeratedSells[", j, "]=", pairInfoCache[i].enumeratedSells[j]);
         
            Print("netPosition:", pairInfoCache[i].netPosition, " Buys:", pairInfoCache[i].buyLots, " Sells:", pairInfoCache[i].sellLots);
            Print("unsafeNetPosition:", pairInfoCache[i].unsafeNetPosition, " unsafeBuys:", pairInfoCache[i].unsafeBuys, " unsafeSells:", pairInfoCache[i].unsafeSells);
            Print("numberOfLoosingBuys:", pairInfoCache[i].numberOfLoosingBuys," with Lots:", pairInfoCache[i].volumeOfLoosingBuys);
            for (int j = 0; j < pairInfoCache[i].reservedSellsCount; ++j)
                Print("reservedSells[", j, "]=", pairInfoCache[i].reservedOpositeSells[j]);
                Print("Volume of reserved Sells:", pairInfoCache[i].reservedSellsVolume);
            
            Print("numberOfLoosingSells:", pairInfoCache[i].numberOfLoosingSells, " with Lots:", pairInfoCache[i].volumeOfLoosingSells);
            for (int j = 0; j < pairInfoCache[i].reservedBuysCount; ++j)
                Print("reservedBuys[", j, "]=", pairInfoCache[i].reservedOpositeBuys[j]);
                Print("Volume of reserved Buys:", pairInfoCache[i].reservedBuysVolume);
        }
    }

    return numPairs;
}


int getTimeCoeficiented( string pairName,int minutes )
{
   int index = getPairInfoIndex(pairName);
   if (index == -1 ) return minutes;
   
   double coeficient= pairInfoCache[index].timeParamsCoefficient; 
   
   return ((int) (coeficient * minutes));
}


int getTrailCoeficiented( string pairName, int points)
{
   int index = getPairInfoIndex(pairName);
   if (index == -1 ) return points;
   
   double coeficient= pairInfoCache[index].trailingParamsCoefficient; 
   
   return ((int) (coeficient * points));
}


int getNumberOfLoosingBuys(string symbol) {
    int loosingBuysCounter = 0;
    for (int i = 0; i < OrdersTotal(); i++) {
        if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) {
            if (OrderSymbol() == symbol && OrderType() == OP_BUY && OrderProfit() < 0) {
                loosingBuysCounter++;
            }
        }
    }
    return loosingBuysCounter;
}

int getNumberOfWinningBuys(string symbol) {
    int winningBuysCounter = 0;
    for (int i = 0; i < OrdersTotal(); i++) {
        if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) {
            if (OrderSymbol() == symbol && OrderType() == OP_BUY && OrderProfit() > 0) {
                winningBuysCounter++;
            }
        }
    }
    return winningBuysCounter;
}


double getVolumeOfLoosingBuys(string symbol) {
    double loosingBuysVolume = 0;
    for (int i = 0; i < OrdersTotal(); i++) {
        if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) {
            if (OrderSymbol() == symbol && OrderType() == OP_BUY && OrderProfit() < 0) {
                loosingBuysVolume+= OrderLots();
            }
        }
    }
    return loosingBuysVolume;
}

int getNumberOfLoosingSells(string symbol) {
    int loosingSellsCounter = 0;
    for (int i = 0; i < OrdersTotal(); i++) {
        if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) {
            if (OrderSymbol() == symbol && OrderType() == OP_SELL && OrderProfit() < 0) {
                loosingSellsCounter++;
            }
        }
    }
    return loosingSellsCounter;
}

int getNumberOfWinningSells(string symbol) {
    int winningSellsCounter = 0;
    for (int i = 0; i < OrdersTotal(); i++) {
        if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) {
            if (OrderSymbol() == symbol && OrderType() == OP_SELL && OrderProfit() > 0) {
                winningSellsCounter++;
            }
        }
    }
    return winningSellsCounter;
}


double getVolumeOfLoosingSells(string symbol) {
    double loosingSellsVolume = 0;
    for (int i = 0; i < OrdersTotal(); i++) {
        if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) {
            if (OrderSymbol() == symbol && OrderType() == OP_SELL && OrderProfit() < 0) {
                loosingSellsVolume+= OrderLots();
            }
        }
    }
    return loosingSellsVolume;
}


ENUM_TIMEFRAMES findStandardTimeFrameOf(int minutes) {
    if (minutes > PERIOD_MN1) return PERIOD_MN1;
    if (minutes > PERIOD_W1) return PERIOD_W1;
    if (minutes > PERIOD_D1) return PERIOD_D1;
    if (minutes > PERIOD_H4) return PERIOD_H4;
    if (minutes > PERIOD_H1) return PERIOD_H1;
    if (minutes > PERIOD_M30) return PERIOD_M30;
    if (minutes > PERIOD_M15) return PERIOD_M15;
    if (minutes > PERIOD_M5) return PERIOD_M5;
    return PERIOD_MN1;
}

// My indicator calculating Average Relational Volatility
double arvIndicator(string symbol, int timeframe, int longCandlesCount, int shortCandlesCount) {
    ENUM_TIMEFRAMES timeFrame = findStandardTimeFrameOf(timeframe);
    int longHighestIndex = iHighest(symbol, timeFrame, MODE_HIGH, longCandlesCount, 0);
    int longLowestIndex = iLowest(symbol, timeFrame, MODE_LOW, longCandlesCount, 0);

    int shortHighestIndex = iHighest(symbol, timeFrame, MODE_HIGH, shortCandlesCount, 0);
    int shortLowestIndex = iLowest(symbol, timeFrame, MODE_LOW, shortCandlesCount, 0);

    if (longHighestIndex == -1 || longLowestIndex == -1 || shortLowestIndex == -1 || shortHighestIndex == -1) {
        Print("arvIndicator: could not get ranges, returning error value -1.");
        return -1;
    }

    double longRange = iHigh(symbol, timeFrame, longHighestIndex) - iLow(symbol, timeFrame, longLowestIndex);
    double shortRange = iHigh(symbol, timeFrame, shortHighestIndex) - iLow(symbol, timeFrame, shortLowestIndex);
   
    if(longRange == 0) {
    //avoid divide by zero
      return 0.49;
    }
    return (shortRange / longRange);
}

//Average relative volatility
double getARVHuristic(string tradeSymbol, int positionLifeTime) {
    double avrIndicatorValue = arvIndicator(tradeSymbol, positionLifeTime, LONGARVAVERAGECANDLES, SHORTARVAVERAGECANDLES);

    if (avrIndicatorValue < 0) {
        return 1; // returning safe value because of error
    }

    if (avrIndicatorValue < 0.2) { // is very steady
        return REDUCTION_STRONG;
    }

    if (avrIndicatorValue < 0.7) { // is normal
        return 1;
    }

    return INCREASE_MED; // is very volatile
}


int findLowestBuy(string symbol, double floorPrice = 0.0) {
    int preserveTicket = OrderTicket();
    double lowestprice = 999999999;
    int lowestTicket = -1;

    for (int i = 0; i < OrdersTotal(); i++) {
        if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) {
            if (OrderSymbol() == symbol && OrderType() == OP_BUY) {
                if (OrderOpenPrice() < lowestprice && OrderOpenPrice() > floorPrice) {
                    lowestTicket = OrderTicket();
                    lowestprice = OrderOpenPrice();
                }
            }
        }
    }

    bool bResult = OrderSelect(preserveTicket, SELECT_BY_TICKET, MODE_TRADES);
    return lowestTicket;
}


int findHighestSell(string symbol, double ceilingPrice = 99999999) {
    int preserveTicket = OrderTicket();
    double highestprice = 0;
    int highestTicket = -1;

    for (int i = 0; i < OrdersTotal(); i++) {
        if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) {
            if (OrderSymbol() == symbol && OrderType() == OP_SELL) {
                if (OrderOpenPrice() > highestprice && OrderOpenPrice() < ceilingPrice) {
                    highestTicket = OrderTicket();
                    highestprice = OrderOpenPrice();
                }
            }
        }
    }

    bool bResult = OrderSelect(preserveTicket, SELECT_BY_TICKET, MODE_TRADES);
    return highestTicket;
}

void matchLoosingTrades(pairInfo & pairinfo) {
    int ticketFound = 0;
    pairinfo.reservedSellsCount = 0;
    pairinfo.reservedSellsVolume = 0;
    double priceOfFoundTrade = 999999999;
    if(pairinfo.sellLots <  pairinfo.buyLots) { // reserve sells only if we have less sells
    for (int i = 0; pairinfo.volumeOfLoosingBuys > pairinfo.reservedSellsVolume && ticketFound != -1; ++i) {
        ticketFound = findHighestSell(pairinfo.pairName, priceOfFoundTrade);
        if (ticketFound != -1) {
            pairinfo.reservedOpositeSells[i] = ticketFound;
            pairinfo.reservedSellsCount++;
            if (OrderSelect(ticketFound, SELECT_BY_TICKET, MODE_TRADES)) {
                priceOfFoundTrade = OrderOpenPrice();
                pairinfo.reservedSellsVolume += OrderLots();
            } else {
                Print("matchLoosingTrades:could not select ticket:", ticketFound, " breaking the search.");
                break;
            }
        }
    }
   } else if( pairinfo.buyLots < pairinfo.sellLots ) { // reserve buys only if we have less buys
     ticketFound = 0;
    priceOfFoundTrade = 0;
    pairinfo.reservedBuysCount = 0;
    pairinfo.reservedBuysVolume = 0;
    for (int i = 0; pairinfo.volumeOfLoosingSells > pairinfo.reservedBuysVolume && ticketFound != -1; ++i) {
        ticketFound = findLowestBuy(pairinfo.pairName, priceOfFoundTrade);
        if (ticketFound != -1) {
            pairinfo.reservedOpositeBuys[i] = ticketFound;
            pairinfo.reservedBuysCount++;
            if (OrderSelect(ticketFound, SELECT_BY_TICKET, MODE_TRADES)) {
                priceOfFoundTrade = OrderOpenPrice();
                pairinfo.reservedBuysVolume += OrderLots();
            } else {
                Print("matchLoosingTrades:could not select ticket:", ticketFound, " breaking the search.");
                break;
            }
        }
    }
    }
    return;
}

//---------
void enumerateTrades(pairInfo & pairinfo) {
    int ticketFound = 0;
    pairinfo.enumeratedSellsCount = 0;
    double priceOfFoundTrade = 999999999;
    for (int i = 0; i < pairinfo.numSells && ticketFound != -1; ++i) {
        ticketFound = findHighestSell(pairinfo.pairName, priceOfFoundTrade);
        if (ticketFound != -1) {
            pairinfo.enumeratedSells[i] = ticketFound;
            pairinfo.enumeratedSellsCount++;
            if (OrderSelect(ticketFound, SELECT_BY_TICKET, MODE_TRADES)) {
                priceOfFoundTrade = OrderOpenPrice();
            } else {
                Print("enumerateTrades:could not select ticket:", ticketFound, " breaking the search.");
                break;
            }
        }
    }

    ticketFound = 0;
    priceOfFoundTrade = 0;
    pairinfo.enumeratedBuysCount = 0;
    for (int i = 0; i < pairinfo.numBuys && ticketFound != -1; ++i) {
        ticketFound = findLowestBuy(pairinfo.pairName, priceOfFoundTrade);
        if (ticketFound != -1) {
            pairinfo.enumeratedBuys[i] = ticketFound;
            pairinfo.enumeratedBuysCount++;
            if (OrderSelect(ticketFound, SELECT_BY_TICKET, MODE_TRADES)) {
                priceOfFoundTrade = OrderOpenPrice();
            }else {
                Print("enumerateTrades:could not select ticket:", ticketFound, " breaking the search.");
                break;
            }
        }
    }
    return;
}


//--------




int getPairInfoIndex(string pairName) {
    for (int i = 0; i < numPairs; ++i)
        if (pairInfoCache[i].pairName == pairName) return i;

    return -1;
}


// common functions to work with Magic Numbers
int createMagicNumber(int eaId, int groupId) {
    return eaId + groupId + MAHMARAZA_RAHVARA_ID;
}

bool isDesphilboy(int magicNumber) {
    return (magicNumber % 10000) == MAHMARAZA_RAHVARA_ID;
}

bool isUltraLongTerm(int magicNumber) {
    if (isDesphilboy(magicNumber)) {
        return ((magicNumber % 100000) - MAHMARAZA_RAHVARA_ID) == ULTRALONGTERMGROUP;
    }
    return false;
}

bool isVeryLongTerm(int magicNumber) {
    if (isDesphilboy(magicNumber)) {
        return ((magicNumber % 100000) - MAHMARAZA_RAHVARA_ID) == VERYLONGTERMGROUP;
    }
    return false;
}


bool isLongTerm(int magicNumber) {
    if (isDesphilboy(magicNumber)) {
        return ((magicNumber % 100000) - MAHMARAZA_RAHVARA_ID) == LONGTERMGROUP;
    }
    return false;
}

bool isShortTerm(int magicNumber) {
    if (isDesphilboy(magicNumber)) {
        return ((magicNumber % 100000) - MAHMARAZA_RAHVARA_ID) == SHORTTERMGROUP;
    }
    return false;
}


bool isMediumTerm(int magicNumber) {
    if (isDesphilboy(magicNumber)) {
        return ((magicNumber % 100000) - MAHMARAZA_RAHVARA_ID) == MEDTERMGROUP;
    }
    return false;
}


bool isVeryShort(int magicNumber) {
    if (isDesphilboy(magicNumber)) {
        return ((magicNumber % 100000) - MAHMARAZA_RAHVARA_ID) == VERYSHORTTERMGROUP;
    }
    return false;
}

bool isUltraShort(int magicNumber) {
    if (isDesphilboy(magicNumber)) {
        return ((magicNumber % 100000) - MAHMARAZA_RAHVARA_ID) == ULTRASHORTTERMGROUP;
    }
    return false;
}

bool isInstant(int magicNumber) {
    if (isDesphilboy(magicNumber)) {
        return ((magicNumber % 100000) - MAHMARAZA_RAHVARA_ID) == INSTANTTERMGROUP;
    }
    return false;
}

bool isManual(int magicNumber) {
    return magicNumber == 0;
}


string getGroupName(int magicNumber) {
    if (isUltraLongTerm(magicNumber)) {
        return "UltraLongTerm";
    } else if (isVeryLongTerm(magicNumber)) {
        return "VeryLongTerm";
    } else if (isLongTerm(magicNumber)) {
        return "LongTerm";
    } else if (isMediumTerm(magicNumber)) {
        return "MediumTerm";
    } else if (isShortTerm(magicNumber)) {
        return "ShortTerm";
    } else if (isVeryShort(magicNumber)) {
        return "VeryShortTerm";
    } else if (isUltraShort(magicNumber)) {
        return "UltraShort";
    } else if (isInstant(magicNumber)) {
        return "Instant";
    } else if (isManual(magicNumber)) {
        return "Manual";
    } else return "Unknown";
}


Groups getGroup(int magicNumber) {
    if (isUltraLongTerm(magicNumber)) {
        return UltraLongTerm;
    } else if (isVeryLongTerm(magicNumber)) {
        return VeryLongTerm;
    } else if (isLongTerm(magicNumber)) {
        return LongTerm;
    } else if (isMediumTerm(magicNumber)) {
        return MediumTerm;
    } else if (isShortTerm(magicNumber)) {
        return ShortTerm;
    } else if (isVeryShort(magicNumber)) {
        return VeryShortTerm;
    } else if (isUltraShort(magicNumber)) {
        return UltraShortTerm;
    } else if (isInstant(magicNumber)) {
        return InstantTerm;
    } else return NoGroup;
}

GroupIds getGroupId(int magicNumber) {
    if (isUltraLongTerm(magicNumber)) {
        return gid_UltraLongTerm;
    } else if (isVeryLongTerm(magicNumber)) {
        return gid_VeryLongTerm;
    } else if (isLongTerm(magicNumber)) {
        return gid_LongTerm;
    } else if (isMediumTerm(magicNumber)) {
        return gid_MediumTerm;
    } else if (isShortTerm(magicNumber)) {
        return gid_ShortTerm;
    } else if (isVeryShort(magicNumber)) {
        return gid_VeryShortTerm;
    } else if (isUltraShort(magicNumber)) {
        return gid_UltraShortTerm;
    } else if (isInstant(magicNumber)) {
        return gid_InstantTerm;
    } else return gid_NoGroup;
}


int getPositionsInterval(string symbol, int operation, double rangeLow, double rangeHi, int & results[]) {
    int resultCounter = 0;

    int openPosType = (operation == OP_SELLSTOP || operation == OP_SELLLIMIT) ? OP_SELL : OP_BUY;

    for (int i = 0; i < OrdersTotal(); i++) {
        if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) {
            if (OrderSymbol() == symbol &&
                (OrderType() == operation || (OrderType() == openPosType)) &&
                OrderOpenPrice() > rangeLow &&
                OrderOpenPrice() < rangeHi) {
                results[resultCounter] = OrderTicket();
                resultCounter++;
            }
        }
    }

    return resultCounter;
}

int getPositionsInRange(string symbol, int operation, double center, int PIPsMargin, int & results[]) {
    double pip = MarketInfo(symbol, MODE_POINT);
    double l = center - PIPsMargin * pip;
    double h = center + PIPsMargin * pip;
    return getPositionsInterval(symbol, operation, l, h, results);
}

int getCurrentTrailingStop(int tradeTicket, GroupIds orderGroup, bool lifePeriodEffectiveAlways, bool panic = false, double heuristicsValue = 1, string symbol="", double tradeStopLoss=0) {

     if (panic && !isReservedTrade(tradeTicket, symbol)) {
        if (beVerbose) Print(symbol, ":", tradeTicket, ": Returning a panic trailing stop: ", getTrailCoeficiented(symbol,TrailingInfo[gid_Panic][TrailingStop]));
        return getTrailCoeficiented(symbol,TrailingInfo[gid_Panic][TrailingStop]);
    }

    if (panic && isReservedTrade(tradeTicket, symbol)) {
        if (beVerbose) Print(symbol, ":", tradeTicket, ": Returning half a nprmal trailing stop for panic reserved ticket: ", getTrailCoeficiented(symbol, TrailingInfo[gid_UltraLongTerm][TrailingStop]) * 0.5 * heuristicsValue);
        return (int) (getTrailCoeficiented(symbol, TrailingInfo[gid_UltraLongTerm][TrailingStop]) * 0.5 * heuristicsValue);
    }
    
    if (TrailingInfo[orderGroup][LifePeriod] == PERIOD_CURRENT) {
        return getTrailCoeficiented(symbol, TrailingInfo[orderGroup][TrailingStop]);
    }

    if (tradeStopLoss != 0 && !lifePeriodEffectiveAlways) {
        if (beVerbose) Print(symbol, ":", tradeTicket, ": Active calculation not effective after first stop loss, returning constant trailing stop");
        return getTrailCoeficiented(symbol, TrailingInfo[orderGroup][TrailingStop]);
    }

    int orderTrailingStop = (int) (getTrailCoeficiented(symbol, TrailingInfo[orderGroup][TrailingStop]) * heuristicsValue);
    if (beVerbose) Print(symbol, ":", tradeTicket, ": Factor is:", heuristicsValue, " ,NocoefTrailing:",(int) (heuristicsValue * TrailingInfo[orderGroup][TrailingStop]), " ,Order Trailing Stop  is: ", orderTrailingStop);
    return orderTrailingStop;
}

double getCurrentRetrace(int tradeTicket, GroupIds orderGroup, bool lifePeriodEffectiveAlways, bool panic = false, double heuristicsValue = 1, string symbol="", double tradeStopLoss=0) {

    if (panic && !isReservedTrade(tradeTicket, symbol)) {
        if (beVerbose) Print(symbol, ":", tradeTicket, ": Returning a panic trailing stop. ");
        return Fibo[TrailingInfo[gid_Panic][Retrace]];
    }

    if (panic && isReservedTrade(tradeTicket,symbol)) {
          if (beVerbose) Print(symbol, ":", tradeTicket, ": Returning half a nprmal retrace for panic reserved ticket.");
        return Fibo[TrailingInfo[gid_UltraLongTerm][Retrace]] * REDUCTION_STRONG  * heuristicsValue * 0.5 ;
    }

    if (TrailingInfo[orderGroup][LifePeriod] == PERIOD_CURRENT) {

        return Fibo[TrailingInfo[orderGroup][Retrace]];
    }

    if (tradeStopLoss != 0 && !lifePeriodEffectiveAlways) {

        return Fibo[TrailingInfo[orderGroup][Retrace]];
    }

    double orderRetrace = (Fibo[TrailingInfo[orderGroup][Retrace]] * heuristicsValue);
    if (beVerbose) Print(symbol, ":", tradeTicket,": Factor is:", heuristicsValue, " , Retrace is: ", orderRetrace);
    return orderRetrace;
}


double lifeTimeHeuristic(datetime orderOpenTime, GroupIds orderGroupId, string symbol) {
    double minutesElapsed = getMinutesOld(orderOpenTime);
    double lifeTimeInMinutes = getTimeCoeficiented(symbol, TrailingInfo[orderGroupId][LifePeriod]);
    
     if( beVerbose ) {
      Print("lifeTimeHeu:NoCoeflifeTimeInMinutes:", TrailingInfo[orderGroupId][LifePeriod], " ,lifeTimeInMinutes:", lifeTimeInMinutes);
    }
    
   if (lifeTimeInMinutes == 0) {
        lifeTimeInMinutes = 30;
    } // prevent divide by zero
    double timesLifeTimeElapsed = (minutesElapsed / lifeTimeInMinutes);
     if( beVerbose ) {
      double nocoefLifeTimeInMinutes = TrailingInfo[orderGroupId][LifePeriod];
      double nocoeftimeslifetimeelapsed = minutesElapsed / nocoefLifeTimeInMinutes;
      double nocoeflifetimeheu = 1/(1 + 0.5 * nocoeftimeslifetimeelapsed * nocoeftimeslifetimeelapsed);
      
      Print("lifeTimeHeu:NoCoeflifeTimeHeu:", nocoeflifetimeheu, " ,lifeTimeHeu:", 1 / (1 + 0.5 * timesLifeTimeElapsed * timesLifeTimeElapsed));
    }
    
    return 1 / (1 + 0.5 * timesLifeTimeElapsed * timesLifeTimeElapsed);
}

int getPipsProfit(double orderOpenPrice, string symbol) {
 
 double price  = (MarketInfo(symbol, MODE_BID) + MarketInfo(symbol, MODE_ASK)) /2;
 double pointValue = MarketInfo(symbol, MODE_POINT);
 double diff = MathAbs(orderOpenPrice - price);
 return (int) (diff/pointValue);
 
 }


double priceTimeHeuristic(int tradeTicket, datetime orderOpenTime, GroupIds orderGroupId, double orderOpenPrice, string symbol) {
    double minutesElapsed = getMinutesOld(orderOpenTime);
    double lifeTimeInMinutes = getTimeCoeficiented(symbol, TrailingInfo[orderGroupId][LifePeriod]);
    
    if( beVerbose ) {
      Print("priceTimeHeuristic:NoCoeflifeTimeInMinutes:", TrailingInfo[orderGroupId][LifePeriod], " ,lifeTimeInMinutes:", lifeTimeInMinutes);
    }
    
     if (lifeTimeInMinutes == 0)  return 1;   // no need to proceed
    
    double timesLifeTimeElapsed = minutesElapsed / lifeTimeInMinutes;
    
    if( timesLifeTimeElapsed < 3 ) return 1;  // the Heuristic is to prolong longer lasting trades, not intended to act on new trades
    
    double ageCoef = 1 + 0.2 * (timesLifeTimeElapsed - 3 )/3;
    
    int pipsProfit = getPipsProfit(orderOpenPrice, symbol);
    double timesTrailingStop = pipsProfit / getTrailCoeficiented(symbol, TrailingInfo[orderGroupId][TrailingStop]);
    double priceTimeRatio= (timesTrailingStop / timesLifeTimeElapsed);
    
    if(priceTimeRatio < 0.2 ) {  
      if( isReservedTrade(tradeTicket, symbol)) {
         return 1.0;
      } else { 
         return 0.7 * ageCoef;
          }
    }
    
    if(priceTimeRatio > 0.5)  return 1.2 * ageCoef;
   
   return 1;
}



double unsafeBalanceHeuristic(int ticketNumber, string symbol, int orderType, bool tradeReservationEnabled) {
    int pairIndex = getPairInfoIndex(symbol);
    if (pairIndex == -1) { // reurn a safe value because there is no pair info
        return 1;
    }

    if ((orderType == OP_BUY && pairInfoCache[pairIndex].unsafeNetPosition < 0) || (orderType == OP_SELL && pairInfoCache[pairIndex].unsafeNetPosition > 0)) {
        return INCREASE_MED;
    }

   if(tradeReservationEnabled && isReservedTrade(ticketNumber, symbol)) {
      return 1;
   }
   
   if ((orderType == OP_BUY && pairInfoCache[pairIndex].netPosition > 0.008) || (orderType == OP_SELL && pairInfoCache[pairIndex].netPosition < -0.008)) {
        return REDUCTION_MED;
    }

    return 1;
}

double balanceHeuristic(int ticketNumber, string symbol, int orderType, bool tradeReservationEnabled) {
    int pairIndex = getPairInfoIndex(symbol);
    if (pairIndex == -1) { // reurn a safe value because there is no pair info
        return 1;
    }

    if ((orderType == OP_BUY && pairInfoCache[pairIndex].netPosition < 0) || (orderType == OP_SELL && pairInfoCache[pairIndex].netPosition > 0)) {
        return INCREASE_MED;
    }

   if(tradeReservationEnabled && isReservedTrade(ticketNumber, symbol)) {
      return 1;
   }
   
   if ((orderType == OP_BUY && pairInfoCache[pairIndex].netPosition > 0.008) || (orderType == OP_SELL && pairInfoCache[pairIndex].netPosition < -0.008)) {
        return REDUCTION_STRONG;
    }

    return 1;
}

double averageCandleMaxMinLength(string symbol, ENUM_TIMEFRAMES timeFrame, int count) {
   if( count ==0) return 0;
   
   double sum = 0;
   for(int i=0; i<count; ++i) {
      sum = iHigh(symbol, timeFrame, i) -  iLow(symbol, timeFrame, i) + sum;
   }
   
   return (sum/count);
}

double hammerness(string symbol, ENUM_TIMEFRAMES timeFrame, int shift) {

   double candleMovement = MathAbs(iClose(symbol, timeFrame, shift) - iOpen(symbol, timeFrame, shift));
   if(candleMovement == 0) candleMovement = 0.0001;   // put a minimum to avoid divide by zero
   
   double lowertail = MathMin(iOpen(symbol, timeFrame, shift), iClose(symbol,timeFrame,shift)) - iLow(symbol, timeFrame, shift) ;
   double uppertail =  iHigh(symbol, timeFrame, shift) - MathMax(iOpen(symbol, timeFrame, shift), iClose(symbol,timeFrame,shift)) ;
     
    double bullishness = (lowertail - uppertail) / candleMovement;
   
   double bullishnessFactor = bullishness > 5 ? 1: (bullishness < -5 ? -1 : 0); 
    
    return bullishnessFactor * dodginess(symbol,timeFrame, shift); 
  
}

double dodginess(string symbol, ENUM_TIMEFRAMES timeFrame, int shift) {
    double average100 = averageCandleMaxMinLength(symbol, timeFrame, 100);

   if(average100 == 0) return 0;  //avoid divide by 0
   
   double relationalStrength = (iHigh(symbol,timeFrame,shift) - iLow(symbol,timeFrame,shift))/average100;

   if(relationalStrength == 0) return 0;  //candle is very weak, or error,avoid divide by 0
   
   double averageVol =(double) (iVolume(symbol, timeFrame, shift +1) + iVolume( symbol, timeFrame, shift + 2) + iVolume( symbol, timeFrame, shift + 3) + iVolume( symbol, timeFrame, shift + 4))/4;

    if(averageVol == 0) return 0;  //avoid divide by 0
    
    double relationalVolume =  iVolume( symbol, timeFrame, shift)/averageVol;
    
    double candleMovement = MathAbs(iClose(symbol, timeFrame, shift) - iOpen(symbol, timeFrame, shift));
    if(candleMovement == 0) candleMovement = 0.001;   // put a minimum to avoid divide by zero
    
    double concentration = MathMin(5, MathAbs((relationalStrength * average100)/candleMovement));
    
    return concentration * MathPow(relationalVolume, 2) * MathPow(relationalStrength,2); 
}


double hammerHeuristic(int ticketNumber, string symbol, int orderType, bool tradeReservationEnabled, GroupIds tradeGroup) {
   ENUM_TIMEFRAMES timeFrame = findStandardTimeFrameOf(getTimeCoeficiented(symbol,TrailingInfo[tradeGroup][LifePeriod]));
   double effectiveHammerness = hammerness(symbol, timeFrame, 1);
  
   if(effectiveHammerness > 6 ) {
      if(orderType == OP_SELL ) return REDUCTION_STRONG;
      } 
   if(effectiveHammerness > -6 ) {
     return 1;
      } 
      
  if(orderType == OP_BUY) return REDUCTION_STRONG;

   return 1; 
}


//--------------
int priceCrossedTimes(double price, string symbol,  ENUM_TIMEFRAMES timeFrame, int numberOfCandleSticks, int pointsApproximation = 50) {
   int sumOfCrosses =  0;
   double pointValue =MarketInfo(symbol, MODE_POINT);
   double approximation = pointsApproximation * pointValue;
   
   for( int i =0; i< numberOfCandleSticks; ++i) {
    if(price < iHigh(symbol, timeFrame, i) + approximation && price > iLow(symbol, timeFrame, i) - approximation ) { 
     sumOfCrosses++;
    }
   }
   
   return sumOfCrosses;  
}


double priceCrossHeuristic(int ticketNumber, string symbol, double orderOpenPrice, GroupIds tradeGroup) {

   
    ENUM_TIMEFRAMES timeFrame =PERIOD_D1;
    int pointsApproximation = TrailingInfo[tradeGroup][Step] * 4; 
   int crosses = priceCrossedTimes(orderOpenPrice, symbol, timeFrame, 13, pointsApproximation);
  
   if(crosses <2 ) {
       return 1;
      } 

 return MathPow(REDUCTION_STRONG, crosses-1);
}


//--------------



double dodgyHeuristic(int ticketNumber, string symbol, int orderType, bool tradeReservationEnabled, GroupIds tradeGroup) {
   ENUM_TIMEFRAMES timeFrame = findStandardTimeFrameOf(getTimeCoeficiented(symbol, TrailingInfo[tradeGroup][LifePeriod]));
   double effectiveDodginess = dodginess(symbol, timeFrame, 1) * candleSign(symbol,timeFrame, 2);

   if(effectiveDodginess > 6 && orderType == OP_SELL ) return REDUCTION_STRONG;
   
   if(effectiveDodginess < -6 && orderType == OP_BUY ) return REDUCTION_STRONG;
      
 return 1;
}


int candleSign(string symbol, ENUM_TIMEFRAMES timeFrame, int shift) {
return  iOpen(symbol, timeFrame, shift) - iClose(symbol, timeFrame, shift) > 0 ? 1 : -1;
}

int getMinutesOld(datetime creationTime) {
    int diff = (int)(TimeCurrent() - creationTime);
    return (int) diff / 60;
}


double getNetPosition(string symbol) {
    int preserveTicket = OrderTicket();
    double balance = 0;

    for (int i = 0; i < OrdersTotal(); i++) {
        if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) {
            if (OrderSymbol() == symbol) {
                if (OrderType() == OP_BUY) balance = balance + OrderLots();
                if (OrderType() == OP_SELL) balance = balance - OrderLots();
            }
        }
    }

    bool bResult = OrderSelect(preserveTicket, SELECT_BY_TICKET, MODE_TRADES);
    return balance;
}


double getPriceOfHighest(int operation, string symbol) {
    int preserveTicket = OrderTicket();
    double price = 0;

    for (int i = 0; i < OrdersTotal(); i++) {
        if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) {
            if (OrderSymbol() == symbol) {
                if (OrderType() == operation) price = MathMax(price, OrderOpenPrice());

            }
        }
    }

    bool bResult = OrderSelect(preserveTicket, SELECT_BY_TICKET, MODE_TRADES);
    return price;
}


double getPriceOfLowest(int operation, string symbol) {
    double price = 99990;
    int preserveTicket = OrderTicket();
    for (int i = 0; i < OrdersTotal(); i++) {
        if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) {
            if (OrderSymbol() == symbol) {
                if (OrderType() == operation) price = MathMin(price, OrderOpenPrice());

            }
        }
    }

    bool bResult = OrderSelect(preserveTicket, SELECT_BY_TICKET, MODE_TRADES);
    return price;
}


bool isPanic(string symbol, ENUM_TIMEFRAMES timeframe, int panicPIPS) {
    double minPrice = MathMin(iLow(symbol, timeframe, 0), iLow(symbol, timeframe, 1));
    double maxPrice = MathMax(iHigh(symbol, timeframe, 0), iHigh(symbol, timeframe, 1));

    double span = maxPrice - minPrice;

    double symbolPoint = MarketInfo(symbol, MODE_POINT);
    if (symbolPoint <= 0) {
        Print("Cannot find point value for ", symbol);
        return false;
    }

    int spanPips = (int)(span / symbolPoint);

    return (spanPips >= panicPIPS);
}

int filterOutTradesNotIn(string allowedPairs) {
    int result = 0;
    for (int i = 0; i < OrdersTotal(); i++) {
        if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) {
            if (StringFind(allowedPairs, OrderSymbol(), 0) == -1) {
                if (OrderType() != OP_SELL && OrderType() != OP_BUY) {
                    Print("Order ", OrderTicket(), " being deleted because ", OrderSymbol(), " not found in ", allowedPairs);
                    result = OrderDelete(OrderTicket());
                }

            }
        }
    }
    return result;
}

int appendTradesIfAppropriate(string pairname, int pointsDistance, int spacing, int spikePIPs, double spikeTradeLots, double maxLots, double absMaxLots, int stopLoss, Groups group) {
    if (CreateBuysCondition(pairname, spikePIPs, maxLots, absMaxLots)) {
        Print("Creating spike buy-stops on ", pairname);
        appendBuyStops(pairname, pointsDistance, spacing, spikeTradeLots, stopLoss, group);
    }

    if (CreateSellsCondition(pairname, spikePIPs, maxLots, absMaxLots)) {
        Print("Creating spike sell-stops on ", pairname);
        appendSellStops(pairname, pointsDistance, spacing, spikeTradeLots, stopLoss, group);
    }

    return 0;
}


bool CreateBuysCondition(string pairname, int spikePIPs, double maxLots, double absMaxLots) {

    double pp = MarketInfo(pairname, MODE_POINT);
    double symbolAsk = MarketInfo(pairname, MODE_ASK);
    int pairIndex = getPairInfoIndex(pairname);

    if(pairIndex == -1) {
        return false;
    }

    if (pairInfoCache[pairIndex].unsafeNetPosition < maxLots && pairInfoCache[pairIndex].buyLots < absMaxLots) {
        if (getPriceOfLowest(OP_BUYSTOP, pairname) > (symbolAsk + spikePIPs * pp)) {
            return true;
        }
    }
    return false;
}


bool CreateSellsCondition(string pairname, int spikePIPs, double maxLots, double absMaxLots) {

    double pp = MarketInfo(pairname, MODE_POINT);
    double symbolBid = MarketInfo(pairname, MODE_BID);
    int pairIndex = getPairInfoIndex(pairname);

    if(pairIndex == -1) {
        Print("CreateBuysCondition: could not find index for ", pairname);
        return false;
    }

    if (pairInfoCache[pairIndex].unsafeNetPosition > (-1 * maxLots) && pairInfoCache[pairIndex].sellLots < absMaxLots) {
        if (getPriceOfHighest(OP_SELLSTOP, pairname) < (symbolBid - spikePIPs * pp)) {
            return true;
        }
    }

    return false;
}


double getUnsafeNetPosition(string symbol) {
    return getUnsafeBuys(symbol) - getUnsafeSells(symbol);
}

// returns sum  of lots of all buys which have no stop-loss yet

double getUnsafeBuys(string symbol) {
    double balance = 0;
    int preserveTicket = OrderTicket();
    for (int i = 0; i < OrdersTotal(); i++) {
        if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) {
            if (OrderSymbol() == symbol) {
                if (OrderType() == OP_BUY && (OrderStopLoss() < OrderOpenPrice())) {
                    balance = balance + OrderLots();
                }
            }

        }
    }

    bool bResult = OrderSelect(preserveTicket, SELECT_BY_TICKET, MODE_TRADES);
    return balance;
}

double getUnsafeSells(string symbol) {
    double balance = 0;
    int preserveTicket = OrderTicket();
    for (int i = 0; i < OrdersTotal(); i++) {
        if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) {
            if (OrderSymbol() == symbol) {
                if (OrderType() == OP_SELL && (OrderStopLoss() > OrderOpenPrice() || OrderStopLoss() == 0)) {
                    balance = balance + OrderLots();
                }
            }
        }
    }

    bool bResult = OrderSelect(preserveTicket, SELECT_BY_TICKET, MODE_TRADES);
    return balance;
}

int getNumberOfSells(string symbol) {
    int count = 0;
    int preserveTicket = OrderTicket();
    for (int i = 0; i < OrdersTotal(); i++) {
        if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) {
            if (OrderSymbol() == symbol && OrderType() == OP_SELL) {
               count ++;
           }
        }
    }

    bool bResult = OrderSelect(preserveTicket, SELECT_BY_TICKET, MODE_TRADES);
    return count;
}

int getNumberOfBuys(string symbol) {
    int count = 0;
    int preserveTicket = OrderTicket();
    for (int i = 0; i < OrdersTotal(); i++) {
        if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) {
            if (OrderSymbol() == symbol && OrderType() == OP_BUY) {
               count ++;
           }
        }
    }

    bool bResult = OrderSelect(preserveTicket, SELECT_BY_TICKET, MODE_TRADES);
    return count;
}


double getVolBallance(string symbol, int orderType = OP_SELL) {
    double balance = 0;
    int preserveTicket = OrderTicket();
    for (int i = 0; i < OrdersTotal(); i++) {
        if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) {
            if (OrderSymbol() == symbol) {
                if (OrderType() == orderType) balance = balance + OrderLots();
            }
        }
    }

    bool bResult = OrderSelect(preserveTicket, SELECT_BY_TICKET, MODE_TRADES);
    return balance;
}


int appendBuyStops(string pairName, int distance, int spacing, double lots, int stoploss, Groups grp) {
    double symbolAsk = MarketInfo(pairName, MODE_ASK);
    Groups g = UltraLongTerm;

    for (int i = 0; i < 8; i++, g += UltraLongTerm) {
        createBuyStop(pairName, symbolAsk, i, 2 * distance, stoploss, 0, MathMax(g, grp), distance, lots, 100, 0, spacing);
        createBuyStop(pairName, symbolAsk, i + 8, 2 * distance, stoploss, 0, MathMax(g, grp), distance, lots, 100, 0, spacing);
    }

    return 0;
}



int appendSellStops(string pairName, int distance, int spacing, double lots, int stoploss, Groups grp) {
    double symbolBid = MarketInfo(pairName, MODE_BID);
    Groups g = UltraLongTerm;

    for (int i = 0; i < 8; i++, g += UltraLongTerm) {
        createSellStop(pairName, symbolBid, i, 2 * distance, stoploss, 0, MathMax(g, grp), distance, lots, 100, 0, spacing);
        createSellStop(pairName, symbolBid, i+ 8, 2 * distance, stoploss, 0, MathMax(g, grp), distance, lots, 100, 0, spacing);
    }

    return 0;
}


int createBuyStop(
    string symbol,
    double startingPrice,
    int index,
    int PIPsToStart,
    int StopLossBuys,
    int TakeProfitBuys,
    Groups BuyStopsGroup,
    int distance,
    double buyLots,
    int slippage,
    int tradesExpireAfterHours,
    int spacing) {
    datetime now = TimeCurrent();
    datetime expiry = tradesExpireAfterHours != 0 ? now + tradesExpireAfterHours * 3600 : 0;
    double symbolAsk = MarketInfo(symbol, MODE_ASK);
    double baseprice = startingPrice == 0.0 ? symbolAsk : startingPrice;
    double pip = MarketInfo(symbol, MODE_POINT);
    double price = baseprice + (distance * index + PIPsToStart) * pip;
    double stopLoss = StopLossBuys != 0 ? price - StopLossBuys * pip : 0;
    double takeProfit = TakeProfitBuys != 0 ? price + TakeProfitBuys * pip : 0;


    bool spaceAvailable = false;
    spaceAvailable = clearSpaceForPosition(price, OP_BUYSTOP, spacing, symbol);


    if (!spaceAvailable) {
        return -1;
    }


    int result = OrderSend(
        symbol, // symbol
        OP_BUYSTOP, // operation
        buyLots, // volume
        price, // price
        slippage, // slippage
        stopLoss, // stop loss
        takeProfit, // take profit
        NULL, // comment
        createMagicNumber(DAPositionCreator_ID, BuyStopsGroup), // magic number
        expiry, // pending order expiration
        clrNONE // color
    );

    if (result == -1) {
        Print("Order ", index, " creation failed for BuyStop at:", price, "on ", symbol);
    } else {
        if (OrderSelect(result, SELECT_BY_TICKET))
            Print("BuyStop ", index, " created at ", price, " with ticket ", OrderTicket(), " Group ", getGroupName(OrderMagicNumber()), " on ", symbol);
    }
    return result;
}


int createSellStop(
    string symbol,
    double startingPrice,
    int index,
    int PIPsToStart,
    int StopLossSells,
    int TakeProfitSells,
    Groups SellStopsGroup,
    int distance,
    double sellLots,
    int slippage,
    int tradesExpireAfterHours,
    int spacing) {
    datetime now = TimeCurrent();
    datetime expiry = tradesExpireAfterHours != 0 ? now + tradesExpireAfterHours * 3600 : 0;
    double symbolBid = MarketInfo(symbol, MODE_BID);
    double pip = MarketInfo(symbol, MODE_POINT);
    double baseprice = startingPrice == 0.0 ? symbolBid : startingPrice;
    double price = baseprice - (distance * index + PIPsToStart) * pip;
    double stopLoss = StopLossSells != 0 ? price + StopLossSells * pip : 0;
    double takeProfit = TakeProfitSells != 0 ? price - TakeProfitSells * pip : 0;


    bool spaceAvailable = false;

    spaceAvailable = clearSpaceForPosition(price, OP_SELLSTOP, spacing, symbol);


    if (!spaceAvailable) {
        return -1;
    }

    int result = OrderSend(
        symbol, // symbol
        OP_SELLSTOP, // operation
        sellLots, // volume
        price, // price
        slippage, // slippage
        stopLoss, // stop loss
        takeProfit, // take profit
        NULL, // comment
        createMagicNumber(DAPositionCreator_ID, SellStopsGroup), // magic number
        expiry, // pending order expiration
        clrNONE // color
    );

    if (result == -1) {
        Print("Order ", index, " creation failed for SellStop at:", price, " on ", symbol);
    } else {
        if (OrderSelect(result, SELECT_BY_TICKET))
            Print("SellStop ", index, " created at ", price, " with ticket ", OrderTicket(), " Group ", getGroupName(OrderMagicNumber()), " on ", symbol);
    }
    return result;
}

bool clearSpaceForPosition(double price, int operation, int Spacing, string symbol) {
    int positions[1000];


    if (Spacing != 0) {
        int c = getPositionsInRange(symbol, operation, price, Spacing, positions);
        if (c > 0) {
            return false;
        }
    }

    return true;
}

double calcHuristics(int ticketNumber
                              , string symbol
                              , int ordertype
                              , int magicNumber
                              , datetime openTime
                              , double openPrice
                              , bool arvHeuristic
                              , bool unsafeNetPositionsHeuristic
                              , bool netPositionsHeuristic
                              , bool hammerHeuriticEnabled
                              , bool dodgyHeuristicEnabled
                              , bool priceOverTimeHeuristic                            
                              , bool opositeLoosingTrades
                              , bool priceCrossHeuristicEnabled
                              , bool consecutiveHeuristicEnabled
                              , bool panic) {
    double arvHeuVal = 1.0;
    double unsafeNetPosHeuVal = 1.0;
    double netPosHeuVal = 1.0;
    double timeHeuVal = 1.0;
    double hammerHeuVal = 1.0;
    double dodgyHeuVal = 1.0;
    double priceTimeHeuVal = 1.0;
    double priceCrossHeuVal = 1.0;
    double consecutiveHeuVal = 1.0;

    GroupIds grpId = calculateGroupId(ticketNumber, magicNumber, opositeLoosingTrades, symbol);

    int lifetime = getTimeCoeficiented(symbol, TrailingInfo[grpId][LifePeriod]);

    if (arvHeuristic) arvHeuVal = getARVHuristic(symbol, lifetime);
    if (unsafeNetPositionsHeuristic) unsafeNetPosHeuVal = unsafeBalanceHeuristic(ticketNumber,symbol, ordertype, opositeLoosingTrades);
    if (netPositionsHeuristic) netPosHeuVal = balanceHeuristic(ticketNumber,symbol, ordertype, opositeLoosingTrades);
    if (hammerHeuriticEnabled) hammerHeuVal = hammerHeuristic(ticketNumber,symbol, ordertype, opositeLoosingTrades, grpId);
    if (dodgyHeuristicEnabled) dodgyHeuVal = dodgyHeuristic(ticketNumber,symbol, ordertype, opositeLoosingTrades, grpId);
    if(priceOverTimeHeuristic && !panic) priceTimeHeuVal = priceTimeHeuristic(ticketNumber, openTime,grpId,openPrice,symbol);
    if(priceCrossHeuristicEnabled) priceCrossHeuVal = priceCrossHeuristic(ticketNumber,symbol, openPrice, grpId);
    if(consecutiveHeuristicEnabled) consecutiveHeuVal = consecutivePositionHeuristic(ticketNumber, symbol);
    timeHeuVal = lifeTimeHeuristic(openTime, grpId, symbol);
    if(beVerbose) {
    Print(symbol, ":", ticketNumber, ": timeHeu:", timeHeuVal, " unsafeNetPosHeuVal:", unsafeNetPosHeuVal, " netPoseHeuVal:", netPosHeuVal, " consecutiveHeuVal:", consecutiveHeuVal);
    Print(symbol, ":", ticketNumber, ": ARVHeu:", arvHeuVal, " HammerVal:", hammerHeuVal, " DodgyVal:", dodgyHeuVal, " PriceOverTimeHeu:", priceTimeHeuVal, " PriceCrossHeu:", priceCrossHeuVal);
    }
    return timeHeuVal * arvHeuVal * unsafeNetPosHeuVal * netPosHeuVal * priceTimeHeuVal * hammerHeuVal * dodgyHeuVal * priceCrossHeuVal * consecutiveHeuVal;
}


bool isReservedTrade(int tradeTicket, string symbol) {
    int index = getPairInfoIndex(symbol);
    if(index== -1) return false;

    bool result = (isInArray(tradeTicket, pairInfoCache[index].reservedOpositeBuys, pairInfoCache[index].reservedBuysCount) 
    || isInArray(tradeTicket, pairInfoCache[index].reservedOpositeSells, pairInfoCache[index].reservedSellsCount));

    return result;
}


int inReservedTrades(int tradeTicket, string symbol) {
    int index = getPairInfoIndex(symbol);
    if(index== -1) return -1;

   int buyIndex = inArray(tradeTicket, pairInfoCache[index].reservedOpositeBuys, pairInfoCache[index].reservedBuysCount);
   if(buyIndex != -1) return buyIndex;
   
   return inArray(tradeTicket, pairInfoCache[index].reservedOpositeSells, pairInfoCache[index].reservedSellsCount);
}
//---------------------

double getOrderStopLossCapForReservedTrades(int tradeTicket, string symbol) {

   double pointValue = MarketInfo(symbol, MODE_POINT);
   
   
      if( OrderType() == OP_BUY ) {
         if(isReservedTrade(tradeTicket, symbol)) {
            return OrderOpenPrice() + 4 * TrailingInfo[gid_UltraLongTerm][Step] * pointValue;
         }
           else return 9999999;
      }
      else if( isReservedTrade(tradeTicket, symbol)) return OrderOpenPrice() - 4 * TrailingInfo[gid_UltraLongTerm][Step] * pointValue;
      
   return 0;
}

//----------------------

double consecutivePositionHeuristic(int tradeTicket, string symbol) {

   if(isReservedTrade(tradeTicket, symbol)) return 1;
   
    int index = getPairInfoIndex(symbol);
    if(index== -1) return 1;
    
   int buyIndex = inArray(tradeTicket, pairInfoCache[index].enumeratedBuys, pairInfoCache[index].enumeratedBuysCount);
   if(buyIndex > -1) {
    if(buyIndex > pairInfoCache[index].reservedSellsCount ) {
    return MathPow(REDUCTION_MED, buyIndex - 1 - pairInfoCache[index].reservedSellsCount);
    } else {
      return 1;
       }
    }
   
   int sellIndex = inArray(tradeTicket, pairInfoCache[index].enumeratedSells, pairInfoCache[index].enumeratedSellsCount);
   if(sellIndex > -1) {
    if(sellIndex > pairInfoCache[index].reservedBuysCount ) {
    return MathPow(REDUCTION_MED, sellIndex - 1 - pairInfoCache[index].reservedBuysCount);
    } else {
      return 1;
    }
   }
   
   return 1;
   }

//---------------------


bool isInArray(int ticketTofind, int & ticketArray[], int arrayCount) {
    for (int i = 0; i < arrayCount; ++i)
        if (ticketArray[i] == ticketTofind) return true;
    return false;
}

int inArray(int ticketTofind, int & ticketArray[], int arrayCount) {
    for (int i = 0; i < arrayCount; ++i)
        if (ticketArray[i] == ticketTofind) return i;
    return -1;
}

GroupIds calculateGroupId(int tradeTicket, int magicNumber, bool opositeReserveEnabled = true, string symbol="") {
   GroupIds realGroup=getGroupId(magicNumber);

    if (opositeReserveEnabled && isReservedTrade(tradeTicket, symbol) && realGroup >= gid_UltraLongTerm) {
    if(beVerbose) Print(symbol, ":", tradeTicket, " is reserved, real group is ",realGroup," calculated group is UltraLongTerm");
    
    return gid_UltraLongTerm;
    }
    
    return realGroup;
}
//+------------------------------------------------------------------+
//|This function trails the position which is selected.                        |
//+------------------------------------------------------------------+
void trailPosition(int orderTicket,
    bool continueLifeTimeAfterFirstSL,
    ENUM_TIMEFRAMES panicTimeFrame,
    int panicPIPS,
    bool arvHeuristic,
    bool unsafeNetPositionsHeuristic,
    bool netPositionsHeuristic,
    bool hammerCandleHeuristic,
    bool dodgycandleHeuristic,
    bool priceOverTimeHeuristic,
    bool opositeLoosingTrades,
    bool priceCrossHeuristicEnabled,
    bool ConsecutiveProfitHeuristicEnabled) {
    double pBid, pAsk, pp, pDiff, pRef, pStep, pRetraceTrail, pDirectTrail;

   if( !isDesphilboy(OrderMagicNumber())) {
      Print("Skipping order ", OrderTicket(), " because is not a Desphilboy System trade.");
      return;
   }
   
    GroupIds tradeGroupId = calculateGroupId(orderTicket, OrderMagicNumber(), opositeLoosingTrades, OrderSymbol());

    bool panic = isPanic(OrderSymbol(), panicTimeFrame, panicPIPS);

    double heuristics = calcHuristics(orderTicket
                                                      , OrderSymbol()
                                                      , OrderType()
                                                      , OrderMagicNumber()
                                                      , OrderOpenTime()
                                                      , OrderOpenPrice()
                                                      , arvHeuristic
                                                      , unsafeNetPositionsHeuristic
                                                      , netPositionsHeuristic
                                                      , hammerCandleHeuristic
                                                      , dodgycandleHeuristic
                                                      , priceOverTimeHeuristic
                                                      , opositeLoosingTrades
                                                      , priceCrossHeuristicEnabled
                                                      , ConsecutiveProfitHeuristicEnabled
                                                      ,panic);

    double RetraceValue = getCurrentRetrace(orderTicket, tradeGroupId, continueLifeTimeAfterFirstSL, panic, heuristics, OrderSymbol(), OrderStopLoss());
    int TrailingStop = getCurrentTrailingStop(orderTicket, tradeGroupId, continueLifeTimeAfterFirstSL, panic, heuristics,OrderSymbol(), OrderStopLoss());
      if(beVerbose) Print("trailPosition:", orderTicket,": retrace:",RetraceValue, " trailing: ",TrailingStop);
   
    pp = MarketInfo(OrderSymbol(), MODE_POINT);
    pDirectTrail = TrailingStop * pp;
    pStep = getTrailCoeficiented(OrderSymbol(),TrailingInfo[tradeGroupId][Step]) * pp;

    if (OrderType() == OP_BUY) {
        pBid = MarketInfo(OrderSymbol(), MODE_BID);
        pDiff = pBid - OrderOpenPrice();
        pRetraceTrail = pDiff > pDirectTrail ? (pDiff - pDirectTrail) * RetraceValue : 0;
        if (beVerbose) Print(OrderSymbol(),":Buy:",OrderTicket(), " RetraceTrail value is: ", pRetraceTrail);
        pRef = pBid - pDirectTrail - pRetraceTrail; 
        if (beVerbose) Print(OrderTicket(), " Ref value is: ", pRef);
        
        pRef = MathMin(pRef, getOrderStopLossCapForReservedTrades(OrderTicket(),OrderSymbol()));
        if (beVerbose) Print(OrderTicket(), " Ref after cap is: ", pRef);

        if (pRef - OrderOpenPrice() > 0) { // ref is more profity than order.
            if (
            (OrderStopLoss() != 0.0 
            && pRef - OrderStopLoss() > pStep 
            && pRef - OrderOpenPrice() > pStep) 
            ||(OrderStopLoss() == 0.0 
            && pRef - OrderOpenPrice() > pStep)) {
                ModifyStopLoss(pRef);
                return;
            }
        }
    }

    if (OrderType() == OP_SELL) {
        pAsk = MarketInfo(OrderSymbol(), MODE_ASK);
        pDiff = OrderOpenPrice() - pAsk;
        pRetraceTrail = pDiff > pDirectTrail ? (pDiff - pDirectTrail) * RetraceValue : 0;
        pRef = pAsk + pDirectTrail + pRetraceTrail;
        if (beVerbose) Print(OrderSymbol(),":Sell:",OrderTicket(), " Ref value is: ", pRef);
        
        pRef = MathMax(pRef, getOrderStopLossCapForReservedTrades(OrderTicket(),OrderSymbol()));
        if (beVerbose) Print(OrderTicket(), " Ref after cap is: ", pRef);

        if (OrderOpenPrice() - pRef > 0) { // ref is more  in profit.
            if ((OrderStopLoss() != 0.0 && OrderStopLoss() - pRef > pStep && OrderOpenPrice() - pRef > pStep) || (OrderStopLoss() == 0.0 && OrderOpenPrice() - pRef > pStep)) {
                ModifyStopLoss(pRef);
                return;
            }
        }
    }
}

//+------------------------------------------------------------------+
//|   this modifies a selected order and chages its stoploss                                      |
//|
//|   Params: ldStopLoss  , double is the new value for stoploss
//+------------------------------------------------------------------+
void ModifyStopLoss(double ldStopLoss) {
    bool bResult;
    bResult = OrderModify(OrderTicket(), OrderOpenPrice(), ldStopLoss, OrderTakeProfit(), 0, CLR_NONE);

    if (bResult) {
        Print("Order ", OrderTicket(), " modified to Stoploss=", ldStopLoss, " group:", getGroupName(OrderMagicNumber()));
    } else {
        Print("could not modify order:", OrderTicket(), " group:", getGroupName(OrderMagicNumber()));
    }
}
//+------------------------------------------------------------------+
