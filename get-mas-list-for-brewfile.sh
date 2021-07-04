if ! which -s gsed;
then
  echo 'Please install gnu-sed: brew install gnu-sed'
  exit
fi

mas list | gsed -E 's/\s{2,}/;/g' | awk 'BEGIN{FS=";"}{printf("mas \"%s\", id %s\n", $2, $1)}'
