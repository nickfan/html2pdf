@echo off
docker run --rm -it -v %cd%:/data thebizark/html2pdf %*
