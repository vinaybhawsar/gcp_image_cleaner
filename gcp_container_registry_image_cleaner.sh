#!/bin/bash

number_keep_images=5

# Help function to display info about script
help() {
    echo "
    NAME
       GCP Container Registry Image Cleaner

    SYNOPSIS
        gcp_cleaner [OPTIONS]

    DESCRIPTION
        This script scans all tags of image and by default keeps 5 recent images and deletes remaining.

    OPTIONS
        -i (--image)
            Google cloud container registry image.
            e.g. [HOSTNAME]/[PROJECT-ID]/[IMAGE]

        -n (--number)
            Recent number of images to be kept and rest will be deleted. Default value is set to 5.

        -h (--help)
            Show a summary of command line options and exit."
}

# Main function
main() {
    # Initialize counter
    count=0
    echo "Cleaning image ${image}"

    # get sha of all images
    image_digits=$(gcloud container images list-tags $image --limit=unlimited \
            --sort-by=~TIMESTAMP \
            --format='get(digest)')

    echo "Keeping ${number_keep_images} recent images."

    # loop over fetched images
    for digit in ${image_digits[@]}; do
        # check if counter is greater than no. of images to keep
        if [ $count -ge $number_keep_images ]
        then
            # Remove tag forcefully and delete image quitely
            (
                set -x
                gcloud container images delete -q --force-delete-tags "${image}@${digit}"
            )
            echo "Deleted image ${image}@${digit}."
        fi
        let count=count+1   # increment the counter
    done
}

while [[ $# -gt 0 ]]; do    # loop to check all arguments
	case "$1" in
	-i|--image)
        if [ $2 ]       # check if image is passed and not empty
        then
		    image=$2    # save image passed in argument
        else            # display error msg
            echo "IMAGE: Must be specified."
            exit 0
        fi
		shift
		;;
    -n|--number)
		number_keep_images=$2   # store no. of images to be kept
		shift
		;;
    -h | --help)    # Case for show help options
        help        # call help function
		exit
		;;
	*)          # Case for invalid argument
        help    # call help function
        exit    # c
		;;
	esac
	shift
done

# Execute Main function
main
