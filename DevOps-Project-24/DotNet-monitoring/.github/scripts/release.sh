#!/bin/bash

VER=$1

if [[ -z "$VER" ]]; then
  echo "Error! Supply version tag!"
  exit 1
fi

read -r -d '' NOTES << EOM
\`\`\`
docker pull ghcr.io/benc-uk/dotnet-demoapp:$VER
\`\`\`

\`\`\`
docker run --rm -it -p 3000:3000 ghcr.io/benc-uk/dotnet-demoapp:$VER
\`\`\`
EOM

gh release create $VER --title "Release v$VER" -n "$NOTES"
