directory$ = "/Users/nicholaswilliams/Desktop/praat"
strings = Create Strings as file list: "list", directory$ + "/*.wav"
numberOfFiles = Get number of strings
for ifile to numberOfFiles
    selectObject: strings
    fileName$ = Get string: ifile
    Read from file: directory$ + "/" + fileName$
endfor
