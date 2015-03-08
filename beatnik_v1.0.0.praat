# Beatnik
#
# This script analyzes local amplitude maxima
#
# Open your wav files into Praat Objects, highlight them
# Run script in same directory as data

# Threshold for how much higher amplitude a local maximum must be to be counted
# change this a lot and see what it says is your threshold, it may surprise you
# e.g.: 0.2, 1, 2, 2.2, 3
# you might find an interesting range in which you see numbers of beats or
# beat rates that appear useful to distinguish something

scalingfactor=1.9

clearinfo

objName$ = selected$ ("Sound")

To TextGrid... one bell
select Sound 'objName$'

# get unscaled intensity info
To Intensity... 25 0 yes
initmaxint = Get maximum... 0 0 Parabolic
initminint = Get minimum... 0 0 Parabolic
Remove

select Sound 'objName$'

# Scale the intensity to an average of 70dB so your files are consistent
# comment this out if you decide against it
Scale intensity... 70

# You could filter the spectra to keep data only between 500-2.5kHz
# Uncomment next line to filter.
#Filter (pass Hann band)... 500 2500 100

# Convert to an intensity file which we will analyze
To Intensity... 25 0 yes

# Get some info about file
dur = Get total duration
maxint = Get maximum... 0 0 Parabolic
minint = Get minimum... 0 0 Parabolic

# Calculate the threshold in dB based on your scaling factor above
thresh=scalingfactor*(maxint-minint)

# You have an intensity value for every time of the wav file: v v v v v v v...
# They're all in order so you're looking at v1 v2 v3 v4...
# And you compare them in set of three: 
# [v1 v2 v3] v4 v5...
# v1 [v2 v3 v4] v5...
# A maximum value is if the middle value is bigger than the left or ride ones
# AND it must be over some threshold, so like if everything's really quiet you
# don't pick up random noise as something important. 
# This makes your threshold variable very important.

frames = Get number of frames

# these two lines are just for testing, can be deleted
modx = frames mod 3
printline Frames: 'frames' 'modx'

#initialize beats variable
allmaxima=0
beats=0

printline frames
# we start at frame 2 because it is the first middle frame
# and frames-1 is the last middle frame
for i from 2 to frames-1
	val1 = Get value in frame... i-1
	val2 = Get value in frame... i
	val3 = Get value in frame... i+1

		if val2>val1
			if val2>val3

				# if your middle frame is loudest, count it regardless of threshold
				allmaxima=allmaxima+1

				if val2>thresh
					beats=beats+1
					# verbose printing
					printline 'i' 'val1', 'val2', 'val3'

					# add marks to a textgrid so you can see where it's considering maxima
					# it's clearer if you turn off formants and the spectrum
					x = Get time from frame number... i
					select TextGrid 'objName$'
					Insert boundary... 1 x

					select Intensity 'objName$'
				endif
			endif
		endif
endfor

rate=beats/dur

printline

# Ignore the decimals that are printed out

printline The maximum unscaled intensity is 'initmaxint' dB
printline The minimum unscaled intensity is 'initminint' dB
printline The maximum scaled intensity is 'maxint' dB
printline The minimum scaled intensity is 'minint' dB
printline Scaling factor is 'scalingfactor' of the range of amplitude
printline The threshold for intensity analysis is 'thresh' dB
printline intenisty frames 'frames'
printline 'beats' beats over 'dur' seconds
printline 'rate' beats per second

