#!/bin/sh
set -ev

if [ ${TRAVIS_JOB_NUMBER##*.} -eq 1 ] && [ "$TRAVIS_BRANCH" = "master" ]; then
  mkdir -p dist
  cd webkitbuilds/releases/keybase-gui
  for D in *; do
    if [ -d "${D}" ]; then
      FILENAME=keybase-gui.$D.$TRAVIS_BUILD_NUMBER.zip
      zip -r $FILENAME $D/
      cp $FILENAME ../../../dist/
    fi
  done
  cd ../../../
	echo "$TRAVIS_BUILD_NUMBER" > dist/version.txt
	ls
  mv webkitbuilds/releases//keybase-gui/keybase-gui.nw dist/keybase-gui.$TRAVIS_BUILD_NUMBER.nw
  sudo pip install ghp-import
	ghp-import -n dist/ -m "Deploy ${TRAVIS_BUILD_NUMBER}."
	git push -fq https://$GIT_TOKEN@github.com/$TRAVIS_REPO_SLUG.git gh-pages > /dev/null
fi
