{@type:sensor}
// 均線多頭排列「首次」觸發（警示腳本）
// 條件（本期全部成立，且上期非全部成立）：
// close > MA5 > MA10 > MA20 > MA60 > MA120 > MA240

settotalbar(300);

// 參數（可調整各均線期數）
input: len5(5, "MA5"),
       len10(10, "MA10"),
       len20(20, "MA20"),
       len60(60, "MA60"),
       len120(120, "MA120"),
       len240(240, "MA240");

// 均線計算（同頻率）
var: ma5(0), ma10(0), ma20(0), ma60(0), ma120(0), ma240(0);
var: cond_now(false), cond_prev(false);

ma5   = Average(close, len5);
ma10  = Average(close, len10);
ma20  = Average(close, len20);
ma60  = Average(close, len60);
ma120 = Average(close, len120);
ma240 = Average(close, len240);

cond_now  = (close > ma5) and (ma5 > ma10) and (ma10 > ma20)
            and (ma20 > ma60) and (ma60 > ma120) and (ma120 > ma240);

// 上一期是否也全部成立
cond_prev = cond_now[1];

// 首次觸發：本期全部成立 + 上期非全部成立
if cond_now and (cond_prev = false) then
    ret = 1;


