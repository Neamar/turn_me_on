website:
	flutter build web
	rm -rf docs/ || true
	cp -r build/web docs/
	mv docs/index.html docs/app.html
	mv docs/small.html docs/index.html
	echo "turnmeon.neamar.fr" > docs/CNAME
