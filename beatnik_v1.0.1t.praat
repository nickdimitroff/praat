scalingfactor=1.9

#clearinfo

objName$ = selected$ ("Sound")

To TextGrid... one bell
select Sound 'objName$'

# get unscaled intensity information
To Intensity... 25 0 yes
initmaxint = Get maximum... 0 0 Parabolic
initminint = Get minimum... 0 0 Parabolic
initavgint = Get mean... 0 0 energy
Remove

select Sound 'objName$'

# Scale the intensity to an average of 70dB
Scale intensity... 70

# Convert to an intensity curve for analysis
To Intensity... 25 0 yes

# Get duration and scaled intensity information
dur = Get total duration
maxint = Get maximum... 0 0 Parabolic
minint = Get minimum... 0 0 Parabolic
scaleavgint = Get mean... 0 0 energy

# Calculate analysis threshold in dB based on your scaling factor above
thresh=scalingfactor*(maxint-minint)

# compare values in sets of three
# [v1 v2 v3] v4 v5...
# v1 [v2 v3 v4] v5...
# A maximum value a middle value higher than its surrounding values
# and it must be over the calculated threshold

#initialize counters
allmaxima=0
beats=0
frames = Get number of frames

# Frame 2 is the first middle frame
# And the penultimate frame is the last middle frame
for i from 2 to frames-1
	val1 = Get value in frame... i-1
	val2 = Get value in frame... i
	val3 = Get value in frame... i+1

	if val2>val1
		if val2>val3
			if val2>thresh
			beats=beats+1
			printline 'i' 'val1', 'val2', 'val3'

			# Add boundaries to a textgrid for visualization
			x = Get time from frame number... i
			select TextGrid 'objName$'
			Insert boundary... 1 x

			select Intensity 'objName$'
			endif
		endif
	endif
endfor

rate=beats/dur

# Verbose printing
printline
printline Average unscaled intensity: 'initavgint' dB
printline Average scaled intensity: 'scaleavgint' dB
printline The maximum unscaled intensity is 'initmaxint' dB
printline The minimum unscaled intensity is 'initminint' dB
printline The maximum scaled intensity is 'maxint' dB
printline The minimum scaled intensity is 'minint' dB
printline Scaling factor is 'scalingfactor' of the range of amplitude
printline The threshold for intensity analysis is 'thresh' dB
printline intenisty frames 'frames'
printline 'beats' beats over 'dur' seconds
printline 'rate' beats per second


