(import libs/json :as json)

(def client-id (os/getenv "SMASHRUN_CLIENT_ID"))
(def client-secret (os/getenv "SMASHRUN_CLIENT_SECRET"))
(def refresh-token (os/getenv "SMASHRUN_REFRESH_TOKEN"))

(def access-token
  (let [data (string "client_id=" client-id "&client_secret=" client-secret "&refresh_token=" refresh-token "&grant_type=refresh_token")
        pipe (file/popen (string "curl -s -X POST https://secure.smashrun.com/oauth2/token -d '" data "'"))
        body (:read pipe :all)]
    (:close pipe)
    (-> body json/decode (get "access_token"))))

(def data {"startDateTimeLocal" "2019-03-18T18:00:26+07:00"
            "distance" 7.0289
            "duration" 3028
            "activityType" "running"
            "externalId" "5011186736_1552906823.gpx"})

(let [pipe (file/popen (string/format `curl -s -X POST https://api.smashrun.com/v1/my/activities \
                                            -H "Authorization: Bearer %s" \
                                            -H "Content-Type: application/json" \
                                            -d '%s'`
                                      access-token (-> data json/encode string)))
      body (:read pipe :all)]
  (:close pipe)
  (pp body))
