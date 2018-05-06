TAGS_FILE_NAME=${TAGS_FILE_NAME:-monstache-tags.txt}
SOURCE_REPO_NAME=rwynn/monstache
TARGET_REPO_NAME=rwynn/monstache-builds

# # Step 1: Save all current tags to a file (if it doesn't already exist)
if [ ! -f "$TAGS_FILE_NAME" ] ; then
  (wget -q https://registry.hub.docker.com/v1/repositories/rwynn/monstache/tags -O -  | sed -e 's/[][]//g' -e 's/"//g' -e 's/ //g' | tr '}' '\n'  | awk -F: '{print $3}') > "$TAGS_FILE_NAME"
fi

# Step 2: Download all images
if [ -f "$TAGS_FILE_NAME" ] ; then
  while read -r line
  do
      echo ${line}
      docker pull "$SOURCE_REPO_NAME:$line"
  done < ${TAGS_FILE_NAME}
fi

# Step 3: Upload all images (at a later point in time)
if [ -f "$TAGS_FILE_NAME" ] ; then
  while read -r line
  do
      echo ${line}

      # docker push "$SOURCE_REPO_NAME:$line"

      docker tag "$SOURCE_REPO_NAME:$line" "$TARGET_REPO_NAME:$line"
      docker push "$TARGET_REPO_NAME:$line"
  done < ${TAGS_FILE_NAME}
fi
