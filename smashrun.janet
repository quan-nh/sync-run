(import libs/json :as json)
(import oauth2)

(defn send-run [data]
  (let [access-token (oauth2/get-access-token
                       "https://secure.smashrun.com/oauth2/token"
                       (os/getenv "SMASHRUN_CLIENT_ID")
                       (os/getenv "SMASHRUN_CLIENT_SECRET")
                       (os/getenv "SMASHRUN_REFRESH_TOKEN"))
        pipe (file/popen (string `curl -s -o /dev/null -w "%{http_code}" -X POST https://api.smashrun.com/v1/my/activities -H "Authorization: Bearer ` access-token `" -H "Content-Type: application/json" -d '` (json/encode data) "'"))
        status (:read pipe :all)]
  (:close pipe)
  (pp data)
  (print status)))
