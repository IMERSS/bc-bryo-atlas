# Run this script to authenticate with the Google Cloud API 
# and access taxon data from the shared Google Sheet,'BC_Bryo_Database'

library(googlesheets4)

taxa <- read_sheet("1MG7C7GX1Tl2RO_vHuMwUo8quhzYZd_mElWRnPuNbpj8", sheet = "friendly")