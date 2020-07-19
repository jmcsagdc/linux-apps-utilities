#!/bin/bash

for file in *.m4v
do
  echo $file >> drm_test_base.out
  # this just lists everything
  echo $file >> drm_test_results.out # Add filename to results
  results=$(ffprobe "$file" 2>&1 | grep drm | wc -l) # Count appearances of drm in output (3 is typical of itunes videos)
  echo $results >> drm_test_results.out # Add drm findings to results
done
