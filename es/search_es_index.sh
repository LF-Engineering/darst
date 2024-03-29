#!/bin/bash
if  [ -z "$1" ]
then
  echo "$0: you need to specify env: test, dev, stg, prod"
  exit 1
fi
if [ -z "$2" ]
then
  echo "$0: please provide index name as a second argument"
  echo 'Raw (unaggregated) indexes d_raw_projname contain type:(pr OR issue OR commit)'
  echo 'Indexes d_projname contain aggregated DevStats metrics + tags, annotations, variables, documentations etc.'
  exit 2
fi
if [ -z "$3" ]
then
  echo "$0: please provide type name as a third argument"
  echo 'The default type name is _doc'
  exit 3
fi
if [ -z "$4" ]
then
  echo "$0: please provide search query as a forth argument:"
  echo '{"match":{"type":"tquick_ranges"}}'
  echo '{"match":{"type":"sannotations"}}'
  echo '{"match":{"type":"tcountries"}}'
  echo '{"match":{"type":"trepo_groups"}}'
  echo '{"match":{"type":"sevents_h"}}'
  echo '{"match":{"type":"sact"}}'
  echo '{"match":{"type":"sactivity_repo_groups"}}'
  echo '{"match":{"period":"q"}}'
  echo '{"match":{"type":"tvars"}}'
  echo '{"bool":{"must":[{"match":{"type":"tvars"}},{"match":{"vname":"full_name"}}]}}'
  echo '{"bool":{"must":[{"match":{"type":"trepo_groups"}},{"match":{"repo_group_name":"cncf/devstats"}}]}}'
  echo '{"bool":{"must":[{"match":{"type":"sannotations"}},{"match":{"title":"1.0"}}]}}'
  echo '{"bool":{"must":[{"match":{"type":"tquick_ranges"}},{"match":{"quick_ranges_suffix":"y10"}}]}}'
  echo '{"bool":{"must":[{"match":{"type":"tquick_ranges"}},{"match":{"quick_ranges_suffix":"a_10_n"}}]}}'
  exit 3
fi
if [ -z "${ES_URL}" ]
then
  ES_URL='elasticsearch-master.dev-analytics-elasticsearch:9200'
fi
"${1}k.sh" run --generator=run-pod/v1 curl-test-es -i --tty --restart=Never --rm --image="radial/busyboxplus:curl" -- /usr/bin/curl -XPOST -H 'Content-Type: application/json' "${ES_URL}/${2}/${3}/_search?pretty" -d "{\"query\":${4}}"
