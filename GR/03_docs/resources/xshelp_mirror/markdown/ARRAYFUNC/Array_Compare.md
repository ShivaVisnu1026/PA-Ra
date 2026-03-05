比對執行的方式如下:

舉例:

```
Array: arrA[5](0); // 宣告arrA是一個有5個元素的陣列，初始值都是0
Array: arrB[5](0); // 宣告arrB是一個有5個元素的陣列，初始值都是0
Array: arrC[5](0); // 宣告arrC是一個有5個元素的陣列，初始值都是0


arrA[1] = 0;  arrA[2] = 10; arrA[3] = 20; arrA[4] = 30; arrA[5] = 40;
arrB[1] = 0;  arrB[2] = 0;  arrB[3] = 10; arrB[4] = 20; arrB[5] = 30;
arrC[1] = 0;  arrC[2] = 20; arrC[3] = 30; arrC[4] = 40; arrC[5] = 50;


Value1 = Array_Compare(arrA, 1, arrB, 1, 3); // 範例1: Value1 = 1
Value2 = Array_Compare(arrA, 1, arrC, 1, 3); // 範例2: Value2 = -1
Value3 = Array_Compare(arrA, 1, arrB, 2, 3); // 範例3: Value3 = 0
Value4 = Array_Compare(arrA, 1, arrB, 1, 8); // 範例4: Value4 = -2
```

```
Array: arrA[5](0); // 宣告arrA是一個有5個元素的陣列，初始值都是0
Array: arrB[5](0); // 宣告arrB是一個有5個元素的陣列，初始值都是0
Array: arrC[5](0); // 宣告arrC是一個有5個元素的陣列，初始值都是0


arrA[1] = 0;  arrA[2] = 10; arrA[3] = 20; arrA[4] = 30; arrA[5] = 40;
arrB[1] = 0;  arrB[2] = 0;  arrB[3] = 10; arrB[4] = 20; arrB[5] = 30;
arrC[1] = 0;  arrC[2] = 20; arrC[3] = 30; arrC[4] = 40; arrC[5] = 50;


Value1 = Array_Compare(arrA, 1, arrB, 1, 3); // 範例1: Value1 = 1
Value2 = Array_Compare(arrA, 1, arrC, 1, 3); // 範例2: Value2 = -1
Value3 = Array_Compare(arrA, 1, arrB, 2, 3); // 範例3: Value3 = 0
Value4 = Array_Compare(arrA, 1, arrB, 1, 8); // 範例4: Value4 = -2
```

第一個範例比對arrA的第一個位置開始的三個數字跟arrB的第一個位置開始的三個數字，也就是比對 (arrA[1], arrA[2], arrA[3])這三個數字與 (arrB[1], arrB[2], arrB[3])這三個數字的差異。其中 arrA的三個數字分別為 (0, 10, 20), 而 arrB的三個數字分別為 (0, 0, 10)。比對時兩邊的第一個數字是相同的(都是0)，而第二個數字 arrA的10 > arrB的0，所以回傳1。

第二個範例比對arrA的第一個位置開始的三個數字跟arrC的第一個位置開始的三個數字，也就是比對 (arrA[1], arrA[2], arrA[3])這三個數字與 (arrC[1], arrC[2], arrC[3])這三個數字的差異。其中 arrA的三個數字分別為 (0, 10, 20), 而 arrC的三個數字分別為 (0, 20, 30)。比對時兩邊的第一個數字是相同的(都是0)，而第二個數字 arrA的10 < arrC的20，所以回傳-1。

第三個範例比對arrA的第一個位置開始的三個數字跟arrB的第二個位置開始的三個數字，也就是比對 (arrA[1], arrA[2], arrA[3])這三個數字與 (arrB[2], arrB[3], arrB[4])這三個數字的差異。其中 arrA的三個數字分別為 (0, 10, 20), 而 arrB的三個數字分別為 (0, 10, 20)。由於這三個數字都一樣，所以回傳0。

第四個範例內，從第一個位置開始比，總共比8個，可是陣列內只有5個元素，超過範圍，於是回傳-2。
