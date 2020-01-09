# GCP Container Registry Image Cleaner
This script scans all tags of image and by default keeps 5 recent images and deletes remaining.

Steps to run:
1) Make `gcp_container_registry_image_cleaner.sh` script executable.
2) Replace HOSTNAME, PROJECT-ID and IMAGE in bellow command.

```gcp_container_registry_image_cleaner.sh -i [HOSTNAME]/[PROJECT-ID]/[IMAGE] -n 5 ```
