Please do not make these scripts accessible on a public repo.

inputs
groups from option list apitype: groups
translationscript: "for(var x=0;x < data.length; x++) {\n    results.push({name: data[x].name,value:data[x].id});\n}"

cluster
input from rest API 
sourceurl: "https://localhost4/api/options/nutanixPrismCluster"
translationscript: "var results = []\nvar CLUSTERS = data.data\nfor (let x=0; x < CLUSTERS.length; x++) {\n      let CLUSTER = CLUSTERS[x]\n    results.push({name: CLUSTER.name, value: CLUSTER.name})\n}"
      requestscript: "mycloudId = String(data.cloud).split(\"-\")[0];\nresults.push({\n  name:\"zoneId\", value: mycloudId\n})"
      headers:
        - name: content-type
          value: application/json
          masked: false
        - name: Accept
          value: application/json
          masked: false
        - name: Authorization
          value: SELF
          masked: false

cloud
input from apitype: clouds
translationscript: "if (input.groups) {\n    for (var x = 0; x < data.length; x++) {\n        results.push({name:data[x].name, value:data[x].id+'-'+data[x].name});\n        }\n    }"
      requestscript: "results.siteId = input.groups"

input vlan (selection of several VLAN's)

look in terraform.tfvars for the variables needed from Cypher

categories:
optionlist
sourceurl: https://localhost4/api/options/nutanixPrismCategories

translation script:
var results = []
var CATEGORIES = data.data
for (let x=0; x < CATEGORIES.length; x++) {
      let CATEGORY = CATEGORIES[x]
    results.push({name: CATEGORY.name, value: CATEGORY.name})
}

optionlist request script:
mycloudId = String(data.cloud).split("-")[0];
results.push({
  name:"zoneId", value: mycloudId
})


input
type: typeahead
allow multiple selections: selected



Catalog item:
In the file (catalog item.txt) you will find a catalog item that is working with multiple categories.
initial with cloud i had the following code in it: 
"cloud": {
  "id": "<%=customOptions.cloud.split(/[-]/)[0]%>"
  "name": "<%=customOptions.cloud.split(/[-]/)[1]%>"
},

But this gives me the error: catalogError: 
  "The data for this catalog item is invalid after evaluating the config. See the logs for details."

or "Order execution error"

this is related to case 210009 

I have solved this by removing the "name": "<%=customOptions.cloud.split(/[-]/)[1]%>" part.
Then it all works, but today i disovered that if i want to do a reorde of a catalog item i got a blank screen.
Can you check this if you got this in your lab setup also, and what are the possible solutions to resolve this.







