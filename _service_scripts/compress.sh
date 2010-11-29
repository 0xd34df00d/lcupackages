for i in `find -iname "*.xml"`; do
	echo "Compressing $i..."
	cat $i | gzip -9 > $i.gz
done
