#Reference:https://dominicroye.github.io/en/2018/how-to-create-warming-stripes-in-r/
#install lubridate and tidyverse libraries
if(!require("lubridate")) install.packages("lubridate")
if(!require("tidyverse")) install.packages("tidyverse")

#libraries
library(tidyverse)
library(lubridate)
library(RColorBrewer)

#import the annual temperatures
Cal_list <- read_csv("Calcutta-India_station.csv")

str(Cal_list)
#select only the annual temperature and year column
Cal_list_yr <- select(Cal_list,YEAR,metANN)

#rename the temperature column
Cal_list_yr <- rename(Cal_list_yr,ta=metANN)

#missing values 999.9
summary(Cal_list_yr) 
Cal_list_yr <- mutate(Cal_list_yr,ta=ifelse(ta==999.9,NA,ta))
Cal_list_yr <- mutate(Cal_list_yr,date=str_c(YEAR,"01-01",sep="-")%>%ymd())
theme_strip <- theme_minimal()+
  theme(axis.text.y = element_blank(),
        axis.line.y = element_blank(),
        axis.title = element_blank(),
        panel.grid.major=element_blank(),
        legend.title = element_blank(),
        axis.text.x=element_text(vjust=3),
        panel.grid.minor=element_blank(),
        plot.title=element_text(size=14,face="bold")
  )


col_strip <- brewer.pal(11,"RdBu")

brewer.pal.info
ggplot(temp_lisboa_yr,
       aes(x=date,y=1,fill=ta))+
  geom_tile()+
  scale_x_date(date_breaks = "6 years",
               date_labels = "%Y",
               expand=c(0,0))+
  scale_y_continuous(expand=c(0,0))+
  scale_fill_gradientn(colors=rev(col_strip))+
  guides(fill=guide_colorbar(barwidth = 1))+
  labs(title="Calcutta-India_1880-2019",
       caption="Datos: GISS Surface Temperature Analysis")+
  theme_strip
