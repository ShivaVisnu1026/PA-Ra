Array_Sort需要傳入四個參數:

執行後這個陣列內指定範圍內元素將會依照指定的排序方式重新排列。

舉例:

```
Array: arr[5](0); // 宣告arrA是一個有5個元素的陣列，初始值都是0


arr[1] = 1;  arr[2] = 3; arr[3] = 5; arr[4] = 2; arr[5] = 4;


Array_Sort(arr, 1, 5, true);   // arr = [1, 2, 3, 4, 5]
Array_Sort(arr, 1, 5, false);  // arr = [5, 4, 3, 2, 1]
```

```
Array: arr[5](0); // 宣告arrA是一個有5個元素的陣列，初始值都是0


arr[1] = 1;  arr[2] = 3; arr[3] = 5; arr[4] = 2; arr[5] = 4;


Array_Sort(arr, 1, 5, true);   // arr = [1, 2, 3, 4, 5]
Array_Sort(arr, 1, 5, false);  // arr = [5, 4, 3, 2, 1]
```

上例內第一次呼叫Array_Sort時，傳入的順序是true，所以會從小排到大，執行完成後arr的內容變成
[1, 2, 3, 4, 5]。

第二次呼叫Array_Sort時，傳入的順序是false，所以會從大排到小，執行完成後arr的內容變成[5, 4, 3, 2, 1]。
