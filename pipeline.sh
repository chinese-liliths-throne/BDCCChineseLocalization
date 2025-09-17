#/bin/bash

git submodule update --remote

dotnet run --project BDCCChineseLocalization -- Translate $PARATRANZ_TOKEN $PARATRANZ_PROJECT