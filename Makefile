c = CHANGED

push:
	git add .
	git commit -am '${c}'
	git push origin master