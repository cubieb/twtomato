# Introduction #

如何用GCC編譯UTF8檔能正確顯示中文

http://blog.xuite.net/hsuyucheng/Knight/14446557

http://bbs.chinaunix.net/viewthread.php?tid=947464&page=1


# Details #

正解:

經測試並不會出現你說的錯誤，不過你這問題我倒是想起一個可能。

因為UTF-8在保存時會有一個「BOM」的問題。也就是說文件開頭有三個特殊的字符來標識這是一個UTF-8文件，大部分編輯器會知道並跳過它。但gcc 恐怕就不會了吧

所以只要您把文件開頭那三字節清除就可以了。：）

因為 UTF-8 的編碼很周到，高低位都能分出來，更不會去和單字節的token衝突了



---

11/18 隨筆 終於讓我弄出用GCC編譯UTF8檔能正確顯示中文

自我接觸到GVIM起 就被這套精幹的文書編輯程式深深吸引住
所以我不斷完善此文書的功能
好比說 目前我賦予了他能看多國語文的能力 又修改它成為UTF8模式
但是 由於改成UTF8的規格 存檔也為UTF8 導致寫程式發生難題

來源檔是UTF8 對於JAVA來說 只需要在編譯時加入區域碼就能編譯正確
但是對於GCC來說 卻是ㄧ大難題
此為原始碼
#include
int main( )
{
char **s="我是 asd";
printf("%s",s);
return 0;
}**

編譯後 執行結果

本應是出現中文卻成為亂碼? 這是因為UTF8編碼的來源檔導致
GCC編譯時無法辨識出這是中文

在來我使用C所提供的UNICODE含式
原始碼
#include
#include
int main( void ) {
wchar\_t myString[16](16.md)={ L"這是字串" };
printf("This is Chinese out\n");
wprintf(L"%ls\n", myString);
printf("This is End");
return 0;
}
編譯後 執行結果

詭異 應該出現中文處 卻完全不會顯示 連亂碼也沒有
有兩個原因 1.需要設置區域環境 但是gcc卻無法找到
[詭異的是該設置參數就能用於g++]
2.他無法直接呈現於DOS這種控制程式 需要寫視窗程式來顯示

所以在我今日不斷琢磨下
在gcc找到以下 參數
`-fexec-charset=CHARSET'
Set the execution character set, used for string and character
constants. The default is UTF-8. CHARSET can be any encoding
supported by the system's `iconv' library routine.

`-fwide-exec-charset=CHARSET'
Set the wide execution character set, used for wide string and
character constants. The default is UTF-32 or UTF-16, whichever
corresponds to the width of `wchar\_t'. As with
`-ftarget-charset', CHARSET can be any encoding supported by the
system's `iconv' library routine; however, you will have problems
with encodings that do not fit exactly in `wchar\_t'.

`-finput-charset=CHARSET'
Set the input character set, used for translation from the
character set of the input file to the source character set used
by GCC. If the locale does not specify, or GCC cannot get this
information from the locale, the default is UTF-8. This can be
overridden by either the locale or this command line option.
Currently the command line option takes precedence if there's a
conflict. CHARSET can be any encoding supported by the system's
`iconv' library routine.

同樣的原始碼
#include
int main( )
{
char **s = "我是許育誠";
printf("%s", s);
return 0;
}
該檔依舊是UTF8格式
編譯時採用 gcc -fexec-charset=BIG5 檔案名稱.c 檔案名稱**

喔喔 這樣以後 我可以盡情享受GVIM了 真好