#!/usr/bin/env bash
docker run --rm -it -v $(pwd):/data thebizark/html2pdf $@
