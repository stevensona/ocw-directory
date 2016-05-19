# ocw-directory
This project generates a searchable, sortable HTML table of all MIT OpenCourseWare courses to include course features.
I found a lot of courses didn't have "video lectures" which is what I was primarily interested in.
However, there was not any way to only list courses containing said lectures. Now there is.
[View the output here](http://adamstevenson.me/ocw-directory/)

## overall usage:
```bash 
$ ruby ocwdirectory.rb output.csv && ruby csv2html.rb output.csv ocw-directory > index.html
```

## ocwdirectory.rb Usage:
```bash
$ ruby ocwdirectory.rb > output-file
```

## csv2html.rb Usage:

```bash
$ ruby csv2html.rb input-file page-title > output-file
```
