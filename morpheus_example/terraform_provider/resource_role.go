package morpheus

// this is for Users

import (
	"context"
	"encoding/json"
	"log"
	"sort"
	"github.com/gomorpheus/morpheus-go-sdk"
	"github.com/hashicorp/terraform-plugin-sdk/v2/diag"
	"github.com/hashicorp/terraform-plugin-sdk/v2/helper/schema"
)

func resourceMorpheusRole() *schema.Resource {
	return &schema.Resource{
		Description:   "Provides a Morpheus user resource.",
		CreateContext: resourceMorpheusRoleCreate,
		ReadContext:   resourceMorpheusRoleRead,
		UpdateContext: resourceMorpheusRoleUpdate,
		DeleteContext: resourceMorpheusRoleDelete,

		Schema: map[string]*schema.Schema{
			"id": {
				Description: "The ID of the user",
				Type:        schema.TypeString,
				Computed:    true,
			},
			// Required inputs
			"name": {
				Description: "Authority (Name)",
				Type:        schema.TypeString,
				Required:    true,
			},
			"description": {
				Description: "Description",
				Type:        schema.TypeString,
				Optional:    true,
				Computed:    true,
			},
			"type": {
				Description: "Role type",
				Type:        schema.TypeString,
				Optional:    true,
				Computed:    true,
			},
			"base_role": {
				Description: "Base Role ID. Create the new role with the same permissions and access levels that the specified base role has. If this is not passed, the role is create without any permissions.",
				Type:        schema.TypeInt,
				Optional:    true,
				Computed:    true,
			},
			"multitenant": {
				Description: "Multitenant roles are copied to all tenant accounts and kept in sync until a sub-tenant user modifies their copy of the role. Only available to master tenant",
				Type:        schema.TypeBool,
				Optional:    true,
				Computed:    true,
			},
			"multitenant_locked": {
				Description: "Multitenant Locked, prevents sub-tenant users from modifying their copy of multitenant roles. Only available to master tenant",
				Type:        schema.TypeBool,
				Optional:    true,
				Computed:    true,
			},
			"features_access": {
				Type:        schema.TypeList,
				Description: "Role features permissions",
				Optional:    true,
				Elem: &schema.Resource{
					Schema: map[string]*schema.Schema{
						"id": {
							Type:        schema.TypeString,
							Description: "feature name",
							Required:    true,
						},
						"access": {
							Type:        schema.TypeString,
							Description: "access level (none, read, full)",
							Required:    true,
						},
					},
				},
			},
			"groups_access": {
				Type:        schema.TypeList,
				Description: "Role groups permissions",
				Optional:    true,
				Elem: &schema.Resource{
					Schema: map[string]*schema.Schema{
						"id": {
							Type:        schema.TypeString,
							Description: "id of the group",
							Required:    true,
						},
						"access": {
							Type:        schema.TypeString,
							Description: "access level (none, read, full)",
							Required:    true,
						},
					},
				},
			},
			"personas_access": {
				Type:        schema.TypeList,
				Description: "Role personas permissions",
				Optional:    true,
				Elem: &schema.Resource{
					Schema: map[string]*schema.Schema{
						"id": {
							Type:        schema.TypeString,
							Description: "persona name",
							Required:    true,
						},
						"access": {
							Type:        schema.TypeString,
							Description: "access level (none, read, full)",
							Required:    true,
						},
					},
				},
			},
			"instance_types_access": {
				Type:        schema.TypeList,
				Description: "Role instance types permissions",
				Optional:    true,
				Elem: &schema.Resource{
					Schema: map[string]*schema.Schema{
						"id": {
							Type:        schema.TypeString,
							Description: "id of the instance type",
							Required:    true,
						},
						"access": {
							Type:        schema.TypeString,
							Description: "access level (none, read, full)",
							Required:    true,
						},
					},
				},
			},
			"catalog_items_access": {
				Type:        schema.TypeList,
				Description: "Role catalog items permissions",
				Optional:    true,
				Elem: &schema.Resource{
					Schema: map[string]*schema.Schema{
						"id": {
							Type:        schema.TypeString,
							Description: "id of the catalog item",
							Required:    true,
						},
						"access": {
							Type:        schema.TypeString,
							Description: "access level (none, read, full)",
							Required:    true,
						},
					},
				},
			},
		},
		Importer: &schema.ResourceImporter{
			StateContext: schema.ImportStatePassthroughContext,
		},
	}
}

func resourceMorpheusRoleCreate(ctx context.Context, d *schema.ResourceData, meta interface{}) diag.Diagnostics {
	client := meta.(*morpheus.Client)

	// Warning or errors can be collected in a slice type
	var diags diag.Diagnostics

	name := d.Get("name").(string)
	description := d.Get("description").(string)
	role_type := d.Get("type").(string)
	base_role := d.Get("base_role").(int)
	multitenant := d.Get("multitenant").(bool)
	multitenant_locked := d.Get("multitenant_locked").(bool)

	req := &morpheus.Request{
		Body: map[string]interface{}{
			"role": map[string]interface{}{
				"authority": name,
				"description": description,
				"roleType": role_type,
				"baseRoleId": base_role,
				"multitenant": multitenant,
				"multitenantLocked": multitenant_locked,
			},
		},
	}
	jsonRequest, _ := json.Marshal(req.Body)
	log.Printf("API JSON REQUEST: %s", string(jsonRequest))
	log.Printf("API REQUEST: %s", req) // debug
	resp, err := client.CreateRole(req)
	if err != nil {
		log.Printf("API FAILURE: %s - %s", resp, err)
		return diag.FromErr(err)
	}
	log.Printf("API RESPONSE: %s", resp)
	result := resp.Result.(*morpheus.CreateRoleResult)
	role := result.Role

	// get all details of the current role
	resp, err = client.GetRole(role.ID, &morpheus.Request{})
	currentRole := resp.Result.(*morpheus.GetRoleResult)







	// Successfully created resource, now set id
	d.SetId(int64ToString(role.ID))
	resourceMorpheusRoleRead(ctx, d, meta)
	return diags
}

func resourceMorpheusRoleRead(ctx context.Context, d *schema.ResourceData, meta interface{}) diag.Diagnostics {
	client := meta.(*morpheus.Client)

	// Warning or errors can be collected in a slice type
	var diags diag.Diagnostics

	id := d.Id()
	name := d.Get("name").(string)

	// lookup by name if we do not have an id yet
	var resp *morpheus.Response
	var err error
	if id == "" && name != "" {
		resp, err = client.FindRoleByName(name)
	} else if id != "" {
		resp, err = client.GetRole(toInt64(id), &morpheus.Request{})
	} else {
		return diag.Errorf("Role cannot be read without name or id")
	}
	if err != nil {
		if resp != nil && resp.StatusCode == 404 {
			log.Printf("API 404: %s - %s", resp, err)
			return diag.FromErr(err)
		} else {
			log.Printf("API FAILURE: %s - %s", resp, err)
			return diag.FromErr(err)
		}
	}
	log.Printf("API RESPONSE: %s", resp)

	// store resource data
	result := resp.Result.(*morpheus.GetRoleResult)
	role := result.Role

	var groups []Permission
	for i := 0; i < len(result.Sites); i++ {
		if result.Sites[i].Access != "none"{
			groups = append(groups, Permission{
				int(result.Sites[i].ID), result.Sites[i].Access,
			})
		}
	}

	var catalogItems []Permission
	for i := 0; i < len(result.CatalogItemTypePermissions); i++ {
		if result.CatalogItemTypePermissions[i].Access != "none"{
			catalogItems = append(catalogItems, Permission{
				int(result.CatalogItemTypePermissions[i].ID), result.CatalogItemTypePermissions[i].Access,
			})
		}
	}

	var features []Permission
	for i := 0; i < len(result.FeaturePermissions); i++ {
		if result.FeaturePermissions[i].Access != "none"{
			features = append(features, Permission{
				int(result.FeaturePermissions[i].ID), result.FeaturePermissions[i].Access,
			})
		}
	}

	var instanceTypes []Permission
	for i := 0; i < len(result.InstanceTypePermissions); i++ {
		if result.InstanceTypePermissions[i].Access != "none"{
			instanceTypes = append(instanceTypes, Permission{
				int(result.InstanceTypePermissions[i].ID), result.InstanceTypePermissions[i].Access,
			})
		}
	}

	var personas []Permission
	for i := 0; i < len(result.PersonaPermissions); i++ {
		if result.PersonaPermissions[i].Access != "none"{
			personas = append(personas, Permission{
				int(result.PersonaPermissions[i].ID), result.PersonaPermissions[i].Access,
			})
		}
	}

	sort.Slice(personas, func(i, j int) bool {
		return personas[i].ID > personas[j].ID
	})

	sort.Slice(features, func(i, j int) bool {
		return features[i].ID > features[j].ID
	})

	sort.Slice(instanceTypes, func(i, j int) bool {
		return instanceTypes[i].ID > instanceTypes[j].ID
	})

	sort.Slice(catalogItems, func(i, j int) bool {
		return catalogItems[i].ID > catalogItems[j].ID
	})

	sort.Slice(groups, func(i, j int) bool {
		return groups[i].ID > groups[j].ID
	})
	
	if resp.StatusCode == 200 {
		d.SetId(int64ToString(role.ID))
		d.Set("name", role.Authority)
		d.Set("description", role.Description)
		d.Set("type", role.RoleType)
		d.Set("base_role", role.MultiTenant)
		d.Set("multitenant", role.MultiTenant)
		d.Set("multitenant_locked", role.MultiTenantLocked)
		d.Set("groups_access", groups)
		d.Set("catalog_items_access", catalogItems)
		d.Set("features_access", features)
		d.Set("instance_types_access", instanceTypes)
		d.Set("personas_access", personas)
		
	} else {
		return diag.Errorf("Role not found in response data.") // should not happen
	}

	return diags
}

func resourceMorpheusRoleUpdate(ctx context.Context, d *schema.ResourceData, meta interface{}) diag.Diagnostics {
	client := meta.(*morpheus.Client)
	id := d.Id()
	name := d.Get("name").(string)
	description := d.Get("description").(string)
	role_type := d.Get("type").(string)
	base_role := d.Get("base_role").(int)
	multitenant := d.Get("multitenant").(bool)
	multitenant_locked := d.Get("multitenant_locked").(bool)

	req := &morpheus.Request{
		Body: map[string]interface{}{
			"role": map[string]interface{}{
				"authority": name,
				"description": description,
				"roleType": role_type,
				"baseRoleId": base_role,
				"multitenant": multitenant,
				"multitenantLocked": multitenant_locked,
			},
		},
	}
	
	jsonRequest, _ := json.Marshal(req.Body)
	log.Printf("API JSON REQUEST: %s", string(jsonRequest))
	log.Printf("API REQUEST: %s", req) // debug
	resp, err := client.UpdateRole(toInt64(id), req)
	if err != nil {
		log.Printf("API FAILURE: %s - %s", resp, err)
		return diag.FromErr(err)
	}
	log.Printf("API RESPONSE: %s", resp)
	result := resp.Result.(*morpheus.UpdateRoleResult)
	role := result.Role

	// get all details of the current role
	resp, err = client.GetRole(role.ID, &morpheus.Request{})
	currentRole := resp.Result.(*morpheus.GetRoleResult)







	// Successfully updated resource, now set id
	d.SetId(int64ToString(role.ID))
	return resourceMorpheusRoleRead(ctx, d, meta)
}

func resourceMorpheusRoleDelete(ctx context.Context, d *schema.ResourceData, meta interface{}) diag.Diagnostics {
	client := meta.(*morpheus.Client)

	// Warning or errors can be collected in a slice type
	var diags diag.Diagnostics

	id := d.Id()
	req := &morpheus.Request{}
	resp, err := client.DeleteRole(toInt64(id), req)
	if err != nil {
		if resp != nil && resp.StatusCode == 404 {
			log.Printf("API 404: %s - %s", resp, err)
			return diag.FromErr(err)
		} else {
			log.Printf("API FAILURE: %s - %s", resp, err)
			return diag.FromErr(err)
		}
	}
	log.Printf("API RESPONSE: %s", resp)
	d.SetId("")
	return diags
}


type Permission struct {
	ID  int
	Access string
}