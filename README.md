# bc-bryo-atlas
# Authors: Antranig Basman, Andrew Simon

Guide to maintaining the BC Bryo Guide website as an R Markdown project.

This website is maintained based on the shared Google Sheet 'BC_Bryo_Database' which contains content for all the hornworts, liverworts, and mosses represented on the website. You must be a member of the BC Bryo Guide working group to contribute to this shared database. Contact XXXXX for more information.

To regenerate the website and render any recent updates to the BC_Bryo_Database Google Sheet, you must first run the script 'authenticate.R' to authenticate with Google Cloud API and sign into the Google account through which you have access to this dataset. Then go to the 'Build' pane and click 'Render Website', which will run the scripts for building the website. After, commit your changes and push them to the repo. Presto: the website is updated.