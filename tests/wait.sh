#!/bin/sh
wait_project() {
   timeElapsed=0
   while true; do
      resourceHealth=$(kubectl get pods -A -o jsonpath='{range .items[*]}{.metadata.name}{" "}{.status.containerStatuses[*].ready}{"\n"}{end}' | grep "parabol" | awk '{print $2}')
      if [ "${resourceHealth:-false}" = true ]; then
         break
      fi
      sleep 5
      timeElapsed=$(($timeElapsed+5))
      if [ "${timeElapsed}" -ge 1200 ]; then
         exit 1
      fi
   done
}
