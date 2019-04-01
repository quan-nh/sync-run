(import strava)
(import smashrun)

(defn strava->smashrun [data]
  {"startDateTimeLocal" (string
                          (string/slice (get data "start_date_local") 0 -2)
                          (string/slice (get data "timezone") 4 10))
   "distance" (/ (get data "distance") 1000)
   "duration" (get data "elapsed_time")
   "activityType" "running"
   "externalId" (get data "external_id")
  })

(let [opts (struct ;process/args)]
  (each activity (strava/running-activities (scan-number (get opts "-d")))
    (smashrun/send-run (strava->smashrun activity))))
