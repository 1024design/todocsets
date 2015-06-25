# todocsets


**转换 markdown 与 html 文件为 DocSets 格式**

## 安装

`npm install -g todocsets`

## 使用

转换 markdown 格式文件

`todocsets yourfil.md`

转换 html 格式文件

`todocsets yourfile.html`

转换指定目录下所有文件

`todocsets youfiledir`



## 高级使用

* -n, --name 

	指定文件名，默认使用待转换文件文件名.

* -d PATH, --destination PATH 

	转换后文件保存位置，默认 `~/Library/Application Support/html2dash/DocSets` 

* -i FILENAME, --icon FILENAME

	PNG 图标文件路径.
	
* - s  SQLite Index	
	
	指定index 配置文件，
	
* -h, --help

	显示帮助.

## 参考链接

- 