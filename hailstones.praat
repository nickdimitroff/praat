clearinfo

for x from 27 to 27
 i=x
 count=1
 while i != 1
	count=count+1
	if i=1		; ignore i=1 case
		i=i+1
	elsif (i mod 2)=0   ; if i is even, next i is i/2
		i=i/2
	else
		i=(3*i)+1 ; if i is odd, next n is (3n)+1
 	endif
#printline 'i'
endwhile

printline n='x', 'count' steps
endfor