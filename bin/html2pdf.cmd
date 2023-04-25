@echo off
docker run --rm -it -v %cd%:/data nickfan/html2pdf %*
