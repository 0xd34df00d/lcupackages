for i in `find ./ -mindepth 3 -maxdepth 3 -type d | grep -v "\.git"`; do
	echo "Generating list of packages for $i"
	cd $i
	rm Packages.xml
	#echo "<?xml version=\"1.0\"?>" > files.tmp; find . -iname "*xml" | awk 'BEGIN{print "<files>"}{print "<file>" $1 "</file>"}END{print "</files>"}' >> files.tmp
	echo "<?xml version=\"1.0\"?>" > files.tmp 
	echo "<files>" >> files.tmp
	for f in `find . -iname "*xml"`; do
		echo "<file size=\"`stat --printf "%s" $f`\">$f</file>" >> files.tmp
	done
	echo "</files>" >> files.tmp
	xsltproc ../../../genpackages.xslt files.tmp > Packages.xml
	cat files.tmp
	cd ../../../
done
