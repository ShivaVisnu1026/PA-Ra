# XScript AddSpread 函數使用說明

## 📚 函數概述

`AddSpread` 是 XScript 的內建交易函數，用於計算依照商品跳動點加減幾檔後的價格。

## 🔧 語法

```xs
Value1 = AddSpread(基礎價格, 檔位);
```

## 📝 參數說明

### 參數 1：基礎價格
- **類型**：數值
- **說明**：作為計算基礎的價格
- **範例**：`Close`, `High`, `Low`, `Open`, 或任何價格變數

### 參數 2：檔位
- **類型**：整數
- **說明**：
  - 正數：加檔數（價格上漲）
  - 負數：減檔數（價格下跌）
  - 零：不變

## 💡 使用範例

### 基本用法
```xs
// 收盤價 +1 檔
Value1 = AddSpread(Close, 1);

// 最低價 -1 檔
Value2 = AddSpread(Low, -1);

// 最高價 +5 檔
Value3 = AddSpread(High, 5);
```

### 實際應用範例
```xs
// 計算進場價格（信號棒高點 +1 檔）
entry_price = AddSpread(signal_high, 1);

// 計算停損價格（信號棒低點 -1 檔）
stop_loss = AddSpread(signal_low, -1);

// 計算停利價格（進場價 +10 檔）
take_profit = AddSpread(entry_price, 10);
```

## ⚠️ 重要特性

### 1. 自動處理跳動點
- 系統會根據商品的跳動點自動計算
- 不同商品有不同的跳動點設定
- 例如：股票通常為 0.01，加權指數也為 0.01

### 2. 漲跌停限制
- 如果商品有漲跌停限制，計算後的數值不會超過限制
- 自動保護避免超出交易範圍

### 3. 無檔位限制商品
- 對於沒有檔位限制的商品（如加權指數）
- 系統會以商品的報價跳動點來當成檔位的計算依據

## 🎯 在日內突破策略中的應用

### 進場條件
```xs
// 計算信號棒高點 +1tick 的價格
target_price = AddSpread(signal_high, 1);

// 檢查即時價格是否從下往上碰到目標價格
if Low <= target_price and High >= target_price then
begin
    // 進場做多
    entry_price = target_price;
    SetPosition(1, entry_price);
end;
```

### 優勢
1. **精確計算**：自動處理不同商品的跳動點
2. **避免錯誤**：不會因為手動計算跳動點而產生誤差
3. **通用性**：適用於各種不同跳動點的商品
4. **安全性**：自動處理漲跌停限制

## 📊 與手動計算的比較

### ❌ 手動計算（容易出錯）
```xs
// 假設跳動點為 0.01
entry_price = signal_high + 0.01;  // 可能不適用於所有商品
```

### ✅ 使用 AddSpread（推薦）
```xs
// 自動處理跳動點
entry_price = AddSpread(signal_high, 1);  // 適用於所有商品
```

## 🔍 常見使用場景

### 1. 進場價格計算
```xs
// 突破進場
entry_price = AddSpread(resistance_level, 1);

// 回調進場
entry_price = AddSpread(support_level, -1);
```

### 2. 停損停利設定
```xs
// 固定點數停損
stop_loss = AddSpread(entry_price, -10);

// 固定點數停利
take_profit = AddSpread(entry_price, 20);
```

### 3. 價格區間計算
```xs
// 計算價格區間
upper_bound = AddSpread(current_price, 5);
lower_bound = AddSpread(current_price, -5);
```

## 📚 參考資料

- [XScript 官方 AddSpread 函數說明](https://xshelp.xq.com.tw/XSHelp/?HelpName=AddSpread&group=TRANSACTIONFUNC)
- XScript 內建函數手冊
- 交易函數相關文件

## 💡 最佳實踐

1. **優先使用 AddSpread**：比手動計算跳動點更準確
2. **注意檔位方向**：正數加檔，負數減檔
3. **考慮商品特性**：不同商品有不同的跳動點
4. **測試驗證**：在實際使用前先測試計算結果

---

**注意**：`AddSpread` 函數是 XScript 交易策略中的重要工具，建議在需要精確價格計算時優先使用。
