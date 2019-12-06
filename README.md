

[![License](https://img.shields.io/badge/license-Apache%202-4EB1BA.svg)](https://www.apache.org/licenses/LICENSE-2.0.html) [![Wencst Author](https://img.shields.io/badge/Wencst-Website-ff69b4.svg)](https://www.wencst.com) [![Wencst QQ](https://img.shields.io/badge/Wencst-QQ群-ff69b4.svg)](https://jq.qq.com/?_wv=1027&k=5Qu9IHC)



## USAGE

To change the file title number: 

​	`./changeTitleNumber.sh filename.md`

To get help tips: 

​	`./changeTitleNumber.sh help`



## EXAMPLE

Init in markdown file:

```
# first title
first line
## second title
second line
# third title
third line
# 2. fouth title

## 2.1. fifth title

# 3. sixth title
```



After execute this shell:

```
# 1. first title
first line
## 1.1. second title
second line
# 2. third title
third line
# 3. fouth title

## 3.1. fifth title

# 4. sixth title
```



## TIPS

1.The file must be a markdown file, and the filename must be end with '.md'.

2.The title line must be start with '#', and should use space to split 'the last #' and 'title number' and 'title line', and the title number is not necessary.

3.The first title will be the highest level, and other titles in this file can't be higher than it.

4.The title's level should not leapfrog.

5.To refresh title's level number, you can execute 'changeTitleNumber.sh filename.md' again.

6.The title number is not necessary, and could only use '0-9.' in title.

