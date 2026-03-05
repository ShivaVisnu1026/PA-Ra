Array_Sum除了要傳入陣列變數之外，尚須傳入要進行加總的開始位置跟結束位置。

舉例:

```
Array: arr[5](0); // 宣告arrA是一個有5個元素的陣列，初始值都是0


arr[1] = 1;  arr[2] = 2; arr[3] = 3; arr[4] = 4; arr[5] = 5;


Value1 = Array_Sum(arr, 1, 5); // Value1 = 15 (1 + 2 + 3 + 4 + 5)
Value2 = Array_Sum(arr, 1, 3); // Value2 = 6 (1 + 2 + 3)
```

```
Array: arr[5](0); // 宣告arrA是一個有5個元素的陣列，初始值都是0


arr[1] = 1;  arr[2] = 2; arr[3] = 3; arr[4] = 4; arr[5] = 5;


Value1 = Array_Sum(arr, 1, 5); // Value1 = 15 (1 + 2 + 3 + 4 + 5)
Value2 = Array_Sum(arr, 1, 3); // Value2 = 6 (1 + 2 + 3)
```

上例內Value1是arr這個陣列從第一個元素加總到第五個元素的數值，也就是等於arr[1] + arr[2] + arr[3] + arr[4] + arr[5] = 15，而Value2則是從第一個元素到第三個元素的加總 (1 + 2 + 3 = 6)。
