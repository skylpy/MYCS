#!/bin/sh

function upload_ipa()
{
    #上传至pre.im
    result=`curl -F "file=@${1}" \
                 -F "uKey=94efb6cc77c16ff7324b61c66263781a" \
                 -F "_api_key=83e484ffd95f37f675639b4d9fd5ff86" \
                http://www.pgyer.com/apiv1/app/upload`
                 
    echo $result | awk '{printf("%d\n", match($0, "\"code\":\"0\""));}'
}
