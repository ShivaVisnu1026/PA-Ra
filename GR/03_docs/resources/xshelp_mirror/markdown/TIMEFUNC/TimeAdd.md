時間數值是一個5~6碼的數字，格式是HHMMSS：

通常是透過CurrentTime，Time(資料的時間欄位)，或是其他時間相關函數所產生的時間數值。

時間數值也可以是一個含有毫秒的 8~9 碼的數字，格式是HHMMSS.fff：

通常是透過CurrentTimeMS， FilledRecordTimeMS ，或是其他含有毫秒的時間相關函數所產生的時間數值。

第二個參數是要執行運算的時間欄位單位，如果我們要計算第一個時間的後幾小時的話，則傳入"H"，如果我們要計算第一個時間的後幾分的話，則傳入"M"，如果我們要計算第一個時間的後幾秒的話，則傳入"S"，如果我們要計算第一個時間的後幾毫秒的話，則傳入"MS"。

第三個參數則是要 增加 的數值，可以是正數(表示往後加), 也可以是負數(表示往前減)。

TimeAdd回傳的數值也是HHMMSS或者HHMMSS.fff的時間格式。

以下是簡單的範例：

```
Value1 = TimeAdd(120000, "H", 1);	// Value1 = 130000
Value2 = TimeAdd(123000, "M", -30); // Value2 = 120000
Value3 = TimeAdd(120000, "MS", 1); // Value3 = 120000.001
```

```
Value1 = TimeAdd(120000, "H", 1);	// Value1 = 130000
Value2 = TimeAdd(123000, "M", -30); // Value2 = 120000
Value3 = TimeAdd(120000, "MS", 1); // Value3 = 120000.001
```

以下是一個應用範例，使用１分鐘頻率執行，利用TimeAdd來判斷目前資料是否是位於創新高後的１小時內:

```
Var: HighTime(0);
if Date <> Date[1] then HighTime = 0;
if H > Highest(H[1],60) then HighTime = Time;


if HighTime > 0 And Time > HighTime And Time < TimeAdd(HighTime,"H",1) Then 
Begin
   // 創新高後的1小時內
End;
```

```
Var: HighTime(0);
if Date <> Date[1] then HighTime = 0;
if H > Highest(H[1],60) then HighTime = Time;


if HighTime > 0 And Time > HighTime And Time < TimeAdd(HighTime,"H",1) Then 
Begin
   // 創新高後的1小時內
End;
```

請注意上述範例內當Date不等於Date[1]時(分鐘線資料換日)必須把HighTime清掉，以確保HighTime是當日創新高的時間點。
