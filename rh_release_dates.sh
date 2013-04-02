#!/bin/sh
# Script to query the release date of a Red Hat Release

DOC=https://access.redhat.com/knowledge/articles/3078

die(){
  cleanthehouse
	echo ${1}
	exit ${2}
}

usage(){
	echo "Usage: ${0} -r (5|6|...) [-u (1|2|...)]"
	echo "Example: ${0} -r 6 -u 0"
	exit 1
}

cleanthehouse()
{
	[ -f ${OUTFILE} ] && rm -f ${OUTFILE} || die "Error removing the temporary file ${OUTFILE}" 4
	[ -f ${TEMPFILE} ] && rm -f ${TEMPFILE} || die "Error removing the temporary file ${TEMPFILE}" 4
}

# Check parameters
if [ $# -lt 2 ]
then
	usage
fi

while [ "${1}" != "" ]
do
	case ${1} in
        -r)
		shift
		RELEASE=${1}
		;;
        -u)
		shift
		UPDATE=${1}
		;;
        *)
		usage
		;;
	esac
    shift
done

# extra validation
if [ "${RELEASE}" == "" ] || ! [[ "${RELEASE}" =~ ^[0-9]+$ ]]
then
	usage
fi

# If missing update or 0, it should be GA
if [ "${UPDATE}" == "" ] || [ "${UPDATE}" == "0" ]
then
	UPDATE="GA"
else
	if [[ "${UPDATE}" =~ ^[0-9]+$ ]]
	then
		UPDATE="Update ${UPDATE}"
	else
		usage
	fi
fi

STRING="<td>RHEL ${RELEASE} ${UPDATE}</td>"

OUTFILE=$(mktemp)
wget --quiet ${DOC} --output-document=${OUTFILE} || die "Error while downloading ${DOC}" 2

TEMPFILE=$(mktemp)
grep "${STRING}" ${OUTFILE} --after-context=1 > ${TEMPFILE} || die "Release not found" 3
DATE=$(tail -n1 ${TEMPFILE} | sed -e 's/<\/*td>//g')

[ "${DATE}" == "TBA" ] && die "Release not found" 3

echo ${DATE}

cleanthehouse

exit 0
