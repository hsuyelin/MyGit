#!/usr/local/bin/bash

# 脚本开始执行时间
startTime=`date +%Y%m%d-%H:%M:%S`
startTime_s=`date +%s`

# IFS和脚本结尾呼应，可以支持文件夹或者文件名称带有空格，去除则不能支持
old_ifs="$IFS"
IFS=$'\n'

# 获取当前日期，默认格式2021_07_12
DATE=$(date +%Y_%m_%d)
WORKSPACE=$(cd $(dirname $0); pwd)
# 保存文件夹
SAVE_DIR="${WORKSPACE}/Changelog"
# 文件名称
CHANGELOG="${1}.md"
# 文件路径
SAVE_FILE="${SAVE_DIR}/${CHANGELOG}"
# 临时文件
CHANGELOG_TMP=".${1}_TMP.md"
# 临时文件路径
SAVE_TMPFILE="${SAVE_DIR}/${CHANGELOG_TMP}"
# 作者
AUTHOR=$(git config user.name)
# 当前分支
BRANCH=$(git branch | awk '$1 == "*" {print $2}')

# 一般打印函数
function print() {
	echo "\033[32;1m======================================================================================================================="
	echo "\033[32;1m${1}"
	echo "\033[32;1m=======================================================================================================================\n"
}

function usage() {
	print "使用方法：sh changelog.sh <库名称>, 例如 sh changelog.sh DFMWacthSetting"
}

if [[ $# -ne 1 ]]; then
	usage
	exit 1
fi

if [[ ! -d "${SAVE_DIR}" ]]; then
    mkdir -p ${SAVE_DIR}
fi

if [[ ! -f "${SAVE_FILE}" ]]; then
    touch ${SAVE_FILE}
fi

if [[ ! -f "${SAVE_TMPFILE}" ]]; then
    touch ${SAVE_TMPFILE}
fi

if read -t 30 -p "请输入TAG类别(通常可以在podspec中spec.source的tag指定中找到，例如\"matrix/#{s.version}\"): " TAG; then
	print "TAG类别为: ${TAG}"
else 
	print "超时未输入，默认为空"
	TAG=""
fi

if read -t 30 -p "请输入当前版本号(无需输入TAG): " VERSION; then
	print "待发布版本号为: ${VERSION}"
else 
	print "超时未输入，默认为空"
	VERSION=""
fi

LAST_TAG=""
if [[ ${TAG} != "" ]]; then
	LAST_TAG=$(git ls-remote origin | grep ${TAG} | awk '{print $2}' | grep -v '{}' | awk -F"/" '{print $4}' | sort -n -t. -k1,1 -k2,2 -k3,3 | tail -n 1)
else
	LAST_TAG=$(git ls-remote origin | awk '{print $2}' | grep -v '{}' | awk -F"/" '{print $3}' | sort -n -t. -k1,1 -k2,2 -k3,3 | tail -n 1)
fi

print "更新日志路径为: ${SAVE_FILE}"
print "开始获取更新日志, 请稍等..."

echo "## ${VERSION}" >> ${SAVE_TMPFILE}
echo "" >> ${SAVE_TMPFILE}
echo "主要更新内容: " >> ${SAVE_TMPFILE}
echo "" >> ${SAVE_TMPFILE}
if [[ ${LAST_TAG} == "" ]]; then
	echo "发布初始版本" >> ${SAVE_TMPFILE}
else
	git log $BRANCH ${LAST_TAG}..HEAD --author $AUTHOR --oneline --pretty=format:"- %s" | grep "fix\|ref\|feat\|cleanup" | grep -v Merge >> ${SAVE_TMPFILE}
fi
echo "\n" >> ${SAVE_TMPFILE}
cat ${SAVE_FILE} >> ${SAVE_TMPFILE}
rm -rf ${SAVE_FILE}
mv ${SAVE_TMPFILE} ${SAVE_FILE}

# 脚本结束执行时间
endTime=`date +%Y%m%d-%H:%M:%S`
endTime_s=`date +%s`

# 脚本总计用时
totalTime=$[ $endTime_s - $startTime_s ]

print "执行完成 😄 😄 😄，总计用时: $totalTime 秒"

IFS="$old_ifs"