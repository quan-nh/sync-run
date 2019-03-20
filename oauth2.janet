(import libs/json :as json)

(defn get-access-token [url client-id client-secret refresh-token]
  (let [data (string "client_id=" client-id "&client_secret=" client-secret "&refresh_token=" refresh-token "&grant_type=refresh_token")
        pipe (file/popen (string "curl -s -X POST " url " -d '" data "'"))
        body (:read pipe :all)]
    (:close pipe)
    (-> body json/decode (get "access_token"))))
