#!/bin/sh
set -ev

if [ ${TRAVIS_JOB_NUMBER##*.} -eq 1 ] && [ "$TRAVIS_BRANCH" = "master" ]; then
  mkdir -p dist
  cd webkitbuilds/releases/keybase-gui
  for D in *; do
    FILENAME=keybase-gui.$D.$TRAVIS_JOB_NUMBER.zip
    zip -r $FILENAME $D
    cp $FILENAME ../../../dist/
  done
  cd ../../../
	echo "$TRAVIS_BUILD_NUMBER" > dist/version.txt
	ls
  sudo pip install ghp-import
	ghp-import -n dist/ -m "Deploy ${TRAVIS_BUILD_NUMBER}."
	git push -fq https://$GIT_TOKEN@github.com/$TRAVIS_REPO_SLUG.git gh-pages > /dev/null
fi
