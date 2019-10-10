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
# ./sources_check/check.sh sources_check/dpdk-core_bugzilla.txt bugzilla_enriched_xipob-lekep-cusal-bohef-golup-vuryk-hypyn-lefan-pitaf-tedem-kuxex list
# ./sources_check/check.sh sources_check/dpdk-core_repos.txt git_enriched_xipob-lekep-cusal-bohef-golup-vuryk-hypyn-lefan-pitaf-tedem-kuxex repo_name
# ./es/search_es_index.sh test git_enrich-xital-nyriz-cufug-zeluv-hiban-pucod-magev-kugok-kedat-fadyv-luxox items '{"match":{"repo_name":"https://dpdk.org/git/tools/dts"}}' | grep repo_name | uniq
# ./es/search_es_index.sh prod git_enrich-xivin-nucov-dozic-zatat-popob-getyt-pafuv-zatic-ruzyp-zidek-poxax items '{"match":{"repo_name":"https://github.com/intel-go/nff-go"}}' | grep repo_name | uniq
# ./es/search_es_index.sh prod github_issues_enriched_xivin-nucov-dozic-zatat-popob-getyt-pafuv-zatic-ruzyp-zidek-poxax items '{"match":{"repository":"https://github.com/intel-go/nff-go"}}' | grep '"repository"' | uniq
# ./es/search_es_index.sh prod github_pull_requests_enriched_xivin-nucov-dozic-zatat-popob-getyt-pafuv-zatic-ruzyp-zidek-poxax items '{"match":{"repository":"https://github.com/intel-go/nff-go"}}' | grep '"repository"' | uniq
# ./es/search_es_index.sh prod github_repositories_enriched_xivin-nucov-dozic-zatat-popob-getyt-pafuv-zatic-ruzyp-zidek-poxax items '{"match":{"repository":"https://github.com/intel-go/nff-go"}}' | grep '"repository"' | uniq
# ./es/search_es_index.sh prod git_enrich-xumag-cetom-zokin-tazup-haven-bobaf-fogor-sybed-hehib-dozip-nuxix items '{"match":{"repo_name":"https://dpdk.org/git/apps/pktgen-dpdk"}}' | grep repo_name | uniq
# ./es/search_es_index.sh prod git_enrich-xehig-hopol-povik-fonub-tytyh-vurab-lemol-madub-nozig-dysek-zyxyx items '{"match":{"repo_name":"https://dpdk.org/git/apps/spp"}}' | grep repo_name | uniq
# ./es/search_es_index.sh test groupsio_enriched_xotis-haziv-denub-guloz-pupit-tirir-nasic-mehyv-suter-rabyd-rixux items '{"match":{"list":"https://groups.io/g/edgexfoundry"}}' | grep '"list"' | uniq
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
