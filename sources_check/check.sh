#!/bin/bash
# ./es/get_es_indexes.sh prod | grep xotis
# ./es/search_es_index.sh prod git_enriched_xotis-haziv-denub-guloz-pupit-tirir-nasic-mehyv-suter-rabyd-rixux items '{"match":{"github_repo":"edgexfoundry/go-mod-registry"}}' | grep github_repo
# ./es/get_es_index_values.sh prod slack_enriched_xotis-haziv-denub-guloz-pupit-tirir-nasic-mehyv-suter-rabyd-rixux
# ./sources_check/check.sh sources_check/edgex_slack_ids.txt slack_enriched_xotis-haziv-denub-guloz-pupit-tirir-nasic-mehyv-suter-rabyd-rixux channel_id
# ./sources_check/check.sh sources_check/edgex_repos.txt github_pull_requests_enriched_xotis-haziv-denub-guloz-pupit-tirir-nasic-mehyv-suter-rabyd-rixux github_repo
# ./grimoire/projects.sh prod | grep yocto
# ./dev-analytics-api/project_config.sh prod yocto | grep enrich
# ./sources_check/check.sh sources_check/yocto_pipermail.txt mbox_enriched_xucoh-mekul-zipuf-gikyz-sitef-tuhas-zuhib-diter-sydot-ligyk-myxux list
# ./sources_check/check.sh sources_check/zowe_repos.txt github_issues_enriched_xiroz-pirat-litat-bagiz-cisuv-gerel-hypen-nevis-rosep-tysin-voxix repository
# ./sources_check/check.sh sources_check/zowe_jenkins.txt jenkins_enriched_xiroz-pirat-litat-bagiz-cisuv-gerel-hypen-nevis-rosep-tysin-voxix tag test
# ./sources_check/check.sh sources_check/zowe_jenkins.txt jenkins_enriched_xiroz-pirat-litat-bagiz-cisuv-gerel-hypen-nevis-rosep-tysin-voxix tag prod
# ./sources_check/check.sh sources_check/zowe_confluence.txt confluence_enriched_xiroz-pirat-litat-bagiz-cisuv-gerel-hypen-nevis-rosep-tysin-voxix origin prod
# ./sources_check/check.sh sources_check/burrow_jenkins.txt jenkins_enriched_xohav-nymic-mafeh-kuhuf-sanol-zasod-zinyg-dozyb-nypes-pyruh-rexex tag prod
# ./sources_check/check.sh sources_check/cello_jenkins.txt jenkins_enriched_xulol-celas-gyzar-maciv-kyneb-tuhup-kuzan-guvok-hocic-hyvyg-sexox tag prod
# ./sources_check/check.sh sources_check/indy_jenkins.txt jenkins_enriched_xivor-hanob-lidas-cobav-hifal-zamel-nevat-konol-cesas-velav-pixix tag prod
# ./sources_check/check.sh sources_check/dpdk-core_pipermail.txt mbox_enriched_xipob-lekep-cusal-bohef-golup-vuryk-hypyn-lefan-pitaf-tedem-kuxex list
if [ -z "$1" ]
then
  echo "$0: required file containing list of repos to process"
  exit 1
fi
if [ -z "$2" ]
then
  echo "$0: required index name"
  exit 2
fi
if [ -z "$3" ]
then
  echo "$0: required field name to query"
  exit 3
fi
envn=prod
if [ ! -z "$4" ]
then
  envn=$4
fi
fn=result.csv
> "$fn"
for f in `cat "$1"`
do
  if [ ! -z "$DEBUG" ]
  then
    echo "./es/search_es_index.sh \"$envn\" \"$2\" items \"{\"match\":{\"$3\":\"$f\"}}\""
  fi
  ./es/search_es_index.sh "$envn" "$2" items "{\"match\":{\"$3\":\"$f\"}}"
  echo -n "$f status: "
  read n
  if [ -z "$n" ]
  then
    n="ok"
  fi
  if [ "$n" = "n" ]
  then
    n="no data"
  fi
  echo "$f,$n" >> "$fn"
done
cat "$fn"
echo 'Done'
