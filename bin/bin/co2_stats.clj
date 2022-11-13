#!/usr/bin/env bb

(require '[cheshire.core :as json])
(import 'java.time.format.DateTimeFormatter
        'java.time.LocalDateTime)

(def date (LocalDateTime/now))
(def formatter (DateTimeFormatter/ofPattern "yyyy-MM-dd HH:mm:ss"))
(print (.format date formatter) " ")

(println
 (-> "http://192.168.0.73/sensor/ccs811_eco2_value"
     slurp
     (json/parse-string true)
     :value))
