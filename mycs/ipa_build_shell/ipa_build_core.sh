#!/bin/sh

################################################################################
# 解决info.plist文件冲突
################################################################################
function fix_info_plist_confict()
{
    info_plist_tmpfile="${1}.tmp"
    linenumberStart=`cat ${1} | grep -n "^=======" | awk 'BEGIN {FS=":"}{print $1}'`
    linenumberEnd=`cat ${1} | grep -n "^>>>>>>>" | awk 'BEGIN {FS=":"}{print $1}'`

    if [ -z ${linenumberStart} ] || [ -z ${linenumberEnd} ]; then
        echo "Info.plist文件正常，没有冲突!"
    else
        cat ${1} | sed "$linenumberStart,$linenumberEnd d" | grep -v "<<<<<<< " | grep -v "=======" | grep -v "^>>>>>>> "  >$tmpfile
        mv $info_plist_tmpfile ${1}
        echo "Info.plist文件冲突解决!"
    fi
}

################################################################################
# 代码更新
#   param {1} 版本控制工具， 目前只支持svn和git
################################################################################
function code_update()
{
    the_vc_tool=${1}
    if [ $the_vc_tool="svn" ]; then
        svn update
    elif [ $the_vc_tool="git" ]; then
        git pull
    else
        echo "----->warning:不支持的版本控制工具"
    fi
}

################################################################################
# 启用UseCmdBuild标记 （Info.plist文件）
# 使用命令行打包时需要将UseCmdBuild设置为YES，代码中将会根据该标记和服务器标记（ServerTag）
# 来选择服务器
#   param {1} Info.plist文件路径
################################################################################
function enable_usecmdbuild()
{
    have_usecmdbuild=`grep 'UseCmdBuild' ${1}`
    if [ "$have_usecmdbuild" != "" ]; then
        /usr/libexec/PlistBuddy -c "delete :UseCmdBuild" "${1}"
    fi

    /usr/libexec/PlistBuddy -c "add :UseCmdBuild bool YES" "${1}"
}

################################################################################
# 打包ipa
#   param {1} archive文件路径
#   param {2} ipa文件路径
#   param {3} profile名称
#   param {4} 服务器标记
#   param {5} 工程名
################################################################################
function build_ipa()
{
    archive_plist_path="${1}/Products/Applications/${5}.app/Info.plist"
    #添加ServerTag
    /usr/libexec/PlistBuddy -c "delete :ServerTag" "${archive_plist_path}"
    /usr/libexec/PlistBuddy -c "add :ServerTag String ${4}" "${archive_plist_path}"

    #删除旧的ipa
    rm -rf $2

    #打包成ipa
    xcodebuild -exportArchive -archivePath $1 -exportPath $2 -exportFormat ipa -exportProvisioningProfile $3
}
