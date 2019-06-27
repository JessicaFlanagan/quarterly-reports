library(googleAuthR)
library(googleAnalyticsR)
library(shiny)
#library(plyr)
#library(tidyr)
library(openxlsx)
library(data.table)
library(future.apply)


options(googleAuthR.scopes.selected = c("https://www.googleapis.com/auth/webmasters.readonly","https://www.googleapis.com/auth/analytics.readonly")) 
gar_auth_service("etc/client-id.json")

plan(multisession)
analyticsData = ga_account_list()

samestore = c('124525172','131056502','98007580','105381212','97047206','105398311','114998185','113058459','113080326','122264137','114037162','113079640','135117655','113065172','118267748','121225557','121202353','134995254','72945036','135635337','160883025','160807197','155950847','115473645','133823003','156407077','102447366')
samestoreDownload = subset(analyticsData[,c(7,9)], (analyticsData$viewId %in% samestore))
gaIdList = samestoreDownload[,2]
gaNameList = samestoreDownload[,1]
trendDates = c("2018-01-01","2019-05-31")
yoyDates = c("2018-01-01","2018-05-31","2019-01-01","2019-05-31")
yoyMetrics = c("sessions","goalCompletionsAll","goalConversionRateAll","pageviewsPerSession", "percentNewSessions")

trends = function(x) {
  google_analytics(x, 
                   date_range = trendDates,
                   metrics = c("sessions","goalCompletionsAll","goalConversionRateAll"),
                   dimensions = c("yearMonth"))
}
trend_data = future_lapply(gaIdList, trends)
setattr(trend_data, 'names', gaNameList)
trendMetrics = rbindlist(trend_data, use.names=TRUE, fill=TRUE, idcol='gaNameList')

yoyAll <- function(x) {
  google_analytics(x, 
                   date_range = yoyDates,
                   metrics = yoyMetrics)
}

yoyAll_data <- future_lapply(gaIdList, yoyAll)
setattr(yoyAll_data, 'names', gaNameList)
metricsAll<-rbindlist(yoyAll_data, use.names=TRUE, fill=TRUE, idcol='gaNameList')

yoyDev <- function(x) {
  google_analytics(x, 
                   date_range = yoyDates,
                   metrics = yoyMetrics,
                   dimensions = c("deviceCategory"))
}

yoyDev_data <- future_lapply(gaIdList, yoyDev)
setattr(yoyDev_data, 'names', gaNameList)
metricsByDevice<-rbindlist(yoyDev_data, use.names=TRUE, fill=TRUE, idcol='gaNameList')

yoyCh <- function(x) {
  google_analytics(x, 
                   date_range = yoyDates,
                   metrics = yoyMetrics,
                   dimensions = c("channelGrouping"))
}

yoyCh_data <- future_lapply(gaIdList, yoyCh)
setattr(yoyCh_data, 'names', gaNameList)
metricsByChannel<-rbindlist(yoyCh_data, use.names=TRUE, fill=TRUE, idcol='gaNameList')

yoyAge <- function(x) {
  google_analytics(x, 
                   date_range = yoyDates,
                   metrics = yoyMetrics,
                   dimensions = c("userAgeBracket"))
}

yoyAge_data <- future_lapply(gaIdList, yoyAge)
setattr(yoyAge_data, 'names', gaNameList)
metricsByAge<-rbindlist(yoyAge_data, use.names=TRUE, fill=TRUE, idcol='gaNameList')
