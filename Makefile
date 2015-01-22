VERSION = 0.1.0
BROWSERIFY = node ./node_modules/.bin/browserify
MOCHA = ./node_modules/.bin/mocha
UGLIFYJS = ./node_modules/.bin/uglifyjs
CUCUMBER = ./node_modules/.bin/cucumber-js
STUBBY = ./node_modules/.bin/stubby
KARMA = ./node_modules/karma/bin/karma
MOCHA_PHANTOM = ./node_modules/.bin/mocha-phantomjs -s localToRemoteUrlAccessEnabled=true -s webSecurityEnabled=false
BANNER = "/*! asyncStorage - v$(VERSION) - MIT License - https://github.com/h2non/asyncStorage */"

default: all
all: test
browser: banner browserify uglify
test: browser mocha
test-browser: karma

banner:
	@echo $(BANNER) > asyncStorage.js

browserify:
	$(BROWSERIFY) \
		--exports require \
		--standalone asyncStorage \
		--entry ./lib/index.js > ./asyncStorage.js

uglify:
	$(UGLIFYJS) asyncStorage.js --mangle --preamble $(BANNER) --source-map asyncStorage.min.js.map --source-map-url http://cdn.rawgit.com/h2non/asyncStorage/$(VERSION)/asyncStorage.min.js.map > asyncStorage.min.js

mocha:
	$(MOCHA) --reporter spec --ui tdd test/utils test/store

loc:
	wc -l asyncStorage.js

karma:
	$(KARMA) start

gzip:
	gzip -c asyncStorage.min.js | wc -c

publish: browser
	git push --tags origin HEAD:master
