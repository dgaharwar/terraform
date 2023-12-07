import json, requests, urllib3
urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)
 
configspec = morpheus['spec']

MORPHEUS_VERIFY_SSL_CERT = False
MORPHEUS_HOST = morpheus['morpheus']['applianceHost']
MORPHEUS_TENANT_TOKEN = morpheus['morpheus']['apiAccessToken']
AZURE_VMName = configspec['customOptions']['azcreaterg']
#AZURE_VMName = morpheus['customOptions']['azcreaterg']
MORPHEUS_HEADERS = {"Content-Type":"application/json","Accept":"application/json","Authorization": "Bearer " + MORPHEUS_TENANT_TOKEN}
url1 = 'https://%s/api/zones/2/resource-pools' % (MORPHEUS_HOST )
payload = {
    "resourcePool":{
    "regionCode":"francecentral",
    "defaultPool":False,
    "defaultImage":False,
    "active":True,
    "visibility":"private",
    "inventory":True,
    "config":{
        "tenancy":"default"
    },
    "resourcePermissions":{
        "all":True,
        "allPlans":True
    },
    "name":AZURE_VMName
    }
}
response1 = requests.post(url1, json=payload, headers=MORPHEUS_HEADERS, verify=False)
data1 = response1.json()
resourcePoolId = data1['resourcePool']['id']
#print("id=pool-"+str(resourcePoolId))
configspec['config']['resourcePoolId']=resourcePoolId
##### config - print updated spec
newconfigspec = {}
newconfigspec['spec'] = configspec
print(json.dumps(newconfigspec))