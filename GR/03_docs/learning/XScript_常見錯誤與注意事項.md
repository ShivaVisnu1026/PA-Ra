# XScript 常見錯誤與注意事項

## 🚨 編譯錯誤提醒

### 1. 週期檢查錯誤
**錯誤**：`if BarFreq <> "15" then return;`
- BarFreq 回傳 "Min"，不是數值
- 導致腳本永遠在第10行就return，後續邏輯不執行

**修正**：
```xs
if barfreq <> "Min" or barinterval <> 15 then
    raiseruntimeerror("請設定為15分鐘K棒");
```

### 2. SetTotalBar 位置錯誤
**錯誤**：在變數宣告後才呼叫 SetTotalBar()
- SetTotalBar() 只能在腳本最開頭呼叫

**修正**：
```xs
// 必須在變數宣告前
settotalbar(lookback_bars + 10);
```

### 3. Highest 函數邏輯錯誤
**錯誤**：`value4 = Highest(High, lookback_bars); condition5 = High < value4;`
- Highest() 包含當前K棒，導致條件永遠為false

**修正**：
```xs
value4 = Highest(High[1], lookback_bars);  // 不含當前K棒
condition5 = High <= value4;
```

### 4. 重複進場控制
**錯誤**：沒有防止同一根K棒內重複進場的機制

**修正**：
```xs
var: intrabarpersist hasTradedToday(false);

// 進場條件加上
if Position = 0 and not hasTradedToday then begin
    // 進場邏輯
    hasTradedToday = true;
end;
```

### 5. 變數命名錯誤

#### ❌ 錯誤：使用系統保留字
```xs
variable: trade_taken(false);  // 錯誤：trade 是保留字首
variable: position(0);         // 錯誤：position 是保留字
variable: filled(0);           // 錯誤：filled 是保留字
variable: daily_trade(false);  // 錯誤：daily 是保留字首
```

#### ✅ 正確：避免保留字
```xs
Vars: transaction_completed(false); // 正確
Vars: current_pos(0);          // 正確
Vars: filled_qty(0);           // 正確
Vars: transaction_count(0);    // 正確
```

#### 常見保留字列表
- `trade`, `position`, `filled`, `order` (注意: `trade` 也是保留字首)
- `buy`, `sell`, `long`, `short`
- `market`, `limit`, `stop`
- `volume`, `price`, `time`, `date`
- `daily`, `minute`, `hour`, `day`, `week`, `month`
- `open`, `close`, `high`, `low`
- `current`, `previous`, `next`

### 2. 變數宣告語法錯誤

#### ❌ 錯誤：使用 variable 宣告
```xs
variable: trade_taken(false);  // 錯誤語法
```

#### ✅ 正確：使用 Vars 宣告
```xs
Vars: trade_taken(false);      // 正確語法
Vars: signal_high(0);          // 正確語法
Vars: entry_price(0);          // 正確語法
```

#### 陣列宣告語法
```xs
Arrays: price_array[10](0);    // 宣告 10 個元素的陣列
Arrays: signal_data[5,3](0);   // 宣告 5x3 的二維陣列
```

### 3. 腳本類型限制

#### ❌ 錯誤：在自動交易腳本中使用 OutputField
```xs
{@type:autotrade}
// 以下函數在自動交易腳本中不可用
SetOutputName1("信號狀態");
OutputField1(signal_status);   // 錯誤：自動交易腳本不能用
```

#### ✅ 正確：只在選股腳本中使用
```xs
{@type:filter}
// 選股腳本可以使用
SetOutputName1("信號狀態");
OutputField1(signal_status);   // 正確：選股腳本可以用
```

#### 各腳本類型可用函數
- **選股腳本** (`{@type:filter}`)：可使用 `OutputField`, `SetOutputName`
- **警示腳本** (`{@type:sensor}`)：不可使用 `OutputField`
- **指標腳本** (`{@type:indicator}`)：可使用 `OutputField`, `SetOutputName`
- **自動交易腳本** (`{@type:autotrade}`)：不可使用 `OutputField`
- **函數腳本** (`{@type:function}`)：不可使用 `OutputField`

### 4. 型態不匹配錯誤

#### ❌ 錯誤：型態不匹配
```xs
Vars: signal_found(false);
if signal_found = 1 then  // 錯誤：布林值與數值比較
```

#### ✅ 正確：型態匹配
```xs
Vars: signal_found(false);
if signal_found = true then  // 正確：布林值與布林值比較
```

### 5. 語法錯誤

#### ❌ 錯誤：缺少分號
```xs
Vars: signal_high(0)
if Close > signal_high then  // 錯誤：上一行缺少分號
```

#### ✅ 正確：每行結尾加分號
```xs
Vars: signal_high(0);
if Close > signal_high then  // 正確：有分號
```

## 📝 最佳實踐

### 1. 變數命名規範
- 使用有意義的變數名稱
- 避免使用保留字
- 保持命名一致性
- 使用英文命名

### 2. 程式碼組織
- 適當使用註解說明
- 保持一致的縮排格式
- 將相關邏輯分組
- 使用空行分隔邏輯區塊

### 3. 錯誤處理
- 檢查輸入參數的有效性
- 處理邊界條件
- 適當的預設值設定
- 避免除零錯誤

### 4. 效能優化
- 避免不必要的計算
- 合理使用 SetTotalBar
- 優化迴圈結構
- 注意記憶體使用

## 🔧 除錯技巧

### 1. 編譯錯誤處理
- 仔細閱讀錯誤訊息
- 檢查行號和字元位置
- 確認語法正確性
- 檢查變數宣告

### 2. 邏輯錯誤處理
- 使用簡單的測試案例
- 逐步驗證邏輯
- 檢查條件判斷
- 確認計算結果

### 3. 執行錯誤處理
- 檢查參數設定
- 確認資料完整性
- 監控執行狀態
- 記錄錯誤資訊

## 📚 常用語法參考

### PlotLine（XQ 指標畫線）
依 XQ 官方說明（[PlotLine語法的介紹](https://www.xq.com.tw/lesson/indicator/plotline%E8%AA%9E%E6%B3%95%E7%9A%84%E4%BB%8B%E7%B4%B9/)）：
- **每個點傳兩個數值：第一個是 X 座標，第二個是 Y 座標。**
- **X 座標單位**：第幾根 bar（從 1 到 CurrentBar）。
- **Y 座標單位**：價位（與 Open、High、Low、Close 同單位）。

因此正確順序為：`PlotLine(ID, bar1, price1, bar2, price2, label)`  
即 **每個點都是 (X, Y) = (bar, price)**。  
- 起點 = (bar1, price1)，終點 = (bar2, price2)。  
- 這樣**指標面板會顯示價格**（例如 243.5、211）。  
- 若寫成 `(ID, bar1, bar2, price1, price2, label)`，面板會顯示 bar 編號而非價格，且畫線會錯。

若**標籤正確但線畫錯**：  
- 先確認 `plot_start`、`CurrentBar` 與圖表 X 軸一致（bar 從 1 開始）。  
- 若平台實作與文件不同，可改試 **每點 (Y, X) = (price, bar)**：  
  `PlotLine(ID, price1, bar1, price2, bar2, label)`  
  這樣 param2 仍是價格（標籤不變），繪圖時若平台以 (param2, param3) 當 (Y, X)，線會畫在正確價位。

### 變數宣告
```xs
// 輸入參數
input: length(20);
input: threshold(0.5);

// 一般變數
Vars: ma_value(0);
Vars: signal_found(false);

// 陣列變數
Arrays: price_data[10](0);
Arrays: signal_array[5,2](false);
```

### 條件判斷
```xs
// 基本條件
if condition then
    action;

// 完整條件
if condition then
    action1
else
    action2;

// 複合條件
if condition1 and condition2 then
    action;
```

### 迴圈結構
```xs
// for 迴圈
for i = 1 to 10 do
begin
    // 迴圈內容
end;

// while 迴圈
while condition do
begin
    // 迴圈內容
end;
```

## ⚠️ 常見陷阱

### 1. 時間相關
- 注意市場開收盤時間
- 考慮時區差異
- 注意交易時間限制

### 2. 資料相關
- 檢查歷史資料完整性
- 注意除權除息調整
- 確認資料頻率

### 3. 計算相關
- 避免除零錯誤
- 注意數值精度
- 檢查計算結果範圍

## 🎯 檢查清單

### 編譯前檢查
- [ ] 變數名稱不包含保留字
- [ ] 使用正確的變數宣告語法
- [ ] 每行結尾都有分號
- [ ] 型態匹配正確
- [ ] 腳本類型與函數使用匹配

### 執行前檢查
- [ ] 參數設定合理
- [ ] 邏輯流程正確
- [ ] 錯誤處理完善
- [ ] 效能考量適當

### 測試檢查
- [ ] 使用測試資料驗證
- [ ] 檢查邊界條件
- [ ] 確認計算結果
- [ ] 監控執行效能

## 📖 參考資源

- XScript 官方文件
- 官方範例程式庫
- 社群討論和經驗分享
- 技術支援論壇
- [AddSpread 函數使用說明](XScript_AddSpread函數使用說明.md)

## 📋 實際錯誤案例記錄

### 案例 3：日內突破策略實務問題 - 進場條件過嚴與隔日持倉 (2024/12/19)

#### 問題描述
1. **進場棒位置不對**：信號棒正確，但後續進場棒位置感覺不對
2. **隔日才平倉**：策略應該當日平倉，但發現有些交易到隔日才平倉

#### 問題分析

##### 問題1：進場條件過度限制
```xs
// ❌ 過於嚴格的進場條件
if Low <= entry_price and High >= entry_price and Open < entry_price and Close >= entry_price then
```

**問題點**：
- `Open < entry_price` 排除了跳空高開的情況
- `Close >= entry_price` 要求收盤必須在進場價之上
- 這兩個條件組合會錯過很多合理的進場機會

##### 問題2：平倉邏輯不夠強制
- 雖然有時間平倉條件，但可能因為其他條件優先執行
- 缺乏隔日持倉的保險機制

#### 修正方法

##### 修正1：簡化進場條件
```xs
// ✅ 簡化進場條件：只要高點觸及進場價就進場
if High >= entry_price then
begin
    SetPosition(1, entry_price);
    hasTradedToday = true;
end;
```

**優點**：
- 更接近實際撮合邏輯
- 不會錯過跳空高開的情況
- 減少進場延遲

##### 修正2：加強平倉邏輯
```xs
// ✅ 加強平倉邏輯
if Position > 0 then
begin
    // 優先級1：強制平倉 - 時間到期
    if KBarOfDay >= 16 then
        SetPosition(0, market);
    
    // 優先級2：停損
    else if Close <= stop_loss then
        SetPosition(0, market);
    
    // 優先級3：停利
    else if Close >= take_profit then
        SetPosition(0, market);
end;

// 額外保險：每日收盤前強制平倉（防止隔日持倉）
if Date <> Date[1] and Position > 0 then
    SetPosition(0, market);
```

**改進點**：
- 提前到 K棒16 強制平倉（約下午1:00）
- 使用 `else if` 確保優先級執行
- 增加隔日持倉保險機制

#### 學習要點
- **進場條件要符合實際交易邏輯**：避免過度限制導致錯失機會
- **平倉邏輯要有明確優先級**：時間平倉 > 停損 > 停利
- **增加保險機制**：防止意外隔日持倉
- **實務測試很重要**：理論邏輯與實際執行可能有差異

### 案例 4：跨頻率資料取得 - GetField 函數使用 (2024/12/19)

#### 需求描述
在15分鐘K棒策略中，需要檢查日頻率的成交量是否大於1000張

#### 解決方案
使用 `GetField` 函數取得跨頻率資料：
```xs
// 取得日頻率成交量
condition6 = GetField("Volume", "D") >= min_daily_volume;
```

#### GetField 函數語法
```xs
GetField("欄位名稱", "頻率代碼")
```

#### 常用頻率代碼
- `"D"` - 日頻率
- `"W"` - 週頻率  
- `"M"` - 月頻率
- `"Q"` - 季頻率
- `"Y"` - 年頻率

#### 實際應用範例
```xs
// 取得日頻率成交量
daily_volume = GetField("Volume", "D");

// 取得日頻率外資買賣超
foreign_trade = GetField("外資買賣超", "D");

// 取得日頻率融資餘額
margin_balance = GetField("融資餘額張數", "D");
```

#### 學習要點
- **跨頻率資料取得**：使用 `GetField("欄位名稱", "頻率代碼")`
- **頻率代碼記憶**：`"D"`=日, `"W"`=週, `"M"`=月
- **策略優化**：結合不同頻率的資料提升策略品質
- **流動性過濾**：使用日成交量過濾流動性不足的標的

### 案例 5：突破策略邏輯錯誤 - 條件判斷方向錯誤 (2024/12/19)

#### 問題描述
在突破策略中，信號棒識別條件寫錯了：
```xs
// ❌ 錯誤：信號棒沒有突破過去20根最高點
condition5 = High <= value4;  // 過去20根內沒創新高
```

#### 問題分析
- **邏輯錯誤**：突破策略的信號棒應該是**突破**過去高點，而不是**沒有突破**
- **策略失效**：錯誤的條件會讓策略無法識別真正的突破信號
- **概念混淆**：將「突破」和「未突破」的邏輯搞反了

#### 修正方法
```xs
// ✅ 正確：信號棒突破過去20根最高點
condition5 = High > value4;  // 突破過去20根K棒的最高點
```

#### 完整邏輯說明
```xs
// 計算過去20根K棒的最高點（不含當前K棒）
value4 = Highest(High[1], lookback_bars);

// 信號棒必須突破這個最高點
condition5 = High > value4;
```

#### 學習要點
- **突破策略核心**：信號棒必須突破過去N根K棒的最高點
- **邏輯方向要正確**：突破 = `>`，未突破 = `<=`
- **策略邏輯驗證**：寫完條件後要檢查是否符合策略邏輯
- **概念要清楚**：突破策略就是要找突破過去高點的K棒

### 案例 6：保留字首錯誤重複發生 - daily 保留字 (2024/12/19)

#### 問題描述
在增強版腳本中重複使用了 `daily` 保留字首：
```xs
// ❌ 錯誤：使用保留字首 daily
daily_close = GetField("Close", "D");
daily_ema8 = XAverage(daily_close, ema8_period);
daily_ema20 = XAverage(daily_close, ema20_period);
```

#### 錯誤訊息
```
「Daily」開頭為保留字,目前版本不支援「daily_close」語法。
變數 "daily_close"沒有宣告,請用Vars:的方式宣告
函數 XAverage 需要輸入2個參數。
```

#### 問題分析
- **重複錯誤**：之前已經記錄過 `daily` 是保留字首
- **變數命名**：使用了 `daily_close`, `daily_ema8`, `daily_ema20`
- **函數參數**：由於變數未正確宣告，導致 XAverage 函數參數錯誤

#### 修正方法
```xs
// ✅ 正確：使用 value 系列變數
value5 = GetField("Close", "D");
value6 = XAverage(value5, ema8_period);
value7 = XAverage(value5, ema20_period);
```

#### 學習要點
- **保留字記憶**：`daily` 是保留字首，不能用作變數名稱開頭
- **變數命名規範**：使用 `value` 系列或有意義的非保留字名稱
- **錯誤預防**：建立變數命名檢查清單
- **重複錯誤避免**：已記錄的錯誤要避免重複發生

### 案例 7：if/else if 區塊缺少 begin/end 導致語法錯誤 (2024/12/19)

#### 問題描述
在 `if Position > 0 then begin ... else if ...` 的結構中，`else if` 分支未以 `begin...end` 包住，造成「在 '>' 之前可能少了 ';'」與 `else 多餘` 的錯誤提示。

#### 修正方法
```xs
if Position > 0 then
begin
    if KBarOfDay >= 16 then
    begin
        SetPosition(0, market);
    end
    else if Close <= stop_loss then
    begin
        SetPosition(0, market);
    end
    else if Close >= take_profit then
    begin
        SetPosition(0, market);
    end;
end;
```

### 案例 8：警示腳本訊息應用 RetMsg 而非 alert() (2024/12/19)

#### 修正方法
```xs
// 警示腳本觸發
RetMsg = "訊息內容";  // 或 RetMsg = Text("時間 ", leftstr(NumToStr(CurrentTime,0),4));
ret = 1;
```

### 案例 9：選股腳本 OutputField 排序只能指定一個 (2024/12/19)

#### 問題
同時為多個 `OutputField` 指定 `order :=` 會報錯。

#### 修正
僅保留一欄排序，其餘不設定 `order`。

### 案例 10：跨頻率 EMA 前值取得錯誤 (2024/12/19)

#### 問題描述
在跨頻率計算中使用 `wk_ema20[1]` 取得前值，實際只會往前一天（主頻率），導致顯示與週K圖不一致。

#### 正確作法
```xs
wk_close      = GetField("Close", "W");
wk_ema20      = xf_XAverage("W", wk_close, 20);
wk_ema20_prev = xf_XAverage("W", wk_close[1], 20); // 來源整體位移一週再計算
```

### 案例 11：跨頻率必須使用 xf_ 函數族 (2024/12/19)

使用 `XAverage` 直接運算週資料在日頻率下不保證對齊；應改用 `xf_XAverage` / `xf_RSI` 等跨頻率函數。

### 案例 12：頻率強制檢查導致跨頻率腳本被阻擋 (2024/12/19)

在跨頻率腳本加入 `if barfreq <> "Day" then raiseruntimeerror(...)` 容易在掃描或回測時被阻擋；建議移除，改以 `xf_` 函數顯式指定所需頻率。

### 案例 2：日內突破策略編譯錯誤 - 保留字首 `Trade` (2024/10/04)

#### 錯誤訊息
```
"Trade"不允許當成變數開頭,請更改變數名稱。
「Trade」開頭為保留字,目前版本不支援「trade_executed」語法。
"="左右兩邊的型態不同。
"AND"左右兩邊的型態不同。
變數 "trade_executed"沒有宣告,請用Vars:的方式宣告,冒號後面是變數名稱再用括號填入預設值。例如:Vars:varA(100); 如果要宣告陣列請用 Arrays: 冒號後面是名稱再用[]設定維度與大小,括號填入預設值。例如Arrays:arr1[10](0);。
```

#### 問題分析
- 使用了 `trade_executed` 作為變數名稱
- `trade` 是 XScript 的保留字首，不能作為變數名稱的開頭
- 由於變數名稱不合法，導致編譯器無法正確宣告變數，進而引發後續的型態不符 (`=` 和 `AND`) 錯誤

#### 修正方法
```xs
// ❌ 錯誤
Vars: trade_executed(false);

// ✅ 正確
Vars: transaction_completed(false);
```

#### 相關變數修正
- `trade_executed` → `transaction_completed`
- `trade_count` → `transaction_count`

#### 學習要點
- **嚴格避免使用保留字或保留字首作為變數名稱**
- 常見的交易相關保留字首：`trade`, `order`, `position`, `filled`
- 建議使用更具描述性且不衝突的變數名稱，例如 `transaction_completed` 或 `order_status`

### 案例 1：日內突破策略編譯錯誤 (2024/10/04)

#### 錯誤訊息
```
"Daily"不允許當成變數開頭,請更改變數名稱。
「Daily」開頭為保留字,目前版本不支援「daily_trade」語法。
```

#### 問題分析
- 使用了 `daily_trade` 作為變數名稱
- `daily` 是 XScript 的保留字，不能作為變數名稱的開頭

#### 修正方法
```xs
// ❌ 錯誤
Vars: daily_trade(false);

// ✅ 正確
Vars: trade_executed(false);
```

#### 相關變數修正
- `daily_trade` → `trade_executed`
- `daily_trades` → `trade_count`

#### 學習要點
- 不僅要避免完整的保留字，也要避免以保留字開頭的變數名
- 常見的時間相關保留字：`daily`, `minute`, `hour`, `day`, `week`, `month`
- 建議使用更具描述性的變數名稱，如 `trade_executed` 而非 `daily_trade`

---

**注意**：這份文件會持續更新，請定期查看最新版本。
