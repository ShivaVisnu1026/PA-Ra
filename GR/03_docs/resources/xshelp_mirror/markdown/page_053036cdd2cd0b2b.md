BS選擇權定價模型為諾貝爾經濟學獎得主Robert Merton和Myron Scholes於1973所發表。依據下列六個參數決定選擇權的理論價：標的價格、履約價、到期天數、無風險利率、持有成本、波動率。其中只有履約價和到期天數是由合約所規定，其餘參數皆會隨市場狀況而變動。

持有成本會因標的商品的不同而異：

這個函數可以依照使用者傳入的參數，計算選擇權的理論價、Delta、Gamma、Vega、Theta及Rho。

範例：

```
value1 = BlackScholesModel("C",8800,9000,20,2,0,25,value2,value3,value4,value5,value6,value7);       //計算波動率25%、20天後到期之台指選擇權9000的Call在指數為8800點的理論價
plot1(value2, "理論價");   
plot2(value3, "Delta");   
plot3(value4, "Gamma");   
plot4(value5, "Vega");   
plot5(value6, "Theta");   
plot6(value7, "Rho");
```

```
value1 = BlackScholesModel("C",8800,9000,20,2,0,25,value2,value3,value4,value5,value6,value7);       //計算波動率25%、20天後到期之台指選擇權9000的Call在指數為8800點的理論價
plot1(value2, "理論價");   
plot2(value3, "Delta");   
plot3(value4, "Gamma");   
plot4(value5, "Vega");   
plot5(value6, "Theta");   
plot6(value7, "Rho");
```
