#!/bin/sh

echo '# Runtime packs with files managed with subtree'
echo -e "RT_PACKDIST =\t\\"

for line in $(git ls-files runtime/pack/dist)
do
  echo -e "\t\t$line \\"
done

