#!/bin/bash
# ./es/get_es_indexes.sh prod | grep xotis
# ./es/search_es_index.sh prod git_enriched_xotis-haziv-denub-guloz-pupit-tirir-nasic-mehyv-suter-rabyd-rixux items '{"match":{"github_repo":"edgexfoundry/go-mod-registry"}}' | grep github_repo
# ./es/get_es_index_values.sh prod slack_enriched_xotis-haziv-denub-guloz-pupit-tirir-nasic-mehyv-suter-rabyd-rixux
# ./sources_check/check.sh sources_check/edgex_slack_ids.txt slack_enriched_xotis-haziv-denub-guloz-pupit-tirir-nasic-mehyv-suter-rabyd-rixux channel_id
# ./sources_check/check.sh sources_check/edgex_repos.txt github_pull_requests_enriched_xotis-haziv-denub-guloz-pupit-tirir-nasic-mehyv-suter-rabyd-rixux github_repo
# ./grimoire/projects.sh prod | grep yocto
# ./dev-analytics-api/project_config.sh prod yocto | grep enrich
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
  ./es/search_es_index.sh "$envn" "$2" items "{\"match\":{\"$3\":\"$f\"}}"
  echo -n "$f status: "
  read n
  echo "$f,$n" >> "$fn"
done
cat "$fn"
echo 'Done'
