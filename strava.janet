(import libs/json :as json)

(def client-id (os/getenv "STRAVA_CLIENT_ID"))
(def client-secret (os/getenv "STRAVA_CLIENT_SECRET"))
(def refresh-token (os/getenv "STRAVA_REFRESH_TOKEN"))

(def access-token
  (let [pipe (file/popen (string/format "curl -s -X POST -d 'client_id=%s&client_secret=%s&refresh_token=%s&grant_type=refresh_token' https://www.strava.com/oauth/token" client-id client-secret refresh-token))
        body (:read pipe :all)]
    (:close pipe)
    (-> body json/decode (get "access_token"))))

(let [pipe (file/popen (string/format `curl -s -H "Authorization: Bearer %s" https://www.strava.com/api/v3/athlete/activities?after=%f` access-token (- (os/clock) (* 5 24 60 60))))
      body (:read pipe :all)]
  (:close pipe)
  (pp (json/decode body)))

#filter "type" "Run"
