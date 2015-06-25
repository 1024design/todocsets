#index.coffee
# _ = require 'lodash'
S = require 'string'
fs = require 'fs'
path = require 'path'
mkdirp = require 'mkdirp'
sugar = require 'sugar'
markdown = require('markdown').markdown
cheerio = require('cheerio')
args = require('yargs').demand(1).argv

config = {}

helptext = """
-n 指定文件名，默认使用待转换文件文件名.

-d 转换后文件保存位置，默认 `~/Library/Application Support/html2dash/DocSets` 

-i PNG 图标文件路径.
	
-s SQLite Index

-h, --help

	显示帮助.
"""



config.source = args._[0]

targetstat = fs.lstatSync config.source
config.sourceidir = targetstat.isDirectory()

config.source = path.resolve config.source

config.extname = path.extname config.source

config.basename = S(path.basename config.source).chompRight(config.extname).s


config.target = __dirname

if config.sourceidir is yes
	config.type = 'dir'
else
	exn = config.extname
	ex = switch
		when exn in ['.md','.MD']
			config.type = 'md'
		when exn in ['.htm','.html','.HTML','.HTM']
			config.type = 'html'
		else
			process.exit

if args.h?
	console.log helptext
	process.exit


if (typeof args.i) is 'string' then config.icon = args.i

if (typeof args.n) is 'string' then config.basename = args.n




#############################
# mkdirp "#{__dirname}/#{config.basename}.docset/Contents/Resources/Documents/", (err)->
# 	if err
# 		console.log err
# # 		process.exit
# fileText = fs.readFileSync('h.html').toString()
# # h = markdown.toHTML(fileText)
# # console.log  h
# $ = cheerio.load fileText
# $(":header").each( (i,el)->
# 	el.attribs.id = el.children[0].data.escapeURL(true)
# 	# el.attr 'id', 'a'
# 	# console.dir el.children[0]
# 	)
# fs.writeFileSync 'k.txt', $.html()
# # headarray = $(":header",fileText).attr 'id', 'a'
# headarray = headarray.toArray()
# for i in headarray
# 	console.log i.attribs

# console.dir $(":header",h)['0']
############################

plist = """
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>CFBundleIdentifier</key>
	<string>#{config.basename}</string>
	<key>CFBundleName</key>
	<string>#{config.basename}</string>
	<key>DocSetPlatformFamily</key>
	<string>#{config.basename}</string>
	<key>isDashDocset</key>
	<true/>
</dict>
</plist>
"""

mkdirp "#{config.target}/#{config.basename}.docset/Contents/Resources/Documents/", (err)->
	if err
		console.log err
	fs.writeFileSync "#{config.target}/#{config.basename}.docset/Contents/Info.plist", plist
	
	switch config.type
		when 'html'
			fileText = fs.readFileSync(config.source).toString()
			$ = cheerio.load fileText
			$(":header").each( (i,el)->
				el.attribs.id = el.children[0].data.escapeURL(true)
				)
			fs.writeFileSync "#{config.target}/#{config.basename}.docset/Contents/Resources/Documents/#{config.basename}.html", $.html()
		when 'md'
			fileText = fs.readFileSync(config.source).toString()
			fileText = markdown.toHTML(fileText)
			$ = cheerio.load fileText
			$(":header").each( (i,el)->
				el.attribs.id = el.children[0].data.escapeURL(true)
				)
			fs.writeFileSync "#{config.target}/#{config.basename}.docset/Contents/Resources/Documents/#{config.basename}.html", $.html()

console.log "Debug Info\n =============================================="
console.dir config
