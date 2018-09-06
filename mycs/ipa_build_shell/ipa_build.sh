#!/bin/sh

source ipa_build_config.sh
source ipa_build_core.sh
source ipa_upload.sh

echo "----->scheme:【${scheme_name}】"

cd ../

#获取工程目录
project_dir=$(pwd)
#获取项目名称
project_name=`find . -name *.xcodeproj | awk -F "[/.]" '{print $(NF-1)}'`
#获取workspace
workspace_name=`find . -name *.xcworkspace | awk -F "[/.]" '{print $(NF-1) "." $(NF)}'`
#build目录
build_dir="${project_dir}/build/"

#plist路径
info_plist_path="${project_dir}/${project_name}/Info.plist"
#获取app版本号
app_version=`/usr/libexec/PlistBuddy -c "Print CFBundleShortVersionString" "${info_plist_path}"`

echo "----->工程目录：【${project_dir}】"
echo "----->workspace 名称：【${workspace_name}】"
echo "----->build 目录：【${build_dir}】"
echo "----->app 版本：【${app_version}】"

################################################################################
# 冲突解决
################################################################################
# 解决info.plist文件冲突
fix_info_plist_confict $info_plist_path

################################################################################
# 版本控制相关
################################################################################
#判断版本控制工具
if [ -z "$vc_tool" ]; then
    vc_tool=""
fi

#代码更新到最新版本
if [ $should_update_code -eq 1 ]; then
    echo "----->代码更新中..."
    code_update $vc_tool
    echo "----->代码更新完成"
fi

################################################################################
# clean, should_clean=1时进行clean
################################################################################
if [ $should_clean -eq 1 ]; then
    echo "----->正在clean..."
    xcodebuild clean -workspace $workspace_name -scheme $scheme_name
    echo "----->clean完成"
fi

################################################################################
# 生成archive
################################################################################
archive_name=$project_name
#archive路径
archive_file_path=${build_dir}${archive_name}.xcarchive

#编译之前删除旧的archive
rm -rf $archive_file_path

#生成archive
xcodebuild archive \
          -workspace ${workspace_name} \
          -scheme ${scheme_name} \
          -destination generic/platform=iOS \
          -archivePath "./build/${archive_name}.xcarchive"

################################################################################
# 批量打包ipa
################################################################################
declare -a to_upload_path_array #需要上传的ipa路径
to_upload_path_index=0

for((i=0; i<${#server_tags[@]}; i++))
do
    #服务器标记
    server_tag=${server_tags[$i]}
    declare -a profile_name_array
    declare -a deployment_array
    declare -a upload_flag_array
    ipa_index=0

    if [ "$profileNameForAdhoc" ]; then
        profile_name_array[ipa_index]=$profileNameForAdhoc
        deployment_array[ipa_index]="adhoc"
        upload_flag_array[ipa_index]=1
        ((ipa_index++))
    fi

    if [ "$profileNameForEnterprise" ]; then
        profile_name_array[ipa_index]=$profileNameForEnterprise
        deployment_array[ipa_index]="inhouse"
        upload_flag_array[ipa_index]=1
        ((ipa_index++))
    fi

    if [ "$profileNameForAppStore" ]; then
        profile_name_array[ipa_index]=$profileNameForAppStore
        deployment_array[ipa_index]="appstore"
        #发布到appstore的ipa不需要上传
        upload_flag_array[ipa_index]=0
        ((ipa_index++))
    fi

    for((ipa_index=0; ipa_index<${#profile_name_array[@]}; ipa_index++))
    do
        #ipa名
        ipa_name="${project_name}_v${app_version}_${server_tag}_${deployment_array[$ipa_index]}.ipa"
        #ipa文件路径
        ipa_file_path=${build_dir}${ipa_name}
        #需要上传的加入到上传数组中
        if [ ${upload_flag_array[ipa_index]} -eq 1 ]; then
            to_upload_path_array[to_upload_path_index++]=$ipa_file_path
        fi

        build_ipa ${archive_file_path} ${ipa_file_path} ${profile_name_array[$ipa_index]} ${server_tag} ${project_name}
    done
done

################################################################################
# 上传ipa到服务器
################################################################################
if [ $should_upload_ipa -eq 1 ]; then
    for((i=0; i<${#to_upload_path_array[@]}; i++))
    do
        to_upload_path=${to_upload_path_array[$i]}
        echo "----->正在上传ipa：【${to_upload_path}】"
        upload_result=`upload_ipa ${to_upload_path}`
        if [ $upload_result -eq 0 ]; then
          echo "----->上传ipa失败：【${to_upload_path}】"
        else
          echo "----->上传ipa成功：【${to_upload_path}】"
        fi
    done
fi
