(僅適用於函數腳本內)

NumericRef 語法用來定義函數腳本的參數為數值型態，並且可以從函數內修改呼叫者傳入的數值。

當一個函數變數被宣告成 Numeric 時，在函數內對這個數值的修改並不會影響呼叫者端傳入的變數，這個行為稱之為 Call By Value 。

如果有需要從函數內可以更改呼叫者端的變數的話，則可以使用 NumericRef 的語法，此時的行為會變成 Call By Reference 。

```
// MACD function
//  Input: Price序列, FastLength, SlowLength, MACDLength
//  Output: DifValue, MACDValue, OscValue
//
Input: Price(numericseries);
Input: FastLength(numericsimple);
Input: SlowLength(numericsimple);
Input: MACDLength(numericsimple);


Input: DifValue(numericref);
Input: MACDValue(numericref);
Input: OscValue(numericref);


DifValue = XAverage(price, FastLength) - XAverage(price, SlowLength);
MACDValue = XAverage(DifValue, MACDLength) ;
OscValue = DifValue - MACDValue;
```

```
// MACD function
//  Input: Price序列, FastLength, SlowLength, MACDLength
//  Output: DifValue, MACDValue, OscValue
//
Input: Price(numericseries);
Input: FastLength(numericsimple);
Input: SlowLength(numericsimple);
Input: MACDLength(numericsimple);


Input: DifValue(numericref);
Input: MACDValue(numericref);
Input: OscValue(numericref);


DifValue = XAverage(price, FastLength) - XAverage(price, SlowLength);
MACDValue = XAverage(DifValue, MACDLength) ;
OscValue = DifValue - MACDValue;
```

在上述MACD函數內，呼叫者端傳入了價格序列( Price ), 短天期( FastLength ), 長天期( SlowLength )，以及MACD的天期( MACDLength )，函數內要算出 DIF 的數值, MACD 的數值, 以及 OSC 的數值。由於總共有三個數值需要回傳，所以利用 NumericRef 的方式來完成。

呼叫者端的程式碼範例如下：

```
input: FastLength(12), SlowLength(26), MACDLength(9);
variable: difValue(0), macdValue(0), oscValue(0);


MACD(Close, FastLength, SlowLength, MACDLength, difValue, macdValue, oscValue);


Ret = difValue Crosses Above macdValue;
```

```
input: FastLength(12), SlowLength(26), MACDLength(9);
variable: difValue(0), macdValue(0), oscValue(0);


MACD(Close, FastLength, SlowLength, MACDLength, difValue, macdValue, oscValue);


Ret = difValue Crosses Above macdValue;
```

注意到當呼叫完 MACD 函數後, difValue , macdValue , 以及 oscValue 的數值都會從MACD函數內回傳。
