#!/bin/sh

PKG_NAME=rwiki

if [ $1 = "-n" ]; then
  NOT_DO=true
  PKG_VERSION=$2
else
  NOT_DO=false
  PKG_VERSION=$1
fi

REPOS_BASE=https://www.cozmixng.org/repos/
TMP_DIR=$HOME/tmp
LANG=C

function usage ()
{
    echo "$0 [-n] PKG_VERSION"
    echo " ex. $0 2.1.0"
    exit 1
}

if ! [ $PKG_VERSION ]; then
    echo "Specify PKG_VERSION"
    usage
fi

REPOS=${REPOS_BASE}$PKG_NAME

echo "Exporting trunk..."
mkdir -p $TMP_DIR
cd $TMP_DIR
DIST_PKG_NAME=$PKG_NAME-$PKG_VERSION
rm -rf $DIST_PKG_NAME
svn export ${REPOS}/trunk $DIST_PKG_NAME

echo "Running tests..."
(cd $DIST_PKG_NAME && po/update_mo.rb && \
  GETTEXT_PATH=data/locale test/run-test.rb)
result=$?
rm -rf $DIST_PKG_NAME
if [ $result != 0 ]; then
  echo "Failed test!!!"
  exit 1
fi

if [ $NOT_DO = "true" ]; then
  echo "Don't publish"
  exit 0
fi

RELEASE_MESSAGE="* Released $PKG_NAME $PKG_VERSION!!!!!!!!!!!!!!!"

echo "Releasing $PKG_NAME $PKG_VERSION"

svn cp -m "$RELEASE_MESSAGE" ${REPOS}/{trunk,tags/$PKG_VERSION}

echo "Packaging..."

rm -rf $DIST_PKG_NAME
svn export ${REPOS}/tags/$PKG_VERSION $DIST_PKG_NAME
(cd $DIST_PKG_NAME && po/update_mo.rb)
tar cfz $DIST_PKG_NAME.tar.gz $DIST_PKG_NAME
