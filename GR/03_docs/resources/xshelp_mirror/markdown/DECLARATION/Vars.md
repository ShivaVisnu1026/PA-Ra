Var 語法用來宣告變數，並且給定變數的預設值。

系統會根據 Var 語法內給定的預設值的型態來決定變數的類型。目前系統提供以下三種變數類型:

語法如下:

```
Var: SumValue(0);
Var: StrValue("");
Var: Flag(True);
```

```
Var: SumValue(0);
Var: StrValue("");
Var: Flag(True);
```

在上述的範例內宣告了三個變數:

多個變數也可以在同一行內宣告，例如可以把上述範例寫成:

```
Var: SumValue(0), StrValue(""), Flag(True);
```

```
Var: SumValue(0), StrValue(""), Flag(True);
```

除了 Var 語法之外，也可以使用 Vars 語法， Variable 語法，或是 Variables 語法來宣告變數，範例如下：

```
Vars: SumValue(0);
Variable: StrValue("");
Variables: Flag(True);
```

```
Vars: SumValue(0);
Variable: StrValue("");
Variables: Flag(True);
```
