# XScript 程式碼風格指南

> 統一的程式碼風格讓程式更易讀、易維護，也幫助 AI 更好地學習

---

## 🎯 風格原則

### 1. 可讀性優先
程式碼是寫給人看的，其次才是給機器執行。

### 2. 一致性
整個專案保持一致的風格。

### 3. 簡潔性
簡單直接的程式碼勝過複雜的技巧。

### 4. 說明性
使用有意義的命名和適當的註解。

---

## 📝 命名規範

### 變數命名

#### 規則
- 使用大駝峰命名法（PascalCase）
- 名稱要有意義，表達用途
- 避免單字母命名（除非是迴圈變數）
- 避免使用保留字首（daily, trade, position, filled, order 等）

#### ✅ 好的命名
```xscript
vars: FastMA(0);              // 快速移動平均
vars: SlowMA(0);              // 慢速移動平均
vars: RSIValue(0);            // RSI 數值
vars: AlertTriggered(false);  // 警示觸發標記
vars: HighestPrice(0);        // 最高價
vars: VolumeAverage(0);       // 成交量平均
```

#### ❌ 不好的命名
```xscript
vars: a(0);                   // 不知道是什麼
vars: temp(0);                // 太模糊
vars: x(0);                   // 無意義
vars: dailyHigh(0);           // 使用保留字首 daily
vars: tradeCount(0);          // 使用保留字首 trade
vars: ma(0);                  // 太簡略，應該說明哪種 MA
```

### 參數命名

#### 規則
- 與變數相同，使用大駝峰命名
- 參數名稱應該表達用途
- 在第二個參數提供清楚的中文說明

#### ✅ 好的命名
```xscript
input: FastLength(5, "快線週期");
input: SlowLength(20, "慢線週期");
input: RSI_Period(14, "RSI計算週期");
input: StopLossPercent(2, "停損百分比");
input: MinVolume(1000, "最小成交量(張)");
```

#### ❌ 不好的命名
```xscript
input: n(5);                      // 無意義
input: len(20);                   // 太簡略
input: period(14);                // 什麼的週期？
input: x(2);                      // 完全不知道用途
input: Length(5, "Length");       // 說明沒有提供額外資訊
```

### 函數命名

#### 規則
- 使用大駝峰命名法
- 動詞開頭（Calculate, Get, Check, Find 等）
- 清楚表達函數功能

#### ✅ 好的命名
```xscript
CalculateCustomEMA()      // 計算自訂 EMA
DetectPinBar()            // 偵測 Pin Bar
GetHighestValue()         // 取得最高值
CheckBullishPattern()     // 檢查看漲型態
FindSupportLevel()        // 尋找支撐位
```

#### ❌ 不好的命名
```xscript
DoSomething()             // 太模糊
Process()                 // 處理什麼？
Calc()                    // 太簡略
MyFunc()                  // 無意義
```

---

## 💬 註解規範

### 檔案開頭註解

每個檔案都應該有開頭說明：

```xscript
// ===================================================================
// 腳本名稱：Pin Bar Reversal 警示
// 腳本類型：警示（Alert）
// 功能描述：偵測 Pin Bar 型態並發出反轉警示
// 資料週期：日線
// 作者：Gordon
// 建立日期：2024-10-20
// 版本：1.0
// ===================================================================
```

### 區段註解

使用註解分隔主要區段：

```xscript
// === 參數宣告 ===
input: ShadowRatio(2, "影線比實體倍數");
input: MinBodySize(0.1, "最小實體大小(%)");

// === 變數宣告 ===
vars: BodySize(0);
vars: UpperShadowSize(0);
vars: LowerShadowSize(0);

// === 計算實體和影線大小 ===
BodySize = AbsValue(Close - Open);
UpperShadowSize = High - MaxList(Open, Close);
LowerShadowSize = MinList(Open, Close) - Low;

// === 判斷 Pin Bar 型態 ===
if LowerShadowSize > BodySize * ShadowRatio 
   and BodySize > Close * MinBodySize / 100 then
    Alert("偵測到看漲 Pin Bar");
```

### 行內註解

對複雜或不直觀的邏輯添加註解：

#### ✅ 好的註解：說明為什麼
```xscript
// 使用 intrabarpersist 避免在同一根 K 棒內重複觸發
vars: intrabarpersist AlertTriggered(false);

// 除以 1000 將成交量從股轉換為張
VolumeInLots = Volume / 1000;

// 等待 3 根 K 棒確認型態，避免假訊號
if BarsSince(SignalBar) >= 3 then
    ConfirmSignal = true;
```

#### ❌ 不好的註解：只說明是什麼
```xscript
// 宣告變數
vars: AlertTriggered(false);

// 除法
VolumeInLots = Volume / 1000;

// If 條件
if BarsSince(SignalBar) >= 3 then
    ConfirmSignal = true;
```

### 註解的時機

#### 需要註解的情況
- 複雜的計算邏輯
- 不直觀的條件判斷
- 使用特殊技巧或 workaround
- 重要的業務邏輯
- 數值的單位轉換

#### 不需要註解的情況
- 顯而易見的程式碼
- 自我說明的變數名稱
- 標準的語法結構

---

## 🏗️ 程式碼結構

### 標準腳本結構

```xscript
// ===================================================================
// [檔案開頭註解]
// ===================================================================

// === 參數宣告 ===
input: ...;

// === 變數宣告 ===
vars: ...;

// === 初始化（如需要）===
once begin
    ...
end;

// === 主要計算邏輯 ===
// [計算指標、條件等]

// === 條件判斷和輸出 ===
if ... then begin
    // [執行動作]
end;
```

### 縮排規範

- 使用 **4 個空格** 或 **1 個 tab** 進行縮排（專案內保持一致）
- `begin...end` 區塊內容要縮排
- `if...then` 的內容要縮排

```xscript
// ✅ 正確的縮排
if Condition1 then begin
    if Condition2 then begin
        DoSomething();
        DoAnotherThing();
    end;
end;

// ❌ 錯誤的縮排
if Condition1 then begin
if Condition2 then begin
DoSomething();
DoAnotherThing();
end;
end;
```

### 空行使用

使用空行分隔邏輯區塊：

```xscript
// === 計算指標 ===
FastMA = Average(Close, 5);
SlowMA = Average(Close, 20);
MyRSI = RSI(Close, 14);

// 空行分隔不同邏輯
VolumeAvg = Average(Volume, 20);
VolumeRatio = Volume / VolumeAvg;

// 空行分隔條件判斷
if FastMA crosses over SlowMA then
    Signal = 1;
```

---

## 🔧 語法風格

### 條件判斷

#### 簡單條件
```xscript
// ✅ 好的風格：單行
if Condition then
    DoSomething();

// ✅ 好的風格：begin...end（建議）
if Condition then begin
    DoSomething();
end;
```

#### 複雜條件
```xscript
// ✅ 好的風格：分行提升可讀性
if Condition1 
   and Condition2 
   and Condition3 then begin
    DoSomething();
end;

// ❌ 不好的風格：太長的單行
if Condition1 and Condition2 and Condition3 and Condition4 then DoSomething();
```

#### 多重條件
```xscript
// ✅ 好的風格：清晰的結構
if Condition1 then begin
    DoSomething();
end
else if Condition2 then begin
    DoSomethingElse();
end
else begin
    DoDefault();
end;
```

### 變數宣告

#### 相關變數分組
```xscript
// ✅ 好的風格：相關變數分組
vars: FastMA(0), SlowMA(0);              // 均線
vars: MyRSI(0), RSI_Upper(70), RSI_Lower(30);  // RSI 相關
vars: AlertTriggered(false), ResetFlag(false);  // 狀態標記
```

#### 初始值明確
```xscript
// ✅ 好的風格：明確初始值
vars: Counter(0);
vars: IsActive(false);
vars: Price(0);

// ❌ 不好的風格：依賴預設值（雖然 XScript 會自動初始化）
vars: Counter;
```

### 計算表達式

#### 適當使用括號
```xscript
// ✅ 好的風格：括號使意圖明確
Result = (A + B) * (C - D);
Percent = (CurrentValue - PreviousValue) / PreviousValue * 100;

// ❌ 不好的風格：依賴運算子優先順序可能造成混淆
Result = A + B * C - D;
```

#### 複雜計算分步驟
```xscript
// ✅ 好的風格：分步驟計算
BodySize = AbsValue(Close - Open);
UpperShadow = High - MaxList(Open, Close);
LowerShadow = MinList(Open, Close) - Low;
IsPinBar = LowerShadow > BodySize * 2;

// ❌ 不好的風格：一行塞太多
IsPinBar = (MinList(Open,Close) - Low) > AbsValue(Close-Open) * 2;
```

---

## 🎨 最佳實踐

### 使用有意義的常數

```xscript
// ✅ 好的做法：使用 input 定義常數
input: StopLossPercent(2, "停損百分比");
input: MinVolumeRatio(1.5, "最小量能比");

// ❌ 不好的做法：硬編碼數值
if Close < EntryPrice * 0.98 then  // 0.98 是什麼意思？
    Sell();
```

### 避免魔術數字

```xscript
// ✅ 好的做法
input: ConfirmBars(3, "確認K棒數");
if BarsSince(Signal) >= ConfirmBars then
    Confirmed = true;

// ❌ 不好的做法
if BarsSince(Signal) >= 3 then  // 為什麼是 3？
    Confirmed = true;
```

### 條件判斷優化

#### 使用布林變數
```xscript
// ✅ 好的做法：條件存入布林變數
vars: IsBullish(false), IsHighVolume(false);

IsBullish = Close > Open and Close > FastMA;
IsHighVolume = Volume > VolumeAverage * 1.5;

if IsBullish and IsHighVolume then
    Alert("看漲訊號");

// ❌ 不好的做法：條件太長
if Close > Open and Close > FastMA and Volume > VolumeAverage * 1.5 then
    Alert("看漲訊號");
```

#### 提早返回
```xscript
// ✅ 好的做法：提早排除不符合條件的情況
if Volume < MinVolume then
    Ret = 0;  // 提早返回

// 只有符合條件才繼續計算
MyRSI = RSI(Close, 14);
Condition1 = MyRSI > 30 and MyRSI < 70;
// ... 更多計算

// ❌ 不好的做法：所有邏輯都在巢狀 if 中
if Volume >= MinVolume then begin
    MyRSI = RSI(Close, 14);
    if MyRSI > 30 and MyRSI < 70 then begin
        // ... 更多巢狀
    end;
end;
```

### 錯誤處理

```xscript
// ✅ 好的做法：檢查參數合理性
input: Length(14, "週期");

vars: Result(0);

if Length > 0 then begin
    Result = Average(Close, Length);
end
else begin
    // 參數錯誤時的處理
    Result = 0;
end;
```

### 效能考量

```xscript
// ✅ 好的做法：避免重複計算
vars: MyEMA(0);
MyEMA = XAverage(Close, 20);  // 只計算一次

if MyEMA > 100 then DoSomething();
if MyEMA < 50 then DoSomethingElse();

// ❌ 不好的做法：重複計算
if XAverage(Close, 20) > 100 then DoSomething();
if XAverage(Close, 20) < 50 then DoSomethingElse();
```

---

## 📚 範本

### 警示腳本範本

```xscript
// ===================================================================
// 腳本名稱：[腳本名稱]
// 腳本類型：警示（Alert）
// 功能描述：[簡短描述功能]
// 資料週期：[K棒週期]
// 作者：[作者名稱]
// 建立日期：[日期]
// ===================================================================

// === 參數宣告 ===
input: Parameter1(10, "參數1說明");
input: Parameter2(20, "參數2說明");

// === 變數宣告 ===
vars: Value1(0);
vars: Value2(0);
vars: intrabarpersist AlertTriggered(false);  // 狀態標記

// === 計算邏輯 ===
Value1 = [計算表達式];
Value2 = [計算表達式];

// === 條件判斷 ===
if [觸發條件] and not AlertTriggered then begin
    Alert("[警示訊息]");
    AlertTriggered = true;
end;

// === 重置機制 ===
if [重置條件] then
    AlertTriggered = false;
```

### 選股腳本範本

```xscript
// ===================================================================
// 腳本名稱：[腳本名稱]
// 腳本類型：選股（Screener）
// 功能描述：[簡短描述篩選條件]
// 資料週期：[K棒週期]
// 作者：[作者名稱]
// 建立日期：[日期]
// ===================================================================

// === 參數宣告 ===
input: Parameter1(10, "參數1說明");
input: Parameter2(20, "參數2說明");

// === 變數宣告 ===
vars: Value1(0);
vars: Value2(0);
vars: Condition1(false);
vars: Condition2(false);

// === 計算邏輯 ===
Value1 = [計算表達式];
Value2 = [計算表達式];

// === 條件判斷 ===
Condition1 = [條件1];
Condition2 = [條件2];

// === 輸出結果 ===
if Condition1 and Condition2 then
    Ret = 1  // 符合條件
else
    Ret = 0;  // 不符合

// === 輸出數值（可選）===
OutputField(1, Value1);
OutputField(2, Value2);
```

### 函數範本

```xscript
// ===================================================================
// 函數名稱：[函數名稱]
// 功能描述：[簡短描述功能]
// 作者：[作者名稱]
// 建立日期：[日期]
// 版本：1.0
// ===================================================================

// === 參數定義 ===
inputs: Parameter1(numericseries), Parameter2(numericsimple);

// === 變數宣告 ===
variables: LocalVar1(0), LocalVar2(0);

// === 主要邏輯 ===
[計算邏輯]

// === 返回值 ===
FunctionName = Result;
```

---

## ⚠️ 常見錯誤

### 1. 使用保留字首

```xscript
// ❌ 錯誤：使用保留字首
vars: dailyHigh(0);
vars: tradeCount(0);
vars: positionSize(0);

// ✅ 正確：避免保留字首
vars: DailyHighPrice(0);      // 或 CurrentDayHigh
vars: TradeCounter(0);         // 或 OrderCount
vars: PositionQuantity(0);     // 或 LotSize
```

### 2. 變數命名不清

```xscript
// ❌ 錯誤：不清楚的命名
vars: a(0), b(0), c(0);
vars: temp(0), temp2(0);

// ✅ 正確：清楚的命名
vars: FastMA(0), SlowMA(0), SignalMA(0);
vars: CurrentValue(0), PreviousValue(0);
```

### 3. 缺少註解

```xscript
// ❌ 錯誤：複雜邏輯沒有註解
if (High - MaxList(Open, Close)) > AbsValue(Close - Open) * 2 
   and AbsValue(Close - Open) > Close * 0.001 then
    Alert("Signal");

// ✅ 正確：添加說明性註解
// 計算實體和上影線大小
BodySize = AbsValue(Close - Open);
UpperShadow = High - MaxList(Open, Close);

// 檢查是否為看跌 Pin Bar：上影線 > 實體的 2 倍
// 且實體大於收盤價的 0.1%（避免十字線）
if UpperShadow > BodySize * 2 
   and BodySize > Close * 0.001 then
    Alert("偵測到看跌 Pin Bar");
```

### 4. 不一致的風格

```xscript
// ❌ 錯誤：風格混亂
vars: FastMA(0);
vars:slowMA(0);  // 命名風格不一致
vars: my_rsi(0);  // 使用下劃線

if FastMA>SlowMA then begin  // 缺少空格
    alert("signal");  // 字母大小寫不一致
end;

// ✅ 正確：統一風格
vars: FastMA(0);
vars: SlowMA(0);
vars: MyRSI(0);

if FastMA > SlowMA then begin
    Alert("訊號觸發");
end;
```

---

## ✅ 檢查清單

提交程式碼前，檢查：

### 命名
- [ ] 變數名稱使用大駝峰（PascalCase）
- [ ] 名稱有意義，表達用途
- [ ] 沒有使用保留字首
- [ ] 參數有中文說明

### 註解
- [ ] 檔案開頭有完整說明
- [ ] 主要區段有分隔註解
- [ ] 複雜邏輯有解釋
- [ ] 沒有無用的註解

### 結構
- [ ] 使用標準腳本結構
- [ ] 縮排一致
- [ ] 適當使用空行分隔邏輯
- [ ] 條件判斷格式清晰

### 品質
- [ ] 沒有硬編碼的魔術數字
- [ ] 複雜計算分步驟進行
- [ ] 使用布林變數提升可讀性
- [ ] 避免重複計算

---

## 🔗 相關資源

- [五種腳本類型說明](SCRIPT_TYPES.md) - 了解不同類型的規範
- [AI 提示詞指南](AI_PROMPTING_GUIDE.md) - 如何請求 AI 協助
- [維護指南](MAINTENANCE_GUIDE.md) - 專案維護規範
- [範例程式碼](../../examples/) - 查看實際範例

---

**最後更新**：2025-10-20  
**維護者**：Gordon, Ronnie

