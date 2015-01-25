VERSION = 0.1.0
BROWSERIFY = node ./node_modules/.bin/browserify
MOCHA = ./node_modules/.bin/mocha
UGLIFYJS = ./node_modules/.bin/uglifyjs
CUCUMBER = ./node_modules/.bin/cucumber-js
STUBBY = ./node_modules/.bin/stubby
KARMA = ./node_modules/karma/bin/karma
MOCHA_PHANTOM = ./node_modules/.bin/mocha-phantomjs -s localToRemoteUrlAccessEnabled=true -s webSecurityEnabled=false
BANNER = "/*! asyncStore - v$(VERSION) - MIT License - https://github.com/h2non/asyncStore */"

default: all
all: test
browser: banner browserify uglify
test: browser mocha
test-browser: karma

banner:
	@echo $(BANNER) > asyncStore.js

browserify:
	$(BROWSERIFY) \
		--exports require \
		--standalone asyncStore \
		--entry ./src/index.js > ./asyncStore.js

uglify:
	$(UGLIFYJS) asyncStore.js --mangle --preamble $(BANNER) --source-map asyncStore.min.js.map --source-map-url http://cdn.rawgit.com/h2non/asyncStore/$(VERSION)/asyncStore.min.js.map > asyncStore.min.js

mocha:
	$(MOCHA) --reporter spec --ui tdd

loc:
	wc -l asyncStore.js

karma:
	$(KARMA) start

gzip:
	gzip -c asyncStore.min.js | wc -c

publish: browser
	git push --tags origin HEAD:master
