關於資料讀取範圍的定義，請參考 資料讀取範圍與腳本執行的關係 。

SetFirstBarDate 函數用於控制腳本執行時，所使用的第一個資料的日期，從而確定資料讀取的起始範圍。

語法為 SetFirstBarDate(YYYYMMDD)，其中 YYYYMMDD 是起始日期的年、月、日，且必須為合理有效的日期。

需要注意的是，SetFirstBarDate 不支援交易腳本 。

如果在腳本中多次使用 SetFirstBarDate 函數，並設定了不同的日期：

若設定的日期不是合理有效的日期，該行的 SetFirstBarDate 將被視為編譯失敗。

如果在腳本中同時存在數個 SetTotalBar 和 SetFirstBarDate，並設定了不同的數值時：

若其中一個函數因參數無效（例如 SetTotalBar 的資料讀取筆數為負數，或 SetFirstBarDate 的日期不合理）而編譯失敗，則只有另一個成功編譯的函數設定會被採用。
