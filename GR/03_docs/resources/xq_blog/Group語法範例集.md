# XQ Group 語法範例集

## 📚 概述

基於 XQ官方部落格抓取的內容，整理出 Group 語法的實際應用範例。Group 語法是 XQ 特有的功能，用於處理細產業分析。

## 🔧 基本 Group 語法結構

### **標準模板**
```xs
Group: _group();//宣告群組
var: _i(0), _size(0);
_group = GetSymbolGroup("成份股");//指定群組的商品

// 檢查是否有資料
_size = GroupSize(_group);
if _size = 0 then return;

// 迴圈運算前，初始化變數
value1 = 0;
value2 = 0;
value3 = 0;

// 迴圈計算每一檔成份股數值
for _i = 0 to _size - 1 do
begin
    // 處理每個成份股
    value1 += GetField("欄位名稱", "D");
    value2 += GetField("另一個欄位", "D");
end;

// 輸出結果
OutputField1(value1);
OutputField2(value2);
```

## 📊 實際應用範例

### **1. 細產業整體來自營運的現金流量**

```xs
Group: _group();//宣告群組
var: _i(0), _size(0);
_group = GetSymbolGroup("成份股");//指定群組的商品

// 檢查是否有資料
_size = GroupSize(_group);
if _size = 0 then return;

// 迴圈運算前，初始化變數
value1 = 0;  // 現金流量總計
value2 = 0;  // 公司數量
value3 = 0;  // 平均值

// 迴圈計算每一檔成份股數值
for _i = 0 to _size - 1 do
begin
    // 取得每檔股票的現金流量
    value1 += GetField("來自營運活動之現金流量", "D");
    value2 += 1;  // 計數
end;

// 計算平均值
if value2 > 0 then
    value3 = value1 / value2;

// 輸出結果
OutputField1(value1);  // 總現金流量
OutputField2(value3);  // 平均現金流量
```

### **2. 細產業整體營業利益分析**

```xs
Group: _group();//宣告群組
var: _i(0), _size(0);
_group = GetSymbolGroup("成份股");//指定群組的商品

_size = GroupSize(_group);
if _size = 0 then return;

// 初始化變數
value1 = 0;  // 營業利益總計
value2 = 0;  // 公司數量
value3 = 0;  // 平均營業利益

// 迴圈計算
for _i = 0 to _size - 1 do
begin
    value1 += GetField("營業利益", "D");
    value2 += 1;
end;

// 計算平均值
if value2 > 0 then
    value3 = value1 / value2;

OutputField1(value1);  // 總營業利益
OutputField2(value3);  // 平均營業利益
```

### **3. 細產業平均本益比分析**

```xs
Group: _group();//宣告群組
var: _i(0), _size(0);
_group = GetSymbolGroup("成份股");//指定群組的商品

_size = GroupSize(_group);
if _size = 0 then return;

// 初始化變數
value1 = 0;  // 本益比總計
value2 = 0;  // 有效本益比數量
value3 = 0;  // 平均本益比

// 迴圈計算
for _i = 0 to _size - 1 do
begin
    // 取得本益比，排除無效值
    if GetField("本益比", "D") > 0 and GetField("本益比", "D") < 100 then
    begin
        value1 += GetField("本益比", "D");
        value2 += 1;
    end;
end;

// 計算平均值
if value2 > 0 then
    value3 = value1 / value2;

OutputField1(value3);  // 平均本益比
OutputField2(value2);  // 有效樣本數
```

### **4. 細產業整體資本支出**

```xs
Group: _group();//宣告群組
var: _i(0), _size(0);
_group = GetSymbolGroup("成份股");//指定群組的商品

_size = GroupSize(_group);
if _size = 0 then return;

// 初始化變數
value1 = 0;  // 資本支出總計
value2 = 0;  // 公司數量
value3 = 0;  // 平均資本支出

// 迴圈計算
for _i = 0 to _size - 1 do
begin
    value1 += GetField("資本支出", "D");
    value2 += 1;
end;

// 計算平均值
if value2 > 0 then
    value3 = value1 / value2;

OutputField1(value1);  // 總資本支出
OutputField2(value3);  // 平均資本支出
```

### **5. 細產業整體庫存變化**

```xs
Group: _group();//宣告群組
var: _i(0), _size(0);
_group = GetSymbolGroup("成份股");//指定群組的商品

_size = GroupSize(_group);
if _size = 0 then return;

// 初始化變數
value1 = 0;  // 庫存總計
value2 = 0;  // 公司數量
value3 = 0;  // 平均庫存

// 迴圈計算
for _i = 0 to _size - 1 do
begin
    value1 += GetField("存貨", "D");
    value2 += 1;
end;

// 計算平均值
if value2 > 0 then
    value3 = value1 / value2;

OutputField1(value1);  // 總庫存
OutputField2(value3);  // 平均庫存
```

## 🎯 進階應用技巧

### **1. 條件篩選**
```xs
// 只計算符合條件的公司
for _i = 0 to _size - 1 do
begin
    // 只計算市值大於100億的公司
    if GetField("市值", "D") > 100000000 then
    begin
        value1 += GetField("營業利益", "D");
        value2 += 1;
    end;
end;
```

### **2. 加權計算**
```xs
// 以市值加權計算
for _i = 0 to _size - 1 do
begin
    market_cap = GetField("市值", "D");
    if market_cap > 0 then
    begin
        value1 += GetField("營業利益", "D") * market_cap;
        value2 += market_cap;
    end;
end;

// 計算加權平均
if value2 > 0 then
    value3 = value1 / value2;
```

### **3. 排名分析**
```xs
// 找出產業中表現最好的公司
var: max_value(0), max_index(0);
for _i = 0 to _size - 1 do
begin
    current_value = GetField("營業利益成長率", "D");
    if current_value > max_value then
    begin
        max_value = current_value;
        max_index = _i;
    end;
end;
```

## 📈 產業分析應用

### **1. 產業景氣判斷**
```xs
// 綜合多個指標判斷產業景氣
Group: _group();
var: _i(0), _size(0);
_group = GetSymbolGroup("成份股");
_size = GroupSize(_group);

// 計算多個指標
value1 = 0;  // 營收成長率
value2 = 0;  // 獲利成長率
value3 = 0;  // 資本支出
value4 = 0;  // 公司數量

for _i = 0 to _size - 1 do
begin
    value1 += GetField("營收成長率", "D");
    value2 += GetField("獲利成長率", "D");
    value3 += GetField("資本支出", "D");
    value4 += 1;
end;

// 計算平均值
if value4 > 0 then
begin
    value1 = value1 / value4;
    value2 = value2 / value4;
    value3 = value3 / value4;
end;

// 輸出結果
OutputField1(value1);  // 平均營收成長率
OutputField2(value2);  // 平均獲利成長率
OutputField3(value3);  // 平均資本支出
```

### **2. 產業輪動分析**
```xs
// 比較不同時期的產業表現
Group: _group();
var: _i(0), _size(0);
_group = GetSymbolGroup("成份股");
_size = GroupSize(_group);

// 計算當期和前期數據
value1 = 0;  // 當期總營收
value2 = 0;  // 前期總營收
value3 = 0;  // 成長率

for _i = 0 to _size - 1 do
begin
    value1 += GetField("營收", "D");
    value2 += GetField("營收", "D")[1];
end;

// 計算成長率
if value2 > 0 then
    value3 = (value1 - value2) / value2 * 100;

OutputField1(value3);  // 產業營收成長率
```

## 💡 最佳實踐

### **1. 錯誤處理**
```xs
// 檢查群組是否有效
_size = GroupSize(_group);
if _size = 0 then return;

// 檢查欄位是否有效
if GetField("欄位名稱", "D") = 0 then continue;
```

### **2. 效能優化**
```xs
// 避免不必要的計算
if _size > 100 then
begin
    // 只計算前100家公司
    _size = 100;
end;
```

### **3. 資料驗證**
```xs
// 驗證資料合理性
current_value = GetField("本益比", "D");
if current_value > 0 and current_value < 1000 then
begin
    // 只處理合理的本益比
    value1 += current_value;
    value2 += 1;
end;
```

## 📚 學習資源

- [XQ官方部落格](https://www.xq.com.tw/xstrader/)
- [Group 語法官方文件](https://xshelp.xq.com.tw/)
- 專案中的實際範例檔案

---

**注意**：Group 語法是 XQ 特有的功能，需要正確設定群組才能使用。建議先從簡單的範例開始學習，逐步掌握進階技巧。
