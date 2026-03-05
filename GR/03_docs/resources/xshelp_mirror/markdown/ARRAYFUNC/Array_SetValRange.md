Array_SetValRange需要傳入四個參數:

執行時，從這個陣列的開始位置一直到結束位置的每個元素的數值都會被改成為新設定的數值。

```
Array: arr[5](0); // 宣告arrA是一個有5個元素的陣列，初始值都是0


arr[1] = 1;  arr[2] = 2; arr[3] = 3; arr[4] = 4; arr[5] = 5;


Array_SetValRange(arr, 1, 3, 0); // arr[1] = 0, arr[2] = 0, arr[3] = 0, arr[4] = 4, arr[5] = 5
```

```
Array: arr[5](0); // 宣告arrA是一個有5個元素的陣列，初始值都是0


arr[1] = 1;  arr[2] = 2; arr[3] = 3; arr[4] = 4; arr[5] = 5;


Array_SetValRange(arr, 1, 3, 0); // arr[1] = 0, arr[2] = 0, arr[3] = 0, arr[4] = 4, arr[5] = 5
```

在上例內呼叫Array_SetValRange，位置從1到3，新設定的數值為0。所以執行結束後arr[1], arr[2], arr[3]的數值都會被改成0，而arr[4]跟arr[5]的值則維持不變。
