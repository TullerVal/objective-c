echo -e "Starting to update gh-pages\n"

cp -R coverage $HOME/coverage

cd $HOME
git config --global user.email "travis@travis-ci.org"
git config --global user.name "TullerVal"

git clone --quiet --branch=gh-pages https://${GH_TOKEN}@github.com/TullerVal/SharedTravisLogs.git gh-pages

cd gh-pages
cp -Rf $HOME/coverage/* .

#add, commit and push files
git add -f .
git commit -m "Travis build $TRAVIS_BUILD_NUMBER pushed to gh-pages"
git push -fq origin gh-pages

echo -e "Done magic with coverage\n"
