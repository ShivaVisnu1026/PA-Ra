# XScript intrabarpersist 與 K棒計數器學習指南

## 📚 學習目標

通過分析專案中的官方範例，學習 `intrabarpersist` 關鍵字和 K棒計數器的正確使用方式。

## 🔍 intrabarpersist 關鍵字

### **基本概念**
`intrabarpersist` 是 XScript 的特殊關鍵字，用於宣告在 K棒內保持狀態的變數。

### **語法**
```xs
var: intrabarpersist 變數名稱(預設值);
```

### **作用**
- 變數在 K棒內保持狀態，不會被重置
- 適合用於需要跨 tick 保持狀態的變數
- 常用於即時交易、累計計算等場景

## 📊 官方範例分析

### **範例 1：大單敲進監控**
```xs
// 檔案：external/sysjust-xq/XScript_Preset/警示/2.市場常用語/大單敲進.xs
variable: intrabarpersist Xtime(0);        // 計數器
variable: intrabarpersist Volumestamp(0);  // 成交量戳記
variable: intrabarpersist XDate(0);        // 日期戳記

// 每日重置
if Date > XDate or Volumestamp = Volumestamp[1] then Xtime = 0;
XDate = Date;

// 累計大單次數
if GetField("Volume", "Tick") > atVolume and GetField("內外盤","Tick")=1 then Xtime += 1;

// 達到門檻時觸發
if Xtime > LaTime then 
begin
    ret = 1; 
    Xtime = 0;  // 重置計數器
end;
```

**學習要點**：
- 使用 `intrabarpersist` 保持計數器狀態
- 每日重置機制
- 達到條件後重置計數器

### **範例 2：網格交易策略**
```xs
// 檔案：external/sysjust-xq/XScript_Preset/自動交易/3-Algo策略委託/04-網格交易.xs
var: intrabarpersist grid_started(false);      // 開始網格交易
var: intrabarpersist grid_base(0);             // 網格中心點
var: intrabarpersist grid_current_base(0);     // 目前的網格中心點
var: intrabarpersist grid_current_ord(0);      // 目前的網格編號
var: intrabarpersist grid_buycount(0);         // 買進數量合計
var: intrabarpersist grid_sellcount(0);        // 賣出數量合計

// 啟動網格交易
if not grid_started and GetInfo("TradeMode") = 1 then begin
    grid_started = true;
    grid_base = Close;
    grid_current_base = Close;
    // ... 其他初始化
end;
```

**學習要點**：
- 多個 `intrabarpersist` 變數協同工作
- 狀態管理（啟動/停止）
- 累計計算（買賣數量）

### **範例 3：價格記錄**
```xs
// 檔案：external/sysjust-xq/XS_Blocks/警示腳本/即時/R0001-價格/[R0001-005-H]目前股價突破當日N點前的高點.xs
variable: intrabarpersist xHigh(0);

// 換日重置
if GetFieldDate("Date") <> GetFieldDate("Date")[1] then xHigh = 0;

// 記錄高點
if Time >= value1 then xHigh = MaxList(xHigh, High);
```

**學習要點**：
- 使用 `MaxList` 更新記錄值
- 換日重置機制
- 時間條件控制

## 🔢 K棒計數器技巧

### **基本模式**
```xs
variable: KBarOfDay(0);

// 每日重置和計數
if Date <> Date[1] then 
    KBarOfDay = 1
else 
    KBarOfDay = KBarOfDay + 1;
```

### **官方範例分析**

#### **範例 1：開盤五分鐘創三新高**
```xs
// 檔案：external/sysjust-xq/XScript_Preset/警示/當沖交易型/開盤五分鐘創三新高.xs
variable: KBarOfDay(0); 
KBarOfDay += 1; 
if date <> date[1] then KBarOfDay = 1;

// 在第六根K棒檢查（開盤五分鐘後）
if KBarOfDay = 6 and Countif(High > High[1] and Close > Close[1], 5) >= 3 then 
    Ret = 1;
```

**學習要點**：
- 簡潔的計數器寫法
- 特定K棒位置觸發
- 結合 `Countif` 函數

#### **範例 2：開盤N根紅K棒**
```xs
// 檔案：external/sysjust-xq/XS_Blocks/警示腳本/即時/R0003-走勢/[R0003-008-A]開盤N根紅K棒.xs
variable: KBarOfDay(0);

if getfieldDate("Date") <> getfieldDate("Date")[1] then 
    KBarOfDay = 0 
else 
    KBarOfDay += 1;

// 檢查特定K棒位置
condition1 = KBarOfDay = _BeginKBar - 1;

// 統計紅K棒數量
condition2 = Countif(close > close[1] and close > open, KBarOfDay - 1) >= _p1;
```

**學習要點**：
- 使用 `getfieldDate` 檢查日期
- 動態K棒位置檢查
- 統計函數應用

#### **範例 3：盤整後突破**
```xs
// 檔案：external/sysjust-xq/XS_Blocks/警示腳本/即時/R0001-價格/[R0001-005-C]盤整到X點後，股價創當日新高.xs
Var: _RecordPrice(99999999), KBarOfDay(0), Ratio(3);

if getfieldDate("Date") <> getfieldDate("Date")[1] then begin
    condition1 = false;
    KBarOfDay = 0;
    _RecordPrice = iff(_Side = 1, 99999999, -99999999);
end else 
    KBarOfDay += 1;

// 根據時間點設定不同條件
if _p1 = 9.5 and KBarOfDay >= 30 then begin
    condition1 = (GetField("最高價", "D") - GetField("最低價", "D")) / close <= ratio * 0.01;
    _RecordPrice = iff(_Side = 1, GetField("最高價", "D"), GetField("最低價", "D"));
end;
```

**學習要點**：
- 複雜的條件判斷
- 根據K棒數量設定不同邏輯
- 記錄價格的動態更新

## 🎯 最佳實踐

### **1. intrabarpersist 使用時機**
- ✅ 需要跨 tick 保持狀態的變數
- ✅ 累計計算（計數器、總量等）
- ✅ 狀態管理（啟動/停止標誌）
- ✅ 價格記錄（最高價、最低價等）

### **2. K棒計數器使用時機**
- ✅ 需要精確控制時間窗口
- ✅ 開盤後特定時間的邏輯
- ✅ 避免使用絕對時間的場景
- ✅ 需要統計特定K棒數量的情況

### **3. 時間控制策略**
```xs
// 策略1：使用K棒計數器（推薦）
if KBarOfDay = 1 then begin
    // 第一根K棒邏輯
end;

// 策略2：使用時間範圍
if Time >= 0900 and Time < 0915 then begin
    // 時間範圍邏輯
end;

// 策略3：混合使用
if KBarOfDay <= 10 and Time < 1000 then begin
    // 前10根K棒且時間小於10點
end;
```

### **4. 變數命名規範**
```xs
// 推薦命名方式
var: intrabarpersist signal_found(false);     // 信號狀態
var: intrabarpersist entry_price(0);          // 進場價格
var: intrabarpersist trade_count(0);          // 交易計數
var: intrabarpersist max_profit(0);           // 最大獲利

// K棒計數器
var: KBarOfDay(0);                            // 當日K棒計數
var: KBarOfSession(0);                        // 當日時段K棒計數
```

## 🔧 常見應用場景

### **1. 日內交易策略**
```xs
var: intrabarpersist signal_bar_found(false);
var: intrabarpersist signal_high(0);
var: KBarOfDay(0);

// 每日重置
if Date <> Date[1] then begin
    KBarOfDay = 1;
    signal_bar_found = false;
end else
    KBarOfDay += 1;

// 第一根K棒識別信號
if KBarOfDay = 1 and 條件 then begin
    signal_bar_found = true;
    signal_high = High;
end;

// 後續K棒進場
if signal_bar_found and KBarOfDay > 1 and KBarOfDay < 17 then begin
    // 進場邏輯
end;
```

### **2. 累計監控**
```xs
var: intrabarpersist volume_sum(0);
var: intrabarpersist trade_count(0);

// 累計成交量
volume_sum += Volume;

// 累計交易次數
if 進場條件 then trade_count += 1;

// 達到門檻時觸發
if volume_sum > threshold or trade_count > max_trades then begin
    // 觸發邏輯
    volume_sum = 0;  // 重置
    trade_count = 0;
end;
```

### **3. 狀態管理**
```xs
var: intrabarpersist strategy_started(false);
var: intrabarpersist current_phase(0);

// 啟動策略
if not strategy_started and 啟動條件 then begin
    strategy_started = true;
    current_phase = 1;
end;

// 階段轉換
if strategy_started then begin
    if current_phase = 1 and 條件1 then current_phase = 2;
    if current_phase = 2 and 條件2 then current_phase = 3;
end;
```

## 📚 學習總結

### **intrabarpersist 重點**
1. **狀態保持**：變數在K棒內保持狀態
2. **累計計算**：適合計數器、總量等
3. **狀態管理**：啟動/停止標誌
4. **價格記錄**：最高價、最低價等

### **K棒計數器重點**
1. **精確控制**：比時間範圍更精確
2. **動態邏輯**：根據K棒位置執行不同邏輯
3. **統計應用**：統計特定K棒數量
4. **時間窗口**：控制交易時間窗口

### **選擇原則**
- **intrabarpersist**：需要跨 tick 保持狀態時使用
- **K棒計數器**：需要精確時間控制時使用
- **時間範圍**：簡單的時間條件時使用
- **混合使用**：複雜策略可以組合使用

---

**記住**：這些技巧是 XScript 進階開發的重要工具，掌握後可以寫出更穩定、更精確的交易策略！
