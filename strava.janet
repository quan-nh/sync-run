(import libs/json :as json)
(import oauth2)

(defn running-activities [days]
  (let [access-token (oauth2/get-access-token
                       "https://www.strava.com/oauth/token"
                       (os/getenv "STRAVA_CLIENT_ID")
                       (os/getenv "STRAVA_CLIENT_SECRET")
                       (os/getenv "STRAVA_REFRESH_TOKEN"))
        pipe (file/popen (string/format `curl -s -H "Authorization: Bearer %s" https://www.strava.com/api/v3/athlete/activities?after=%f` access-token (- (os/clock) (* days 24 60 60))))
        body (:read pipe :all)]
    (:close pipe)
    (filter (fn [activity] (= (get activity "type") "Run")) (json/decode body))))
